import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewInfosDate extends StatelessWidget {
  // ✅ MODIFIÉ : Les dates sont maintenant de type DateTime? pour accepter les valeurs nulles.
  final DateTime? dateDebut;
  final DateTime? dateFin;
  final int dureeDuSejour;

  const ReviewInfosDate({
    super.key,
    required this.dateDebut,
    required this.dateFin,
    required this.dureeDuSejour,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy');

    // ✅ MODIFIÉ : Utilisez l'opérateur '??' pour fournir une date par défaut
    // si l'une des dates est null. Par exemple, la date actuelle.
    final formattedDateDebut =
        dateDebut != null
            ? formatter.format(dateDebut!)
            : 'Date non disponible';
    final formattedDateFin =
        dateFin != null ? formatter.format(dateFin!) : 'Date non disponible';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0x1a2196F3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Durée du séjour'),
              Text(
                '($dureeDuSejour) Nuits',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Arrivée'),
              Text(
                // ✅ UTILISATION : Affiche la date formatée ou le texte de remplacement
                formattedDateDebut,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Départ'),
              Text(
                // ✅ UTILISATION : Affiche la date formatée ou le texte de remplacement
                formattedDateFin,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ------ Code Statique

// import 'package:flutter/material.dart';

// class ReviewInfosDate extends StatefulWidget {
//   const ReviewInfosDate({super.key});

//   @override
//   State<ReviewInfosDate> createState() => _ReviewInfosDateState();
// }

// class _ReviewInfosDateState extends State<ReviewInfosDate> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
//       decoration: BoxDecoration(
//         color: const Color(0x1a2196F3),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Date'),
//               Text(
//                 // Données du range picker
//                 'Date debit et fin',
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//             ],
//           ),
//           //
//           SizedBox(height: 15),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Check in'),
//               Text(
//                 // Données du range picker
//                 'Date debut',
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//             ],
//           ),
//           //
//           SizedBox(height: 15),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Ckeck out'),
//               Text(
//                 // Données du range picker
//                 'Date fin',
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
