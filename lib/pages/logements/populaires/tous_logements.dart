import 'package:flutter/material.dart';
import 'package:kunft/widget/widget_popular_house_infos2.dart';

class TousLogements extends StatefulWidget {
  const TousLogements({super.key});

  @override
  State<TousLogements> createState() => _TousLogementsState();
}

class _TousLogementsState extends State<TousLogements> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Text('Tous les logements test'),
        WidgetPopularHouseInfos2(
          imgHouse: 'assets/images/img03.jpg',
          houseName: 'Studio test d la ville',
          price: '30 000',
          locate: 'Douala, NdogBong',
          ownerName: 'Collins',
          time: '20h34',
        ),
        //
        WidgetPopularHouseInfos2(
          imgHouse: 'assets/images/img05.jpg',
          houseName: 'Studio test',
          price: '30 000',
          locate: 'Douala, NdogBong de la teste',
          ownerName: 'Collins',
          time: '20h34',
        ),
        //
        WidgetPopularHouseInfos2(
          imgHouse: 'assets/images/img02.jpg',
          houseName: 'Studio test',
          price: '30 000',
          locate: 'Douala, NdogBong de la teste',
          ownerName: 'Collins',
          time: '20h34',
        ),
      ],
    );
  }
}
