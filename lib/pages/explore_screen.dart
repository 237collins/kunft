import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:kunft/widget/widget_animation2.dart';
import 'package:kunft/widget/widget_message_aleatoire.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import pour récupérer le token

import 'package:kunft/pages/map_search.dart';
import 'package:kunft/widget/widget_animation.dart';
// import 'package:kunft/widget/widget_house_infos2.dart'; // ✅ RETIRÉ
// import 'package:kunft/widget/widget_house_infos3.dart'; // ✅ RETIRÉ
import 'package:kunft/widget/widget_house_infos2_bis.dart'; // ✅ AJOUTÉ : Nouveau widget
import 'package:kunft/widget/widget_house_infos_explore.dart';
import 'package:kunft/widget/widget_owner_list.dart';
import 'package:kunft/widget/widget_profile_infos.dart';

const String API_BASE_URL = 'http://127.0.0.1:8000';
final Dio _dio = Dio();

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<dynamic> _latestLogements = [];
  List<dynamic> _trendingOwners = [];
  List<dynamic> _recentSearches =
      []; // Utiliser pour les logements récemment recherchés

  bool _isLoadingLatest = true;
  bool _isLoadingOwners = true;
  bool _isLoadingRecent = true;

  String? _errorLatest;
  String? _errorOwners;
  String? _errorRecent;

  @override
  void initState() {
    super.initState();
    _fetchData(); // Lance le chargement de toutes les données
  }

  // Fonction pour récupérer toutes les données nécessaires
  Future<void> _fetchData() async {
    await Future.wait([
      _fetchLatestLogements(),
      _fetchTrendingOwners(),
      _fetchRecentSearches(), // Appelle la fonction pour les recherches récentes
    ]);
  }

  // Helper pour obtenir le token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Helper pour formater les données de logement
  Map<String, String> _formatLogementData(Map<String, dynamic> l) {
    final String imgUrl =
        (l['images'] != null && l['images'].isNotEmpty)
            ? '$API_BASE_URL/storage/${l['images'][0]['image_path']}'
            : 'https://www.batiactu.com/images/auto/620-465-c/20210913_170834_immobilier-dossier-credit-istock.jpg';

    final String ownerName =
        (l['user'] != null && l['user']['name'] != null)
            ? '@${(l['user']['name'] as String).replaceAll(' ', '.').toLowerCase()}'
            : '@proprietaire.inconnu';

    String formattedTime = 'Date inconnue';
    if (l['created_at'] != null) {
      try {
        final DateTime dateTime = DateTime.parse(l['created_at'] as String);
        final Duration difference = DateTime.now().difference(dateTime);
        if (difference.inDays > 30) {
          formattedTime = DateFormat('dd MMM yyyy', 'fr_FR').format(dateTime);
        } else if (difference.inDays > 0) {
          formattedTime =
              '${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
        } else if (difference.inHours > 0) {
          formattedTime =
              '${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
        } else if (difference.inMinutes > 0) {
          formattedTime =
              '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
        } else {
          formattedTime = 'à l\'instant';
        }
      } catch (e) {
        print('DEBUG: Erreur de parsing ou formatage de date: $e');
        formattedTime = 'Date invalide';
      }
    }

    String formattedPrice = 'N/A';
    if (l['prix_par_nuit'] != null) {
      try {
        double price;
        if (l['prix_par_nuit'] is String) {
          price = double.parse(l['prix_par_nuit'] as String);
        } else if (l['prix_par_nuit'] is num) {
          price = (l['prix_par_nuit'] as num).toDouble();
        } else {
          throw FormatException('Type de prix inattendu');
        }
        formattedPrice = NumberFormat('#,##0', 'fr_FR').format(price);
      } catch (e) {
        print(
          'DEBUG: Erreur de formatage du prix pour "${l['prix_par_nuit']}" : $e',
        );
        formattedPrice = 'Prix invalide';
      }
    }

    return {
      'imgUrl': imgUrl,
      'houseName': l['titre'] ?? 'Titre Inconnu',
      'price': '$formattedPrice Fcfa',
      'locate': l['adresse'] ?? '',
      'ownerName': ownerName,
      'time': formattedTime,
    };
  }

  // Helper pour extraire la liste de données de la réponse API
  List<dynamic> _extractDataFromResponse(dynamic responseData, String context) {
    if (responseData is Map &&
        responseData.containsKey('data') &&
        responseData['data'] is List) {
      return responseData['data'];
    } else if (responseData is Map &&
        responseData.containsKey('logements') &&
        responseData['logements'] is List) {
      return responseData['logements']; // ✅ AJOUTÉ : Vérifie la clé 'logements'
    } else if (responseData is List) {
      return responseData;
    } else {
      String debugInfo =
          'Type de réponse inattendu: ${responseData.runtimeType}. ';
      if (responseData is Map) {
        debugInfo +=
            'Clés présentes: ${(responseData as Map).keys.join(', ')}. ';
      }
      throw Exception('Format de réponse inattendu pour $context. $debugInfo');
    }
  }

  // ✅ Récupère les 10 derniers logements
  Future<void> _fetchLatestLogements() async {
    setState(() => _isLoadingLatest = true);
    try {
      final token = await _getToken();
      if (token == null)
        throw Exception('Token non trouvé. Veuillez vous connecter.');

      final response = await _dio.get(
        '$API_BASE_URL/api/logements',
        queryParameters: {
          'limit': 10,
          'sort': 'latest',
        }, // Assurez-vous que votre API gère ces paramètres
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = _extractDataFromResponse(
          response.data,
          'les derniers logements',
        );
        setState(() {
          _latestLogements = data;
          _isLoadingLatest = false;
        });
      } else {
        throw Exception(
          'Erreur API: ${response.statusCode} - ${response.data}',
        );
      }
    } catch (e) {
      print('DEBUG: Erreur _fetchLatestLogements: $e');
      setState(() {
        _errorLatest = e.toString();
        _isLoadingLatest = false;
      });
    }
  }

  // ✅ Récupère les propriétaires tendance
  Future<void> _fetchTrendingOwners() async {
    setState(() => _isLoadingOwners = true);
    try {
      final token = await _getToken();
      if (token == null)
        throw Exception('Token non trouvé. Veuillez vous connecter.');

      final response = await _dio.get(
        '$API_BASE_URL/api/trending-owners', // Assurez-vous que cette route existe et est protégée
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = _extractDataFromResponse(
          response.data,
          'les propriétaires tendance',
        );
        setState(() {
          _trendingOwners = data;
          _isLoadingOwners = false;
        });
      } else {
        throw Exception(
          'Erreur API: ${response.statusCode} - ${response.data}',
        );
      }
    } catch (e) {
      print('DEBUG: Erreur _fetchTrendingOwners: $e');
      setState(() {
        _errorOwners = e.toString();
        _isLoadingOwners = false;
      });
    }
  }

  // ✅ Récupère les logements pour la section "récemment recherchés"
  // Pour l'instant, cela récupère une liste générale de logements.
  // Pour une vraie fonctionnalité "récemment recherché", vous auriez besoin:
  // 1. D'un mécanisme pour enregistrer les recherches de l'utilisateur (côté backend ou localement).
  // 2. D'un endpoint API pour récupérer ces recherches spécifiques.
  Future<void> _fetchRecentSearches() async {
    setState(() => _isLoadingRecent = true);
    try {
      final token = await _getToken();
      if (token == null)
        throw Exception('Token non trouvé. Veuillez vous connecter.');

      final response = await _dio.get(
        '$API_BASE_URL/api/logements', // Utilise le même endpoint, sans filtre spécifique pour l'exemple
        queryParameters: {
          'limit': 6,
        }, // Limite à quelques éléments pour cette section
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = _extractDataFromResponse(
          response.data,
          'les recherches récentes',
        ); // ✅ UTILISE LE NOUVEL HELPER
        setState(() {
          _recentSearches = data;
          _isLoadingRecent = false;
        });
      } else {
        throw Exception(
          'Erreur API: ${response.statusCode} - ${response.data}',
        );
      }
    } catch (e) {
      print('DEBUG: Erreur _fetchRecentSearches: $e');
      setState(() {
        _errorRecent = e.toString();
        _isLoadingRecent = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Préparer les colonnes pour les logements récemment recherchés
    List<Widget> colonneGWidgets = [];
    List<Widget> colonneDWidgets = [];

    // ✅ MODIFIÉ : La boucle utilise _recentSearches directement
    for (int i = 0; i < _recentSearches.length; i++) {
      final l = _recentSearches[i];
      final formattedData = _formatLogementData(l);

      final Widget houseWidget = Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: GestureDetector(
          onTap: () {
            // Naviguer vers les détails du logement
            // Assurez-vous d'avoir une page PropertyDetail et de lui passer les données
            // Navigator.push(context, MaterialPageRoute(builder: (context) => PropertyDetail(logementData: l)));
          },
          child: WidgetHouseInfos2Bis(
            // ✅ MODIFIÉ : Utilise WidgetHouseInfos2Bis
            imgHouse: formattedData['imgUrl']!,
            houseName: formattedData['houseName']!,
            price: formattedData['price']!,
            locate: formattedData['locate']!,
            ownerName: formattedData['ownerName']!,
            time: formattedData['time']!,
            logementData: l,
          ),
        ),
      );

      if (i.isEven) {
        colonneGWidgets.add(houseWidget);
      } else {
        colonneDWidgets.add(houseWidget);
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          //
                          WidgetAnimation2(
                            imageUrls: [],
                            initialImageUrl:
                                'https://www.freepik.com/free-photo/swimming-pool_1037896.htm#fromView=search&page=1&position=49&uuid=cb31a530-6c15-4a84-a79a-0ada78578303&query=maison+de+luxe',
                          ),
                          // ✅ WidgetHouseInfosExplore: Affiche les 10 derniers logements
                          SizedBox(
                            height: screenHeight * .47,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //
                                WidgetProfileInfos(),
                                //
                                Spacer(),
                                //
                                Column(children: [WidgetMessageAleatoire()]),
                                // Affichage des logements recemment recherchés.
                                _isLoadingLatest
                                    // Barre de chargement
                                    ? SizedBox(
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                    : _errorLatest != null
                                    // Message de d'erreur
                                    ? SizedBox(
                                      height: screenHeight * .47,
                                      child: Center(
                                        child: Text(
                                          'Erreur: $_errorLatest',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                    // Si logement manque
                                    : _latestLogements.isEmpty
                                    ? SizedBox(
                                      height: screenHeight * .47,
                                      child: const Center(
                                        child: Text(
                                          'Aucun logement récent disponible',
                                        ),
                                      ),
                                    )
                                    : SizedBox(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children:
                                              _latestLogements.map((l) {
                                                final formattedData =
                                                    _formatLogementData(l);
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 10.0,
                                                      ),
                                                  child: WidgetHouseInfosExplore(
                                                    imgHouse:
                                                        formattedData['imgUrl']!,
                                                    houseName:
                                                        formattedData['houseName']!,
                                                    price:
                                                        formattedData['price']!,
                                                    locate:
                                                        formattedData['locate']!,
                                                    ownerName:
                                                        formattedData['ownerName']!,
                                                    time:
                                                        formattedData['time']!,
                                                    logementData: l,
                                                  ),
                                                );
                                              }).toList(),
                                        ),
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Column(
                        children: [
                          Row(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: screenWidth * .55,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Row(
                                    // Ajout de const
                                    children: [
                                      Icon(Icons.search, color: Colors.grey),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Chercher un Meublé',
                                            hintStyle: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                              backgroundColor: Colors.white,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(Icons.tune, color: Colors.grey),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10), // Ajout de const
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    // Ajout de const
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xffffd055,
                                    ), // Ajout de const
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.map_outlined,
                                      ), // Ajout de const
                                      const SizedBox(
                                        width: 10,
                                      ), // Ajout de const

                                      InkWell(
                                        onTap: () {
                                          // setState(() { // Pas nécessaire si isSelected n'est pas utilisé pour le rendu
                                          //   isSelected = !isSelected;
                                          // });
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      const MapSearch(), // Ajout de const
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          // Ajout de const
                                          'Google Map',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18), // Ajout de const
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                // Ajout de const
                                'Trending Broker\'s',
                                style: TextStyle(
                                  color: Color(0xff010101),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Text(
                                // Ajout de const
                                'see all',
                                style: TextStyle(
                                  color: Color(0xffffd055),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15), // Ajout de const
                          // ✅ WidgetOwnerList: Affiche les propriétaires tendance
                          _isLoadingOwners
                              ? const Center(child: CircularProgressIndicator())
                              : _errorOwners != null
                              ? Center(
                                child: Text(
                                  'Erreur: $_errorOwners',
                                  textAlign: TextAlign.center,
                                ),
                              )
                              : _trendingOwners.isEmpty
                              ? const Center(
                                child: Text(
                                  'Aucun propriétaire tendance disponible',
                                ),
                              )
                              : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children:
                                      _trendingOwners.map((owner) {
                                        final String ownerImg =
                                            (owner['profile_image'] != null &&
                                                    owner['profile_image']
                                                        .isNotEmpty)
                                                ? '$API_BASE_URL/storage/${owner['profile_image']}'
                                                : 'https://placehold.co/600x400/png'; // Fallback image
                                        return WidgetOwnerList(
                                          img: ownerImg,
                                          name: owner['name'] ?? 'Inconnu',
                                          number:
                                              owner['logements_count']
                                                  ?.toString() ??
                                              '0', // Assurez-vous que 'logements_count' est bien renvoyé par l'API
                                          withSpacing:
                                              true, // Ou false pour le dernier élément si vous gérez l'espacement manuellement
                                        );
                                      }).toList(),
                                ),
                              ),
                          const SizedBox(height: 18), // Ajout de const
                          const Row(
                            // Ajout de const
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Versatile mixed-use property',
                                style: TextStyle(
                                  color: Color(0xff010101),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'see all',
                                style: TextStyle(
                                  color: Color(0xffffd055),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // ✅ WidgetHouseInfos2Bis: Affiche les logements récemment recherchés
                      const SizedBox(height: 16), // Ajout de const
                      _isLoadingRecent
                          ? const Center(child: CircularProgressIndicator())
                          : _errorRecent != null
                          ? Center(
                            child: Text(
                              'Erreur: $_errorRecent',
                              textAlign: TextAlign.center,
                            ),
                          )
                          : _recentSearches.isEmpty
                          ? const Center(
                            child: Text(
                              'Aucun logement récemment recherché disponible.',
                            ),
                          )
                          : SizedBox(
                            height:
                                (_recentSearches.length / 2).ceil() *
                                270.0, // Ajuste la hauteur pour 2 colonnes
                            child: Row(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount:
                                        (colonneGWidgets.length / 2)
                                            .ceil(), // Nombre d'éléments pour la colonne gauche
                                    itemBuilder: (context, index) {
                                      final l = _recentSearches[index * 2];
                                      final formattedData = _formatLogementData(
                                        l,
                                      );
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8.0,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            // Naviguer vers les détails du logement
                                            // Assurez-vous d'avoir une page PropertyDetail et de lui passer les données
                                            // Navigator.push(context, MaterialPageRoute(builder: (context) => PropertyDetail(logementData: l)));
                                          },
                                          child: WidgetHouseInfos2Bis(
                                            // ✅ MODIFIÉ
                                            imgHouse: formattedData['imgUrl']!,
                                            houseName:
                                                formattedData['houseName']!,
                                            price: formattedData['price']!,
                                            locate: formattedData['locate']!,
                                            ownerName:
                                                formattedData['ownerName']!,
                                            time: formattedData['time']!,
                                            logementData: l,
                                          ),
                                        ),
                                      );
                                    },
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                  ),
                                ),
                                const SizedBox(width: 8), // Ajout de const
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount:
                                        (_recentSearches.length / 2)
                                            .floor(), // Nombre d'éléments pour la colonne droite
                                    itemBuilder: (context, index) {
                                      final l = _recentSearches[index * 2 + 1];
                                      final formattedData = _formatLogementData(
                                        l,
                                      );
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8.0,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            // Naviguer vers les détails du logement
                                            // Assurez-vous d'avoir une page PropertyDetail et de lui passer les données
                                            // Navigator.push(context, MaterialPageRoute(builder: (context) => PropertyDetail(logementData: l)));
                                          },
                                          child: WidgetHouseInfos2Bis(
                                            // ✅ MODIFIÉ
                                            imgHouse: formattedData['imgUrl']!,
                                            houseName:
                                                formattedData['houseName']!,
                                            price: formattedData['price']!,
                                            locate: formattedData['locate']!,
                                            ownerName:
                                                formattedData['ownerName']!,
                                            time: formattedData['time']!,
                                            logementData: l,
                                          ),
                                        ),
                                      );
                                    },
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Ancien code Statique

// import 'package:flutter/material.dart';
// import 'package:kunft/pages/map_search.dart';
// import 'package:kunft/widget/widget_animation.dart';
// import 'package:kunft/widget/widget_house_infos2.dart';
// import 'package:kunft/widget/widget_house_infos3.dart';
// import 'package:kunft/widget/widget_house_infos_explore.dart';
// import 'package:kunft/widget/widget_owner_list.dart';
// import 'package:kunft/widget/widget_profile_infos.dart';

// class ExploreScreen extends StatefulWidget {
//   const ExploreScreen({super.key});

//   @override
//   State<ExploreScreen> createState() => _ExploreScreenState();
// }

// class _ExploreScreenState extends State<ExploreScreen> {
//   final List<Widget> colonneG = [
//     WidgetHouseInfos2(
//       imgHouse: 'assets/images/img04.jpg',
//       houseName: 'Single family home',
//       price: '\$185 000',
//       locate: '908 Elm Street, Unit 48, Aistin,',
//       ownerName: '@abigail.moore',
//       time: '2 hours ago',
//     ),
//     WidgetHouseInfos2(
//       imgHouse: 'assets/images/img05.jpg',
//       houseName: 'Single family home',
//       price: '\$185 000',
//       locate: '908 Elm Street, Unit 48, Aistin,',
//       ownerName: '@abigail.moore',
//       time: '2 hours ago',
//     ),
//   ];

//   final List<Widget> colonneD = [
//     WidgetHouseInfos3(
//       imgHouse: 'assets/images/img01.jpg',
//       houseName: 'Single family home',
//       price: '\$185 000',
//       locate: '908 Elm Street, Unit 48, Aistin,',
//       ownerName: '@abigail.moore',
//       time: '2 hours ago',
//     ),
//     WidgetHouseInfos3(
//       imgHouse: 'assets/images/img06.jpg',
//       houseName: 'Single family home',
//       price: '\$185 000',
//       locate: '908 Elm Street, Unit 48, Aistin,',
//       ownerName: '@abigail.moore',
//       time: '2 hours ago',
//     ),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     bool isSelected = false;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: Color(0xfff7f7f7),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Column(
//                     children: [
//                       Stack(
//                         children: [
//                           WidgetAnimation(),

//                           SizedBox(
//                             height: screenHeight * .47,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 // SizedBox(height: ),
//                                 WidgetProfileInfos(),
//                                 // Spacer(),
//                                 Column(
//                                   children: [
//                                     // WidgetMessageAleatoire(),
//                                     SizedBox(height: 5),
//                                     SingleChildScrollView(
//                                       scrollDirection: Axis.horizontal,
//                                       child: Row(
//                                         children: [
//                                           WidgetHouseInfosExplore(
//                                             imgHouse: 'assets/images/img06.jpg',
//                                             houseName:
//                                                 'Single family home in City A',
//                                             price: '\$185 000',
//                                             locate:
//                                                 '908 Elm Street, Unit 48, Aistin,',
//                                             ownerName: '@abigail.moore',
//                                             time: '2 hours ago',
//                                           ),
//                                           WidgetHouseInfosExplore(
//                                             imgHouse: 'assets/images/img05.jpg',
//                                             houseName:
//                                                 'Single family home in City A',
//                                             price: '\$185 000',
//                                             locate:
//                                                 '908 Elm Street, Unit 48, Aistin,',
//                                             ownerName: '@abigail.moore',
//                                             time: '2 hours ago',
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 18),
//                       Column(
//                         children: [
//                           Row(
//                             children: [
//                               ConstrainedBox(
//                                 constraints: BoxConstraints(
//                                   maxWidth: screenWidth * .55,
//                                 ),
//                                 child: Container(
//                                   // width: 240,
//                                   padding: EdgeInsets.symmetric(horizontal: 14),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(100),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Icon(Icons.search, color: Colors.grey),
//                                       SizedBox(width: 5),
//                                       Expanded(
//                                         child: TextField(
//                                           decoration: InputDecoration(
//                                             hintText: 'Search',
//                                             hintStyle: TextStyle(
//                                               fontSize: 12,
//                                               color: Colors.grey,
//                                               backgroundColor: Colors.white,
//                                             ),
//                                             border: InputBorder.none,
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(width: 5),
//                                       Icon(Icons.tune, color: Colors.grey),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 10),
//                               Expanded(
//                                 child: Container(
//                                   // width: 240,
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 14,
//                                     vertical: 12,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Color(0xffffd055),
//                                     borderRadius: BorderRadius.circular(100),
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(Icons.map_outlined),
//                                       SizedBox(width: 10),

//                                       InkWell(
//                                         onTap: () {
//                                           setState(() {
//                                             isSelected = !isSelected;
//                                           });
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                               builder: (context) => MapSearch(),
//                                             ),
//                                           );
//                                         },
//                                         child: Text(
//                                           'Google Map',
//                                           style: TextStyle(
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 18),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 'Trending Broker\'s',
//                                 style: TextStyle(
//                                   color: Color(0xff010101),
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               Text(
//                                 'see all',
//                                 style: TextStyle(
//                                   color: Color(0xffffd055),
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w400,
//                                   fontStyle: FontStyle.italic,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 15),
//                           SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 // Details
//                                 WidgetOwnerList(
//                                   img: 'assets/images/img01.jpg',
//                                   name: 'James Carter',
//                                   number: '230',
//                                 ),
//                                 WidgetOwnerList(
//                                   img: 'assets/images/img01.jpg',
//                                   name: 'Sophia White',
//                                   number: '250',
//                                 ),
//                                 WidgetOwnerList(
//                                   img: 'assets/images/img01.jpg',
//                                   name: 'William Davis',
//                                   number: '240',
//                                 ),
//                                 WidgetOwnerList(
//                                   img: 'assets/images/img01.jpg',
//                                   name: 'Abigail Moore',
//                                   number: '260',
//                                   withSpacing: false,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 18),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 'Versatile mixed-use property',
//                                 style: TextStyle(
//                                   color: Color(0xff010101),
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               Text(
//                                 'see all',
//                                 style: TextStyle(
//                                   color: Color(0xffffd055),
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w400,
//                                   fontStyle: FontStyle.italic,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),

//                       // Ajustement 2 Okay
//                       SizedBox(height: 16),
//                       SizedBox(
//                         height: screenWidth,
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: ListView.builder(
//                                 padding: EdgeInsets.zero,
//                                 itemCount: colonneG.length,
//                                 itemBuilder:
//                                     (context, index) => colonneG[index],
//                               ),
//                             ),
//                             SizedBox(width: 8),
//                             Expanded(
//                               child: ListView.builder(
//                                 padding: EdgeInsets.zero,
//                                 itemCount: colonneD.length,
//                                 itemBuilder:
//                                     (context, index) => colonneD[index],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
