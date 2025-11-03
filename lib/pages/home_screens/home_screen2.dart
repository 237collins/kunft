import 'package:flutter/material.dart';
import 'package:kunft/pages/home_screens/widgets/category_widget.dart';
import 'package:kunft/pages/home_screens/widgets/recent_house_widget.dart';
import 'package:kunft/pages/home_screens/widgets/search_bar_widget.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: screenHeight * .35,
            decoration: const BoxDecoration(
              // color: const Color(0xFF256AFD),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff256AFD), Colors.white],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 40),

            child: SingleChildScrollView(
              child: Column(
                children: [
                  //
                  const SizedBox(height: 110),

                  //
                  // const SizedBox(height: 10),
                  // Barre de recherche
                  const SearchBarWidget(),
                  // Affichage des categories ou types
                  const SizedBox(height: 10),
                  const CategoryWidget(name: ''),
                  const SizedBox(height: 15),
                  // listes des derniers logement
                  RecentHouseWidget(),
                  RecentHouseWidget(),

                  // Fin de page
                  SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
