import 'package:flutter/material.dart';
import 'package:kunft/pages/chat/messaging_page2.dart';
import 'package:kunft/widget/widget_book/widget_house_infos3_bis.dart'; // Importez le widget des informations
import 'package:lucide_icons/lucide_icons.dart';

class WidgetBoutonCommander extends StatelessWidget {
  final Map<String, dynamic> logementData; // Ajout du paramètre

  const WidgetBoutonCommander({
    super.key,
    required this.logementData, // Le paramètre est maintenant requis
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => MessagingPage2(
                  // ✅ MODIFIÉ : On envoie le widget d'informations du logement
                  initialMessageWidget: WidgetHouseInfos3Bis(
                    logementData: logementData,
                  ),
                ),
          ),
        );
      },
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(50),
            bottomLeft: Radius.circular(50),
            topLeft: Radius.circular(50),
          ),
        ),
        child: const Column(
          children: [
            Icon(LucideIcons.shoppingCart, color: Colors.white, size: 15),
            SizedBox(height: 4),
            Text(
              'Contacter',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Ancien code Statique ---

// import 'package:flutter/material.dart';
// import 'package:kunft/pages/chat/messaging_page2.dart';
// import 'package:lucide_icons/lucide_icons.dart';

// class WidgetBoutonCommander extends StatefulWidget {
//   const WidgetBoutonCommander({super.key});

//   @override
//   State<WidgetBoutonCommander> createState() => _WidgetBoutonCommanderState();
// }

// class _WidgetBoutonCommanderState extends State<WidgetBoutonCommander> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => MessagingPage2()),
//         );
//       },
//       child: Container(
//         height: 62,
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         decoration: const BoxDecoration(
//           color: Colors.blue,
//           borderRadius: BorderRadius.only(
//             bottomRight: Radius.circular(50),
//             bottomLeft: Radius.circular(50),
//             topLeft: Radius.circular(50),
//           ),
//         ),
//         child: const Column(
//           children: [
//             Icon(LucideIcons.userCircle2, color: Colors.white, size: 20),
//             SizedBox(height: 4),
//             Text(
//               'Commander',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
