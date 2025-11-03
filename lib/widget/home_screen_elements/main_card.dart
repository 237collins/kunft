// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:kunft/widget/home_screen_elements/infos_card.dart';

class MainCard extends StatefulWidget {
  // final String count;
  // final String name;

  const MainCard({
    super.key,
    // required this.count,
    // required this.name
  });

  @override
  State<MainCard> createState() => _MainCardState();
}

class _MainCardState extends State<MainCard> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 150,
      width: screenWidth,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        // borderRadius: BorderRadius.only(
        //   topLeft: Radius.circular(50),
        //   topRight: Radius.circular(50),
        //   bottomLeft: Radius.circular(40),
        //   bottomRight: Radius.circular(40),
        // ),
        // color: Colors.green,
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF555555), Color(0xFF101A2A)],
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 6),
            spreadRadius: 4,
            blurRadius: 7,
            color: Color(0xcce9e9e9),
          ),
        ],
      ),
      child: Column(
        children: [
          //

          //
          // ClipRRect(
          //   borderRadius: BorderRadiusGeometry.circular(20),
          //   // const BorderRadius.only(
          //   //   topLeft: Radius.circular(50),
          //   //   topRight: Radius.circular(50),
          //   //   // bottomLeft: Radius.circular(50),
          //   //   // bottomRight: Radius.circular(50),
          //   // ),
          //   child: Image.asset(
          //     'assets/images/house.jpg',
          //     // height: 250,
          //     width: screenWidth,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          //
          SizedBox(height: 20),
          // Counts
          const Column(
            children: [
              // Text(
              //   // '18',
              //   // widget.count,
              //   style: const TextStyle(
              //     fontSize: 45,
              //     fontWeight: FontWeight.w800,
              //     height: .8,
              //   ),
              // ),
              //
              // Text(
              //   'Résidences ',
              //   style: TextStyle(
              //     fontSize: 16,
              //     fontWeight: FontWeight.w800,
              //     height: .9,
              //   ),
              // ),
            ],
          ),

          // const Column(
          //   children: [
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         // const Text(
          //         //   'Nos ',
          //         //   style: TextStyle(
          //         //     fontSize: 30,
          //         //     fontWeight: FontWeight.w800,
          //         //     color: Colors.white,
          //         //   ),
          //         // ),
          //         //
          //         Text(
          //           // widget.name,
          //           'Images ici',
          //           style: TextStyle(
          //             fontSize: 30,
          //             fontWeight: FontWeight.w800,
          //             color: Colors.white,
          //           ),
          //         ),
          //       ],
          //     ),
          //     // const Spacer(),
          //     // Row(
          //     //   children: [
          //     //     Container(
          //     //       padding: const EdgeInsets.all(8),
          //     //       decoration: BoxDecoration(
          //     //         borderRadius: BorderRadius.circular(20),
          //     //         color: Colors.white,
          //     //       ),
          //     //       child: const Icon(Icons.arrow_forward_ios, size: 20),
          //     //     ),
          //     //   ],
          //     // ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
