import 'package:flutter/material.dart';

class ReviewInfosDate2 extends StatefulWidget {
  const ReviewInfosDate2({super.key});

  @override
  State<ReviewInfosDate2> createState() => _ReviewInfosDate2State();
}

class _ReviewInfosDate2State extends State<ReviewInfosDate2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0x1a2196F3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Montant'),
              Text(
                // Données du range picker
                'Momtant',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          //
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tax'),
              Text(
                // Données du range picker
                '800',
                style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 25,
                  // fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          //
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total'),
              Text(
                // Données du range picker
                '120 000',
                style: TextStyle(fontFamily: 'BebasNeue', fontSize: 25),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
