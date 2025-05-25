import 'package:flutter/material.dart';

class WidgetHouseInfos extends StatefulWidget {
  const WidgetHouseInfos({super.key});

  @override
  State<WidgetHouseInfos> createState() => _WidgetHouseInfosState();
}

class _WidgetHouseInfosState extends State<WidgetHouseInfos> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 33),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 260,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Townhouse Residentials',
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.end,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Charming townhouse with modern amenities, a private backyard, and located in a friendly neighborhood with easy access to schools and parks.',
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontSize: 8,
                            // fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: isExpanded ? null : 1,
                          overflow:
                              isExpanded
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_outward, color: Colors.white),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '@michael.robinson',
                        style: TextStyle(
                          color: Color(0xffffffff),
                          fontSize: 10,
                          // fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 35),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            '2 hours ago',
                            style: TextStyle(
                              color: Color(0xffffffff),
                              fontSize: 10,
                              // fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // bouton du slider
                  // Text(
                  //   '000',
                  //   style: TextStyle(
                  //     color: Color(0xffffffff),
                  //     fontSize: 10,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
