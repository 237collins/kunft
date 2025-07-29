import 'package:flutter/material.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Communautés')),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Best Home'),
          ),
        ],
      ),
    );
  }
}
