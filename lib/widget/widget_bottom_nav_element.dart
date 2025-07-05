// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetBottomNavElement extends StatefulWidget {
  final String title;

  const WidgetBottomNavElement({Key? key, Key? superkey, required this.title})
    : super(key: superkey);

  @override
  State<WidgetBottomNavElement> createState() => _WidgetBottomNavElementState();
}

class _WidgetBottomNavElementState extends State<WidgetBottomNavElement> {
  // IconData home = Icons.home_filled;
  // IconData search = Icons.travel_explore_rounded;
  // IconData profil = Icons.person_pin;
  // IconData like = Icons.favorite;
  // IconData setting = Icons.settings;
  @override
  Widget build(BuildContext context) {
    return Text(
      // nom de l'element
      widget.title,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
    );
  }
}
