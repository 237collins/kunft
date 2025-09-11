import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importez le package intl pour le formatage des nombres

class WidgetAmount extends StatelessWidget {
  final double prixParNuit;
  final int dureeDuSejour;

  const WidgetAmount({
    super.key,
    required this.prixParNuit,
    required this.dureeDuSejour,
  });

  @override
  Widget build(BuildContext context) {
    // Calcul des montants
    final montant = prixParNuit * dureeDuSejour;
    final frais = montant * 0.05; // 10% de frais
    final total = montant + frais;

    // Création d'un NumberFormat pour la devise XAF avec séparateur de milliers
    // J'utilise 'fr_FR' pour s'assurer que l'espace est utilisé comme séparateur.
    final numberFormat = NumberFormat('#,###', 'fr_FR');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0x1a2196F3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Montant'),
              Text(
                // ✅ MODIFIÉ : Formate le montant pour afficher "20 000 XAF"
                '${numberFormat.format(montant)} XAF',
                style: const TextStyle(fontFamily: 'BebasNeue', fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [Text('Frais'), SizedBox(width: 10), Text('5%')],
              ),
              Text(
                // ✅ MODIFIÉ : Formate les frais
                '${numberFormat.format(frais)} XAF',
                style: const TextStyle(fontFamily: 'BebasNeue', fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total'),
              Text(
                // ✅ MODIFIÉ : Formate le total
                '${numberFormat.format(total)} XAF',
                style: const TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 20,
                  // color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---- Ancien code

// import 'package:flutter/material.dart';

// class WidgetAmount extends StatefulWidget {
//   const WidgetAmount({super.key});

//   @override
//   State<WidgetAmount> createState() => _WidgetAmountState();
// }

// class _WidgetAmountState extends State<WidgetAmount> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//       decoration: BoxDecoration(
//         color: const Color(0x1a2196F3),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Montant'),
//               Text(
//                 //
//                 'Momtant',
//                 // style: TextStyle(fontWeight: FontWeight.w600),
//                 style: TextStyle(
//                   fontFamily: 'BebasNeue',
//                   fontSize: 20,
//                   // fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//           //
//           SizedBox(height: 15),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(children: [Text('Frais'), SizedBox(width: 10), Text('10%')]),
//               Text(
//                 // Données du range picker
//                 '0',
//                 style: TextStyle(
//                   fontFamily: 'BebasNeue',
//                   fontSize: 20,
//                   // fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//           //
//           SizedBox(height: 15),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Total'),
//               Row(
//                 children: [
//                   Text(
//                     // Données du range picker
//                     '0',
//                     style: TextStyle(fontFamily: 'BebasNeue', fontSize: 20),
//                   ),
//                   // Text(
//                   //   // Données du range picker
//                   //   ' frs',
//                   //   style: TextStyle(fontFamily: 'BebasNeue', fontSize: 20),
//                   // ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
