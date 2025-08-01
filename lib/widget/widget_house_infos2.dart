// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:kunft/pages/property_detail.dart';

class WidgetHouseInfos2 extends StatefulWidget {
  final String imgHouse;
  final String houseName;
  final String price;
  final String locate;
  final String ownerName;
  final String time;
  final Map<String, dynamic>? logementData; // ✅ Nouveau paramètre facultatif

  const WidgetHouseInfos2({
    Key? superkey,
    required this.imgHouse,
    required this.houseName,
    required this.price,
    required this.locate,
    required this.ownerName,
    required this.time,
    this.logementData, // ✅ Rendre facultatif
  }) : super(key: superkey);

  @override
  State<WidgetHouseInfos2> createState() => _WidgetHouseInfos2State();
}

class _WidgetHouseInfos2State extends State<WidgetHouseInfos2> {
  bool isExpanded = false;
  bool isFavorite = false;

  // Fonction pour naviguer vers PropertyDetail
  void _navigateToPropertyDetail() {
    // Navigue seulement si logementData est fourni
    if (widget.logementData != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => PropertyDetail(
                logementData:
                    widget.logementData!, // Passe les données complètes
              ),
        ),
      );
    } else {
      // Optionnel: afficher un message si logementData est manquant
      debugPrint(
        'logementData est null, impossible de naviguer vers PropertyDetail.',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Détails non disponibles pour ce logement.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hauteur totale estimée pour la carte, incluant l'image et les textes
    const double totalCardHeight = 220.0; // Ajustez cette valeur au besoin

    return GestureDetector(
      // ✅ Encapsule tout le widget avec GestureDetector
      onTap: _navigateToPropertyDetail, // Appelle la fonction de navigation
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0), // Marge pour l'espacement
        width: double.infinity,
        height: totalCardHeight * .9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color(0x1a000000),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(-2, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.imgHouse,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 165,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 165,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 140,
                          child: Text(
                            widget.houseName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              widget.price,
                              style: const TextStyle(
                                color: Colors.white,
                                // fontSize: 16,
                                // fontFamily: 'BebasNeue',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //
                            Text(
                              ' | Nuit',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                // fontFamily: 'BebasNeue',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              color: Colors.white,
                              size: 17,
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                widget.locate,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                softWrap: true,
                                textAlign: TextAlign.left,
                                maxLines: isExpanded ? null : 1,
                                overflow:
                                    isExpanded
                                        ? TextOverflow.visible
                                        : TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Boutons d'interaction (Share et Favorite) - Ces InkWell ne sont pas affectés par le GestureDetector parent
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          debugPrint(
                            'Partager le logement: ${widget.houseName}',
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0x1affffff),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                          debugPrint(
                            'Logement ${widget.houseName} favori: $isFavorite',
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0x1affffff),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isFavorite ? Colors.red : Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.ownerName,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.time,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Ancien ode statique

// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';

// class WidgetHouseInfos2 extends StatefulWidget {
//   final String imgHouse;
//   final String houseName;
//   final String price;
//   final String locate;
//   final String ownerName;
//   final String time;

//   const WidgetHouseInfos2({
//     Key? superkey,
//     required this.imgHouse,
//     required this.houseName,
//     required this.price,
//     required this.locate,
//     required this.ownerName,
//     required this.time,
//   }) : super(key: superkey);

//   @override
//   State<WidgetHouseInfos2> createState() => _WidgetHouseInfos2State();
// }

// class _WidgetHouseInfos2State extends State<WidgetHouseInfos2> {
//   bool isExpanded = false;
//   bool isFavorite = false;
//   @override
//   Widget build(BuildContext context) {
//     return ConstrainedBox(
//       constraints: BoxConstraints(
//         minHeight: 150,
//         minWidth: 130,
//         // maxWidth: 150,
//         maxHeight: 200,
//       ),
//       child: Column(
//         children: [
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: Image.network(
//                   //insert image
//                   widget.imgHouse,
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                   height: 165,
//                 ),
//               ),
//               Positioned.fill(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     gradient: const LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [Colors.transparent, Colors.black54],
//                     ),
//                   ),
//                 ),
//               ),
//               // Text
//               Positioned(
//                 bottom: 0,
//                 child: Container(
//                   padding: EdgeInsets.all(10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         width: 140,
//                         child: Text(
//                           // nom du mobilier
//                           widget.houseName,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       Text(
//                         // Prix
//                         widget.price,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       SizedBox(
//                         // width: 150,
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.location_on_rounded,
//                               color: Colors.white,
//                               size: 17,
//                             ),
//                             SizedBox(width: 3),
//                             Text(
//                               // nom du lieu
//                               widget.locate,
//                               style: TextStyle(
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.white,
//                               ),
//                               softWrap: true,
//                               textAlign: TextAlign.left,
//                               maxLines: isExpanded ? null : 1,
//                               overflow:
//                                   isExpanded
//                                       ? TextOverflow.visible
//                                       : TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
    
//               // Bouton d'interaction
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     // Bouton Share
//                     InkWell(
//                       onTap: () {
//                         // Ajoute l'action d partage ici
//                       },
//                       child: Row(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(5),
//                             child: Container(
//                               padding: EdgeInsets.all(5),
//                               decoration: BoxDecoration(
//                                 color: Color(0x1affffff),
//                                 borderRadius: BorderRadius.circular(50),
//                               ),
//                               child: Icon(
//                                 Icons.share,
//                                 color: Colors.white,
//                                 size: 18,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // Bouton j'aime
//                     InkWell(
//                       onTap: () {
//                         setState(() {
//                           isFavorite = !isFavorite;
//                         });
//                       },
//                       child: Row(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(5),
//                             child: Container(
//                               padding: EdgeInsets.all(5),
//                               decoration: BoxDecoration(
//                                 color: Color(0x1affffff),
//                                 borderRadius: BorderRadius.circular(50),
//                               ),
//                               child: Icon(
//                                 isFavorite
//                                     ? Icons.favorite_rounded
//                                     : Icons.favorite_rounded,
//                                 // color: Colors.white,
//                                 color: isFavorite ? Colors.red : Colors.white,
//                                 size: 18,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 5),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 widget.ownerName,
//                 style: TextStyle(
//                   // color: Color(0xffffffff),
//                   fontSize: 10,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Row(
//                 children: [
//                   Icon(Icons.access_time, size: 12, color: Colors.grey),
//                   SizedBox(width: 5),
//                   Text(
//                     widget.time,
//                     style: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 10,
//                       fontStyle: FontStyle.italic,
//                       // fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
    
//           //
//         ],
//       ),
//     );
//   }
// }
