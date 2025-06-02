// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetPropertyCategory extends StatefulWidget {
  final String number;
  final String name;

  const WidgetPropertyCategory({
    Key? superkey,
    required this.number,
    required this.name,
  }) : super(key: superkey);

  @override
  State<WidgetPropertyCategory> createState() => _WidgetPropertyCategoryState();
}

class _WidgetPropertyCategoryState extends State<WidgetPropertyCategory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 10),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Color(0xfff7f7f7),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              widget.number,
              // '01',
              style: TextStyle(
                color: Color(0xff010101),
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 5),
          Text(
            widget.name,
            style: TextStyle(
              color: Color(0xff010101),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
