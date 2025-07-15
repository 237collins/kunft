// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetBrokerList extends StatefulWidget {
  final String brokerName;
  final String propertyNumber;

  const WidgetBrokerList({
    Key? superkey,
    required this.brokerName,
    required this.propertyNumber,
  }) : super(key: superkey);

  @override
  State<WidgetBrokerList> createState() => _WidgetBrokerListState();
}

class _WidgetBrokerListState extends State<WidgetBrokerList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      width: 80,
      height: 80,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 15),
          SizedBox(height: 7),
          Text(
            // 'Name',
            widget.brokerName,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          //
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                // Va recevoir le nombre de logement
                // '10',
                widget.propertyNumber,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 5),
              Text(
                ' Logements',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
