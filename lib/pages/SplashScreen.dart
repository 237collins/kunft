import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kunft/pages/home_screen.dart';
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
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data == true) {
          // ✅ Token présent → utilisateur connecté
          return const HomeScreen(); // ou sans user si pas utilisé
        } else {
          // ❌ Pas de token → connexion nécessaire
          return const LoginPage();
        }
      },
    );
  }
}
