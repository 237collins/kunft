import 'package:flutter/material.dart';
import 'package:kunft/pages/profile_screen/profile_screen.dart';

class NotificationsSettings extends StatefulWidget {
  const NotificationsSettings({super.key});

  @override
  State<NotificationsSettings> createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 70, left: 15, right: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Fleche de retour
                      InkWell(
                        onTap: () {
                          setState(() {});
                          Navigator.pop(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.arrow_back_rounded,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),

                      SizedBox(width: 8),
                      Text(
                        // Titre de la nav
                        'Notification',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          // Apres remet en blanc
                          color: Colors.black,
                        ),
                      ),
                      //
                    ],
                  ),
                  //
                  // Icon(LucideIcons.moreHorizontal),
                ],
              ),
              //
              // Appel widget
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'General notification',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Icon(Icons.playlist_add_check_circle_sharp),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
