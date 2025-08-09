import 'package:flutter/material.dart';

class WidgetOkayDialog extends StatelessWidget {
  const WidgetOkayDialog({super.key});

  // void showWidgetOkayDialog(BuildContext context) {
  //   showGeneralDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     barrierLabel: 'Payment Failed',
  //     transitionDuration: const Duration(milliseconds: 300),
  //     pageBuilder: (context, anim1, anim2) {
  //       return const SizedBox.shrink(); // Ne retourne rien ici
  //     },
  //     transitionBuilder: (context, anim1, anim2, child) {
  //       return Transform.scale(
  //         scale: anim1.value,
  //         child: Opacity(
  //           opacity: anim1.value,
  //           child: const WidgetOkayDialog(),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SizedBox(
          height: 470,
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                child: Image.asset('assets/images/okay.png', fit: BoxFit.cover),
              ),
              // Cercle rouge avec une icône "X"
              // Container(
              //   width: 100,
              //   height: 100,
              //   decoration: const BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: Color(0xFFFF5A5F),
              //   ),
              //   child: const Center(
              //     child: Icon(
              //       Icons.close_rounded,
              //       color: Colors.white,
              //       size: 40,
              //     ),
              //   ),
              // ),
              const SizedBox(height: 20),
              const Text(
                'Félicitations!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF007AFF),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your payment failed.\nPlease check your internet connection\nthen try again.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 30),
              // Bouton "Try Again"
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Action à personnaliser
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF007AFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Voir le reçu',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Bouton "Cancel"
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Ferme le dialogue
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFFF0F4FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Non merci',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF007AFF),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class WidgetOkayDialog extends StatelessWidget {
//   const WidgetOkayDialog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       backgroundColor: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Red Circle with X icon
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 Container(
//                   width: 100,
//                   height: 100,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Color(0xFFFF5A5F), // Red-pink color
//                   ),
//                 ),
//                 const Icon(Icons.close, size: 40, color: Colors.white),
//               ],
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Oops, Failed!',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFFFF5A5F),
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               'Your payment failed.\nPlease check your internet connection\nthen try again.',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 14, color: Colors.black87),
//             ),
//             const SizedBox(height: 30),
//             // Try Again Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context); // Example action
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF007AFF),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                 ),
//                 child: const Text('Try Again', style: TextStyle(fontSize: 16)),
//               ),
//             ),
//             const SizedBox(height: 10),
//             // Cancel Button
//             SizedBox(
//               width: double.infinity,
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 style: TextButton.styleFrom(
//                   backgroundColor: const Color(0xFFF0F4FF),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                 ),
//                 child: const Text(
//                   'Cancel',
//                   style: TextStyle(fontSize: 16, color: Color(0xFF007AFF)),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
