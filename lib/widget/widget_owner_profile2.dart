// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetOwnerProfile2 extends StatefulWidget {
  // final String propertyCount;
  final String ownerName;
  final String imgOwner;
  final String number;

  const WidgetOwnerProfile2({
    Key? superkey,
    required this.ownerName,
    required this.imgOwner,
    required this.number,
  }) : super(key: superkey);

  @override
  State<WidgetOwnerProfile2> createState() => _WidgetOwnerProfile2State();
}

class _WidgetOwnerProfile2State extends State<WidgetOwnerProfile2> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // photo de profile ici
                Container(
                  padding: EdgeInsets.all(10),
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),

                    Text(
                      // Nom du proprietaire
                      widget.ownerName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          // Numb
                          widget.number,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            height: 1,
                          ),
                        ),
                        Text(
                          // '@abigail.moore',
                          ' Logements',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                // Ajoute les actions ici
                // GestureDetector(
                //   onTap: () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => const MessagingPage2(),
                //           ),
                //         );
                //       },
                //   child: Container(
                //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                //     decoration: BoxDecoration(
                //       color: Colors.blue,
                //       borderRadius: BorderRadius.only(
                //         bottomRight: Radius.circular(50),
                //         bottomLeft: Radius.circular(50),
                //         topLeft: Radius.circular(50),
                //         // topRight: Radius.circular(20),
                //       ),
                //     ),
                //     child: Column(
                //       children: [
                //         Icon(LucideIcons.shoppingCart),
                //         SizedBox(height: 5),
                //         Text(
                //           'Commandez Ici',
                //           style: TextStyle(
                //             fontWeight: FontWeight.w500,
                //             fontSize: 12,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // SizedBox(width: 20),

                // Pour la fonction d'appel direct
                // Column(
                //   children: [
                //     Icon(Icons.phone, color: Colors.black),
                //     SizedBox(height: 8),
                //     Text(
                //       'Call',
                //       style: TextStyle(
                //         fontWeight: FontWeight.w500,
                //         fontSize: 12,
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ],
        ),
        // Bouton reserver, Non operationnel pour le moment
        // SizedBox(height: 10),
        // Container(
        //   width: screenWidth,
        //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        //   decoration: BoxDecoration(
        //     color: Color(0xffffd055),
        //     borderRadius: BorderRadius.circular(50),
        //   ),
        //   child: Text(
        //     'Book Shedule',
        //     style: TextStyle(fontWeight: FontWeight.w600),
        //     textAlign: TextAlign.center,
        //   ),
        // ),
      ],
    );
  }
}
