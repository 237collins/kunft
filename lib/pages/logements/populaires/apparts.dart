import 'package:flutter/material.dart';
import 'package:kunft/widget/widget_popular_house_infos2.dart';

class Apparts extends StatefulWidget {
  const Apparts({super.key});

  @override
  State<Apparts> createState() => _AppartsState();
}

class _AppartsState extends State<Apparts> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WidgetPopularHouseInfos2(
          imgHouse: 'assets/images/img03.jpg',
          houseName: 'Appartement Meublés',
          price: '35 000',
          locate: 'Douala, NdogBong',
          ownerName: 'Collins',
          time: '20h30',
        ),
      ],
    );
  }
}
