import 'package:flutter/material.dart';
import 'package:kunft/widget/widget_animation.dart';
import 'package:kunft/widget/widget_house_image1.dart';
import 'package:kunft/widget/widget_house_image2.dart';
import 'package:kunft/widget/widget_house_infos.dart';
import 'package:kunft/widget/widget_house_specs.dart';
import 'package:kunft/widget/widget_map_top_nav_bar.dart';
import 'package:kunft/widget/widget_owner_profile.dart';
import 'package:kunft/widget/widget_profile_infos.dart';
import 'package:kunft/widget/widget_property_top_nav_bar.dart';

class PropertyDetail extends StatefulWidget {
  const PropertyDetail({super.key});

  @override
  State<PropertyDetail> createState() => _PropertyDetailState();
}

class _PropertyDetailState extends State<PropertyDetail> {
  final List<Widget> colonneG = [
    WidgetHouseImage1(
      imgHouse: 'assets/images/img04.jpg',
      houseName: 'Single family home',
      price: '\$185 000',
      locate: '908 Elm Street, Unit 48, Aistin,',
      ownerName: '@abigail.moore',
      time: '2 hours ago',
    ),
    WidgetHouseImage1(
      imgHouse: 'assets/images/img05.jpg',
      houseName: 'Single family home',
      price: '\$185 000',
      locate: '908 Elm Street, Unit 48, Aistin,',
      ownerName: '@abigail.moore',
      time: '2 hours ago',
    ),
  ];

  final List<Widget> colonneD = [
    WidgetHouseImage2(
      imgHouse: 'assets/images/img01.jpg',
      houseName: 'Single family home',
      price: '\$185 000',
      locate: '908 Elm Street, Unit 48, Aistin,',
      ownerName: '@abigail.moore',
      time: '2 hours ago',
    ),
    WidgetHouseImage2(
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
    // bool isSelected = false;
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
                                Expanded(
                                  child: WidgetPropertyTopNavBar(
                                    title: 'Property Detail',
                                  ),
                                ),
                                Spacer(),

                                Expanded(child: WidgetHouseInfos()),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Details du logement
                                WidgetHouseSpecs(bed: '3', bath: '2'),
                              ],
                            ),
                          ),
                          SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Complete Images',
                                style: TextStyle(
                                  color: Color(0xff010101),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
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
          // Barre de
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(bottom: 20),
              height: 110,
              width: screenWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: WidgetOwnerProfile(imgOwner: 'assets/images/img01.jpg'),
            ),
          ),
        ],
      ),
    );
  }
}
