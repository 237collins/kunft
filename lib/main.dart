// Nouveau Code Okay

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // Importez ceci pour initializeDateFormatting
import 'package:kunft/provider/logement_provider.dart';
import 'package:provider/provider.dart'; // ✅ Import de Provider
import 'package:kunft/pages/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Assurez-vous que les bindings Flutter sont initialisés

  // Initialisez les données de locale pour 'fr_FR' pour le package intl
  // Ceci est crucial pour que DateFormat puisse formater correctement les dates en français.
  await initializeDateFormatting('fr_FR', null);

  runApp(
    // ✅ Enveloppe l'application avec ChangeNotifierProvider
    ChangeNotifierProvider(
      create:
          (context) =>
              LogementProvider(), // Crée une instance de votre LogementProvider
      child: const MyApp(), // Votre application est l'enfant du Provider
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:
          false, // Une bonne pratique pour les applications en production
      title: 'KUNFT App', // Un titre plus spécifique pour votre app
      theme: ThemeData(
        primarySwatch:
            Colors.deepOrange, // Couleur principale pour les Material widgets
        fontFamily:
            'Poppins', // ✅ Police par défaut (vérifiez que 'Poppins' est bien configurée dans pubspec.yaml)
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'BebasNeue',
            fontSize: 96.0,
          ), // ✅ Police spécifique pour displayLarge
          // Ajoutez d'autres styles de texte ici si vous voulez appliquer 'BebasNeue' ou d'autres polices à des styles spécifiques.
          // Exemple:
          // headlineMedium: TextStyle(fontFamily: 'BebasNeue'),
          // bodyMedium: TextStyle(fontFamily: 'Poppins'), // Si vous avez une police 'Poppins'
        ),
        scaffoldBackgroundColor: const Color(
          0xfff7f7f7,
        ), // Couleur de fond par défaut pour les Scaffold
      ),
      home: const SplashScreen(),
    );
  }
}

// Code okay avec firebase et avec Logout auto
// import 'package:flutter/material.dart';
// import 'package:kunft/pages/SplashScreen.dart';
// import 'package:kunft/pages/on_boarding_page.dart';
// import 'package:firebase_core/firebase_core.dart'; // Importez Firebase Core
// import 'firebase_options.dart'; // Importez le fichier des options Firebase
// import 'package:intl/date_symbol_data_local.dart'; // Importez ceci pour initializeDateFormatting

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized(); // Assurez-vous que les bindings Flutter sont initialisés

//   // Initialisez Firebase
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   // Initialisez les données de locale pour 'fr_FR' pour le package intl
//   // Ceci est crucial pour que DateFormat puisse formater correctement les dates en français.
//   await initializeDateFormatting('fr_FR', null);

//   runApp(
//     const MyApp(),
//   ); // Utilisez 'const' pour des raisons de performance si possible
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key}); // Ajoutez 'const' ici si le widget est immuable
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner:
//           false, // Une bonne pratique pour les applications en production
//       title: 'KUNFT App', // Un titre plus spécifique pour votre app
//       theme: ThemeData(
//         // primarySwatch: Colors.blue, // Commenté pour utiliser la couleur de fond par défaut de Scaffold si nécessaire
//         fontFamily: 'Barlow', // ✅ Police par défaut
//         textTheme: const TextTheme(
//           displayLarge: TextStyle(fontFamily: 'BebasNeue', fontSize: 96.0),
//           // ... d'autres styles de texte où vous voulez Bebas Neue ou d'autres polices
//         ),
//         scaffoldBackgroundColor: Color(0xfff7f7f7),
//       ),
//       home: const SplashScreen(), // Point d'entrée voulu
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: const Center(child: OnBoardingPage()));
//   }
// }

// Bouton de deconnexion

// ElevatedButton(
//   onPressed: () async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LoginPage()),
//     );
//   },
//   child: Text('Se déconnecter'),
// )

// Ancien code

// import 'package:flutter/material.dart';
// import 'package:kunft/pages/on_boarding_page.dart';
// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Navigation Flutter',
//       theme: ThemeData(
//         // primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: Colors.white,
//       ),
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(title: Text('Accueil')),
//       body: Center(child: OnBoardingPage()),
//     );
//   }
// }
