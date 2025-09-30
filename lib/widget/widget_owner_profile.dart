import 'package:flutter/material.dart';
import 'package:kunft/pages/broker_details.dart';

class WidgetOwnerProfile extends StatefulWidget {
  // final String propertyCount;
  final String ownerName;
  final String imgOwner;
  final Widget houseInfosWidget; // <-- Ajout du widget en paramètre

  const WidgetOwnerProfile({
    Key? superkey,
    required this.ownerName,
    required this.imgOwner,
    required this.houseInfosWidget, // <-- Le widget est maintenant requis
  }) : super(key: superkey);

  @override
  State<WidgetOwnerProfile> createState() => _WidgetOwnerProfileState();
}

class _WidgetOwnerProfileState extends State<WidgetOwnerProfile> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BrokerDetails(ownerData: {}),
                ),
              );
            },
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    color: const Color(0xFF256AFD),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.imgOwner),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    const Text(
                      'Propriétaire',
                      style: TextStyle(fontSize: 8, color: Colors.grey),
                    ),
                    Text(
                      widget.ownerName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF256AFD),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// // Ancien code statique
// import 'package:flutter/material.dart';
// import 'package:kunft/pages/broker_details.dart';
// import 'package:kunft/pages/chat/messaging_page2.dart';
// import 'package:lucide_icons/lucide_icons.dart';

// class WidgetOwnerProfile extends StatefulWidget {
//   // final String propertyCount;
//   final String ownerName;
//   final String imgOwner;

//   const WidgetOwnerProfile({
//     Key? superkey,
//     required this.ownerName,
//     required this.imgOwner,
//   }) : super(key: superkey);

//   @override
//   State<WidgetOwnerProfile> createState() => _WidgetOwnerProfileState();
// }

// class _WidgetOwnerProfileState extends State<WidgetOwnerProfile> {
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       // top: 0,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const BrokerDetails(ownerData: {}),
//                 ),
//               );
//             },
//             child: Row(
//               children: [
//                 // photo de profile ici
//                 Container(
//                   padding: EdgeInsets.all(2),
//                   height: 56,
//                   width: 56,
//                   decoration: BoxDecoration(
//                     color: Color(0xFF256AFD),
//                     borderRadius: BorderRadius.circular(100),
//                   ),
//                   child: CircleAvatar(
//                     backgroundImage: NetworkImage(widget.imgOwner),
//                   ),

//                   // ClipRRect(
//                   //   borderRadius: BorderRadius.circular(100),
//                   //   child: Image.network(
//                   //     // photo de profil du propriétaire
//                   //     widget.imgOwner,
//                   //     fit: BoxFit.cover,
//                   //     width: double.infinity,
//                   //   ),
//                   // ),
//                 ),
//                 // Icon(
//                 //   Icons.account_circle_rounded,
//                 //   size: 56,
//                 //   color: Colors.yellow,
//                 // ),
//                 SizedBox(width: 8),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 5),
//                     Text(
//                       // '@abigail.moore',
//                       'Propriétaire',
//                       style: TextStyle(fontSize: 8, color: Colors.grey),
//                     ),
//                     Text(
//                       // Nom du proprietaire
//                       widget.ownerName,
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                         color: Color(0xFF256AFD),
//                       ),
//                     ),
//                     // Text(
//                     //   'Detient 10 logements',
//                     //   style: TextStyle(
//                     //     fontSize: 8,
//                     //     fontStyle: FontStyle.italic,
//                     //     fontWeight: FontWeight.w500,
//                     //     color: Colors.black,
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   GestureDetector(
//                     // Pointe directement sur la messagerie
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const MessagingPage2(),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 15,
//                         vertical: 10,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Color(0xFF256AFD),
//                         borderRadius: BorderRadius.only(
//                           bottomRight: Radius.circular(30),
//                           bottomLeft: Radius.circular(30),
//                           topLeft: Radius.circular(30),
//                           // topRight: Radius.circular(20),
//                         ),
//                       ),
//                       child: Column(
//                         children: [
//                           Icon(
//                             LucideIcons.userCircle2,
//                             // size: 40,
//                             color: Colors.white,
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             'Profile',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 15),
//                   GestureDetector(
//                     // Processe de reservation avant de pointer sur la messagerie avec les infos
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const MessagingPage2(),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       // margin: EdgeInsets.only(right: 10), // Commenté car non fourni dans le snippet complet
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 15,
//                         vertical: 10,
//                       ),
//                       decoration: const BoxDecoration(
//                         color: Color(0xFF256AFD),
//                         borderRadius: BorderRadius.only(
//                           bottomRight: Radius.circular(30),
//                           bottomLeft: Radius.circular(30),
//                           topRight: Radius.circular(30),
//                           // topRight: Radius.circular(20), // Commenté car déjà présent dans l'exemple
//                         ),
//                       ),
//                       child: const Column(
//                         children: [
//                           Icon(Icons.book_rounded, color: Colors.white),
//                           SizedBox(height: 4),
//                           Text(
//                             'Résa.',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
