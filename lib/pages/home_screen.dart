// Nouve
import 'package:flutter/material.dart';
import 'package:kunft/pages/book/payment_page.dart';
import 'package:kunft/pages/chat/chat_page.dart';
import 'package:provider/provider.dart'; // Import de Provider

import 'package:kunft/pages/list_logement.dart';
import 'package:kunft/pages/list_logement_populaire.dart';
import 'package:kunft/pages/chat/messaging_page2.dart' hide Message;

import 'package:kunft/widget/widget_animation.dart';
import 'package:kunft/widget/widget_house_text_infos.dart';
import 'package:kunft/widget/widget_house_infos2.dart';
import 'package:kunft/widget/widget_house_infos3.dart';
import 'package:kunft/widget/widget_popular_house_infos.dart';
import 'package:kunft/widget/widget_profile_infos.dart';

// Importez votre LogementProvider
import 'package:kunft/provider/logement_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Appelle la fonction de fetch du provider
    // listen: false car nous ne voulons pas reconstruire le widget ici, juste appeler la fonction
    Provider.of<LogementProvider>(context, listen: false).fetchHomeScreenData();
  }

  @override
  Widget build(BuildContext context) {
    // Consomme les données du LogementProvider
    return Consumer<LogementProvider>(
      builder: (context, logementProvider, child) {
        // ✅ MODIFIÉ : Accédez aux données et aux états de chargement via logementProvider.mainLogements
        final List<dynamic> logements = logementProvider.mainLogements;
        final bool isLoadingLogements = logementProvider.isLoadingMainLogements;
        final String? errorLogements = logementProvider.errorMainLogements;

        final List<dynamic> popularLogements =
            logementProvider.popularLogements;
        final bool isLoadingPopularLogements =
            logementProvider.isLoadingPopularLogements;
        final String? errorPopularLogements =
            logementProvider.errorPopularLogements;

        // Le dernier logement sera le premier de la liste générale
        final Map<String, dynamic>? dernierLogement =
            logements.isNotEmpty ? logements.first : null;

        List<Widget> colonneGWidgets = [];
        List<Widget> colonneDWidgets = [];

        // On parcourt les logements et on prépare les données pour les widgets enfants
        for (int i = 0; i < logements.length; i++) {
          final l = logements[i];
          final formattedData = logementProvider.formatLogementData(
            l,
          ); // Utilisez le helper du provider

          if (i.isEven) {
            colonneGWidgets.add(
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: WidgetHouseInfos2(
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
          } else {
            colonneDWidgets.add(
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: WidgetHouseInfos3(
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
                          WidgetAnimation(logementData: dernierLogement),
                          SizedBox(
                            height: 420,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(child: WidgetProfileInfos()),
                                const Spacer(),
                                WidgetHouseTextInfos(
                                  logementData: dernierLogement,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      // Affichage des logements populaires
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Logement Populaire',
                                style: TextStyle(
                                  color: Color(0xff010101),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              const ListLogementPopulaire(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'Voir tout',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // FUTURE IMPROVEMENT: Cette section affichera les logements des propriétaires ayant payé l'abonnement
                          isLoadingPopularLogements
                              ? const Center(child: CircularProgressIndicator())
                              : errorPopularLogements != null
                              ? Center(
                                child: Text(
                                  'Erreur: $errorPopularLogements',
                                  textAlign: TextAlign.center,
                                ),
                              )
                              : popularLogements.isEmpty
                              ? const Center(
                                child: Text(
                                  'Aucun logement populaire disponible.',
                                ),
                              )
                              : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  height: 130,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        popularLogements.map((l) {
                                          final formattedData = logementProvider
                                              .formatLogementData(l);
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              right: 10.0,
                                            ),
                                            child: WidgetPopularHouseInfos(
                                              imgHouse:
                                                  formattedData['imgUrl']!,
                                              houseName:
                                                  formattedData['houseName']!,
                                              price: formattedData['price']!,
                                              locate: formattedData['locate']!,
                                              ownerName:
                                                  formattedData['ownerName']!,
                                              time: formattedData['time']!,
                                              logementData: l,
                                            ),
                                          );
                                        }).toList(),
                                  ),
                                ),
                              ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Logements Disponibles',
                            style: TextStyle(
                              color: Color(0xff010101),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ListLogement(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Voir tout',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Boutton de Nav temporaire
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PaymentPage(),
                                ),
                              );
                            },
                            child: const Text('review infos'),
                          ),
                          const SizedBox(width: 20),
                          const SizedBox(width: 30),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MessagingPage2(),
                                ),
                              );
                            },
                            child: Logout(),
                          ),
                          // const SizedBox(width: 30),
                          // InkWell(
                          //   onTap: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => const CustomNavBar(),
                          //       ),
                          //     );
                          //   },
                          //   child: const Text('Bottom Nav Ba'),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Affichage des logements ou indicateur de chargement/message d'erreur
                      isLoadingLogements
                          ? const Center(child: CircularProgressIndicator())
                          : errorLogements != null
                          ? Center(
                            child: Text(
                              errorLogements,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                          : logements.isEmpty
                          ? const Center(
                            child: Text(
                              'Aucun logement disponible pour le moment.',
                            ),
                          )
                          : SizedBox(
                            height:
                                (colonneGWidgets.length * 270.0).toDouble() >
                                        (colonneDWidgets.length * 270.0)
                                            .toDouble()
                                    ? (colonneGWidgets.length * 270.0)
                                        .toDouble()
                                    : (colonneDWidgets.length * 270.0)
                                        .toDouble(),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: colonneGWidgets.length,
                                    itemBuilder:
                                        (context, index) =>
                                            colonneGWidgets[index],
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: colonneDWidgets.length,
                                    itemBuilder:
                                        (context, index) =>
                                            colonneDWidgets[index],
                                    shrinkWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Ancien code fonctionnel avec Fir

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:dio/dio.dart';
// import 'package:intl/intl.dart';
// import 'package:kunft/pages/list_logement.dart';
// import 'package:kunft/pages/list_logement_populaire.dart';
// import 'package:kunft/pages/chat/message.dart';
// import 'package:kunft/pages/chat/messaging_page2.dart' hide Message;
// import 'package:kunft/pages/profile_screen.dart';

// import 'package:kunft/widget/widget_animation.dart';
// import 'package:kunft/widget/widget_house_text_infos.dart';
// import 'package:kunft/widget/widget_house_infos2.dart';
// import 'package:kunft/widget/widget_house_infos3.dart';
// import 'package:kunft/widget/widget_popular_house_infos.dart';
// import 'package:kunft/widget/widget_profile_infos.dart';

// const String API_BASE_URL = 'http://127.0.0.1:8000';

// final Dio _dio = Dio();

// // --- Fonction de récupération des logements ajustée pour le format API attendu ---
// Future<List<dynamic>> fetchLogements() async {
//   try {
//     final response = await _dio.get(
//       '$API_BASE_URL/api/logements',
//       options: Options(headers: {'Accept': 'application/json'}),
//     );

//     print('DEBUG: API Call /logements...');
//     print('DEBUG: Response status : ${response.statusCode}');
//     print('DEBUG: Response data : ${response.data}');

//     if (response.statusCode == 200) {
//       // ✅ CHANGEMENT ICI : Attendez-vous à une liste directement si l'API renvoie [{}, {}]
//       // Si l'API renvoie {'logements': [{}, {}]}, remettez response.data['logements']
//       if (response.data is List) {
//         return response.data;
//       } else {
//         throw Exception(
//           'Format de réponse API inattendu. La réponse n\'est pas une liste directement.',
//         );
//       }
//     } else {
//       throw Exception(
//         'Erreur de chargement des propriétés : ${response.statusCode} - ${response.data}',
//       );
//     }
//   } on DioException catch (e) {
//     if (e.response != null) {
//       print(
//         'DEBUG: Dio Error Response: ${e.response?.statusCode} - ${e.response?.data}',
//       );
//       throw Exception(
//         'Erreur de requête Dio : ${e.response?.statusCode} - ${e.response?.data}',
//       );
//     } else {
//       print('DEBUG: Dio Error Request: ${e.requestOptions.uri}');
//       print('DEBUG: Dio Error Message: ${e.message}');
//       throw Exception('Erreur réseau ou de configuration Dio : ${e.message}');
//     }
//   } catch (e) {
//     print('DEBUG: Erreur inattendue lors du fetch des logements: $e');
//     throw Exception('Une erreur inattendue est survenue : $e');
//   }
// }

// class HomeScreen extends StatefulWidget {
//   final User? user;

//   const HomeScreen({super.key, required this.user});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List<dynamic> logements = [];
//   bool isLoading = true;
//   Map<String, dynamic>? dernierLogement;
//   String? errorMessage; // Pour stocker les messages d'erreur de chargement

//   @override
//   void initState() {
//     super.initState();
//     chargerLogements();
//   }

//   Future<void> chargerLogements() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = null; // Réinitialise l'erreur avant chaque chargement
//     });
//     try {
//       final data = await fetchLogements();
//       setState(() {
//         logements = data;
//         isLoading = false;
//         if (logements.isNotEmpty) {
//           dernierLogement = logements.first;
//         }
//       });
//       print('DEBUG: Logements chargés : ${logements.length}');
//       if (dernierLogement != null) {
//         print('DEBUG: Dernier logement ID: ${dernierLogement!['id']}');
//       }
//     } catch (e) {
//       print('DEBUG: Erreur lors du chargement des propriétés: $e');
//       setState(() {
//         isLoading = false;
//         errorMessage =
//             'Impossible de charger les propriétés : $e'; // Stocke l'erreur
//       });
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(errorMessage!)));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> colonneGWidgets = [];
//     List<Widget> colonneDWidgets = [];

//     // On parcourt les logements et on prépare les données pour les widgets enfants
//     for (int i = 0; i < logements.length; i++) {
//       final l = logements[i]; // C'est l'objet Map<String, dynamic> complet

//       // --- Extraction et formatage des données pour les widgets inchangés ---
//       final String imgUrl =
//           (l['images'] != null && l['images'].isNotEmpty)
//               ? '$API_BASE_URL/storage/${l['images'][0]['image_path']}'
//               : 'https://www.batiactu.com/images/auto/620-465-c/20210913_170834_immobilier-dossier-credit-istock.jpg';

//       final String ownerName =
//           (l['user'] != null && l['user']['name'] != null)
//               ? '@${(l['user']['name'] as String).replaceAll(' ', '.').toLowerCase()}'
//               : '@proprietaire.inconnu';

//       String formattedTime = 'Date inconnue';
//       if (l['created_at'] != null) {
//         try {
//           final DateTime dateTime = DateTime.parse(l['created_at'] as String);
//           final Duration difference = DateTime.now().difference(dateTime);
//           if (difference.inDays > 30) {
//             formattedTime = DateFormat('dd MMM yyyy', 'fr_FR').format(dateTime);
//           } else if (difference.inDays > 0) {
//             formattedTime =
//                 '${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
//           } else if (difference.inHours > 0) {
//             formattedTime =
//                 '${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
//           } else if (difference.inMinutes > 0) {
//             formattedTime =
//                 '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
//           } else {
//             formattedTime = 'à l\'instant';
//           }
//         } catch (e) {
//           print('DEBUG: Erreur de parsing ou formatage de date: $e');
//           formattedTime = 'Date invalide';
//         }
//       }

//       String formattedPrice = 'N/A';
//       if (l['prix_par_nuit'] != null) {
//         try {
//           double price;
//           if (l['prix_par_nuit'] is String) {
//             price = double.parse(l['prix_par_nuit'] as String);
//           } else if (l['prix_par_nuit'] is num) {
//             price = (l['prix_par_nuit'] as num).toDouble();
//           } else {
//             throw FormatException('Type de prix inattendu');
//           }
//           formattedPrice = NumberFormat('#,##0', 'fr_FR').format(price);
//         } catch (e) {
//           print(
//             'DEBUG: Erreur de formatage du prix pour "${l['prix_par_nuit']}" : $e',
//           );
//           formattedPrice = 'Prix invalide';
//         }
//       }

//       // Alterner entre WidgetHouseInfos2 et WidgetHouseInfos3
//       if (i.isEven) {
//         colonneGWidgets.add(
//           Padding(
//             // Ajoutez un Padding si vous voulez un espacement vertical entre les widgets
//             padding: const EdgeInsets.only(bottom: 8.0),
//             child: WidgetHouseInfos2(
//               imgHouse: imgUrl,
//               houseName: l['titre'] ?? 'Titre Inconnu',
//               price: '$formattedPrice Fcfa',
//               locate: l['adresse'] ?? '',
//               ownerName: ownerName,
//               time: formattedTime,
//               logementData: l, // ✅ PASSEZ LE LOGEMENT DATA ICI
//             ),
//           ),
//         );
//       } else {
//         colonneDWidgets.add(
//           Padding(
//             // Ajoutez un Padding si vous voulez un espacement vertical entre les widgets
//             padding: const EdgeInsets.only(bottom: 8.0),
//             child: WidgetHouseInfos3(
//               imgHouse: imgUrl,
//               houseName: l['titre'] ?? 'Titre Inconnu',
//               price: '$formattedPrice Fcfa',
//               locate: l['adresse'] ?? '',
//               ownerName: ownerName,
//               time: formattedTime,
//               logementData: l, // ✅ PASSEZ LE LOGEMENT DATA ICI
//             ),
//           ),
//         );
//       }
//     }

//     return Scaffold(
//       backgroundColor: const Color(0xfff7f7f7),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                 children: [
//                   Stack(
//                     children: [
//                       // Passez le dernier logement à WidgetAnimation
//                       WidgetAnimation(logementData: dernierLogement),
//                       SizedBox(
//                         height: 400,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Expanded(child: WidgetProfileInfos()),
//                             const Spacer(),
//                             WidgetHouseTextInfos(logementData: dernierLogement),
//                             const SizedBox(height: 20),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 18),
//                   // Affichage des logements de ceux qui ont payé l'abonnement
//                   Column(
//                     children: [
//                       Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 'Logement Populaire',
//                                 style: TextStyle(
//                                   color: Color(0xff010101),
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               //
//                               InkWell(
//                                 onTap: () {
//                                   setState(() {});
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder:
//                                           (context) => ListLogementPopulaire(),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 10,
//                                     vertical: 5,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.blue,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Text(
//                                     'Voir tout',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 11,
//                                       fontWeight: FontWeight.w700,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           //
//                           SizedBox(height: 12),
//                           // Appel de Widget
//                           SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: SizedBox(
//                               height: 130,
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   WidgetPopularHouseInfos(
//                                     imgHouse: 'assets/images/img03.jpg',
//                                     houseName: 'Studio test',
//                                     price: '30 000',
//                                     locate: 'Douala, NdogBong',
//                                     ownerName: 'Collins',
//                                     time: '20h34',
//                                   ),
//                                   //
//                                   WidgetPopularHouseInfos(
//                                     imgHouse: 'assets/images/img05.jpg',
//                                     houseName: 'Studio test',
//                                     price: '30 000',
//                                     locate: 'Douala, NdogBong',
//                                     ownerName: 'Collins',
//                                     time: '20h34',
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       //
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Logements Disponibles',
//                             // 'Catégorie de logement',
//                             style: TextStyle(
//                               color: Color(0xff010101),
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           //
//                           InkWell(
//                             onTap: () {
//                               setState(() {});
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => ListLogement(),
//                                 ),
//                               );
//                             },
//                             child: Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 10,
//                                 vertical: 5,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.blue,
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Text(
//                                 'Voir tout',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),

//                       // Ce scroll sera dans un widget

//                       // Bouton page Profile "Teste"
//                       Row(
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               setState(() {});
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => ProfileScreen(),
//                                 ),
//                               );
//                             },
//                             child: Text('Page profile'),
//                           ),
//                           SizedBox(width: 30),
//                           //
//                           // InkWell(
//                           //   onTap: () {
//                           //     setState(() {});
//                           //     Navigator.push(
//                           //       context,
//                           //       MaterialPageRoute(
//                           //         builder: (context) => Message(),
//                           //       ),
//                           //     );
//                           //   },
//                           //   child: Text('Messaging Page'),
//                           // ),
//                           //
//                           SizedBox(width: 30),
//                           InkWell(
//                             onTap: () {
//                               setState(() {});
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => MessagingPage2(),
//                                 ),
//                               );
//                             },
//                             child: Text('Messaging Page'),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   // Affichage des logements ou indicateur de chargement/message d'erreur
//                   isLoading
//                       ? const Center(child: CircularProgressIndicator())
//                       : errorMessage !=
//                           null // Affiche l'erreur si elle existe
//                       ? Center(
//                         child: Text(
//                           errorMessage!,
//                           style: const TextStyle(
//                             color: Colors.red,
//                             fontSize: 16,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       )
//                       : logements.isEmpty
//                       ? const Center(
//                         child: Text(
//                           'Aucun logement disponible pour le moment.',
//                         ),
//                       )
//                       : SizedBox(
//                         // Calcul de la hauteur dynamique pour les ListView
//                         // Ajustez ces valeurs (ex: 250.0 ou 270.0) selon la hauteur réelle de vos cartes
//                         height:
//                             (colonneGWidgets.length * 270.0).toDouble() >
//                                     (colonneDWidgets.length * 270.0).toDouble()
//                                 ? (colonneGWidgets.length * 270.0).toDouble()
//                                 : (colonneDWidgets.length * 270.0).toDouble(),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: ListView.builder(
//                                 padding: EdgeInsets.zero,
//                                 itemCount: colonneGWidgets.length,
//                                 itemBuilder:
//                                     (context, index) => colonneGWidgets[index],
//                                 shrinkWrap: true,
//                                 physics: const NeverScrollableScrollPhysics(),
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             Expanded(
//                               child: ListView.builder(
//                                 padding: EdgeInsets.zero,
//                                 itemCount: colonneDWidgets.length,
//                                 itemBuilder:
//                                     (context, index) => colonneDWidgets[index],
//                                 shrinkWrap: true,
//                                 // physics: const NeverScrollableScrollPhysics(),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                   const SizedBox(height: 50),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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
