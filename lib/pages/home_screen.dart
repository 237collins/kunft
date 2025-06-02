import 'package:flutter/material.dart';
// import 'package:kunft/widget/widget_animated_switcher.dart';
import 'package:kunft/widget/widget_animation.dart';
import 'package:kunft/widget/widget_house_infos.dart';
import 'package:kunft/widget/widget_house_infos2.dart';
import 'package:kunft/widget/widget_house_infos3.dart';
import 'package:kunft/widget/widget_profile_infos.dart';
import 'package:kunft/widget/widget_property_category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
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
                  SizedBox(height: 24),
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
                            WidgetPropertyCategory(number: '03', name: 'Land'),
                            SizedBox(width: 10),
                            WidgetPropertyCategory(
                              number: '04',
                              name: 'Specialty',
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
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
                      SizedBox(height: 15),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        // Faut faire une liste  2 colonnes ici
                        child: Column(
                          children: [
                            // Widget infos ici
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
                            // SizedBox(height: 20),
                            // Column(children: [Text('data2'), Text('data2')]),
                          ],
                        ),
                        // Column(
                        //   children: [
                        //     // Widget infos ici
                        //     WidgetHouseInfos2(
                        //       imgHouse: 'assets/images/img04.jpg',
                        //       houseName: 'Single family home',
                        //       price: '\$185 000',
                        //       locate: '908 Elm Street, Unit 48, Aistin,',
                        //       ownerName: '@abigail.moore',
                        //       time: '2 hours ago',
                        //     ),
                        //     WidgetHouseInfos2(
                        //       imgHouse: 'assets/images/img05.jpg',
                        //       houseName: 'Single family home',
                        //       price: '\$185 000',
                        //       locate: '908 Elm Street, Unit 48, Aistin,',
                        //       ownerName: '@abigail.moore',
                        //       time: '2 hours ago',
                        //     ),
                        //     // SizedBox(height: 20),
                        //     // Column(children: [Text('data2'), Text('data2')]),
                        //   ],
                        // ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
