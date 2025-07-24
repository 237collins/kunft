import 'package:flutter/material.dart';
import 'package:kunft/widget/widget_popular_house_infos2.dart';

class Duplex extends StatefulWidget {
  const Duplex({super.key});

  @override
  State<Duplex> createState() => _DuplexState();
}

class _DuplexState extends State<Duplex> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WidgetPopularHouseInfos2(
          imgHouse: 'assets/images/img03.jpg',
          houseName: 'Duplex Meublé',
          price: '100 000',
          locate: 'Douala, NdogBong',
          ownerName: 'Collins',
          time: '20h30',
        ),
      ],
    );
  }
}
