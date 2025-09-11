import 'package:flutter/material.dart';
import 'package:kunft/pages/book/review_page.dart';
import 'package:kunft/widget/widget_book/widget_payment_mode.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:kunft/provider/ReservationProvider.dart';

class PaymentPage extends StatefulWidget {
  final Map<String, dynamic> logementData;
  final int dureeDuSejour;
  final DateTime? dateDebut;
  final DateTime? dateFin;

  const PaymentPage({
    super.key,
    required this.logementData,
    required this.dureeDuSejour,
    this.dateDebut,
    this.dateFin,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? _modeDePaiement;

  @override
  void initState() {
    super.initState();
    // Affiche les données pour s'assurer que la bonne clé est là
    print('--- Données de logementData reçues sur la PaymentPage ---');
    print(widget.logementData);
    print('---------------------------------------------------------');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 70, left: 15, right: 15),
        child: Column(
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
                  'Paiement',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 35),
            Column(
              children: [
                Column(
                  children: [
                    const Text(
                      'Choisissez un mode de paiement',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 50),
                    WidgetPaymentMode(
                      imgPayment: 'assets/logo-payment/om.png',
                      text: 'Orange money',
                      isSelected: _modeDePaiement == 'Orange money',
                      onTap: () {
                        setState(() {
                          _modeDePaiement = 'Orange money';
                        });
                      },
                    ),
                    const SizedBox(height: 40),
                    WidgetPaymentMode(
                      imgPayment: 'assets/logo-payment/mtn.png',
                      text: 'MTN Money',
                      isSelected: _modeDePaiement == 'MTN Money',
                      onTap: () {
                        setState(() {
                          _modeDePaiement = 'MTN Money';
                        });
                      },
                    ),
                    const SizedBox(height: 40),
                    WidgetPaymentMode(
                      imgPayment: 'assets/logo-payment/paypal.png',
                      text: 'PayPal',
                      isSelected: _modeDePaiement == 'PayPal',
                      onTap: () {
                        setState(() {
                          _modeDePaiement = 'PayPal';
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                if (_modeDePaiement != null) {
                  // Récupère la valeur du prix, qui peut être un String ou un double
                  final dynamic prixValue =
                      widget.logementData['prix_par_nuit'];
                  double? prixParNuit;

                  // Tente de convertir la valeur en double
                  if (prixValue is String) {
                    prixParNuit = double.tryParse(prixValue);
                  } else if (prixValue is double) {
                    prixParNuit = prixValue;
                  }

                  // Vérifie si le prix a pu être récupéré et converti correctement
                  if (prixParNuit == null) {
                    print(
                      'Erreur : prix_par_nuit est manquant ou ne peut pas être converti.',
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Le prix n\'est pas disponible pour ce logement.',
                        ),
                      ),
                    );
                    return;
                  }

                  final double totalPrice = prixParNuit * widget.dureeDuSejour;
                  print('Prix total calculé : $totalPrice');

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ChangeNotifierProvider<ReservationProvider>(
                          create: (_) => ReservationProvider(),
                          child: ReviewPageInfos(
                            logementData: widget.logementData,
                            dureeDuSejour: widget.dureeDuSejour,
                            modeDePaiement: _modeDePaiement!,
                            dateDebut: widget.dateDebut,
                            dateFin: widget.dateFin,
                            totalPrice: totalPrice,
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('Veuillez choisir un mode de paiement.'),
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
                  color: Colors.blue,
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
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}




// ------- 

// import 'package:flutter/material.dart';
// import 'package:kunft/pages/book/review_page.dart';
// import 'package:kunft/widget/widget_book/widget_payment_mode.dart';
// import 'package:lucide_icons/lucide_icons.dart';

// class PaymentPage extends StatefulWidget {
//   final Map<String, dynamic> logementData;
//   final int dureeDuSejour;
//   final DateTime? dateDebut;
//   final DateTime? dateFin;

//   const PaymentPage({
//     super.key,
//     required this.logementData,
//     required this.dureeDuSejour,
//     this.dateDebut,
//     this.dateFin,
//   });

//   @override
//   State<PaymentPage> createState() => _PaymentPageState();
// }

// class _PaymentPageState extends State<PaymentPage> {
//   String? _modeDePaiement;

//   @override
//   void initState() {
//     super.initState();
//     // Affiche les données pour s'assurer que la bonne clé est là
//     print('--- Données de logementData reçues sur la PaymentPage ---');
//     print(widget.logementData);
//     print('---------------------------------------------------------');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(top: 70, left: 15, right: 15),
//         child: Column(
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
//                   'Paiement',
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 35),
//             Column(
//               children: [
//                 Column(
//                   children: [
//                     const Text(
//                       'Choisissez un mode de paiement',
//                       style: TextStyle(
//                         fontSize: 25,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(height: 50),
//                     WidgetPaymentMode(
//                       imgPayment: 'assets/logo-payment/om.png',
//                       text: 'Orange money',
//                       isSelected: _modeDePaiement == 'Orange money',
//                       onTap: () {
//                         setState(() {
//                           _modeDePaiement = 'Orange money';
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 40),
//                     WidgetPaymentMode(
//                       imgPayment: 'assets/logo-payment/mtn.png',
//                       text: 'MTN Money',
//                       isSelected: _modeDePaiement == 'MTN Money',
//                       onTap: () {
//                         setState(() {
//                           _modeDePaiement = 'MTN Money';
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 40),
//                     WidgetPaymentMode(
//                       imgPayment: 'assets/logo-payment/paypal.png',
//                       text: 'PayPal',
//                       isSelected: _modeDePaiement == 'PayPal',
//                       onTap: () {
//                         setState(() {
//                           _modeDePaiement = 'PayPal';
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const Spacer(),
//             GestureDetector(
//               onTap: () {
//                 if (_modeDePaiement != null) {
//                   // Récupère la valeur du prix, qui peut être un String ou un double
//                   final dynamic prixValue =
//                       widget.logementData['prix_par_nuit'];
//                   double? prixParNuit;

//                   // Tente de convertir la valeur en double
//                   if (prixValue is String) {
//                     prixParNuit = double.tryParse(prixValue);
//                   } else if (prixValue is double) {
//                     prixParNuit = prixValue;
//                   }

//                   // Vérifie si le prix a pu être récupéré et converti correctement
//                   if (prixParNuit == null) {
//                     print(
//                       'Erreur : prix_par_nuit est manquant ou ne peut pas être converti.',
//                     );
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text(
//                           'Le prix n\'est pas disponible pour ce logement.',
//                         ),
//                       ),
//                     );
//                     return;
//                   }

//                   final double totalPrice = prixParNuit * widget.dureeDuSejour;
//                   print('Prix total calculé : $totalPrice');

//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder:
//                           (context) => ReviewPageInfos(
//                             logementData: widget.logementData,
//                             dureeDuSejour: widget.dureeDuSejour,
//                             modeDePaiement: _modeDePaiement!,
//                             dateDebut: widget.dateDebut,
//                             dateFin: widget.dateFin,
//                             totalPrice: totalPrice,
//                           ),
//                     ),
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       backgroundColor: Colors.red,
//                       content: Text('Veuillez choisir un mode de paiement.'),
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
//                   color: Colors.blue,
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
//             const SizedBox(height: 60),
//           ],
//         ),
//       ),
//     );
//   }
// }



// Ancien code sans l'envoie du montant

// import 'package:flutter/material.dart';
// import 'package:kunft/pages/book/review_page.dart';
// import 'package:kunft/widget/widget_book/widget_payment_mode.dart';
// import 'package:lucide_icons/lucide_icons.dart';

// class PaymentPage extends StatefulWidget {
//   final Map<String, dynamic> logementData;
//   final int dureeDuSejour;
//   final DateTime? dateDebut; // ✅ AJOUTÉ : date de début
//   final DateTime? dateFin; // ✅ AJOUTÉ : date de fin

//   const PaymentPage({
//     super.key,
//     required this.logementData,
//     required this.dureeDuSejour,
//     this.dateDebut, // ✅ AJOUTÉ
//     this.dateFin, // ✅ AJOUTÉ
//   });

//   @override
//   State<PaymentPage> createState() => _PaymentPageState();
// }

// class _PaymentPageState extends State<PaymentPage> {
//   String? _modeDePaiement;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(top: 70, left: 15, right: 15),
//         child: Column(
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
//                   'Paiement',
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 35),
//             Column(
//               children: [
//                 Column(
//                   children: [
//                     const Text(
//                       'Choisissez un mode de paiement',
//                       style: TextStyle(
//                         fontSize: 25,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(height: 50),
//                     //
//                     WidgetPaymentMode(
//                       imgPayment: 'assets/logo-payment/om.png',
//                       text: 'Orange money',
//                       isSelected: _modeDePaiement == 'Orange money',
//                       onTap: () {
//                         setState(() {
//                           _modeDePaiement = 'Orange money';
//                         });
//                       },
//                     ),
//                     //
//                     const SizedBox(height: 40),
//                     //
//                     WidgetPaymentMode(
//                       imgPayment: 'assets/logo-payment/mtn.png',
//                       text: 'MTN Money',
//                       isSelected: _modeDePaiement == 'MTN Money',
//                       onTap: () {
//                         setState(() {
//                           _modeDePaiement = 'MTN Money';
//                         });
//                       },
//                     ),
//                     //
//                     const SizedBox(height: 40),
//                     //
//                     WidgetPaymentMode(
//                       imgPayment: 'assets/logo-payment/paypal.png',
//                       text: 'PayPal',
//                       isSelected: _modeDePaiement == 'PayPal',
//                       onTap: () {
//                         setState(() {
//                           _modeDePaiement = 'PayPal';
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const Spacer(),
//             // Bouton de Confirmation
//             GestureDetector(
//               onTap: () {
//                 if (_modeDePaiement != null) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder:
//                           (context) => ReviewPageInfos(
//                             logementData: widget.logementData,
//                             dureeDuSejour: widget.dureeDuSejour,
//                             modeDePaiement: _modeDePaiement!,
//                             dateDebut: widget.dateDebut, // ✅ PASSAGE DES DATES
//                             dateFin: widget.dateFin, // ✅ PASSAGE DES DATES
//                           ),
//                     ),
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Veuillez choisir un mode de paiement.'),
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
//                   color: Colors.blue,
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
//             const SizedBox(height: 60),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ReviewPageInfos extends StatefulWidget {
//   final Map<String, dynamic> logementData;
//   final int dureeDuSejour;
//   final String modeDePaiement;

//   const ReviewPageInfos({
//     Key? key,
//     required this.logementData,
//     required this.dureeDuSejour,
//     required this.modeDePaiement,
//   }) : super(key: key);

//   @override
//   State<ReviewPageInfos> createState() => _ReviewPageInfosState();
// }

// class _ReviewPageInfosState extends State<ReviewPageInfos> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Facturation')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text('Récapitulatif de votre réservation :'),
//             const SizedBox(height: 20),
//             Text('Logement : ${widget.logementData['titre']}'),
//             Text('Durée du séjour : ${widget.dureeDuSejour} nuits'),
//             Text('Mode de paiement : ${widget.modeDePaiement}'),
//             // Vous pouvez ajouter plus d'informations ici, comme le prix total.
//           ],
//         ),
//       ),
//     );
//   }
// }

//   ------ Code Statique

// import 'package:flutter/material.dart';
// import 'package:kunft/pages/book/date_page.dart';
// import 'package:kunft/pages/book/review_page.dart';
// import 'package:kunft/widget/widget_book/widget_payment_mode.dart';
// import 'package:lucide_icons/lucide_icons.dart';

// class PaymentPage extends StatefulWidget {
//   const PaymentPage({super.key});

//   @override
//   State<PaymentPage> createState() => _PaymentPageState();
// }

// class _PaymentPageState extends State<PaymentPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Colors.blueAccent,
//       body: Padding(
//         padding: const EdgeInsets.only(top: 70, left: 15, right: 15),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 InkWell(
//                   onTap: () {
//                     Navigator.pop(
//                       context,
//                       MaterialPageRoute(builder: (context) => DatePage()),
//                     );
//                   },
//                   child: Container(
//                     padding: EdgeInsets.all(5),
//                     child: Icon(LucideIcons.arrowLeft),
//                   ),
//                 ),
//                 // SizedBox(width: 20),
//                 // Text(
//                 //   'Paiement',
//                 //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
//                 // ),
//               ],
//             ),
//             //
//             SizedBox(height: 35),
//             Column(
//               children: [
//                 Text(
//                   'Choissisez un mode de paiement',
//                   style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
//                 ),
//                 SizedBox(height: 50),
//                 //
//                 WidgetPaymentMode(
//                   imgPayment: 'assets/logo-payment/om.png',
//                   text: 'Orange money',
//                 ),
//                 //
//                 SizedBox(height: 40),
//                 //
//                 WidgetPaymentMode(
//                   imgPayment: 'assets/logo-payment/mtn.png',
//                   text: 'MTN Money',
//                 ),
//                 //
//                 SizedBox(height: 40),
//                 //
//                 WidgetPaymentMode(
//                   imgPayment: 'assets/logo-payment/paypal.png',
//                   text: 'PayPal',
//                 ),
//               ],
//             ),
//             Spacer(),
//             // Bouton de Confimation
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const ReviewPageInfos(logementData: {},),
//                   ),
//                 );
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
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

//             //
//             // ElevatedButton(
//             //   onPressed: () {
//             //     showDialog(
//             //       context: context,
//             //       builder: (context) => const WidgetOkayDialog(),
//             //     );
//             //   },
//             //   child: const Text("Simuler Échec de Paiement"),
//             // ),
//             SizedBox(height: 60),
//           ],
//         ),
//       ),
//     );
//   }
// }
