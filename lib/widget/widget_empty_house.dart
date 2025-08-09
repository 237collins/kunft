// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetEmptyHouse extends StatefulWidget {
  final String message;

  const WidgetEmptyHouse({Key? superkey, required this.message})
    : super(key: superkey);

  @override
  State<WidgetEmptyHouse> createState() => _WidgetEmptyHouseState();
}

class _WidgetEmptyHouseState extends State<WidgetEmptyHouse> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 120),
      child: Align(
        alignment: Alignment.topCenter,
        child:
        // Text('Aucun appartement disponible pour le moment.'), // Ancien Element
        Container(
          height: 350,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(60),
            boxShadow: [
              BoxShadow(
                color: Color(0x1ad9d9d9),
                offset: Offset(0, 3),
                spreadRadius: 10,
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(radius: 70),
              SizedBox(height: 20),
              Column(
                children: [
                  Text(
                    'Oups ',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: Text(
                      // MEssage ici
                      // 'Aucun appartement disponible pour le moment.',
                      widget.message,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
