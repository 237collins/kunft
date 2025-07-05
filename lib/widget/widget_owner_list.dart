// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetOwnerList extends StatefulWidget {
  final String img;
  final String number;
  final String name;
  final bool withSpacing;

  const WidgetOwnerList({
    Key? key,
    Key? superkey,
    required this.img,
    required this.number,
    required this.name,
    this.withSpacing = true,
  }) : super(key: superkey);

  @override
  State<WidgetOwnerList> createState() => _WidgetOwnerListState();
}

class _WidgetOwnerListState extends State<WidgetOwnerList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      width: 100,
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            // padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Color(0xffd9d9d9),
              borderRadius: BorderRadius.circular(100),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(widget.img, fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.name,
                style: TextStyle(
                  color: Color(0xff010101),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Affichage de nombre de propriétés
                  Text(
                    widget.number,
                    // '01',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    ' Property',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (widget.withSpacing) SizedBox(width: 15),
        ],
      ),
    );
  }
}
