import 'package:flutter/material.dart';
import 'package:kunft/widget/widget_popular_house_infos2.dart';

class Studio extends StatefulWidget {
  const Studio({super.key});

  @override
  State<Studio> createState() => _StudioState();
}

class _StudioState extends State<Studio> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WidgetPopularHouseInfos2(
          imgHouse: 'assets/images/img03.jpg',
          houseName: 'Studio Meublés',
          price: '20 000',
          locate: 'Douala, NdogBong',
          ownerName: 'Collins',
          time: '20h30',
        ),
      ],
    );
  }
}
