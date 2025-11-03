// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class InfosCard extends StatefulWidget {
  // final String count;
  final String name;

  const InfosCard({
    super.key,
    // required this.count,
    required this.name,
  });

  @override
  State<InfosCard> createState() => _InfosCardState();
}

class _InfosCardState extends State<InfosCard> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 120,
      width: screenWidth,
      // margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // border: Border.all(style: BorderStyle.solid, color: Colors.black12),
        // color: Colors.pink,
        // boxShadow: const [
        //   BoxShadow(
        //     offset: Offset(0, 4),
        //     spreadRadius: 5,
        //     blurRadius: 6,
        //     color: Color(0x1a000000),
        //   ),
        // ],
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color.fromARGB(255, 2, 189, 252), Color(0xff176CFF)],
        ),
      ),
      child: Stack(
        children: [
          // Counts
          const Positioned(
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                // Text(
                //   '18',
                //   style: TextStyle(
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
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // const Text(
                  //   'Nos ',
                  //   style: TextStyle(
                  //     fontSize: 30,
                  //     fontWeight: FontWeight.w800,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  //
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              // const Spacer(),
              //
              // Container(
              //   padding: const EdgeInsets.all(8),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(20),
              //     color: Colors.white,
              //   ),
              //   child: const Icon(Icons.arrow_forward_ios, size: 20),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
