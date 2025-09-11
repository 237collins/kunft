import 'package:flutter/material.dart';
import 'package:kunft/pages/property_detail.dart';
import 'package:intl/intl.dart'; // Importez intl pour le formatage de la date

class WidgetHouseTextInfos extends StatefulWidget {
  // Nouveau paramètre pour recevoir les données du dernier logement
  final Map<String, dynamic>? logementData;

  const WidgetHouseTextInfos({super.key, this.logementData});

  @override
  State<WidgetHouseTextInfos> createState() => _WidgetHouseTextInfosState();
}

class _WidgetHouseTextInfosState extends State<WidgetHouseTextInfos> {
  bool isExpanded = false; // Pour la description du logement

  @override
  Widget build(BuildContext context) {
    // Récupérer les données du logement, ou utiliser des valeurs par défaut si null
    final logement = widget.logementData;

    final String title = logement?['titre'] ?? 'Titre Inconnu';
    final String description =
        logement?['description'] ?? 'Aucune description disponible.';
    final String ownerName =
        (logement?['user'] != null && logement?['user']['name'] != null)
            ? '@${logement!['user']['name'].toString().replaceAll(' ', '.').toUpperCase()}' // Format @prenom.nom
            : '@proprietaire.inconnu';

    String formattedTime = 'Date Inconnue';
    if (logement?['created_at'] != null) {
      // AJOUTEZ CETTE LIGNE POUR DÉBOGUER LE FORMAT
      print('DEBUG: Raw created_at value: ${logement!['created_at']}');
      try {
        final DateTime dateTime = DateTime.parse(
          logement['created_at'] as String,
        );
        // ... (le reste de votre code de formatage) ...
        formattedTime = DateFormat(
          'dd MMM yyyy HH:mm',
          'fr_FR',
        ).format(dateTime); // Ex: 13 juil. 2025 05:20
      } catch (e) {
        print(
          'DEBUG: Erreur de formatage de date dans WidgetHouseTextInfos: $e',
        );
      }
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 280,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Affichage dynamique du titre du logement
                        Text(
                          title,
                          style: const TextStyle(
                            // Utilisation de const car TextStyle est constant
                            color: Color(0xffffffff),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: isExpanded ? null : 1,
                          overflow:
                              isExpanded
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // Affichage dynamique de la description du logement
                        Text(
                          description,
                          style: const TextStyle(
                            color: Color(0xffffffff),
                            fontSize: 10,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // ✅ Bouton pour naviguer vers les détails de la propriété
                  InkWell(
                    onTap: () {
                      if (logement != null) {
                        // Vérifie si les données du logement sont disponibles
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => PropertyDetail(
                                  logementData: logement,
                                  // logementData:
                                  //     logement, // ✅ C'est ici que le logement actuel est passé !
                                ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Aucun détail de logement disponible.',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Icon(Icons.arrow_outward, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 8), // Utilisation de const
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Affichage dynamique du nom du propriétaire
                      Text(
                        ownerName,
                        style: const TextStyle(
                          // Utilisation de const
                          color: Color(0xffffffff),
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(width: 35),
                      Row(
                        children: [
                          const Icon(
                            // Utilisation de const
                            Icons.access_time,
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5), // Utilisation de const
                          // Affichage dynamique de la date formatée
                          Text(
                            formattedTime,
                            style: const TextStyle(
                              // Utilisation de const
                              color: Color(0xffffffff),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Si vous voulez un bouton de slider ou autre, il sera ici
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
