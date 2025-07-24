import 'package:flutter/material.dart';
import 'package:kunft/widget/widget_popular_house_infos2.dart';

class Chambres extends StatefulWidget {
  const Chambres({super.key});

  @override
  State<Chambres> createState() => _ChambresState();
}

class _ChambresState extends State<Chambres> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WidgetPopularHouseInfos2(
          imgHouse: 'assets/images/img03.jpg',
          houseName: 'Chambre meublés',
          price: '10 000',
          locate: 'Douala, NdogBong',
          ownerName: 'Collins',
          time: '20h30',
        ),
      ],
    );
  }
}
