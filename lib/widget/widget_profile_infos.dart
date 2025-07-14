// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetProfileInfos extends StatefulWidget {
  const WidgetProfileInfos({Key? key}) : super(key: key);

  @override
  State<WidgetProfileInfos> createState() => _WidgetProfileInfosState();
}

class _WidgetProfileInfosState extends State<WidgetProfileInfos> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      // top: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // photo de profile ici
                Container(
                  padding: EdgeInsets.all(3),
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://img.freepik.com/free-psd/3d-icon-social-media-app_23-2150049569.jpg?t=st=1752401142~exp=1752404742~hmac=6b43b692930935ffccf129f98ed7ece809f4fd70644cfdc1b7b5d664b102f36c&w=1380',
                    ),
                  ),

                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(100),
                  //   child: Image.asset(
                  //     '',
                  //     fit: BoxFit.cover,
                  //     width: double.infinity,
                  //   ),
                  // ),
                ),
                // Icon(
                //   Icons.account_circle_rounded,
                //   size: 56,
                //   color: Colors.yellow,
                // ),
                SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      'Good morning',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    Text(
                      'Charlotte Anderson',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                // Linker sur la page messagerie
                Icon(Icons.message, color: Colors.white),
                SizedBox(width: 10),
                // page de notifs
                Icon(Icons.notification_add, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
