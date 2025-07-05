import 'package:flutter/material.dart';

class WidgetProfileInfos extends StatefulWidget {
  const WidgetProfileInfos({super.key});

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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      'assets/images/img01.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
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
                Icon(Icons.message, color: Colors.white),
                SizedBox(width: 10),
                Icon(Icons.notification_add, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
