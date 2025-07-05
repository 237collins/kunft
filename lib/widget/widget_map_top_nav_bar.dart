// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:kunft/pages/explore_screen.dart';

class WidgetMapTopNavBar extends StatefulWidget {
  final String title;

  const WidgetMapTopNavBar({Key? key, Key? superkey, required this.title})
    : super(key: superkey);

  @override
  State<WidgetMapTopNavBar> createState() => _WidgetMapTopNavBarState();
}

class _WidgetMapTopNavBarState extends State<WidgetMapTopNavBar> {
  IconData message = Icons.ac_unit_outlined;
  // bool isSelected = false;
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
                    Navigator.pop(
                      context,
                      MaterialPageRoute(builder: (context) => ExploreScreen()),
                    );
                  },
                  child: Icon(Icons.arrow_back, size: 36),
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
                Icon(message, color: Colors.white),
                SizedBox(width: 10),
                Icon(Icons.notification_add, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
