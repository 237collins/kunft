// Fichier : openstreetmap-test.dart
//
// Un exemple d'application Flutter qui affiche une carte OpenStreetMap
// en utilisant un service d'hébergement de tuiles.
//
// Pour que ce code fonctionne, assurez-vous d'avoir ajouté le package
// 'flutter_map' à votre fichier pubspec.yaml.
// flutter pub add flutter_map

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapTestScreen extends StatelessWidget {
  const MapTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Coordonnées pour un marqueur (Paris, France)
    final LatLng paris = LatLng(48.8566, 2.3522);

    // Votre jeton d'accès (token) ici.
    // Vous pouvez obtenir un jeton d'accès gratuit en vous inscrivant à
    // un service comme Stadia Maps. Pas de carte de crédit requise pour les plans gratuits.
    // REMARQUE: N'utilisez PAS ce jeton d'accès en production, utilisez le vôtre.
    const String stadiaMapsApiKey = '85e477c0-fe80-413e-9541-c76dbfbea2bf';

    // Remplacer 'your.package.name' par le nom de votre package.
    const String userAgent = 'com.example.app';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test de Carte OpenStreetMap'),
        backgroundColor: const Color(0xFF256AFD),
      ),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(48.8566, 2.3522),
          initialZoom: 13.0,
        ),
        // Couches de la carte
        children: [
          // La couche de tuiles Stadia Maps, alimentée par les données OSM
          TileLayer(
            urlTemplate:
                "https://tiles.stadiamaps.com/tiles/osm_bright/{z}/{x}/{y}{r}.png?api_key=$stadiaMapsApiKey",
            userAgentPackageName: userAgent,
          ),
          // La couche de marqueurs
          MarkerLayer(
            markers: [
              Marker(
                point: paris,
                width: 80,
                height: 80,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
