// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetHouseSpecs extends StatefulWidget {
  final String bed;
  final String bath;
  final bool withSpacing;

  const WidgetHouseSpecs({
    Key? key,
    Key? superkey,
    required this.bed,
    required this.bath,
    this.withSpacing = true,
  }) : super(key: superkey);

  @override
  State<WidgetHouseSpecs> createState() => _WidgetHouseSpecsState();
}

class _WidgetHouseSpecsState extends State<WidgetHouseSpecs> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Nombre de Lits
        Container(
          margin: EdgeInsets.only(right: 10),
          width: 80,
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),

          child: Column(
            children: [
              Icon(Icons.bed),
              SizedBox(height: 8),
              Text(
                'Bedroom',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 8,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.bed,
                    style: TextStyle(
                      color: Color(0xff010101),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    ' Rooms',
                    style: TextStyle(
                      color: Color(0xff010101),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Nombre de douche
        Container(
          margin: EdgeInsets.only(right: 10),
          width: 80,
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(Icons.bathtub),
              SizedBox(height: 8),
              Text(
                'Bathroom',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 8,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.bath,
                    style: TextStyle(
                      color: Color(0xff010101),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    ' Rooms',
                    style: TextStyle(
                      color: Color(0xff010101),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Nombre clim
        Container(
          margin: EdgeInsets.only(right: 10),
          width: 80,
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(Icons.air),
              SizedBox(height: 8),
              Text(
                'Air conditionar',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 8,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ajoute une action ici

                  // Text(
                  //   widget.number,
                  //   style: TextStyle(
                  //     color: Color(0xff010101),
                  //     fontSize: 12,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                  Text(
                    ' Clim',
                    style: TextStyle(
                      color: Color(0xff010101),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Wifi dispo
        Container(
          margin: EdgeInsets.only(right: 10),
          width: 80,
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(Icons.wifi_password_rounded),
              SizedBox(height: 8),
              Text(
                'Wifi avaible ?',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 8,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ajoute une action ici

                  // Text(
                  //   widget.number,
                  //   style: TextStyle(
                  //     color: Color(0xff010101),
                  //     fontSize: 12,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                  // afficher un bouton action ici
                  Text(
                    ' Wifi',
                    style: TextStyle(
                      color: Color(0xff010101),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Bloc 5
        Container(
          margin: EdgeInsets.only(right: 10),
          width: 80,
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(Icons.local_parking_rounded),
              SizedBox(height: 8),
              Text(
                'Parking',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 8,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ajoute une action ici
                  // Text(
                  //   widget.number,
                  //   style: TextStyle(
                  //     color: Color(0xff010101),
                  //     fontSize: 12,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                  Text(
                    ' Parking',
                    style: TextStyle(
                      color: Color(0xff010101),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              // if (widget.withSpacing) SizedBox(width: 15),
            ],
          ),
        ),
      ],
    );
  }
}
