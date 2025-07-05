import 'package:flutter/material.dart';
import 'package:kunft/pages/home_screen.dart';
import 'package:kunft/pages/explore_screen.dart';
import 'package:kunft/pages/map_search.dart';
import 'package:kunft/pages/property_detail.dart';
// import 'package:kunft/widget/widget_bottom_nav_element.dart';

class WidgetNavBarBottom extends StatefulWidget {
  const WidgetNavBarBottom({super.key});

  @override
  State<WidgetNavBarBottom> createState() => _WidgetNavBarBottomState();
}

class _WidgetNavBarBottomState extends State<WidgetNavBarBottom> {
  bool isSelected = false;
  bool isSelected2 = false;
  bool isSelected3 = false;
  bool isSelected4 = false;
  bool isSelected5 = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 35),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isSelected = !isSelected;
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
            child: Column(
              children: [
                Icon(
                  isSelected ? Icons.home_filled : Icons.home_filled,
                  color: isSelected ? Colors.black : Colors.grey,
                ),
                Spacer(),
                Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.black : Colors.grey,
                  ),
                ),

                // WidgetBottomNavElement(title: 'Home'),
              ],
            ),
          ),

          InkWell(
            onTap: () {
              setState(() {
                isSelected2 = !isSelected2;
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExploreScreen()),
              );
            },
            child: Column(
              children: [
                Icon(
                  isSelected2 ? Icons.travel_explore : Icons.travel_explore,
                  color: isSelected2 ? Colors.black : Colors.grey,
                ),
                Spacer(),

                Text(
                  'Explore',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected2 ? Colors.black : Colors.grey,
                  ),
                ),

                // WidgetBottomNavElement(title: 'Explore'),
              ],
            ),
          ),

          InkWell(
            onTap: () {
              setState(() {
                isSelected3 = !isSelected3;
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PropertyDetail()),
              );
            },
            child: Column(
              children: [
                Icon(
                  isSelected3 ? Icons.person_pin : Icons.person_pin,
                  color: isSelected3 ? Colors.black : Colors.grey,
                ),
                Spacer(),

                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected3 ? Colors.black : Colors.grey,
                  ),
                ),

                // WidgetBottomNavElement(title: 'Profile'),
              ],
            ),
          ),

          Column(
            children: [
              Icon(
                isSelected4 ? Icons.favorite : Icons.favorite,
                color: isSelected4 ? Colors.black : Colors.grey,
              ),
              Spacer(),
              Text(
                'Favorites',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected4 ? Colors.black : Colors.grey,
                ),
              ),

              // WidgetBottomNavElement(title: 'Favorites'),
            ],
          ),
          Column(
            children: [
              Icon(
                isSelected5 ? Icons.settings : Icons.settings,
                color: isSelected5 ? Colors.black : Colors.grey,
              ),
              Spacer(),

              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected5 ? Colors.black : Colors.grey,
                ),
              ),

              // WidgetBottomNavElement(title: 'Settings'),
            ],
          ),
        ],
      ),
    );
  }
}
