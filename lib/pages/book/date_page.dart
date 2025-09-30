import 'package:flutter/material.dart';
import 'package:kunft/pages/book/payment_page.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:kunft/widget/widget_book/widget_booking_calendar.dart';

class DatePage extends StatefulWidget {
  final Map<String, dynamic> logementData;

  const DatePage({super.key, required this.logementData});

  @override
  State<DatePage> createState() => _DatePageState();
}

class _DatePageState extends State<DatePage> {
  // AJOUTÉ : Variables d'état pour stocker les dates sélectionnées
  DateTime? _checkInDate;
  DateTime? _checkOutDate;

  // Initialisation à 0, car aucune date n'est sélectionnée au départ
  int dureeDuSejourEnNuits = 0;

  // Méthode de callback pour recevoir les dates du calendrier
  void _onDatesSelected(DateTime? startDate, DateTime? endDate) {
    setState(() {
      _checkInDate = startDate;
      _checkOutDate = endDate;

      if (_checkInDate != null && _checkOutDate != null) {
        // Calculez la différence en jours
        final difference = _checkOutDate!.difference(_checkInDate!);
        // Mettez à jour la durée du séjour
        dureeDuSejourEnNuits = difference.inDays;
      } else {
        // Réinitialisez la durée si la sélection n'est pas complète
        dureeDuSejourEnNuits = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 70, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(LucideIcons.arrowLeft),
                  ),
                ),
                const SizedBox(width: 20),
                const Text(
                  'Réservation',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sélectionnez une date',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                // ---
                // Passez la fonction de callback au calendrier
                WidgetBookingCalendar(
                  onDatesSelected: _onDatesSelected,
                  onDateRangeSelected:
                      (DateTime? startDate, DateTime? endDate) {},
                  // onDateRangeSelected: (DateTime? startDate, DateTime? endDate) {}, // Cette ligne peut être supprimée si onDatesSelected est déjà utilisée
                ),
                // ---
                const SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Note à l\'hôte ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 160,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Laissez un message (Optionnel)',
                          hintStyle: TextStyle(fontSize: 13),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                // Vérifiez si la durée du séjour est de 2 jours ou plus
                if (dureeDuSejourEnNuits >= 2) {
                  // ✅ MODIFIÉ : On transmet maintenant _checkInDate et _checkOutDate à la PaymentPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(
                        logementData: widget.logementData,
                        dureeDuSejour: dureeDuSejourEnNuits,
                        dateDebut: _checkInDate,
                        dateFin: _checkOutDate,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        'Veuillez choisir une période d\'au moins 2 nuits.',
                      ),
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF256AFD),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  'Confirmé',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            //
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}


// ------ Ancien code 

// import 'package:flutter/material.dart';
// import 'package:kunft/pages/book/payment_page.dart';
// import 'package:lucide_icons/lucide_icons.dart';

// import 'package:kunft/widget/widget_book/widget_booking_calendar.dart';

// class DatePage extends StatefulWidget {
//   final Map<String, dynamic> logementData;

//   const DatePage({super.key, required this.logementData});

//   @override
//   State<DatePage> createState() => _DatePageState();
// }

// class _DatePageState extends State<DatePage> {
//   // AJOUTÉ : Variables d'état pour stocker les dates sélectionnées
//   DateTime? _checkInDate;
//   DateTime? _checkOutDate;

//   // Initialisation à 0, car aucune date n'est sélectionnée au départ
//   int dureeDuSejourEnNuits = 0;

//   // Méthode de callback pour recevoir les dates du calendrier
//   void _onDatesSelected(DateTime? startDate, DateTime? endDate) {
//     setState(() {
//       _checkInDate = startDate;
//       _checkOutDate = endDate;

//       if (_checkInDate != null && _checkOutDate != null) {
//         // Calculez la différence en jours
//         final difference = _checkOutDate!.difference(_checkInDate!);
//         // Mettez à jour la durée du séjour
//         dureeDuSejourEnNuits = difference.inDays;
//       } else {
//         // Réinitialisez la durée si la sélection n'est pas complète
//         dureeDuSejourEnNuits = 0;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(top: 70, left: 15, right: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 InkWell(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Padding(
//                     padding: EdgeInsets.all(5),
//                     child: Icon(LucideIcons.arrowLeft),
//                   ),
//                 ),
//                 const SizedBox(width: 20),
//                 const Text(
//                   'Réservation',
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Sélectionnez une date',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                 ),
//                 const SizedBox(height: 10),
//                 // ---
//                 // Passez la fonction de callback au calendrier
//                 WidgetBookingCalendar(
//                   onDatesSelected: _onDatesSelected,
//                   onDateRangeSelected:
//                       (DateTime? startDate, DateTime? endDate) {},
//                 ),
//                 // ---
//                 const SizedBox(height: 15),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Note à l\'hôte ',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Container(
//                       height: 190,
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade300,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: const TextField(
//                         decoration: InputDecoration(
//                           hintText: 'Laissez un message (Optionnel)',
//                           hintStyle: TextStyle(fontSize: 13),
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//             GestureDetector(
//               onTap: () {
//                 // Vérifiez si la durée du séjour est de 2 jours ou plus
//                 if (dureeDuSejourEnNuits >= 2) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder:
//                           (context) => PaymentPage(
//                             logementData: widget.logementData,
//                             dureeDuSejour: dureeDuSejourEnNuits,
//                             // ✅ MODIFIÉ : Passage des dates de début et de fin
//                             dateDebut: _checkInDate,
//                             dateFin: _checkOutDate,
//                           ),
//                     ),
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text(
//                         'Veuillez choisir une période d\'au moins 2 nuits.',
//                       ),
//                     ),
//                   );
//                 }
//               },
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 30,
//                   vertical: 15,
//                 ),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Color(0xFF256AFD),
//                   borderRadius: BorderRadius.circular(100),
//                 ),
//                 child: const Text(
//                   'Confirmé',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w700,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Ancien code 2

// import 'package:flutter/material.dart';
// import 'package:kunft/pages/book/payment_page.dart';
// import 'package:lucide_icons/lucide_icons.dart';

// import 'package:kunft/widget/widget_book/widget_booking_calendar.dart';

// class DatePage extends StatefulWidget {
//   final Map<String, dynamic> logementData;

//   const DatePage({super.key, required this.logementData});

//   @override
//   State<DatePage> createState() => _DatePageState();
// }

// class _DatePageState extends State<DatePage> {
//   // Initialisation à 0, car aucune date n'est sélectionnée au départ
//   int dureeDuSejourEnNuits = 0;

//   // Méthode de callback pour recevoir les dates du calendrier
//   void _onDatesSelected(DateTime? startDate, DateTime? endDate) {
//     setState(() {
//       if (startDate != null && endDate != null) {
//         // Calculez la différence en jours
//         final difference = endDate.difference(startDate);
//         // Mettez à jour la durée du séjour
//         dureeDuSejourEnNuits = difference.inDays;
//       } else {
//         // Réinitialisez la durée si la sélection n'est pas complète
//         dureeDuSejourEnNuits = 0;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(top: 70, left: 15, right: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 InkWell(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Padding(
//                     padding: EdgeInsets.all(5),
//                     child: Icon(LucideIcons.arrowLeft),
//                   ),
//                 ),
//                 const SizedBox(width: 20),
//                 const Text(
//                   'Réservation',
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Sélectionnez une date',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                 ),
//                 const SizedBox(height: 10),
//                 // ---
//                 // Passez la fonction de callback au calendrier
//                 WidgetBookingCalendar(
//                   onDatesSelected: _onDatesSelected,
//                   onDateRangeSelected:
//                       (DateTime? startDate, DateTime? endDate) {},
//                 ),
//                 // ---
//                 const SizedBox(height: 15),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Note à l\'hôte ',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Container(
//                       height: 190,
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade300,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: const TextField(
//                         // J'ai remplacé TextFormField par TextField
//                         decoration: InputDecoration(
//                           hintText: 'Laissez un message (Optionnel)',
//                           hintStyle: TextStyle(fontSize: 13),
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//             GestureDetector(
//               onTap: () {
//                 // Vérifiez si la durée du séjour est de 2 jours ou plus
//                 if (dureeDuSejourEnNuits >= 2) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder:
//                           (context) => PaymentPage(
//                             logementData: widget.logementData,
//                             dureeDuSejour: dureeDuSejourEnNuits,
//                           ),
//                     ),
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text(
//                         'Veuillez choisir une période d\'au moins 2 nuits.',
//                       ),
//                     ),
//                   );
//                 }
//               },
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 30,
//                   vertical: 15,
//                 ),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Color(0xFF256AFD),
//                   borderRadius: BorderRadius.circular(100),
//                 ),
//                 child: const Text(
//                   'Confirmé',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w700,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// -------- Ancien code 2

// import 'package:flutter/material.dart';
// import 'package:kunft/pages/book/payment_page.dart';
// import 'package:lucide_icons/lucide_icons.dart';

// import 'package:kunft/widget/widget_book/widget_booking_calendar.dart';

// class DatePage extends StatefulWidget {
//   // ✅ MODIFIÉ : Ajout du paramètre pour recevoir les données du logement
//   final Map<String, dynamic> logementData;

//   const DatePage({
//     super.key,
//     required this.logementData, // ✅ MODIFIÉ : Rendez-le obligatoire
//   });

//   @override
//   State<DatePage> createState() => _DatePageState();
// }

// class _DatePageState extends State<DatePage> {
//   // ✅ AJOUTÉ : État pour stocker la durée du séjour
//   // Vous devrez mettre à jour cet état en fonction de la sélection de l'utilisateur
//   // dans le calendrier. Pour l'exemple, nous l'initialisons à 1 nuit.
//   int dureeDuSejourEnNuits = 1;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(top: 70, left: 15, right: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 InkWell(
//                   onTap: () {
//                     // ✅ MODIFIÉ : La navigation retour est gérée automatiquement
//                     // par `Navigator.pop`, pas besoin de créer une nouvelle page.
//                     Navigator.pop(context);
//                   },
//                   child: const Padding(
//                     padding: EdgeInsets.all(5),
//                     child: Icon(LucideIcons.arrowLeft),
//                   ),
//                 ),
//                 const SizedBox(width: 20),
//                 const Text(
//                   'Réservation',
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
//                 ),
//               ],
//             ),
//             //
//             const SizedBox(height: 16),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Sélectionnez une date',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                 ),
//                 //
//                 const SizedBox(height: 10),
//                 // Bloc Calendrier
//                 const WidgetBookingCalendar(),
//                 //
//                 const SizedBox(height: 15),
//                 //
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Note à l\'hôte ',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     //
//                     const SizedBox(height: 12),
//                     //
//                     Container(
//                       height: 190,
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade300,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: TextFormField(
//                         decoration: InputDecoration(
//                           hintText: 'Laissez un message (Optionnel)',
//                           hintStyle: TextStyle(fontSize: 13),
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//             //
//             GestureDetector(
//               onTap: () {
//                 if (dureeDuSejourEnNuits != 1) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder:
//                           (context) => PaymentPage(
//                             // ✅ MODIFIÉ : Passage des données du logement et de la durée
//                             logementData: widget.logementData,
//                             dureeDuSejour: dureeDuSejourEnNuits,
//                           ),
//                     ),
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Veuillez choisir une période.'),
//                     ),
//                   );
//                 }
//               },
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 30,
//                   vertical: 15,
//                 ),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Color(0xFF256AFD),
//                   borderRadius: BorderRadius.circular(100),
//                 ),
//                 child: const Text(
//                   'Confirmé',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w700,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ----Code Statique

// import 'package:flutter/material.dart';
// import 'package:kunft/pages/book/payment_page.dart';
// import 'package:kunft/pages/property_detail.dart';
// import 'package:kunft/widget/widget_book/widget_booking_calendar.dart';
// import 'package:lucide_icons/lucide_icons.dart';

// class DatePage extends StatefulWidget {
//   const DatePage({super.key});

//   @override
//   State<DatePage> createState() => _DatePageState();
// }

// class _DatePageState extends State<DatePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(top: 70, left: 15, right: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 InkWell(
//                   onTap: () {
//                     Navigator.pop(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => PropertyDetail(logementData: {}),
//                       ),
//                     );
//                   },
//                   child: Container(
//                     padding: EdgeInsets.all(5),
//                     child: Icon(LucideIcons.arrowLeft),
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 Text(
//                   'Réservation',
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
//                 ),
//               ],
//             ),
//             //
//             SizedBox(height: 16),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Sélectionnez une date',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                 ),
//                 //
//                 SizedBox(height: 10),
//                 // Bloc Calendrier
//                 WidgetBookingCalendar(),
//                 //
//                 SizedBox(height: 15),
//                 //
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Note à l\'hôte ',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     //
//                     SizedBox(height: 12),
//                     //
//                     Container(
//                       height: 190,
//                       padding: EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade300,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: TextFormField(
//                         decoration: InputDecoration(
//                           hintText: 'Laissez un message (Optionnel)',
//                           hintStyle: TextStyle(fontSize: 13),
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(height: 30),
//             //
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const PaymentPage()),
//                 );
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Color(0xFF256AFD),
//                   borderRadius: BorderRadius.circular(100),
//                 ),
//                 child: Text(
//                   'Confirmé',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w700,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
