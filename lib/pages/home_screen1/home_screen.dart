// Nouve
import 'package:flutter/material.dart';
import 'package:kunft/pages/explore_screen.dart';
import 'package:kunft/pages/home_screen1/widgets/popular_units.dart';
import 'package:kunft/pages/home_screen1/widgets/properties_categories.dart';
import 'package:kunft/pages/home_screens/home_screen2.dart';
import 'package:kunft/pages/home_screens/main_screeen.dart';
import 'package:kunft/pages/profile_screen/profile_screen.dart';
import 'package:kunft/provider/UserProvider.dart';
import 'package:provider/provider.dart'; // Import de Provider

import 'package:kunft/pages/list_logement.dart';

import 'package:kunft/widget/widget_animation.dart';
import 'package:kunft/widget/widget_house_text_infos.dart';
import 'package:kunft/widget/widget_house_infos2.dart';
import 'package:kunft/widget/widget_house_infos3.dart';
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
  // ----- Nouveau code. ------
  @override
  void initState() {
    super.initState();
    // Utilise addPostFrameCallback pour s'assurer que la fonction de
    // chargement est appelée après le premier rendu du widget.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final logementProvider = Provider.of<LogementProvider>(
        context,
        listen: false,
      );

      final token = userProvider.authToken;

      if (token != null) {
        logementProvider.fetchHomeScreenData(token);
      } else {
        // Optionnel : Gérer le cas où le jeton n'est pas disponible,
        // par exemple, en affichant un message d'erreur ou en naviguant vers la page de connexion.
        print('Erreur: Jeton d\'authentification non trouvé.');
        // logementProvider.setErrorMainLogements('Veuillez vous connecter pour voir les logements.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // Consomme les données du LogementProvider
    return Consumer<LogementProvider>(
      builder: (context, logementProvider, child) {
        // ✅ MODIFIÉ : Accédez aux données et aux états de chargement via logementProvider.mainLogements
        final List<dynamic> logements = logementProvider.mainLogements;
        final bool isLoadingLogements = logementProvider.isLoadingMainLogements;
        final String? errorLogements = logementProvider.errorMainLogements;

        // Le dernier logement sera le premier de la liste générale
        final Map<String, dynamic>? dernierLogement = logements.isNotEmpty
            ? logements.first
            : null;

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
                          // ----------------------------------------------
                          // ------- Widget d'accueil
                          // ----------------------------------------------
                          const WidgetAnimation(),
                          SizedBox(
                            height: screenHeight * 0.45,
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
                      // Nouvelle emplacement
                      const SizedBox(height: 18),
                      // // ----------------------------------------------
                      // // ------- Affichage des logements populaires : Doit afficher les logements les plus visités ou autres ----
                      // // ----------------------------------------------
                      const PopularUnits(),

                      // // ----------------------------------------------
                      // // ------- Affichage des logements Categories de Properties : Disponible ----
                      //
                      //  position des listes de catego
                      const PropertiesCategories(),
                      const SizedBox(height: 15),
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
                                color: const Color(0xFF256AFD),
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

                      //==================================================================
                      // Boutton de Nav temporaire
                      //==================================================================
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ExploreScreen(),
                                ),
                              );
                            },
                            child: const Text('Recherche'),
                          ),
                          // const SizedBox(width: 20),
                          // Exemple dans un bouton
                          ElevatedButton(
                            onPressed: () {
                              // ✅ Passe le BuildContext
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainScreeen(),
                                ),
                              );
                            },
                            child: const Text('Test accueil'),
                          ),

                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen2(),
                                ),
                              );
                            },
                            child: const Text('Home test'),
                          ),

                          // Test de notication
                          // ElevatedButton(
                          //   onPressed: showNotification,
                          //   child: const Text('Afficher la notification'),
                          // ),
                          const SizedBox(width: 20),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfileScreen(),
                                ),
                              );
                            },
                            child: const Text('Profile page '),
                          ),
                        ],
                      ),
                      //==================================================================
                      // Fin des Bouttons de Nav temporaire
                      //==================================================================
                      const SizedBox(height: 16),
                      // Affichage des logements ou indicateur de chargement/message d'erreur
                      isLoadingLogements
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF256AFD),
                              ),
                            )
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
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : SizedBox(
                              height:
                                  (colonneGWidgets.length * 270.0).toDouble() >
                                      (colonneDWidgets.length * 270.0)
                                          .toDouble()
                                  ? (colonneGWidgets.length * 270.0).toDouble()
                                  : (colonneDWidgets.length * 270.0).toDouble(),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: colonneGWidgets.length,
                                      itemBuilder: (context, index) =>
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
                                      itemBuilder: (context, index) =>
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
