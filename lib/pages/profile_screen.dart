import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kunft/pages/SplashScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 15, right: 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.home_max_outlined),
                SizedBox(width: 20),
                Text(
                  'Profile',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            //
            SizedBox(height: 25),
            // User image et name
            Column(
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage('assets/images/img07.png'),
                ),
                // User name
                SizedBox(height: 10),
                Text(
                  'Andrew Aisnley',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                //
                SizedBox(height: 10),
                //
                Divider(),
              ],
            ),
            //
            SizedBox(height: 10),
            //
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.edit_calendar_sharp),
                    //
                    SizedBox(width: 20),
                    Text('Mes reservations'),
                  ],
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 17),
              ],
            ),
            SizedBox(height: 10),
            //
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.payment_rounded),
                    //
                    SizedBox(width: 20),
                    Text('Mode de Paiement'),
                  ],
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 17),
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
            //
            Row(
              children: [
                Icon(Icons.logout_outlined, color: Colors.red),
                //
                // SizedBox(width: 20),
                // Text(
                //   'Mode de Paiement',
                //   style: TextStyle(
                //     // fontSize: 12,
                //     color: Colors.red,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
                // //
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    // await prefs.remove('token');
                    if (mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SplashScreen(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: const Text(
                    'Déconnexion',
                    style: TextStyle(
                      // fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
