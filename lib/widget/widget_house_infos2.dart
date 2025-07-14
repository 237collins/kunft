// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetHouseInfos2 extends StatefulWidget {
  final String imgHouse;
  final String houseName;
  final String price;
  final String locate;
  final String ownerName;
  final String time;

  const WidgetHouseInfos2({
    Key? superkey,
    required this.imgHouse,
    required this.houseName,
    required this.price,
    required this.locate,
    required this.ownerName,
    required this.time,
  }) : super(key: superkey);

  @override
  State<WidgetHouseInfos2> createState() => _WidgetHouseInfos2State();
}

class _WidgetHouseInfos2State extends State<WidgetHouseInfos2> {
  bool isExpanded = false;
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 150,
        minWidth: 130,
        // maxWidth: 150,
        maxHeight: 200,
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  //insert image
                  widget.imgHouse,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 165,
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
              // Text
              Positioned(
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 140,
                        child: Text(
                          // nom du mobilier
                          widget.houseName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        // Prix
                        widget.price,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 5),
                      SizedBox(
                        // width: 150,
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: Colors.white,
                              size: 17,
                            ),
                            SizedBox(width: 3),
                            Text(
                              // nom du lieu
                              widget.locate,
                              style: TextStyle(
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bouton d'interaction
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
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
                                isFavorite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_rounded,
                                // color: Colors.white,
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
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
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
          SizedBox(height: 10),

          //
        ],
      ),
    );
  }
}
