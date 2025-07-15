// Ancien code

import 'package:flutter/material.dart';
import 'package:kunft/pages/map_search.dart';
import 'package:kunft/widget/widget_animation.dart';
import 'package:kunft/widget/widget_house_infos2.dart';
import 'package:kunft/widget/widget_house_infos3.dart';
import 'package:kunft/widget/widget_house_infos_explore.dart';
import 'package:kunft/widget/widget_owner_list.dart';
import 'package:kunft/widget/widget_profile_infos.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final List<Widget> colonneG = [
    WidgetHouseInfos2(
      imgHouse: 'assets/images/img04.jpg',
      houseName: 'Single family home',
      price: '\$185 000',
      locate: '908 Elm Street, Unit 48, Aistin,',
      ownerName: '@abigail.moore',
      time: '2 hours ago',
    ),
    WidgetHouseInfos2(
      imgHouse: 'assets/images/img05.jpg',
      houseName: 'Single family home',
      price: '\$185 000',
      locate: '908 Elm Street, Unit 48, Aistin,',
      ownerName: '@abigail.moore',
      time: '2 hours ago',
    ),
  ];

  final List<Widget> colonneD = [
    WidgetHouseInfos3(
      imgHouse: 'assets/images/img01.jpg',
      houseName: 'Single family home',
      price: '\$185 000',
      locate: '908 Elm Street, Unit 48, Aistin,',
      ownerName: '@abigail.moore',
      time: '2 hours ago',
    ),
    WidgetHouseInfos3(
      imgHouse: 'assets/images/img06.jpg',
      houseName: 'Single family home',
      price: '\$185 000',
      locate: '908 Elm Street, Unit 48, Aistin,',
      ownerName: '@abigail.moore',
      time: '2 hours ago',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    bool isSelected = false;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xfff7f7f7),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          WidgetAnimation(),

                          SizedBox(
                            height: screenHeight * .47,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // SizedBox(height: ),
                                WidgetProfileInfos(),
                                // Spacer(),
                                Column(
                                  children: [
                                    // WidgetMessageAleatoire(),
                                    SizedBox(height: 5),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          WidgetHouseInfosExplore(
                                            imgHouse: 'assets/images/img06.jpg',
                                            houseName:
                                                'Single family home in City A',
                                            price: '\$185 000',
                                            locate:
                                                '908 Elm Street, Unit 48, Aistin,',
                                            ownerName: '@abigail.moore',
                                            time: '2 hours ago',
                                          ),
                                          WidgetHouseInfosExplore(
                                            imgHouse: 'assets/images/img05.jpg',
                                            houseName:
                                                'Single family home in City A',
                                            price: '\$185 000',
                                            locate:
                                                '908 Elm Street, Unit 48, Aistin,',
                                            ownerName: '@abigail.moore',
                                            time: '2 hours ago',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 18),
                      Column(
                        children: [
                          Row(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: screenWidth * .55,
                                ),
                                child: Container(
                                  // width: 240,
                                  padding: EdgeInsets.symmetric(horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.search, color: Colors.grey),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Search',
                                            hintStyle: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                              backgroundColor: Colors.white,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(Icons.tune, color: Colors.grey),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  // width: 240,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xffffd055),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.map_outlined),
                                      SizedBox(width: 10),

                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            isSelected = !isSelected;
                                          });
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MapSearch(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Google Map',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Details
                                WidgetOwnerList(
                                  img: 'assets/images/img01.jpg',
                                  name: 'James Carter',
                                  number: '230',
                                ),
                                WidgetOwnerList(
                                  img: 'assets/images/img01.jpg',
                                  name: 'Sophia White',
                                  number: '250',
                                ),
                                WidgetOwnerList(
                                  img: 'assets/images/img01.jpg',
                                  name: 'William Davis',
                                  number: '240',
                                ),
                                WidgetOwnerList(
                                  img: 'assets/images/img01.jpg',
                                  name: 'Abigail Moore',
                                  number: '260',
                                  withSpacing: false,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Versatile mixed-use property',
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
                        ],
                      ),

                      // Ajustement 2 Okay
                      SizedBox(height: 16),
                      SizedBox(
                        height: screenWidth,
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: colonneG.length,
                                itemBuilder:
                                    (context, index) => colonneG[index],
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: colonneD.length,
                                itemBuilder:
                                    (context, index) => colonneD[index],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Barre de navigation
        ],
      ),
    );
  }
}
