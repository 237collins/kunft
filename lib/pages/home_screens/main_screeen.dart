import 'package:flutter/material.dart';
import 'package:kunft/pages/custom_scaffold/gradient_scaffold.dart';
import 'package:kunft/widget/home_screen_elements/main_card.dart';
import 'package:kunft/widget/home_screen_elements/property_type2.dart';
import 'package:kunft/widget/home_screen_elements/property_type3.dart';

class MainScreeen extends StatefulWidget {
  const MainScreeen({super.key});

  @override
  State<MainScreeen> createState() => _MainScreeenState();
}

class _MainScreeenState extends State<MainScreeen> {
  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;
    //
    return const GradientScaffold(
      // appBar: AppBar(
      //   title: const Text('Welcome'),
      //   backgroundColor: Colors.white,
      // ),
      body: Center(
        child: Padding(
          padding: EdgeInsetsGeometry.only(top: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: 20),
              const MainCard(),

              // SizedBox(height: 10),

              //
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const SizedBox(height: 20),
                    Divider(color: Color(0x66d9d9d9)),

                    const Text(
                      'Catégories disponibles',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    //
                    const SizedBox(height: 15),

                    const SizedBox(
                      height: 210,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PropertyCategory2(count: '12', name: ' Hôtels'),
                          //
                          // SizedBox(width: 10),
                          Column(
                            children: [
                              PropertyCategory3(
                                count: '10',
                                name: 'Résidences',
                              ),
                              PropertyCategory3(count: '10', name: 'Standard'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // PropertyCategory(count: '18', name: 'Location '),
              Divider(color: Color(0x66d9d9d9)),
            ],
          ),
        ),
      ),
    );
  }
}
