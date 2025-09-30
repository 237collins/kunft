import 'package:flutter/material.dart';
import 'package:kunft/pages/auth/login_page.dart';
import 'package:kunft/pages/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:kunft/provider/UserProvider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> _initializeApp(BuildContext context) async {
    // On écoute le provider une fois pour appeler la méthode de chargement
    // On n'a pas besoin de "listen" car on ne va pas reconstruire le widget
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadUserFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeApp(context),
        builder: (context, snapshot) {
          // Pendant le chargement, on montre un indicateur
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            // Une fois la méthode terminée, on vérifie le token
            final userProvider = Provider.of<UserProvider>(
              context,
              listen: false,
            );

            if (userProvider.authToken != null) {
              // Si un token existe, on navigue vers la page d'accueil
              return const HomeScreen();
            } else {
              // Sinon, on navigue vers la page de connexion
              return const LoginPage();
            }
          }
        },
      ),
    );
  }
}

// import 'dart:ffi';

// import 'package:flutter/material.dart';
// import 'package:kunft/pages/custom_nav_bar.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:kunft/pages/auth/login_page.dart';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   Future<bool> checkIfLoggedIn() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');
//     return token != null && token.isNotEmpty;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<bool>(
//       future: checkIfLoggedIn(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // 🔄 Chargement
//           return Scaffold(
//             body: Center(
//               child: TweenAnimationBuilder<double>(
//                 tween: Tween<double>(begin: 0, end: 1),
//                 duration: Duration(milliseconds: 1000),
//                 builder:
//                     (context, value, _) => SizedBox(
//                       height: 100,
//                       width: 100,
//                       child: CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF256AFD)),
//                         backgroundColor: Color(0xffd9d9d9),
//                         strokeWidth: 10,
//                       ),
//                     ),
//               ),
//             ),
//           );
//         }

//         if (snapshot.hasData && snapshot.data == true) {
//           // ✅ Token présent → utilisateur connecté
//           return const CustomNavBar(); // ou sans user si pas utilisé
//         } else {
//           // ❌ Pas de token → connexion nécessaire
//           return const LoginPage();
//         }
//       },
//     );
//   }
// }
