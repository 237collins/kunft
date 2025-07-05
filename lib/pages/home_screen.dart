import 'package:flutter/material.dart';
import 'package:kunft/widget/widget_animation.dart';
import 'package:kunft/widget/widget_house_infos.dart';
import 'package:kunft/widget/widget_house_infos2.dart';
import 'package:kunft/widget/widget_house_infos3.dart';
import 'package:kunft/widget/widget_nav_bar_bottom.dart';
import 'package:kunft/widget/widget_profile_infos.dart';
import 'package:kunft/widget/widget_property_category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      imgHouse: 'assets/images/img04.jpg',
      houseName: 'Single family home',
      price: '\$185 000',
      locate: '908 Elm Street, Unit 48, Aistin,',
      ownerName: '@abigail.moore',
      time: '2 hours ago',
    ),
    WidgetHouseInfos3(
      imgHouse: 'assets/images/img05.jpg',
      houseName: 'Single family home',
      price: '\$185 000',
      locate: '908 Elm Street, Unit 48, Aistin,',
      ownerName: '@abigail.moore',
      time: '2 hours ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                              children: [
                                Expanded(child: WidgetProfileInfos()),
                                Spacer(),
                                Expanded(child: WidgetHouseInfos()),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 18),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Property category',
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
                                WidgetPropertyCategory(
                                  number: '01',
                                  name: 'Residential',
                                ),
                                SizedBox(width: 10),
                                WidgetPropertyCategory(
                                  number: '02',
                                  name: 'Commercial',
                                ),
                                SizedBox(width: 10),
                                WidgetPropertyCategory(
                                  number: '03',
                                  name: 'Land',
                                ),
                                SizedBox(width: 10),
                                WidgetPropertyCategory(
                                  number: '04',
                                  name: 'Specialty',
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                          ),
                          SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Luxury living at it\'s fitnest',
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
                      // Ajustement Okay 1 mais Fixe
                      // SizedBox(
                      //   height: 600, // Ajuste cette valeur selon ton besoin
                      //   child: GridView.builder(
                      //     itemCount: colonneG.length,
                      //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //       crossAxisCount: 2,
                      //       mainAxisSpacing: 10,
                      //       crossAxisSpacing: 10,
                      //       childAspectRatio: 0.75,
                      //     ),
                      //     itemBuilder: (context, index) {
                      //       return Column(
                      //         children: [colonneG[index], colonneD[index]],
                      //       );
                      //     },
                      //   ),
                      // ),

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
          Positioned(bottom: 0, child: WidgetNavBarBottom()),
        ],
      ),
    );
  }
}
