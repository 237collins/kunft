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
      margin: EdgeInsets.only(right: 15),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0x1a000000),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(4, 5),
          ),
        ],
      ),
      constraints: BoxConstraints(
        // minHeight: 100,
        // minWidth: 130,
        maxWidth: 300,
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
                  width: 160,
                  height: 100,
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: 60,
                  width: 160,
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
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Color(0x1affffff),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(
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
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(0x1affffff),
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
          //
          // Text
          Container(
            width: 130,
            height: 100,
            padding: EdgeInsets.only(left: 5, right: 8, bottom: 5),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        // nom du mobilier
                        widget.houseName,
                        style: TextStyle(
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
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'BebasNeue',
                          ),
                        ),
                        //
                        Text(
                          // Duree
                          ' / Nuit',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      // width: 150,
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: Colors.blue,
                            size: 15,
                          ),
                          SizedBox(width: 3),
                          Text(
                            // nom du lieu
                            widget.locate,
                            style: TextStyle(
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
                Spacer(),
                //
                SizedBox(
                  // width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.ownerName,
                        style: TextStyle(
                          // color: Color(0xffffffff),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 12, color: Colors.grey),
                          SizedBox(width: 5),
                          Text(
                            widget.time,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
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
        ],
      ),
    );
  }
}
