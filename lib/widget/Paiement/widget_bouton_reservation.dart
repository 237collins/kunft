import 'package:flutter/material.dart';
import 'package:kunft/pages/book/date_page.dart';

class WidgetBoutonReservation extends StatefulWidget {
  // ✅ MODIFIÉ : Ajout du paramètre pour recevoir les données du logement
  final Map<String, dynamic> logementData;

  const WidgetBoutonReservation({
    super.key,
    required this.logementData, // ✅ MODIFIÉ : Rendez-le obligatoire
  });

  @override
  State<WidgetBoutonReservation> createState() =>
      _WidgetBoutonReservationState();
}

class _WidgetBoutonReservationState extends State<WidgetBoutonReservation> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DatePage(
              // ✅ MODIFIÉ : Passez les données du logement à la prochaine page
              logementData: widget.logementData,
            ),
          ),
        );
      },
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: const BoxDecoration(
          color: Color(0xFF256AFD),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(50),
            bottomLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: const Column(
          children: [
            Icon(Icons.book_rounded, color: Colors.white, size: 15),
            SizedBox(height: 4),
            Text(
              'Résa.',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------ Code statique

// import 'package:flutter/material.dart';
// import 'package:kunft/pages/book/date_page.dart';

// class WidgetBoutonReservation extends StatefulWidget {
//   const WidgetBoutonReservation({super.key});

//   @override
//   State<WidgetBoutonReservation> createState() =>
//       _WidgetBoutonReservationState();
// }

// class _WidgetBoutonReservationState extends State<WidgetBoutonReservation> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const DatePage()),
//         );
//       },
//       child: Container(
//         height: 56,
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         decoration: const BoxDecoration(
//           color: Color(0xFF256AFD),
//           borderRadius: BorderRadius.only(
//             bottomRight: Radius.circular(50),
//             bottomLeft: Radius.circular(50),
//             topRight: Radius.circular(50),
//           ),
//         ),
//         child: const Column(
//           children: [
//             Icon(Icons.book_rounded, color: Colors.white, size: 15),
//             SizedBox(height: 4),
//             Text(
//               'Résa.',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
