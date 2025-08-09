import 'package:flutter/material.dart';

class WidgetHouseSpecs extends StatefulWidget {
  final String bed;
  final String bath;
  final bool wifi;
  final bool parking;
  final bool generator;
  final bool climatisation;

  const WidgetHouseSpecs({
    super.key,
    required this.bed,
    required this.bath,
    this.wifi = false,
    this.parking = false,
    this.generator = false,
    this.climatisation = false,
  });

  @override
  State<WidgetHouseSpecs> createState() => _WidgetHouseSpecsState();
}

class _WidgetHouseSpecsState extends State<WidgetHouseSpecs> {
  // ✅ Fonction privée pour construire un élément de spécification réutilisable
  // Elle prend maintenant un paramètre `boolValue` pour les commodités
  Widget _buildSpecItem({
    required IconData icon,
    required String title,
    required Widget valueWidget, // Peut être un Text ou une Icône colorée
    double iconSize = 17.0,
    bool isAvailable =
        false, // ✅ Nouveau paramètre pour la disponibilité (booléen)
  }) {
    // Détermine la couleur de l'icône de valeur si c'est une commodité
    Color valueIconColor =
        isAvailable
            ? Colors.blue
            : Colors.grey; // Vert si disponible, gris sinon

    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 80,
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      decoration: BoxDecoration(
        color: Color(0x1a2196f3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // L'icône principale du bloc (ex: lit, baignoire, clim)
          Icon(icon, size: iconSize),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 8,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          // ✅ Affichage conditionnel :
          // Si c'est une commodité (isAvailable est utilisé pour la couleur), affiche une icône de coche/croix ou un simple point
          // Sinon, affiche le valueWidget fourni (pour les nombres de lits/douches)
          isAvailable
              ? Icon(
                Icons
                    .radio_button_checked_sharp, // Icône de coche pour "disponible"
                color: valueIconColor, // Couleur basée sur la disponibilité
                size: 15, // Ajustez la taille de cette icône si nécessaire
              )
              : valueWidget,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Le switchScaleFactor n'est plus nécessaire car nous n'utilisons plus de Switches
    // const double switchScaleFactor = 0.5;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Nombre de Lits
          _buildSpecItem(
            icon: Icons.bed,
            title: 'Chambres',
            valueWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.bed,
                  style: const TextStyle(
                    color: Color(0xff010101),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // const Text(
                //   ' pièces',
                //   style: TextStyle(
                //     color: Color(0xff010101),
                //     fontSize: 12,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
              ],
            ),
          ),

          // Nombre de douches
          _buildSpecItem(
            icon: Icons.bathtub,
            title: 'Douches',
            valueWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.bath,
                  style: const TextStyle(
                    color: Color(0xff010101),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // const Text(
                //   ' pièces',
                //   style: TextStyle(
                //     color: Color(0xff010101),
                //     fontSize: 12,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
              ],
            ),
          ),

          // ✅ Climatisation - Maintenant avec une icône colorée
          _buildSpecItem(
            icon: Icons.ac_unit,
            title: 'Clim / AC',
            valueWidget:
                const SizedBox.shrink(), // Pas de valueWidget direct pour les booléens
            isAvailable:
                widget
                    .climatisation, // Passe la valeur booléenne pour la couleur de l'icône
          ),

          // ✅ Wi-Fi
          _buildSpecItem(
            icon: Icons.wifi,
            title: 'Wi-Fi',
            valueWidget: const SizedBox.shrink(),
            isAvailable: widget.wifi,
          ),

          // ✅ Parking
          _buildSpecItem(
            icon: Icons.local_parking_rounded,
            title: 'Parking',
            valueWidget: const SizedBox.shrink(),
            isAvailable: widget.parking,
          ),

          // ✅ Générateur
          _buildSpecItem(
            icon: Icons.power,
            title: 'Générateur',
            valueWidget: const SizedBox.shrink(),
            isAvailable: widget.generator,
          ),
        ],
      ),
    );
  }
}
