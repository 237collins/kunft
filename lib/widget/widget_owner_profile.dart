// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetOwnerProfile extends StatefulWidget {
  // final String propertyCount;
  final String ownerName;
  final String imgOwner;

  const WidgetOwnerProfile({
    Key? key,
    required this.ownerName,
    required this.imgOwner,
  }) : super(key: key);

  @override
  State<WidgetOwnerProfile> createState() => _WidgetOwnerProfileState();
}

class _WidgetOwnerProfileState extends State<WidgetOwnerProfile> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      // top: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // photo de profile ici
              Container(
                padding: EdgeInsets.all(2),
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.imgOwner),
                ),

                // ClipRRect(
                //   borderRadius: BorderRadius.circular(100),
                //   child: Image.network(
                //     // photo de profil du propriétaire
                //     widget.imgOwner,
                //     fit: BoxFit.cover,
                //     width: double.infinity,
                //   ),
                // ),
              ),
              // Icon(
              //   Icons.account_circle_rounded,
              //   size: 56,
              //   color: Colors.yellow,
              // ),
              SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(
                    // '@abigail.moore',
                    'Propriétaire',
                    style: TextStyle(fontSize: 8, color: Colors.grey),
                  ),
                  Text(
                    // Nom du proprietaire
                    widget.ownerName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue,
                    ),
                  ),
                  // Text(
                  //   'Detient 10 logements',
                  //   style: TextStyle(
                  //     fontSize: 8,
                  //     fontStyle: FontStyle.italic,
                  //     fontWeight: FontWeight.w500,
                  //     color: Colors.black,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Ajoute les actions ici
                  Column(
                    children: [
                      Icon(Icons.message, color: Colors.blue),
                      SizedBox(height: 4),
                      Text(
                        'Message',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  Container(
                    // margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        topLeft: Radius.circular(30),
                        // topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.book_rounded, color: Colors.white),
                        SizedBox(height: 4),
                        Text(
                          'Résa.',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
