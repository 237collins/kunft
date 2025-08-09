// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:kunft/pages/property_detail.dart';

// ignore: camel_case_types
class WidgetHouseInfos3Bis extends StatefulWidget {
  final String imgHouse;
  final String houseName;
  final String price;
  final String locate;
  final String ownerName;
  final String time;
  final Map<String, dynamic>? logementData; // ✅ Nouveau paramètre facultatif

  const WidgetHouseInfos3Bis({
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
  State<WidgetHouseInfos3Bis> createState() => _WidgetHouseInfos3BisState();
}

class _WidgetHouseInfos3BisState extends State<WidgetHouseInfos3Bis> {
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

    return GestureDetector(
      onTap: _navigateToPropertyDetail, // Appelle la fonction de navigation
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0), // Marge pour l'espacement
        // width: double.infinity,
        // height: 160,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color(0x80d9d9d9),
              spreadRadius: 4,
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: SizedBox(
          height: 180,
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: Image.network(
                      widget.imgHouse,
                      fit: BoxFit.cover,
                      // width: double.infinity,
                      height: 130,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 180,
                          width: 180,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        );
                      },
                    ),
                  ),

                  // Boutons d'interaction (Share et Favorite) - Ces InkWell ne sont pas affectés par le GestureDetector parent
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // InkWell(
                        //   onTap: () {
                        //     debugPrint(
                        //       'Partager le logement: ${widget.houseName}',
                        //     );
                        //   },
                        //   child: Container(
                        //     padding: const EdgeInsets.all(5),
                        //     decoration: BoxDecoration(
                        //       color: const Color(0x26000000),
                        //       borderRadius: BorderRadius.circular(50),
                        //     ),
                        //     child: const Icon(
                        //       Icons.share,
                        //       color: Colors.white,
                        //       size: 18,
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(width: 5),
                        // InkWell(
                        //   onTap: () {
                        //     setState(() {
                        //       isFavorite = !isFavorite;
                        //     });
                        //     debugPrint(
                        //       'Logement ${widget.houseName} favori: $isFavorite',
                        //     );
                        //   },
                        //   child: Container(
                        //     padding: const EdgeInsets.all(5),
                        //     decoration: BoxDecoration(
                        //       color: const Color(0x40ffffff),
                        //       borderRadius: BorderRadius.circular(50),
                        //     ),
                        //     child: Icon(
                        //       isFavorite
                        //           ? Icons.favorite_rounded
                        //           : Icons.favorite_border_rounded,
                        //       color: isFavorite ? Colors.red : Colors.white,
                        //       size: 18,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              // 2e Partie de bloc
              SizedBox(
                height: 170,
                child: Column(
                  children: [
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        children: [
                          // SizedBox(height: 3),
                          //
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nom de maison et Heure
                              SizedBox(
                                // decoration: BoxDecoration(color: Colors.orange),
                                width: 160,
                                child: Text(
                                  widget.houseName,
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    height: 1.2,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              //
                              Row(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.price,
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 35,
                                      fontFamily: 'BebasNeue',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  //
                                  Text(
                                    ' | Nuit',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 18,
                                      // fontFamily: 'BebasNeue',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          //
                          SizedBox(height: 45),
                          // Spacer(),
                          // Nom du user, Date et Lieux
                          Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Nom du user
                              Row(
                                children: [
                                  Text(
                                    widget.ownerName,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  //
                                  SizedBox(width: 30),
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
                              //
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_rounded,
                                    color: Colors.blue,
                                    size: 17,
                                  ),
                                  const SizedBox(width: 3),
                                  SizedBox(
                                    // decoration: BoxDecoration(color: Colors.amber),
                                    width: 170,
                                    child: Text(
                                      widget.locate,
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
                            ],
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
      ),
    );
  }
}
