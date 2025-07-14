import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Importez intl pour le formatage des dates et nombres

import 'package:kunft/pages/SplashScreen.dart';
import 'package:kunft/widget/widget_animation.dart';
import 'package:kunft/widget/widget_house_text_infos.dart';
import 'package:kunft/widget/widget_house_infos2.dart';
import 'package:kunft/widget/widget_house_infos3.dart'; // NOUVEL IMPORT pour WidgetHouseInfos3
import 'package:kunft/widget/widget_profile_infos.dart';
import 'package:kunft/widget/widget_property_category.dart';

const String API_BASE_URL = 'http://127.0.0.1:8000';

final Dio _dio = Dio();

Future<List<dynamic>> fetchLogements() async {
  try {
    final response = await _dio.get(
      '$API_BASE_URL/api/logements',
      options: Options(headers: {'Accept': 'application/json'}),
    );

    print('DEBUG: API Call /logements...');
    print('DEBUG: Response status : ${response.statusCode}');
    print('DEBUG: Response data : ${response.data}');

    if (response.statusCode == 200) {
      if (response.data is Map &&
          response.data.containsKey('logements') &&
          response.data['logements'] is List) {
        return response.data['logements'];
      } else {
        throw Exception(
          'Format de réponse API inattendu. La clé "logements" est manquante ou n\'est pas une liste.',
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
    print('DEBUG: Erreur inattendue lors du fetch des logements: $e');
    throw Exception('Une erreur inattendue est survenue : $e');
  }
}

class HomeScreen extends StatefulWidget {
  final User? user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> logements = [];
  bool isLoading = true;
  // Nouveau : variable pour stocker le dernier logement
  Map<String, dynamic>?
  dernierLogement; // Utiliser Map<String, dynamic> pour un objet JSON

  @override
  void initState() {
    super.initState();
    chargerLogements();
  }

  Future<void> chargerLogements() async {
    try {
      final data = await fetchLogements();
      setState(() {
        logements = data;
        isLoading = false;
        // Si des logements sont chargés, prenez le premier (qui est le plus récent grâce à `latest()->get()` dans Laravel)
        if (logements.isNotEmpty) {
          dernierLogement = logements.first;
        }
      });
      print('DEBUG: Logements chargés : ${logements.length}');
      if (dernierLogement != null) {
        print('DEBUG: Dernier logement ID: ${dernierLogement!['id']}');
      }
    } catch (e) {
      print('DEBUG: Erreur lors du chargement des propriétés: $e');
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Impossible de charger les propriétés : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;

    List<Widget> colonneGWidgets = [];
    List<Widget> colonneDWidgets = [];

    for (int i = 0; i < logements.length; i++) {
      final l = logements[i];
      final imgUrl =
          (l['images'] != null && l['images'].isNotEmpty)
              ? '$API_BASE_URL/storage/${l['images'][0]['image_path']}'
              : 'https://www.batiactu.com/images/auto/620-465-c/20210913_170834_immobilier-dossier-credit-istock.jpg';

      final ownerName =
          (l['user'] != null && l['user']['name'] != null)
              ? l['user']['name']
              : 'Propriétaire Inconnu';

      // --- Formatage de la date ---
      String formattedTime = 'Date inconnue';
      if (l['created_at'] != null) {
        try {
          final DateTime dateTime = DateTime.parse(l['created_at'] as String);
          formattedTime = DateFormat(
            'EEE d MMM HH:mm',
            'fr_FR',
          ).format(dateTime);
        } catch (e) {
          print('DEBUG: Erreur de parsing ou formatage de date: $e');
          formattedTime = 'Date invalide';
        }
      }

      // --- Formatage du prix ---
      String formattedPrice = 'N/A';
      if (l['prix_par_nuit'] != null) {
        print(
          'DEBUG: Valeur de prix_par_nuit reçue: ${l['prix_par_nuit']} (Type: ${l['prix_par_nuit'].runtimeType})',
        );
        try {
          double price;
          if (l['prix_par_nuit'] is String) {
            price = double.parse(
              l['prix_par_nuit'] as String,
            ); // Convertir la chaîne en double
          } else if (l['prix_par_nuit'] is num) {
            price =
                (l['prix_par_nuit'] as num)
                    .toDouble(); // Gérer les int/double directement
          } else {
            throw FormatException(
              'Type de prix inattendu',
            ); // Si ce n'est ni string ni num
          }
          formattedPrice = NumberFormat('#,##0', 'fr_FR').format(price);
        } catch (e) {
          print(
            'DEBUG: Erreur de formatage du prix pour "${l['prix_par_nuit']}" : $e',
          );
          formattedPrice = 'Prix invalide';
        }
      }

      // ✅ MODIFICATION ICI : Alterner entre WidgetHouseInfos2 et WidgetHouseInfos3
      if (i.isEven) {
        colonneGWidgets.add(
          WidgetHouseInfos2(
            imgHouse: imgUrl,
            houseName: l['titre'] ?? 'Titre Inconnu',
            price: '$formattedPrice Fcfa', // Utilisation du prix formaté
            locate: l['adresse'] ?? '',
            ownerName: ownerName,
            time: formattedTime, // Utilisation de la date formatée
          ),
        );
      } else {
        colonneDWidgets.add(
          WidgetHouseInfos3(
            // <--- Utilisation de WidgetHouseInfos3 ici
            imgHouse: imgUrl,
            houseName: l['titre'] ?? 'Titre Inconnu',
            price: '$formattedPrice Fcfa', // Utilisation du prix formaté
            locate: l['adresse'] ?? '',
            ownerName: ownerName,
            time: formattedTime, // Utilisation de la date formatée
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      // Passez le dernier logement à WidgetAnimation
                      // S'il n'y a pas de logement, passez null et WidgetAnimation gérera un placeholder
                      WidgetAnimation(logementData: dernierLogement),
                      //  Widget statique
                      // WidgetAnimation(),
                      SizedBox(
                        height: 400,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: WidgetProfileInfos()),
                            Spacer(),
                            WidgetHouseTextInfos(logementData: dernierLogement),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            'Catégorie de logement',
                            style: TextStyle(
                              color: Color(0xff010101),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          // Text(
                          //   'Voir tout',
                          //   style: TextStyle(
                          //     color: Color(0xffffd055),
                          //     fontSize: 12,
                          //     fontWeight: FontWeight.w400,
                          //     fontStyle: FontStyle.italic,
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Ajoute fonction de filtrage dynamique
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: const [
                            WidgetPropertyCategory(
                              number: '01',
                              name: 'Résidentiel',
                            ),
                            SizedBox(width: 10),
                            WidgetPropertyCategory(
                              number: '02',
                              name: 'Commercial',
                            ),
                            SizedBox(width: 10),
                            WidgetPropertyCategory(
                              number: '03',
                              name: 'Terrain',
                            ),
                            SizedBox(width: 10),
                            WidgetPropertyCategory(
                              number: '04',
                              name: 'Spécialité',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Bouton de Deconnexion

                      // ElevatedButton(
                      //   onPressed: () async {
                      //     await FirebaseAuth.instance.signOut();
                      //     SharedPreferences prefs =
                      //         await SharedPreferences.getInstance();
                      //     await prefs.remove('token');
                      //     Navigator.pushReplacement(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => const SplashScreen(),
                      //       ),
                      //     );
                      //   },
                      //   child: const Text('Déconnexion'),
                      // ),

                      // Ligne avec Title

                      // const SizedBox(height: 18),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: const [
                      //     Text(
                      //       'Vie de luxe à son meilleur',
                      //       style: TextStyle(
                      //         color: Color(0xff010101),
                      //         fontSize: 18,
                      //         fontWeight: FontWeight.w600,
                      //       ),
                      //     ),
                      //     Text(
                      //       'Voir tout',
                      //       style: TextStyle(
                      //         color: Color(0xffffd055),
                      //         fontSize: 12,
                      //         fontWeight: FontWeight.w400,
                      //         fontStyle: FontStyle.italic,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : logements.isEmpty
                      ? const Center(
                        child: Text(
                          'Aucun logement disponible pour le moment.',
                        ),
                      )
                      : SizedBox(
                        height:
                            (colonneGWidgets.length * 250.0) >
                                    (colonneDWidgets.length * 250.0)
                                ? (colonneGWidgets.length * 250.0)
                                : (colonneDWidgets.length * 250.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: colonneGWidgets.length,
                                itemBuilder:
                                    (context, index) => colonneGWidgets[index],
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: colonneDWidgets.length,
                                itemBuilder:
                                    (context, index) => colonneDWidgets[index],
                                shrinkWrap: true,
                                // physics: const NeverScrollableScrollPhysics(),
                              ),
                            ),
                          ],
                        ),
                      ),
                  //
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// //Ancien code pas encore Connecté

// import 'package:flutter/material.dart';
// import 'package:kunft/widget/widget_animation.dart';
// import 'package:kunft/widget/widget_house_infos.dart';
// import 'package:kunft/widget/widget_house_infos2.dart';
// import 'package:kunft/widget/widget_house_infos3.dart';
// import 'package:kunft/widget/widget_nav_bar_bottom.dart';
// import 'package:kunft/widget/widget_profile_infos.dart';
// import 'package:kunft/widget/widget_property_category.dart';

// import 'package:http/http.dart' as http;
// import 'dart:convert';
// //

// Future<List<dynamic>> fetchLogements(String token) async {
//   final response = await http.get(
//     Uri.parse('http://127.0.0.1:8000/api/logements'),
//     headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
//   );

//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);
//     print('Logements récupérés : $data');
//     return data; // ← une liste de logements
//   } else {
//     throw Exception('Erreur : ${response.body}');
//   }
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
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
//       imgHouse: 'assets/images/img04.jpg',
//       houseName: 'Single family home',
//       price: '\$185 000',
//       locate: '908 Elm Street, Unit 48, Aistin,',
//       ownerName: '@abigail.moore',
//       time: '2 hours ago',
//     ),
//     WidgetHouseInfos3(
//       imgHouse: 'assets/images/img05.jpg',
//       houseName: 'Single family home',
//       price: '\$185 000',
//       locate: '908 Elm Street, Unit 48, Aistin,',
//       ownerName: '@abigail.moore',
//       time: '2 hours ago',
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
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
//                               children: [
//                                 Expanded(child: WidgetProfileInfos()),
//                                 Spacer(),
//                                 Expanded(child: WidgetHouseInfos()),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 18),
//                       Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 'Property category',
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
//                                 WidgetPropertyCategory(
//                                   number: '01',
//                                   name: 'Residential',
//                                 ),
//                                 SizedBox(width: 10),
//                                 WidgetPropertyCategory(
//                                   number: '02',
//                                   name: 'Commercial',
//                                 ),
//                                 SizedBox(width: 10),
//                                 WidgetPropertyCategory(
//                                   number: '03',
//                                   name: 'Land',
//                                 ),
//                                 SizedBox(width: 10),
//                                 WidgetPropertyCategory(
//                                   number: '04',
//                                   name: 'Specialty',
//                                 ),
//                                 SizedBox(width: 10),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 18),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 'Luxury living at it\'s fitnest',
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
//                       // Ajustement Okay 1 mais Fixe
//                       // SizedBox(
//                       //   height: 600, // Ajuste cette valeur selon ton besoin
//                       //   child: GridView.builder(
//                       //     itemCount: colonneG.length,
//                       //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       //       crossAxisCount: 2,
//                       //       mainAxisSpacing: 10,
//                       //       crossAxisSpacing: 10,
//                       //       childAspectRatio: 0.75,
//                       //     ),
//                       //     itemBuilder: (context, index) {
//                       //       return Column(
//                       //         children: [colonneG[index], colonneD[index]],
//                       //       );
//                       //     },
//                       //   ),
//                       // ),

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
//           // Barre de navigation
//           Positioned(bottom: 0, child: WidgetNavBarBottom()),
//         ],
//       ),
//     );
//   }
// }
