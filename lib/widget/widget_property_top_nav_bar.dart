// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:kunft/pages/explore_screen.dart';

class WidgetPropertyTopNavBar extends StatefulWidget {
  final String title;

  const WidgetPropertyTopNavBar({Key? key, Key? superkey, required this.title})
    : super(key: superkey);

  @override
  State<WidgetPropertyTopNavBar> createState() =>
      _WidgetPropertyTopNavBarState();
}

class _WidgetPropertyTopNavBarState extends State<WidgetPropertyTopNavBar> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Fleche de retour
                InkWell(
                  onTap: () {
                    setState(() {});
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExploreScreen()),
                    );
                  },
                  child: Icon(Icons.arrow_back, size: 36, color: Colors.white),
                ),

                SizedBox(width: 8),
                Text(
                  // Titre de la nav
                  widget.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.share, color: Colors.white),
                SizedBox(width: 15),
                InkWell(
                  onTap: () {
                    setState(() {
                      isSelected = !isSelected;
                    });
                  },
                  child: Icon(
                    isSelected ? Icons.favorite : Icons.favorite,
                    color: isSelected ? Colors.red : Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
