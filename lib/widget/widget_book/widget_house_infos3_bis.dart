import 'package:flutter/material.dart';
import 'package:kunft/pages/property_detail.dart';
import 'package:intl/intl.dart';

class WidgetHouseInfos3Bis extends StatelessWidget {
  final Map<String, dynamic> logementData;

  const WidgetHouseInfos3Bis({super.key, required this.logementData});

  void _navigateToPropertyDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyDetail(logementData: logementData),
      ),
    );
  }

  // Fonction utilitaire pour formater le prix
  String _formatPrice(dynamic price) {
    if (price == null) {
      return 'Prix inconnu';
    }
    try {
      double parsedPrice;
      if (price is String) {
        parsedPrice = double.tryParse(price) ?? 0.0;
      } else if (price is num) {
        parsedPrice = price.toDouble();
      } else {
        return 'Prix invalide';
      }
      final formatter = NumberFormat('#,##0', 'fr_FR');
      return '${formatter.format(parsedPrice)} Fcfa';
    } catch (e) {
      return 'Prix invalide';
    }
  }

  // Fonction utilitaire pour formater la date
  String _formatDate(dynamic date) {
    if (date == null) {
      return 'Date inconnue';
    }
    try {
      final DateTime dateTime = DateTime.parse(date as String);
      final Duration difference = DateTime.now().difference(dateTime);

      if (difference.inDays > 30) {
        return DateFormat('dd MMM yyyy', 'fr_FR').format(dateTime);
      } else if (difference.inDays > 0) {
        return '${difference.inDays}j';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}min';
      } else {
        return 'à l\'instant';
      }
    } catch (e) {
      return 'Date invalide';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extraction des données de manière sécurisée et avec des valeurs par défaut robustes
    final List<dynamic>? images = logementData['images'];
    final String imgHouse = (images != null && images[0]['image_paths'] != null)
        ? '${images[0]['image_paths']}' // Lien de BD temporaire
        : 'https://placehold.co/400x400/EFEFEF/grey?text=No+Image';

    final String houseName = logementData['titre'] ?? 'Titre inconnu';
    final String price = _formatPrice(logementData['prix_par_nuit']);
    final String locate = logementData['adresse'] ?? 'Lieu inconnu';
    final String ownerName = logementData['user']?['name'] ?? 'Inconnu';
    final String time = _formatDate(logementData['created_at']);

    return GestureDetector(
      onTap: () => _navigateToPropertyDetail(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 25.0),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x80d9d9d9),
              spreadRadius: 4,
              blurRadius: 8,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: SizedBox(
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          imgHouse,
                          fit: BoxFit.cover,
                          width: 200,
                          height: 140,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 140,
                              width: 200,
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // decoration: BoxDecoration(color: Colors.pink),
                          width: 150,
                          child: Text(
                            houseName,
                            style: const TextStyle(
                              color: Color(0xFF256AFD),
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              // height: 1.2,
                            ),
                            maxLines: 3,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.only(
                            right: 7,
                            left: 7,
                            top: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF256AFD),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                price,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'BebasNeue',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Text(
                                ' | Nuit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'BebasNeue',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          // width: 150,
                          child: Row(
                            children: [
                              Text(
                                ownerName,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(width: 30),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 12,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    time,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 9,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        //
                        const SizedBox(height: 5),
                        //
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              color: Color(0xFF256AFD),
                              size: 17,
                            ),
                            const SizedBox(width: 3),
                            SizedBox(
                              width: 140,
                              child: Text(
                                locate,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                                softWrap: true,
                                textAlign: TextAlign.left,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Ancien code

// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';
// import 'package:kunft/pages/property_detail.dart';

// // ignore: camel_case_types
// class WidgetHouseInfos3Bis extends StatefulWidget {
//   final String imgHouse;
//   final String houseName;
//   final String price;
//   final String locate;
//   final String ownerName;
//   final String time;
//   final Map<String, dynamic>? logementData; // ✅ Nouveau paramètre facultatif

//   const WidgetHouseInfos3Bis({
//     Key? superkey,
//     required this.imgHouse,
//     required this.houseName,
//     required this.price,
//     required this.locate,
//     required this.ownerName,
//     required this.time,
//     this.logementData, // ✅ Rendre facultatif
//   }) : super(key: superkey);

//   @override
//   State<WidgetHouseInfos3Bis> createState() => _WidgetHouseInfos3BisState();
// }

// class _WidgetHouseInfos3BisState extends State<WidgetHouseInfos3Bis> {
//   bool isExpanded = false;
//   bool isFavorite = false;

//   // Fonction pour naviguer vers PropertyDetail
//   void _navigateToPropertyDetail() {
//     // Navigue seulement si logementData est fourni
//     if (widget.logementData != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder:
//               (context) => PropertyDetail(
//                 logementData:
//                     widget.logementData!, // Passe les données complètes
//               ),
//         ),
//       );
//     } else {
//       // Optionnel: afficher un message si logementData est manquant
//       debugPrint(
//         'logementData est null, impossible de naviguer vers PropertyDetail.',
//       );
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Détails non disponibles pour ce logement.'),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Hauteur totale estimée pour la carte, incluant l'image et les textes

//     return GestureDetector(
//       onTap: _navigateToPropertyDetail, // Appelle la fonction de navigation
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 10.0), // Marge pour l'espacement
//         // width: double.infinity,
//         // height: 160,
//         padding: EdgeInsets.all(5),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Color(0x80d9d9d9),
//               spreadRadius: 4,
//               blurRadius: 5,
//               offset: const Offset(0, 1),
//             ),
//           ],
//         ),
//         child: SizedBox(
//           height: 180,
//           child: Row(
//             // crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(17),
//                     child: Image.network(
//                       widget.imgHouse,
//                       fit: BoxFit.cover,
//                       // width: double.infinity,
//                       height: 130,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Container(
//                           height: 180,
//                           width: 180,
//                           color: Colors.grey[300],
//                           child: const Center(
//                             child: Icon(Icons.broken_image, color: Colors.grey),
//                           ),
//                         );
//                       },
//                     ),
//                   ),

//                   // Boutons d'interaction (Share et Favorite) - Ces InkWell ne sont pas affectés par le GestureDetector parent
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         // InkWell(
//                         //   onTap: () {
//                         //     debugPrint(
//                         //       'Partager le logement: ${widget.houseName}',
//                         //     );
//                         //   },
//                         //   child: Container(
//                         //     padding: const EdgeInsets.all(5),
//                         //     decoration: BoxDecoration(
//                         //       color: const Color(0x26000000),
//                         //       borderRadius: BorderRadius.circular(50),
//                         //     ),
//                         //     child: const Icon(
//                         //       Icons.share,
//                         //       color: Colors.white,
//                         //       size: 18,
//                         //     ),
//                         //   ),
//                         // ),
//                         // const SizedBox(width: 5),
//                         // InkWell(
//                         //   onTap: () {
//                         //     setState(() {
//                         //       isFavorite = !isFavorite;
//                         //     });
//                         //     debugPrint(
//                         //       'Logement ${widget.houseName} favori: $isFavorite',
//                         //     );
//                         //   },
//                         //   child: Container(
//                         //     padding: const EdgeInsets.all(5),
//                         //     decoration: BoxDecoration(
//                         //       color: const Color(0x40ffffff),
//                         //       borderRadius: BorderRadius.circular(50),
//                         //     ),
//                         //     child: Icon(
//                         //       isFavorite
//                         //           ? Icons.favorite_rounded
//                         //           : Icons.favorite_border_rounded,
//                         //       color: isFavorite ? Colors.red : Colors.white,
//                         //       size: 18,
//                         //     ),
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               // 2e Partie de bloc
//               SizedBox(
//                 height: 170,
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 6),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 5.0),
//                       child: Column(
//                         children: [
//                           // SizedBox(height: 3),
//                           //
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Nom de maison et Heure
//                               SizedBox(
//                                 // decoration: BoxDecoration(color: Colors.orange),
//                                 width: 160,
//                                 child: Text(
//                                   widget.houseName,
//                                   style: const TextStyle(
//                                     color: Color(0xFF256AFD),
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.w500,
//                                     height: 1.2,
//                                   ),
//                                   maxLines: 3,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               //
//                               Row(
//                                 // crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     widget.price,
//                                     style: const TextStyle(
//                                       color: Color(0xFF256AFD),
//                                       fontSize: 35,
//                                       fontFamily: 'BebasNeue',
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                   //
//                                   Text(
//                                     ' | Nuit',
//                                     style: const TextStyle(
//                                       color: Color(0xFF256AFD),
//                                       fontSize: 18,
//                                       // fontFamily: 'BebasNeue',
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           //
//                           SizedBox(height: 45),
//                           // Spacer(),
//                           // Nom du user, Date et Lieux
//                           Column(
//                             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               // Nom du user
//                               Row(
//                                 children: [
//                                   Text(
//                                     widget.ownerName,
//                                     style: const TextStyle(
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.w500,
//                                       color: Colors.black54,
//                                     ),
//                                   ),
//                                   //
//                                   SizedBox(width: 30),
//                                   Row(
//                                     children: [
//                                       const Icon(
//                                         Icons.access_time,
//                                         size: 12,
//                                         color: Colors.grey,
//                                       ),
//                                       const SizedBox(width: 5),
//                                       Text(
//                                         widget.time,
//                                         style: const TextStyle(
//                                           color: Colors.grey,
//                                           fontSize: 10,
//                                           fontStyle: FontStyle.italic,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               //
//                               Row(
//                                 children: [
//                                   const Icon(
//                                     Icons.location_on_rounded,
//                                     color: Color(0xFF256AFD),
//                                     size: 17,
//                                   ),
//                                   const SizedBox(width: 3),
//                                   SizedBox(
//                                     // decoration: BoxDecoration(color: Colors.amber),
//                                     width: 170,
//                                     child: Text(
//                                       widget.locate,
//                                       style: const TextStyle(
//                                         fontSize: 10,
//                                         fontWeight: FontWeight.w500,
//                                         color: Colors.black54,
//                                       ),
//                                       softWrap: true,
//                                       textAlign: TextAlign.left,
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
