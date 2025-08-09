// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:kunft/pages/home_screen.dart';
import 'package:kunft/pages/profile_screen/elements/notifications_page.dart';

class WidgetPropertyTopNavBar2 extends StatefulWidget {
  final String title;

  const WidgetPropertyTopNavBar2({Key? key, Key? superkey, required this.title})
    : super(key: superkey);

  @override
  State<WidgetPropertyTopNavBar2> createState() =>
      _WidgetPropertyTopNavBar2State();
}

class _WidgetPropertyTopNavBar2State extends State<WidgetPropertyTopNavBar2> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Fleche de retour
                GestureDetector(
                  onTap: () {
                    // ✅ MODIFIÉ : Utilise Navigator.pushReplacement pour remplacer la page actuelle par HomeScreen
                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 36,
                  ), // Ajout de const
                ),
                // GestureDetector(
                //   onTap: () {
                //     // Navigation en arrière jusqu'à la page d'accueil (HomeScreen)
                //     Navigator.of(context).popUntil((route) => route.isFirst);

                //     // Alternative si vous voulez revenir à une route spécifique :
                //     // Navigator.of(context).popUntil(ModalRoute.withName('/home'));
                //   },
                //   child: const Icon(Icons.arrow_back, size: 36),
                // ),

                //
                SizedBox(width: 8),
                Text(
                  // Titre de la nav
                  widget.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    // Apres remet en blanc
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.message),
                SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Notifications()),
                    );
                  },
                  child: Icon(Icons.notifications),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
