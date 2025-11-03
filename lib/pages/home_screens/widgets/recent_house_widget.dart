import 'package:flutter/material.dart';

class RecentHouseWidget extends StatefulWidget {
  const RecentHouseWidget({super.key});

  @override
  State<RecentHouseWidget> createState() => _RecentHouseWidgetState();
}

class _RecentHouseWidgetState extends State<RecentHouseWidget> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      // width: 200,
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/house.jpg',
              height: 180,
              width: screenWidth,
              fit: BoxFit.cover,
            ),
          ),
          const Column(
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Studio meubles',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      // color: Color(0xff256AFD),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '30 000',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          // color: Color(0xff256AFD),
                        ),
                      ),
                      SizedBox(width: 3),
                      //
                      Text(
                        'Fcfa',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          // color: Color(0xff256AFD),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 3),
              //
              Row(
                children: [
                  Text('4 '),
                  Text(
                    'Chambres',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(width: 20),
                  Text('|'),
                  //
                  SizedBox(width: 20),
                  Text('2 '),
                  Text(
                    'Salle de bain',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(width: 20),
                  Text('|'),
                  //
                  SizedBox(width: 20),
                  Text(
                    '800',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  Text('Cm'),
                  SizedBox(width: 20),
                ],
              ),

              //
              Row(
                children: [
                  Text('Notation'),
                  SizedBox(width: 3),
                  Icon(Icons.star_border_rounded, size: 17),
                  Text('4.9 '),
                  Text('(123 Vues)'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
