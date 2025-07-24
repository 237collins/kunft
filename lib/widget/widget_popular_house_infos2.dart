// Ancien code statique

// // ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetPopularHouseInfos2 extends StatefulWidget {
  final String imgHouse;
  final String houseName;
  final String price;
  final String locate;
  final String ownerName;
  final String time;

  const WidgetPopularHouseInfos2({
    Key? key,
    Key? superkey,
    required this.imgHouse,
    required this.houseName,
    required this.price,
    required this.locate,
    required this.ownerName,
    required this.time,
  }) : super(key: superkey);

  @override
  State<WidgetPopularHouseInfos2> createState() =>
      _WidgetPopularHouseInfos2State();
}

class _WidgetPopularHouseInfos2State extends State<WidgetPopularHouseInfos2> {
  bool isExpanded = false;
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0x1a000000),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      constraints: BoxConstraints(
        // minHeight: 100,
        // minWidth: 130,
        maxWidth: screenWidth * .94,
        // maxHeight: 150,
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  //insert image
                  widget.imgHouse,
                  fit: BoxFit.cover,
                  // width: double.infinity,
                  width: 200,
                  height: 130,
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: 80,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
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
            width: 150,
            height: 130,
            // decoration: BoxDecoration(color: Colors.green),
            padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 140,
                      child: Text(
                        // nom du mobilier
                        widget.houseName,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          // Prix
                          widget.price,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        //
                        Text(
                          // Duree
                          ' / Nuit',
                          style: TextStyle(
                            color: Colors.blue,
                            // fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    //
                    // Divider(),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: Colors.blue,
                          size: 15,
                        ),
                        SizedBox(width: 3),
                        SizedBox(
                          width: 120,
                          child: Text(
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
                        ),
                      ],
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
                          // color: Colors.blue,
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
