import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WidgetNotificationListEmpty extends StatefulWidget {
  const WidgetNotificationListEmpty({super.key});

  @override
  State<WidgetNotificationListEmpty> createState() =>
      _WidgetNotificationListEmptyState();
}

class _WidgetNotificationListEmptyState
    extends State<WidgetNotificationListEmpty> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          child: SvgPicture.asset(
            'assets/svg/Push_notifications.svg',
            fit: BoxFit.scaleDown,
            // height: 300,
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -90),
          child: const Column(
            children: [
              Text(
                'Vide',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  // Apres remet en blanc
                  color: Color(0xFF256AFD),
                ),
              ),
              //
              SizedBox(
                width: 250,
                child: Text(
                  'Vous n\'avez aucune notification pour le moment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    // Apres remet en blanc
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
