// Ancien code statique

// // ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetPopularHouseInfos extends StatefulWidget {
  final String imgHouse;
  final String houseName;
  final String price;
  final String locate;
  final String ownerName;
  final String time;
  final Map<String, dynamic>? logementData; // ✅ Nouveau paramètre facultatif

  const WidgetPopularHouseInfos({
    Key? key,
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
  State<WidgetPopularHouseInfos> createState() =>
      _WidgetPopularHouseInfosState();
}

class _WidgetPopularHouseInfosState extends State<WidgetPopularHouseInfos> {
  bool isExpanded = false;
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1a000000),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(4, 5),
          ),
        ],
      ),
      constraints: const BoxConstraints(
        // minHeight: 100,
        // minWidth: 130,
        maxWidth: 250,
        // maxHeight: 150,
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  //insert image
                  widget.imgHouse,
                  fit: BoxFit.cover,
                  // width: double.infinity,
                  width: 120,
                  height: 100,
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: 60,
                  width: 120,
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

              // Bouton d'interaction
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Bouton Share
                  InkWell(
                    onTap: () {
                      // Ajoute l'action d partage ici
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
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
                      ],
                    ),
                  ),
                  // Bouton j'aime
                  InkWell(
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(0x1affffff),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_rounded,
                          // color: Colors.white,
                          color: isFavorite ? Colors.red : Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          //v======================
          // Bloc de Text
          // ==============================
          Expanded(
            child: Container(
              // width: 130,
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(
                          // nom du mobilier
                          widget.houseName,
                          style: const TextStyle(
                            color: Colors.black,
                            // fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            // Prix
                            widget.price,
                            style: const TextStyle(
                              color: Color(0xFF256AFD),
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'BebasNeue',
                            ),
                          ),
                          //
                          const Text(
                            // Duree
                            ' / Nuit',
                            style: TextStyle(
                              color: Color(0xFF256AFD),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(height: 5),
                      SizedBox(
                        width: 130,
                        // decoration: BoxDecoration(color: Color(0xff000000)),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              color: Color(0xFF256AFD),
                              size: 15,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              // nom du lieu
                              widget.locate,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.left,
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  //
                  SizedBox(
                    // width: 120,
                    // decoration: BoxDecoration(color: Color(0xff000000)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 60,
                          child: Text(
                            widget.ownerName,
                            style: const TextStyle(
                              // color: Color(0xffffffff),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 12,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              widget.time,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 9,
                                fontStyle: FontStyle.italic,
                                // fontWeight: FontWeight.w600,
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
          ),
        ],
      ),
    );
  }
}
