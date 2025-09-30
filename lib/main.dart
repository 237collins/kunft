import 'package:flutter/material.dart';
import 'package:kunft/pages/auth/login_page.dart';
import 'package:kunft/pages/home_screen.dart';
import 'package:kunft/provider/ReservationProvider.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kunft/provider/UserProvider.dart';
import 'package:kunft/provider/logement_provider.dart';
import 'package:kunft/pages/SplashScreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Créez une instance du plugin de notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  // Assurez-vous que les widgets sont initialisés
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise les données de locale pour la gestion des dates
  await initializeDateFormatting('fr_FR', null);

  // Configuration des paramètres de la notification pour chaque plateforme
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
        'app_icon',
      ); // Remplacer 'app_icon' par le nom de l'icône de votre application.

  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LogementProvider()),
        ChangeNotifierProvider(create: (context) => ReservationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // On écoute les changements dans le UserProvider
    final userProvider = Provider.of<UserProvider>(context);

    // Si le provider est en cours de chargement (par exemple, il vérifie le token)
    if (userProvider.isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _appTheme,
        home: const SplashScreen(),
      );
    }

    // Après le chargement, on vérifie si l'utilisateur est connecté
    if (userProvider.authToken != null) {
      // L'utilisateur est connecté, on le dirige vers la page d'accueil
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _appTheme,
        home: const HomeScreen(),
      );
    } else {
      // L'utilisateur n'est pas connecté, on le dirige vers la page de connexion
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _appTheme,
        home: const LoginPage(),
      );
    }
  }

  // Thème de l'application
  static final ThemeData _appTheme = ThemeData(
    primarySwatch: Colors.deepOrange,
    fontFamily: 'Onest',
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: 'BebasNeue', fontSize: 96.0),
    ),
    scaffoldBackgroundColor: Colors.white,
  );
}

// Okay mais sans Gestion des notifs

// import 'package:flutter/material.dart';
// import 'package:kunft/pages/auth/login_page.dart';
// import 'package:kunft/pages/home_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:kunft/provider/UserProvider.dart';
// import 'package:kunft/provider/logement_provider.dart';
// import 'package:kunft/pages/SplashScreen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // Initialise les données de locale pour la gestion des dates
//   await initializeDateFormatting('fr_FR', null);

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => UserProvider()),
//         ChangeNotifierProvider(create: (_) => LogementProvider()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // On écoute les changements dans le UserProvider
//     final userProvider = Provider.of<UserProvider>(context);

//     // Si le provider est en cours de chargement (par exemple, il vérifie le token)
//     if (userProvider.isLoading) {
//       return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: _appTheme,
//         home: const SplashScreen(),
//       );
//     }

//     // Après le chargement, on vérifie si l'utilisateur est connecté
//     if (userProvider.authToken != null) {
//       // L'utilisateur est connecté, on le dirige vers la page d'accueil
//       return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: _appTheme,
//         home: const HomeScreen(),
//       );
//     } else {
//       // L'utilisateur n'est pas connecté, on le dirige vers la page de connexion
//       return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: _appTheme,
//         home: const LoginPage(),
//       );
//     }
//   }

//   // Thème de l'application
//   static final ThemeData _appTheme = ThemeData(
//     primarySwatch: Colors.deepOrange,
//     fontFamily: 'Poppins',
//     textTheme: const TextTheme(
//       displayLarge: TextStyle(fontFamily: 'BebasNeue', fontSize: 96.0),
//     ),
//     scaffoldBackgroundColor: const Color(0xfff7f7f7),
//   );
// }
