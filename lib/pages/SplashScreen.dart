import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kunft/pages/home_screen.dart';
import 'package:kunft/pages/auth/login_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Chargement en cours
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          // ✅ Utilisateur connecté → passer l'utilisateur à HomeScreen
          final user = snapshot.data!;
          return HomeScreen(user: user);
        } else {
          // ❌ Aucun utilisateur → vers LoginPage
          return const LoginPage();
        }
      },
    );
  }
}
