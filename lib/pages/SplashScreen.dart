import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:kunft/pages/custom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kunft/pages/auth/login_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<bool> checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkIfLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 🔄 Chargement
          return Scaffold(
            body: Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 1),
                duration: Duration(seconds: 5),
                builder:
                    (context, value, _) => SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        backgroundColor: Color(0xffd9d9d9),
                        strokeWidth: 10,
                      ),
                    ),
              ),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data == true) {
          // ✅ Token présent → utilisateur connecté
          return const CustomNavBar(); // ou sans user si pas utilisé
        } else {
          // ❌ Pas de token → connexion nécessaire
          return const LoginPage();
        }
      },
    );
  }
}
