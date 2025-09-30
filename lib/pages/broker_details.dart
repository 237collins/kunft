import 'package:flutter/material.dart';
import 'package:kunft/pages/chat/messaging_page2.dart';
import 'package:kunft/widget/widget_animation3.dart';
import 'package:kunft/widget/widget_broker_infos.dart';
import 'package:kunft/widget/widget_broker_list.dart';
import 'package:kunft/widget/widget_owner_profile2.dart';
import 'package:kunft/widget/widget_property_top_nav_bar2.dart';
import 'package:lucide_icons/lucide_icons.dart';
// Importez la constante API_BASE_URL depuis votre LogementProvider
import 'package:kunft/provider/logement_provider.dart' show API_BASE_URL;

class BrokerDetails extends StatelessWidget {
  // ✅ MODIFIÉ : Devient un StatelessWidget
  final Map<String, dynamic>
  ownerData; // ✅ AJOUTÉ : Reçoit toutes les données du propriétaire

  const BrokerDetails({
    super.key,
    required this.ownerData,
  }); // ✅ MODIFIÉ : Constructeur avec ownerData

  @override
  Widget build(BuildContext context) {
    // Accédez aux données du propriétaire via ownerData

    // final String name = ownerData['name'] ?? 'Nom Inconnu';

    // final String name = (ownerData['name'] ?? 'Inconnu').toUpperCase();

    // Premiere lettre en majuscule
    String rawName = ownerData['name'] ?? 'Inconnu';
    final String name = rawName.isNotEmpty
        ? rawName[0].toUpperCase() + rawName.substring(1).toLowerCase()
        : 'Inconnu';
    //
    final String profileImage = ownerData['profile_image'] ?? '';
    final String logementsCount = (ownerData['logements_count'] ?? 0)
        .toString();

    // Construire l'URL complète de l'image de profil
    final String fullProfileImageUrl = profileImage.isNotEmpty
        ? '$API_BASE_URL/storage/$profileImage'
        : 'https://placehold.co/600x400/png';

    // Image de couverture
    final String fullCoverImageUrl = profileImage.isNotEmpty
        ? '$API_BASE_URL/storage/$profileImage'
        : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhsXUFt7Wnbe4xWz1ccciA8eIj40IBXeVYg6zsaMIMnPVb_tWRBgOxPpm3hoXDgqQKJZ4&usqp=CAU';

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Column(
              children: [
                const WidgetPropertyTopNavBar2(
                  title: 'Détails du Courtier',
                ), // ✅ MODIFIÉ : Titre plus explicite
                const SizedBox(height: 5),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // ✅ MODIFIÉ : Passe l'image de profil du propriétaire à WidgetAnimation3
                    WidgetAnimation3(img: fullCoverImageUrl),

                    Positioned(
                      bottom: -65,
                      left: 10,
                      child: Column(
                        children: [
                          // ✅ MODIFIÉ : Passe les données dynamiques au WidgetOwnerProfile2
                          WidgetOwnerProfile2(
                            ownerName: name,
                            imgOwner: fullProfileImageUrl,
                            number: logementsCount,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: -45,
                      right: 0,
                      child: GestureDetector(
                        // onTap: () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => const MessagingPage2(),
                        //     ),
                        //   );
                        // },
                        child: Container(
                          padding: const EdgeInsets.all(4), // Ajout de const
                          decoration: const BoxDecoration(
                            // Ajout de const
                            color: Colors.white,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              // Ajout de const
                              horizontal: 15,
                              vertical: 5,
                            ),
                            decoration: const BoxDecoration(
                              // Ajout de const
                              color: Color(0xffffd700),
                            ),
                            child: const Row(
                              // Ajout de const
                              children: [
                                Icon(
                                  LucideIcons.fileCheck,
                                  color: Colors.black87,
                                ),
                                SizedBox(width: 7),
                                Text(
                                  'Consulter',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            //
            Column(
              children: [
                const SizedBox(height: 70),
                // Infos de suivi
                const SizedBox(height: 15),
                // ✅ MODIFIÉ : Passe le nombre de propriétés réel
                WidgetBrokerInfos(
                  follower:
                      '1K', // Placeholder, à remplacer par des données réelles si disponibles
                  following:
                      '13.K', // Placeholder, à remplacer par des données réelles si disponibles
                  property:
                      logementsCount, // ✅ Utilise le nombre de logements du propriétaire
                ),
                //
                const SizedBox(height: 10), // Ajout de const
              ],
            ),
            // Partie Scrollable
            const Expanded(
              // ✅ AJOUTÉ : Expanded pour que SingleChildScrollView prenne l'espace restant
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ), // Ajout de const
                  child: Column(
                    children: [
                      //
                      SizedBox(height: 10), // Ajout de const
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            // Ajout de const
                            'Autres Propriétaires',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Padding(
                            // Ajout de const
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.keyboard_arrow_down_outlined,
                              color: Color(0xffffd055),
                            ),
                          ),
                        ],
                      ),
                      //
                      SizedBox(height: 10), // Ajout de const
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Ajout de const
                            // Appel de Widget ici (ces données sont statiques pour l'instant)
                            WidgetBrokerList(
                              brokerName: 'Momo',
                              propertyNumber: '5',
                            ),
                            WidgetBrokerList(
                              brokerName: 'Collins',
                              propertyNumber: '3',
                            ),
                            WidgetBrokerList(
                              brokerName: 'Loanne',
                              propertyNumber: '15',
                            ),
                            WidgetBrokerList(
                              brokerName: 'Anne',
                              propertyNumber: '20',
                            ),
                          ],
                        ),
                      ),
                      //
                      SizedBox(height: 15), // Ajout de const
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Ajout de const
                          Text(
                            'Logement les plus visités',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.keyboard_arrow_down_outlined,
                              color: Color(0xffffd055),
                            ),
                          ),
                        ],
                      ),
                      // Afichage du Listview Widget_House_Infos 2 et 3
                      // Text('Afichage du Listview Widget_House_Infos2_Bis'),
                      SizedBox(height: 20), // Ajout d'un espace en bas
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Ancien code statique

// import 'package:flutter/material.dart';
// import 'package:kunft/pages/chat/messaging_page2.dart';
// import 'package:kunft/widget/widget_animation3.dart';
// import 'package:kunft/widget/widget_broker_infos.dart';
// import 'package:kunft/widget/widget_broker_list.dart';
// import 'package:kunft/widget/widget_owner_profile2.dart';
// import 'package:kunft/widget/widget_property_top_nav_bar2.dart';
// import 'package:lucide_icons/lucide_icons.dart';

// class BrokerDetails extends StatefulWidget {
//   const BrokerDetails({super.key});

//   @override
//   State<BrokerDetails> createState() => _BrokerDetailsState();
// }

// class _BrokerDetailsState extends State<BrokerDetails> {
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.only(top: 50),
//         child: Column(
//           children: [
//             Column(
//               children: [
//                 WidgetPropertyTopNavBar2(title: 'Détails'),
//                 SizedBox(height: 5),
//                 Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     WidgetAnimation3(
//                       img:
//                           'https://www.marbella-hills-homes.com/cms/wp-content/uploads/2018/04/mh2940_2_villa-at-night.jpg',
//                     ),

//                     // Ce widget est temporaire
//                     Positioned(
//                       bottom: -65,
//                       left: 10,
//                       child: Column(
//                         children: [
//                           // SizedBox(height: 10),
//                           WidgetOwnerProfile2(
//                             ownerName: 'Momo',
//                             imgOwner:
//                                 'https://images.pexels.com/photos/697509/pexels-photo-697509.jpeg?cs=srgb&dl=pexels-andrewperformance1-697509.jpg&fm=jpg',
//                           ),
//                         ],
//                       ),
//                     ),
//                     //
//                     Positioned(
//                       bottom: -45,
//                       right: 0,
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const MessagingPage2(),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           padding: EdgeInsets.all(4),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             // borderRadius: BorderRadius.only(
//                             //   bottomRight: Radius.circular(25),
//                             //   bottomLeft: Radius.circular(25),
//                             //   // topLeft: Radius.circular(5),
//                             //   topRight: Radius.circular(25),
//                             // ),
//                           ),
//                           child: Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 5,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Color(0xffffd700),
//                               // borderRadius: BorderRadius.only(
//                               //   bottomRight: Radius.circular(30),
//                               //   bottomLeft: Radius.circular(10),
//                               //   topLeft: Radius.circular(10),
//                               //   topRight: Radius.circular(30),
//                               // ),
//                             ),
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   LucideIcons.fileCheck,
//                                   color: Colors.black87,
//                                 ),
//                                 SizedBox(width: 7),
//                                 Text(
//                                   'Consulter',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black87,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             //
//             Column(
//               children: [
//                 SizedBox(height: 70),
//                 // Infos de suivi
//                 SizedBox(height: 15),
//                 WidgetBrokerInfos(
//                   follower: '1K',
//                   following: '13.K',
//                   property: '20',
//                 ),
//                 //
//                 SizedBox(height: 10),
//               ],
//             ),
//             // Partie Scrollable
//             Column(
//               children: [
//                 //
//                 SizedBox(
//                   height: screenHeight * .48,
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 10, right: 10),
//                       child: Column(
//                         children: [
//                           //
//                           SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 'Autres Propriétaires',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(4.0),
//                                 child: Icon(
//                                   Icons.keyboard_arrow_down_outlined,
//                                   color: Color(0xffffd055),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           //
//                           SizedBox(height: 10),
//                           SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 // Appel de Widget ici
//                                 WidgetBrokerList(
//                                   brokerName: 'Momo',
//                                   propertyNumber: '5',
//                                 ),
//                                 WidgetBrokerList(
//                                   brokerName: 'Collins',
//                                   propertyNumber: '3',
//                                 ),
//                                 WidgetBrokerList(
//                                   brokerName: 'Loanne',
//                                   propertyNumber: '15',
//                                 ),
//                                 WidgetBrokerList(
//                                   brokerName: 'Anne',
//                                   propertyNumber: '20',
//                                 ),
//                               ],
//                             ),
//                           ),
//                           //
//                           SizedBox(height: 15),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 // Voici la logique de ce bloc
//                                 // Il doit avoir au moins 2 de ses logements visités
//                                 // pour que cette liste s'active et les affichent
//                                 'logement les plus visités',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(4.0),
//                                 child: Icon(
//                                   Icons.keyboard_arrow_down_outlined,
//                                   color: Color(0xffffd055),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           // Afichage du Listview Widget_House_Infos 2 et 3
//                           // Text('Afichage du Listview Widget_House_Infos2_Bis'),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
