import 'package:flutter/material.dart';
import 'package:kunft/widget/widget_popular_house_infos2.dart';

class Villas extends StatefulWidget {
  const Villas({super.key});

  @override
  State<Villas> createState() => _VillasState();
}

class _VillasState extends State<Villas> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WidgetPopularHouseInfos2(
          imgHouse: 'assets/images/img03.jpg',
          houseName: 'Villa Meublé',
          price: '80 000',
          locate: 'Yaounde, Omnisport',
          ownerName: 'Collins',
          time: '20h30',
        ),
      ],
    );
  }
}
