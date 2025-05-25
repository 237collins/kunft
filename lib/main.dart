import 'package:flutter/material.dart';
import 'package:kunft/pages/on_boarding_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Flutter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Accueil')),
      body: Center(
        child: OnBoardingPage(),
        // ElevatedButton(
        //   onPressed: () {
        //     // Appel de la deuxième page
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => OnBoardingPage()),
        //     );
        //   },
        //   child: Text('Aller à la deuxième page'),
        // ),
      ),
    );
  }
}
