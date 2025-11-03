// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class PropertyCategory3 extends StatefulWidget {
  final String count;
  final String name;

  const PropertyCategory3({super.key, required this.count, required this.name});

  @override
  State<PropertyCategory3> createState() => _PropertyCategory3State();
}

class _PropertyCategory3State extends State<PropertyCategory3> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 90,
      width: screenWidth * .44,
      // width: 100,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.pink.shade300,
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color.fromARGB(255, 2, 189, 252), Color(0xff176CFF)],
        ),
      ),
      child: Stack(
        children: [
          // Counts
          Positioned(
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                Text(
                  // '18',
                  widget.count,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    height: .8,
                  ),
                ),
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
            crossAxisAlignment: CrossAxisAlignment.start,

            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  //
                  const Text(
                    // widget.name,
                    'Meublés',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ],
              ),
              // const Spacer(),
              // Row(
              //   children: [
              //     Container(
              //       padding: const EdgeInsets.all(8),
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(20),
              //         color: Colors.white,
              //       ),
              //       child: const Icon(Icons.arrow_forward_ios, size: 20),
              //     ),
              //   ],
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
