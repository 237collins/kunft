// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class WidgetOwnerProfile extends StatefulWidget {
  final String imgOwner;

  const WidgetOwnerProfile({Key? superkey, required this.imgOwner})
    : super(key: superkey);

  @override
  State<WidgetOwnerProfile> createState() => _WidgetOwnerProfileState();
}

class _WidgetOwnerProfileState extends State<WidgetOwnerProfile> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      // top: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
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
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      // photo de profil du propriétaire
                      widget.imgOwner,
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
                      '@abigail.moore',
                      style: TextStyle(fontSize: 8, color: Colors.grey),
                    ),
                    Text(
                      'Abigail Moore',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'abigailmoore24@email.com',
                      style: TextStyle(
                        fontSize: 8,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Ajoute les actions ici
                    Column(
                      children: [
                        Icon(Icons.message, color: Colors.black),
                        Text(
                          'Message',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        Icon(Icons.phone, color: Colors.black),
                        Text(
                          'Call',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
