// dans le fichier `widget_payment_mode.dart`
// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class WidgetPaymentMode extends StatelessWidget {
  final String imgPayment;
  final String text;
  // ✅ MODIFIÉ : Nouvelle propriété pour gérer la sélection
  final bool isSelected;
  final VoidCallback onTap;

  const WidgetPaymentMode({
    super.key,
    required this.imgPayment,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            // ✅ MODIFIÉ : Le bord s'illumine si le mode de paiement est sélectionné
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      imgPayment,
                      fit: BoxFit.scaleDown,
                      height: 23,
                      width: 23,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Icon(
              // ✅ MODIFIÉ : L'icône change en fonction de l'état `isSelected`
              isSelected ? LucideIcons.checkCircle : LucideIcons.circle,
              color: isSelected ? Colors.green : Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}

// Code Statique

// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';
// import 'package:lucide_icons/lucide_icons.dart';

// class WidgetPaymentMode extends StatefulWidget {
//   final String imgPayment;
//   final String text;

//   const WidgetPaymentMode({
//     Key? superkey,
//     required this.imgPayment,
//     required this.text,
//   }) : super(key: superkey);

//   @override
//   State<WidgetPaymentMode> createState() => _WidgetPaymentModeState();
// }

// class _WidgetPaymentModeState extends State<WidgetPaymentMode> {
//   bool _isToggled = false;

//   void _toggleIcon() {
//     setState(() {
//       _isToggled = !_isToggled; // Inverse l'état à chaque clic
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             Container(
//               // width: 90,
//               // height: 40,
//               decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(6),
//                 child: Image.asset(
//                   // img
//                   widget.imgPayment,
//                   fit: BoxFit.scaleDown,
//                   height: 23,
//                   width: 23,
//                 ),
//               ),
//             ),
//             //
//             SizedBox(width: 20),
//             //
//             Text(
//               // Titre
//               widget.text,
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//           ],
//         ),
//         GestureDetector(
//           onTap: _toggleIcon,
//           child: Icon(
//             _isToggled ? LucideIcons.checkCircle : LucideIcons.circle,
//             color: _isToggled ? Colors.green : Colors.black,
//           ),
//         ),
//       ],
//     );
//   }
// }
