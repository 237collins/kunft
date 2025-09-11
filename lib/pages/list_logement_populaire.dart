import 'package:flutter/material.dart';

class ListLogementPopulaire extends StatefulWidget {
  const ListLogementPopulaire({super.key});

  @override
  State<ListLogementPopulaire> createState() => _ListLogementPopulaireState();
}

class _ListLogementPopulaireState extends State<ListLogementPopulaire> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meublés Populaires'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            //
            // SizedBox(height: 15),

            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Row(
            //     children: const [
            //       WidgetPropertyCategory(number: '01', name: 'Duplex'),
            //       SizedBox(width: 10),
            //       WidgetPropertyCategory(number: '02', name: 'Villas'),
            //       SizedBox(width: 10),
            //       WidgetPropertyCategory(number: '03', name: 'Appartements'),
            //       SizedBox(width: 10),
            //       WidgetPropertyCategory(number: '04', name: 'Studio'),
            //       SizedBox(width: 10),
            //       WidgetPropertyCategory(number: '03', name: 'Chambres'),
            //     ],
            //   ),
            // ),
            //
          ],
        ),
      ),
    );
  }
}
