// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetBrokerInfos extends StatefulWidget {
  final String follower;
  final String following;
  final String property;

  const WidgetBrokerInfos({
    Key? key,
    Key? superkey,
    required this.follower,
    required this.following,
    required this.property,
  }) : super(key: superkey);

  @override
  State<WidgetBrokerInfos> createState() => _WidgetBrokerInfosState();
}

class _WidgetBrokerInfosState extends State<WidgetBrokerInfos> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          // margin: const EdgeInsets.only(right: 10),
          width: 100,
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(0, 0),
                spreadRadius: 5,
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_pin, size: 36, color: Colors.blue),
              Text(
                'Following',
                style: TextStyle(
                  fontSize: 10,
                  // fontStyle: FontStyle.italic,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    // Nombres de suiveur
                    widget.follower,
                    style: TextStyle(
                      // fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  // Text(
                  //   ' People',
                  //   style: TextStyle(
                  //     fontSize: 12,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.blue,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
        //
        // SizedBox(width: 15),
        //
        Container(
          // margin: const EdgeInsets.only(right: 10),
          width: 100,
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(0, 0),
                spreadRadius: 3,
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people_alt_outlined, size: 36, color: Colors.blue),
              Text(
                'Followers',
                style: TextStyle(
                  fontSize: 10,
                  // fontStyle: FontStyle.italic,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    // Nombres de suiveur
                    widget.following,
                    style: TextStyle(
                      // fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  // Text(
                  //   ' People',
                  //   style: TextStyle(
                  //     fontSize: 12,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.blue,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
        //
        // SizedBox(width: 15),
        //
        Container(
          // margin: const EdgeInsets.only(right: 10),
          width: 100,
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(0, 0),
                spreadRadius: 3,
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.other_houses, size: 36, color: Colors.blue),
              Text(
                'Logements',
                style: TextStyle(
                  fontSize: 10,
                  // fontStyle: FontStyle.italic,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    // Nombres de logement
                    widget.property,
                    style: TextStyle(
                      // fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  // Text(
                  //   ' Logements',
                  //   style: TextStyle(
                  //     fontSize: 12,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.blue,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
        //
        // SizedBox(width: 15),
      ],
    );
  }
}
