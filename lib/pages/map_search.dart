import 'package:flutter/material.dart';
import 'package:kunft/widget/widget_house_infos_explore.dart';
import 'package:kunft/widget/widget_map_top_nav_bar.dart';
import 'package:kunft/widget/widget_message_aleatoire.dart';

class MapSearch extends StatefulWidget {
  const MapSearch({super.key});

  @override
  State<MapSearch> createState() => _MapSearchState();
}

class _MapSearchState extends State<MapSearch> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: screenWidth,
            height: screenHeight,
            // Ajoute maps ici eb bg
            child: ClipRRect(
              child: Image.asset(
                'assets/images/img04.jpg',
                width: double.infinity,
                height: screenHeight,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
            ),
          ),
          // Element au dessus
          Padding(
            padding: const EdgeInsets.only(
              top: 70,
              left: 10,
              right: 10,
              // bottom: 30.0,
            ),
            child: Column(
              // Continue ici
              children: [
                WidgetMapTopNavBar(title: 'Google Map'),
                SizedBox(height: 30),
                WidgetMessageAleatoire(),
                SizedBox(height: 18),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Trending Broker\'s',
                      style: TextStyle(
                        color: Color(0xff010101),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'see all',
                      style: TextStyle(
                        color: Color(0xffffd055),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    WidgetHouseInfosExplore(
                      imgHouse: 'assets/images/img06.jpg',
                      houseName: 'Single family home in City A',
                      price: '\$185 000',
                      locate: '908 Elm Street, Unit 48, Aistin,',
                      ownerName: '@abigail.moore',
                      time: '2 hours ago',
                    ),
                    WidgetHouseInfosExplore(
                      imgHouse: 'assets/images/img05.jpg',
                      houseName: 'Single family home in City A',
                      price: '\$185 000',
                      locate: '908 Elm Street, Unit 48, Aistin,',
                      ownerName: '@abigail.moore',
                      time: '2 hours ago',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
