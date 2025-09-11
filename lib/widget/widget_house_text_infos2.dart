import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kunft/pages/broker_details.dart'; // Pour le formatage de la date et des nombres

class WidgetHouseTextInfos2 extends StatefulWidget {
  // Nouveau paramètre pour recevoir les données du dernier logement
  final Map<String, dynamic>? logementData;

  const WidgetHouseTextInfos2({super.key, this.logementData});

  @override
  State<WidgetHouseTextInfos2> createState() => _WidgetHouseTextInfos2State();
}

class _WidgetHouseTextInfos2State extends State<WidgetHouseTextInfos2> {
  bool isExpanded =
      false; // Pour la description du logement (non utilisé ici pour le prix)

  // Fonction utilitaire pour formater le prix
  String _formatPrice(dynamic price) {
    if (price == null) return 'N/A';
    try {
      double p;
      if (price is String) {
        p = double.parse(price);
      } else if (price is num) {
        p = price.toDouble();
      } else {
        return 'Prix invalide';
      }
      return '${NumberFormat('#,##0', 'fr_FR').format(p)} Fcfa';
    } catch (e) {
      debugPrint('Erreur de formatage du prix dans WidgetHouseTextInfos2: $e');
      return 'Prix invalide';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer les données du logement, ou utiliser des valeurs par défaut si null
    final logement = widget.logementData;

    final String title = logement?['titre'] ?? 'Titre Inconnu';
    // ✅ RETIRÉ : final String description = logement?['description'] ?? 'Aucune description disponible.';
    final String ownerName =
        (logement?['user'] != null && logement?['user']['name'] != null)
            ? '@${logement!['user']['name'].toString().replaceAll(' ', '.').toLowerCase()}' // Format @prenom.nom
            : '@proprietaire.inconnu';

    String formattedTime = 'Date Inconnue';
    if (logement?['created_at'] != null) {
      debugPrint('DEBUG: Raw created_at value: ${logement!['created_at']}');
      try {
        final DateTime dateTime = DateTime.parse(
          logement['created_at'] as String,
        );
        formattedTime = DateFormat(
          'dd MMM yyyy HH:mm',
          'fr_FR',
        ).format(dateTime); // Ex: 13 juil. 2025 05:20
      } catch (e) {
        debugPrint(
          'DEBUG: Erreur de formatage de date dans WidgetHouseTextInfos2: $e',
        );
      }
    }

    // ✅ AJOUTÉ : Extraction et formatage du prix
    final String formattedPrice = _formatPrice(logement?['prix_par_nuit']);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                        // const SizedBox(height: 3),
                        // ✅ MODIFIÉ : Affichage dynamique du PRIX du logement
                        SizedBox(
                          // width: 280, inutile maintenant
                          child: Text(
                            formattedPrice, // ✅ Affiche le prix formaté ici
                            style: const TextStyle(
                              color: Color(0xffffffff),
                              fontSize:
                                  40, // Taille de police légèrement plus grande pour le prix
                              fontWeight: FontWeight.bold,
                              fontFamily: 'BebasNeue',
                            ),
                            // ✅ RETIRÉ : maxLines et overflow ne sont généralement pas nécessaires pour un prix
                            // maxLines: 2,
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bouton pour naviguer vers les détails de la propriété (commenté)
                  InkWell(
                    onTap: () {
                      if (logement != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BrokerDetails(ownerData: {}),
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
              // const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Affichage dynamique du nom du propriétaire (commenté)
                      // Text(
                      //   ownerName,
                      //   style: const TextStyle(
                      //     color: Color(0xffffffff),
                      //     fontSize: 10,
                      //   ),
                      // ),
                      // const SizedBox(width: 35),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          // Affichage dynamique de la date formatée
                          Text(
                            formattedTime,
                            style: const TextStyle(
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
