import 'package:flutter/material.dart';

class WidgetMessageAleatoire extends StatefulWidget {
  const WidgetMessageAleatoire({super.key});

  @override
  State<WidgetMessageAleatoire> createState() => _WidgetMessageAleatoireState();
}

class _WidgetMessageAleatoireState extends State<WidgetMessageAleatoire> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Salution
                        Text(
                          'Monday Madness',
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: isExpanded ? null : 1,
                          overflow:
                              isExpanded
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                        ),
                        // Titre
                        Text(
                          'Kickstart the week with a special offer',
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: isExpanded ? null : 1,
                          overflow:
                              isExpanded
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5),
                        // Description
                        Text(
                          'Charming townhouse with modern amenities, a private backyard, and located in a friendly neighborhood with easy access to schools and parks.',
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: isExpanded ? null : 2,
                          overflow:
                              isExpanded
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}
