import 'package:flutter/material.dart';

class ReviewInfosDate extends StatefulWidget {
  const ReviewInfosDate({super.key});

  @override
  State<ReviewInfosDate> createState() => _ReviewInfosDateState();
}

class _ReviewInfosDateState extends State<ReviewInfosDate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0x1a2196F3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Date'),
              Text(
                // Données du range picker
                'Date debit et fin',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          //
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Check in'),
              Text(
                // Données du range picker
                'Date debut',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          //
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ckeck fin'),
              Text(
                // Données du range picker
                'Date out',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
