// import 'package:flutter/material.dart';

// class Duplex extends StatefulWidget {
//   const Duplex({super.key});

//   @override
//   State<Duplex> createState() => _DuplexState();
// }

// class _DuplexState extends State<Duplex> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(children: [Text('Duplex test')]);
//   }
// }

import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Import pour les requêtes HTTP
import 'package:intl/intl.dart'; // Import pour le formatage des dates et nombres
import 'package:kunft/widget/widget_house_infos2_bis.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import pour récupérer le token
import 'package:kunft/pages/property_detail.dart'; // Import pour la navigation vers les détails

// Définissez votre URL de base d'API ici
const String API_BASE_URL = 'http://127.0.0.1:8000';

final Dio _dio = Dio(); // Instance de Dio pour les requêtes HTTP

// --- Fonction de récupération des logements de type 'Duplex' ---
Future<List<dynamic>> fetchDuplexLogements() async {
  try {
    // Récupérer le token depuis SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      print(
        'DEBUG: Aucun token d\'authentification trouvé. Impossible de charger les duplex.',
      );
      throw Exception('Non authentifié. Veuillez vous connecter.');
    }

    // ✅ Requête GET avec un paramètre de type pour filtrer les duplex
    final response = await _dio.get(
      '$API_BASE_URL/api/logements', // Assurez-vous que cette URL est correcte
      queryParameters: {'type': 'Duplex'}, // ✅ Filtre par type 'Duplex'
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Ajout de l'en-tête d'autorisation
        },
      ),
    );

    print('DEBUG: API Call /logements?type=Duplex...');
    print('DEBUG: Response status : ${response.statusCode}');
    print('DEBUG: Response data : ${response.data}'); // Affiche la donnée brute

    if (response.statusCode == 200) {
      // Vérifier plusieurs formats de réponse courants de Laravel
      if (response.data is Map &&
          response.data.containsKey('data') &&
          response.data['data'] is List) {
        return response
            .data['data']; // Format typique pour les ressources API Laravel (e.g., {"data": [...]})
      } else if (response.data is Map &&
          response.data.containsKey('logements') &&
          response.data['logements'] is List) {
        return response.data['logements']; // Format si la clé est 'logements'
      } else if (response.data is List) {
        return response
            .data; // Format si la réponse est une liste directe (e.g., [...])
      } else {
        String debugInfo =
            'Type de réponse inattendu: ${response.data.runtimeType}. ';
        if (response.data is Map) {
          debugInfo +=
              'Clés présentes: ${(response.data as Map).keys.join(', ')}. ';
        }
        print('DEBUG: $debugInfo');
        throw Exception(
          'Format de réponse API inattendu. La réponse n\'est ni une liste directe, ni un objet avec une clé "data" ou "logements" contenant une liste. $debugInfo',
        );
      }
    } else {
      throw Exception(
        'Erreur de chargement des propriétés : ${response.statusCode} - ${response.data}',
      );
    }
  } on DioException catch (e) {
    if (e.response != null) {
      print(
        'DEBUG: Dio Error Response: ${e.response?.statusCode} - ${e.response?.data}',
      );
      throw Exception(
        'Erreur de requête Dio : ${e.response?.statusCode} - ${e.response?.data}',
      );
    } else {
      print('DEBUG: Dio Error Request: ${e.requestOptions.uri}');
      print('DEBUG: Dio Error Message: ${e.message}');
      throw Exception('Erreur réseau ou de configuration Dio : ${e.message}');
    }
  } catch (e) {
    print('DEBUG: Erreur inattendue lors du fetch des duplex: $e');
    throw Exception('Une erreur inattendue est survenue : $e');
  }
}

class Duplex extends StatefulWidget {
  const Duplex({super.key});

  @override
  State<Duplex> createState() => _DuplexState();
}

class _DuplexState extends State<Duplex> {
  List<dynamic> logements = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _chargerDuplexLogements(); // Lancer la récupération des duplex au démarrage
  }

  Future<void> _chargerDuplexLogements() async {
    setState(() {
      isLoading = true;
      errorMessage = null; // Réinitialise l'erreur avant chaque chargement
    });
    try {
      final data =
          await fetchDuplexLogements(); // Appel de la fonction de récupération
      setState(() {
        logements = data;
        isLoading = false;
      });
      print('DEBUG: Duplex chargés : ${logements.length}');
    } catch (e) {
      print('DEBUG: Erreur lors du chargement des duplex: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Impossible de charger les duplex : $e';
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage!)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Duplex Disponibles'),
      //   backgroundColor: Colors.deepOrange, // Couleur d'en-tête
      // ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(),
              ) // Indicateur de chargement
              : errorMessage != null
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
              : logements.isEmpty
              ? const Center(
                child: Text('Aucun duplex disponible pour le moment.'),
              )
              : Padding(
                padding: const EdgeInsets.all(
                  8.0,
                ), // Padding général pour la grille
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 colonnes pour la grille
                    crossAxisSpacing: 8.0, // Espacement horizontal
                    mainAxisSpacing: 8.0, // Espacement vertical
                    childAspectRatio:
                        0.8, // Ajustez si nécessaire pour que les cartes s'affichent bien
                  ),
                  itemCount: logements.length,
                  itemBuilder: (context, index) {
                    final l = logements[index];

                    // --- Extraction et formatage des données pour WidgetHouseInfos2 ---
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
                        final DateTime dateTime = DateTime.parse(
                          l['created_at'] as String,
                        );
                        final Duration difference = DateTime.now().difference(
                          dateTime,
                        );
                        if (difference.inDays > 30) {
                          formattedTime = DateFormat(
                            'dd MMM yyyy',
                            'fr_FR',
                          ).format(dateTime);
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
                        print(
                          'DEBUG: Erreur de parsing ou formatage de date: $e',
                        );
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
                        formattedPrice = NumberFormat(
                          '#,##0',
                          'fr_FR',
                        ).format(price);
                      } catch (e) {
                        print(
                          'DEBUG: Erreur de formatage du prix pour "${l['prix_par_nuit']}" : $e',
                        );
                        formattedPrice = 'Prix invalide';
                      }
                    }

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => PropertyDetail(logementData: l),
                          ),
                        );
                      },
                      child: WidgetHouseInfos2Bis(
                        imgHouse: imgUrl,
                        houseName: l['titre'] ?? 'Titre Inconnu',
                        price: '$formattedPrice Fcfa',
                        locate: l['adresse'] ?? '',
                        ownerName: ownerName,
                        time: formattedTime,
                        logementData:
                            l, // Passez les données complètes du logement
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
