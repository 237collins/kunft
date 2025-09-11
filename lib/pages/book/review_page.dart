import 'package:flutter/material.dart';
import 'package:kunft/pages/home_screen.dart';
import 'package:kunft/pages/profile_screen/elements/my_booking.dart';
import 'package:kunft/pages/profile_screen/elements/my_reservations_page.dart';
import 'package:kunft/provider/ReservationProvider.dart';
import 'package:kunft/provider/UserProvider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import 'package:kunft/widget/widget_book/review_infos_date.dart';
import 'package:kunft/widget/widget_book/widget_amount.dart';
import 'package:kunft/widget/widget_book/widget_house_infos3_bis.dart';

class ReviewPageInfos extends StatefulWidget {
  final Map<String, dynamic> logementData;
  final int dureeDuSejour;
  final String modeDePaiement;
  final double totalPrice;
  final DateTime? dateDebut;
  final DateTime? dateFin;

  const ReviewPageInfos({
    super.key,
    required this.logementData,
    required this.dureeDuSejour,
    required this.modeDePaiement,
    required this.totalPrice,
    this.dateDebut,
    this.dateFin,
  });

  @override
  State<ReviewPageInfos> createState() => _ReviewPageInfosState();
}

class _ReviewPageInfosState extends State<ReviewPageInfos> {
  String _getPaymentImage(String mode) {
    switch (mode) {
      case 'Orange money':
        return 'assets/logo-payment/om.png';
      case 'MTN Money':
        return 'assets/logo-payment/mtn.png';
      case 'PayPal':
        return 'assets/logo-payment/paypal.png';
      default:
        return 'assets/logo-payment/default.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final dynamic prixValue = widget.logementData['prix_par_nuit'];
    double? prixParNuit;

    if (prixValue is String) {
      prixParNuit = double.tryParse(prixValue);
    } else if (prixValue is double) {
      prixParNuit = prixValue;
    }

    if (prixParNuit == null) {
      prixParNuit = 0.0;
      print(
        'Erreur de conversion : le prix par nuit n\'est pas un nombre valide.',
      );
    }

    final reservationProvider = Provider.of<ReservationProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      'Facturation',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },
                      child: const Icon(LucideIcons.home),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 35),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    WidgetHouseInfos3Bis(logementData: widget.logementData),
                    const SizedBox(height: 10),
                    ReviewInfosDate(
                      dateDebut: widget.dateDebut,
                      dateFin: widget.dateFin,
                      dureeDuSejour: widget.dureeDuSejour,
                    ),
                    const SizedBox(height: 30),
                    WidgetAmount(
                      prixParNuit: prixParNuit,
                      dureeDuSejour: widget.dureeDuSejour,
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          child: Image.asset(
                            _getPaymentImage(widget.modeDePaiement),
                            fit: BoxFit.cover,
                            height: 40,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Changer',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: reservationProvider.isLoading
                  ? null
                  : () async {
                      final userProvider = Provider.of<UserProvider>(
                        context,
                        listen: false,
                      );

                      if (widget.logementData['id'] == null ||
                          userProvider.user?['id'] == null ||
                          widget.dateDebut == null ||
                          widget.dateFin == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Impossible de confirmer : données de réservation manquantes.',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      await reservationProvider.confirmReservation(
                        context,
                        logementData: widget.logementData,
                        dateDebut: widget.dateDebut!,
                        dateFin: widget.dateFin!,
                      );

                      if (reservationProvider.errorMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(reservationProvider.errorMessage!),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Demande de réservation réussie !'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        if (mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyBooking(),
                            ),
                          );
                        }
                      }
                    },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: reservationProvider.isLoading
                      ? Colors.grey
                      : Colors.blue,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: reservationProvider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Text(
                        'Demander une réservation',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}


// -------------- Code okay mais sans envoie des donnes a la page ds booking


// import 'package:flutter/material.dart';
// import 'package:kunft/pages/home_screen.dart';
// import 'package:kunft/provider/ReservationProvider.dart';
// import 'package:kunft/provider/UserProvider.dart' hide ReservationProvider;
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:provider/provider.dart';

// import 'package:kunft/widget/widget_book/review_infos_date.dart';
// import 'package:kunft/widget/widget_book/widget_amount.dart';
// import 'package:kunft/widget/widget_book/widget_house_infos3_bis.dart';

// class ReviewPageInfos extends StatefulWidget {
//   final Map<String, dynamic> logementData;
//   final int dureeDuSejour;
//   final String modeDePaiement;
//   final double totalPrice;
//   final DateTime? dateDebut;
//   final DateTime? dateFin;

//   const ReviewPageInfos({
//     super.key,
//     required this.logementData,
//     required this.dureeDuSejour,
//     required this.modeDePaiement,
//     required this.totalPrice,
//     this.dateDebut,
//     this.dateFin,
//   });

//   @override
//   State<ReviewPageInfos> createState() => _ReviewPageInfosState();
// }

// class _ReviewPageInfosState extends State<ReviewPageInfos> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final reservationProvider = Provider.of<ReservationProvider>(
//         context,
//         listen: false,
//       );
//       final userProvider = Provider.of<UserProvider>(context, listen: false);

//       if (widget.dateDebut == null || widget.dateFin == null) {
//         print('Erreur: Les dates de début ou de fin sont nulles.');
//         return;
//       }

//       final dynamic rawId = widget.logementData['id'];
//       final int logementId = rawId is String ? int.parse(rawId) : rawId as int;

//       // ✅ MODIFICATION : Récupérez l'ID de l'utilisateur depuis l'objet 'user' du UserProvider
//       final String? userId = userProvider.user?['id']?.toString();

//       if (userId == null) {
//         print(
//           'Erreur: ID utilisateur non disponible. Assurez-vous d\'être connecté.',
//         );
//         // Vous pouvez rediriger l'utilisateur vers la page de connexion ici
//         // ou gérer l'erreur de manière appropriée.
//         return;
//       }

//       // 1. Initialiser le provider avec les détails de la réservation
//       reservationProvider.setReservationDetails(
//         logementId: logementId,
//         userId:
//             userId, // ✅ MODIFICATION : Utilisez l'ID de l'utilisateur récupéré
//         dateDebut: widget.dateDebut!,
//         dateFin: widget.dateFin!,
//       );
//     });
//   }

//   String _getPaymentImage(String mode) {
//     switch (mode) {
//       case 'Orange money':
//         return 'assets/logo-payment/om.png';
//       case 'MTN Money':
//         return 'assets/logo-payment/mtn.png';
//       case 'PayPal':
//         return 'assets/logo-payment/paypal.png';
//       default:
//         return 'assets/logo-payment/default.png';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dynamic prixValue = widget.logementData['prix_par_nuit'];
//     double? prixParNuit;

//     if (prixValue is String) {
//       prixParNuit = double.tryParse(prixValue);
//     } else if (prixValue is double) {
//       prixParNuit = prixValue;
//     }

//     if (prixParNuit == null) {
//       prixParNuit = 0.0;
//       print(
//         'Erreur de conversion : le prix par nuit n\'est pas un nombre valide.',
//       );
//     }

//     final reservationProvider = Provider.of<ReservationProvider>(context);

//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Padding(
//                         padding: EdgeInsets.all(5),
//                         child: Icon(LucideIcons.arrowLeft),
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     const Text(
//                       'Facturation',
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const HomeScreen(),
//                           ),
//                         );
//                       },
//                       child: const Icon(LucideIcons.home),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 35),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     WidgetHouseInfos3Bis(logementData: widget.logementData),
//                     const SizedBox(height: 10),
//                     ReviewInfosDate(
//                       dateDebut: widget.dateDebut,
//                       dateFin: widget.dateFin,
//                       dureeDuSejour: widget.dureeDuSejour,
//                     ),
//                     const SizedBox(height: 30),
//                     WidgetAmount(
//                       prixParNuit: prixParNuit,
//                       dureeDuSejour: widget.dureeDuSejour,
//                     ),
//                     const SizedBox(height: 40),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ClipRRect(
//                           child: Image.asset(
//                             _getPaymentImage(widget.modeDePaiement),
//                             fit: BoxFit.cover,
//                             height: 40,
//                           ),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: const Text(
//                             'Changer',
//                             style: TextStyle(
//                               color: Colors.blue,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             GestureDetector(
//               onTap: reservationProvider.isLoading
//                   ? null
//                   : () async {
//                       // You no longer need to get the token here.
//                       // The provider will handle it internally.

//                       await reservationProvider.confirmReservation(
//                         context, // ✅ Passe le 'context' au lieu du 'authToken'
//                       );

//                       if (reservationProvider.errorMessage != null) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(reservationProvider.errorMessage!),
//                             backgroundColor: Colors.red,
//                           ),
//                         );
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('Demande de réservation réussie !'),
//                             backgroundColor: Colors.green,
//                           ),
//                         );
//                       }
//                     },
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 30,
//                   vertical: 15,
//                 ),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: reservationProvider.isLoading
//                       ? Colors.grey
//                       : Colors.blue,
//                   borderRadius: BorderRadius.circular(100),
//                 ),
//                 child: reservationProvider.isLoading
//                     ? const Center(
//                         child: CircularProgressIndicator(color: Colors.white),
//                       )
//                     : const Text(
//                         'Demander une réservation',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w700,
//                           fontSize: 17,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//               ),
//             ),
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }
// }

    



// import 'package:flutter/material.dart';
// import 'package:kunft/pages/home_screen.dart';
// import 'package:kunft/provider/ReservationProvider.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:provider/provider.dart';

// import 'package:kunft/widget/widget_book/review_infos_date.dart';
// import 'package:kunft/widget/widget_book/widget_amount.dart';
// import 'package:kunft/widget/widget_book/widget_house_infos3_bis.dart';

// class ReviewPageInfos extends StatefulWidget {
//   final Map<String, dynamic> logementData;
//   final int dureeDuSejour;
//   final String modeDePaiement;
//   final double totalPrice;
//   final DateTime? dateDebut;
//   final DateTime? dateFin;

//   const ReviewPageInfos({
//     super.key,
//     required this.logementData,
//     required this.dureeDuSejour,
//     required this.modeDePaiement,
//     required this.totalPrice,
//     this.dateDebut,
//     this.dateFin,
//   });

//   @override
//   State<ReviewPageInfos> createState() => _ReviewPageInfosState();
// }

// class _ReviewPageInfosState extends State<ReviewPageInfos> {
//   // ✅ AJOUT : Initialise le provider dès que le widget est créé
//   @override
//   void initState() {
//     super.initState();
//     // Nous utilisons addPostFrameCallback pour s'assurer que le contexte est disponible.
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // On accède au provider avec `listen: false` car on ne veut pas
//       // reconstruire le widget ici, juste appeler une méthode.
//       final reservationProvider = Provider.of<ReservationProvider>(
//         context,
//         listen: false,
//       );

//       // S'assurer que les dates ne sont pas nulles avant de les passer.
//       if (widget.dateDebut == null || widget.dateFin == null) {
//         print('Erreur: Les dates de début ou de fin sont nulles.');
//         return;
//       }

//       // Convertir l'ID du logement si nécessaire pour éviter une _TypeError.
//       final dynamic rawId = widget.logementData['id'];
//       final int logementId = rawId is String ? int.parse(rawId) : rawId as int;

//       // ATTENTION : Remplacez '123' par l'ID de l'utilisateur réel obtenu de votre service d'authentification.
//       const int userId = 3;

//       // 1. Initialiser le provider avec les détails de la réservation
//       reservationProvider.setReservationDetails(
//         logementId: logementId,
//         userId: userId,
//         dateDebut: widget.dateDebut!,
//         dateFin: widget.dateFin!,
//       );
//     });
//   }

//   String _getPaymentImage(String mode) {
//     switch (mode) {
//       case 'Orange money':
//         return 'assets/logo-payment/om.png';
//       case 'MTN Money':
//         return 'assets/logo-payment/mtn.png';
//       case 'PayPal':
//         return 'assets/logo-payment/paypal.png';
//       default:
//         return 'assets/logo-payment/default.png';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dynamic prixValue = widget.logementData['prix_par_nuit'];
//     double? prixParNuit;

//     if (prixValue is String) {
//       prixParNuit = double.tryParse(prixValue);
//     } else if (prixValue is double) {
//       prixParNuit = prixValue;
//     }

//     if (prixParNuit == null) {
//       prixParNuit = 0.0;
//       print(
//         'Erreur de conversion : le prix par nuit n\'est pas un nombre valide.',
//       );
//     }

//     // Le Provider est maintenant disponible pour ce widget et ses enfants
//     final reservationProvider = Provider.of<ReservationProvider>(context);

//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Padding(
//                         padding: EdgeInsets.all(5),
//                         child: Icon(LucideIcons.arrowLeft),
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     const Text(
//                       'Facturation',
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const HomeScreen(),
//                           ),
//                         );
//                       },
//                       child: const Icon(LucideIcons.home),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 35),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     WidgetHouseInfos3Bis(logementData: widget.logementData),
//                     const SizedBox(height: 10),
//                     ReviewInfosDate(
//                       dateDebut: widget.dateDebut,
//                       dateFin: widget.dateFin,
//                       dureeDuSejour: widget.dureeDuSejour,
//                     ),
//                     const SizedBox(height: 30),
//                     WidgetAmount(
//                       prixParNuit: prixParNuit,
//                       dureeDuSejour: widget.dureeDuSejour,
//                     ),
//                     const SizedBox(height: 40),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ClipRRect(
//                           child: Image.asset(
//                             _getPaymentImage(widget.modeDePaiement),
//                             fit: BoxFit.cover,
//                             height: 40,
//                           ),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: const Text(
//                             'Change',
//                             style: TextStyle(
//                               color: Colors.blue,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Le bouton "Payez" appelle maintenant le provider.
//             GestureDetector(
//               onTap:
//                   reservationProvider.isLoading
//                       ? null
//                       : () async {
//                         // 2. Confirmer la réservation
//                         await reservationProvider.confirmReservation();

//                         // 3. Afficher un message de succès ou d'erreur
//                         if (reservationProvider.errorMessage != null) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(reservationProvider.errorMessage!),
//                             ),
//                           );
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Réservation réussie !'),
//                             ),
//                           );
//                           // Optionnel : Naviguer vers un écran de confirmation
//                           // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ConfirmationPage()));
//                         }
//                       },
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 30,
//                   vertical: 15,
//                 ),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color:
//                       reservationProvider.isLoading ? Colors.grey : Colors.blue,
//                   borderRadius: BorderRadius.circular(100),
//                 ),
//                 child:
//                     reservationProvider.isLoading
//                         ? const Center(
//                           child: CircularProgressIndicator(color: Colors.white),
//                         )
//                         : const Text(
//                           'Payez',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w700,
//                             fontSize: 17,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//               ),
//             ),
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:kunft/pages/home_screen.dart';
// import 'package:kunft/provider/ReservationProvider.dart'; // Importation de votre provider
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:provider/provider.dart'; // Importation du package Provider

// import 'package:kunft/widget/widget_book/review_infos_date.dart';
// import 'package:kunft/widget/widget_book/widget_amount.dart';
// import 'package:kunft/widget/widget_book/widget_house_infos3_bis.dart';

// class ReviewPageInfos extends StatefulWidget {
//   final Map<String, dynamic> logementData;
//   final int dureeDuSejour;
//   final String modeDePaiement;
//   final double totalPrice;
//   final DateTime? dateDebut;
//   final DateTime? dateFin;

//   const ReviewPageInfos({
//     super.key,
//     required this.logementData,
//     required this.dureeDuSejour,
//     required this.modeDePaiement,
//     required this.totalPrice,
//     this.dateDebut,
//     this.dateFin,
//   });

//   @override
//   State<ReviewPageInfos> createState() => _ReviewPageInfosState();
// }

// class _ReviewPageInfosState extends State<ReviewPageInfos> {
//   String _getPaymentImage(String mode) {
//     switch (mode) {
//       case 'Orange money':
//         return 'assets/logo-payment/om.png';
//       case 'MTN Money':
//         return 'assets/logo-payment/mtn.png';
//       case 'PayPal':
//         return 'assets/logo-payment/paypal.png';
//       default:
//         return 'assets/logo-payment/default.png';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dynamic prixValue = widget.logementData['prix_par_nuit'];
//     double? prixParNuit;

//     if (prixValue is String) {
//       prixParNuit = double.tryParse(prixValue);
//     } else if (prixValue is double) {
//       prixParNuit = prixValue;
//     }

//     if (prixParNuit == null) {
//       prixParNuit = 0.0;
//       print(
//         'Erreur de conversion : le prix par nuit n\'est pas un nombre valide.',
//       );
//     }

//     // Le Provider est maintenant disponible pour ce widget et ses enfants
//     final reservationProvider = Provider.of<ReservationProvider>(context);

//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Padding(
//                         padding: EdgeInsets.all(5),
//                         child: Icon(LucideIcons.arrowLeft),
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     const Text(
//                       'Facturation',
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const HomeScreen(),
//                           ),
//                         );
//                       },
//                       child: const Icon(LucideIcons.home),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 35),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     WidgetHouseInfos3Bis(logementData: widget.logementData),
//                     const SizedBox(height: 10),
//                     ReviewInfosDate(
//                       dateDebut: widget.dateDebut,
//                       dateFin: widget.dateFin,
//                       dureeDuSejour: widget.dureeDuSejour,
//                     ),
//                     const SizedBox(height: 30),
//                     WidgetAmount(
//                       prixParNuit: prixParNuit,
//                       dureeDuSejour: widget.dureeDuSejour,
//                     ),
//                     const SizedBox(height: 40),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ClipRRect(
//                           child: Image.asset(
//                             _getPaymentImage(widget.modeDePaiement),
//                             fit: BoxFit.cover,
//                             height: 40,
//                           ),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: const Text(
//                             'Change',
//                             style: TextStyle(
//                               color: Colors.blue,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Le bouton "Payez" appelle maintenant le provider.
//             GestureDetector(
//               onTap:
//                   reservationProvider.isLoading
//                       ? null
//                       : () async {
//                         // 1. Définir les détails de la réservation dans le provider
//                         final int logementId = widget.logementData['id'];
//                         // ATTENTION : Remplacez '123' par l'ID de l'utilisateur réel obtenu de votre service d'authentification.
//                         final int userId = 123;
//                         final DateTime dateDebut = widget.dateDebut!;
//                         final DateTime dateFin = widget.dateFin!;

//                         reservationProvider.setReservationDetails(
//                           logementId: logementId,
//                           userId: userId,
//                           dateDebut: dateDebut,
//                           dateFin: dateFin,
//                         );

//                         // 2. Confirmer la réservation
//                         await reservationProvider.confirmReservation();

//                         // 3. Afficher un message de succès ou d'erreur
//                         if (reservationProvider.errorMessage != null) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(reservationProvider.errorMessage!),
//                             ),
//                           );
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Réservation réussie !'),
//                             ),
//                           );
//                           // Optionnel : Naviguer vers un écran de confirmation
//                           // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ConfirmationPage()));
//                         }
//                       },
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 30,
//                   vertical: 15,
//                 ),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color:
//                       reservationProvider.isLoading ? Colors.grey : Colors.blue,
//                   borderRadius: BorderRadius.circular(100),
//                 ),
//                 child:
//                     reservationProvider.isLoading
//                         ? const Center(
//                           child: CircularProgressIndicator(color: Colors.white),
//                         )
//                         : const Text(
//                           'Payez',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w700,
//                             fontSize: 17,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//               ),
//             ),
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }
// }




// Ancien code 4 non ajuste


// import 'package:flutter/material.dart';
// import 'package:kunft/pages/home_screen.dart';
// import 'package:kunft/provider/ReservationProvider.dart'; // Importation de votre provider
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:provider/provider.dart'; // Importation du package Provider

// import 'package:kunft/widget/widget_book/review_infos_date.dart';
// import 'package:kunft/widget/widget_book/widget_amount.dart';
// import 'package:kunft/widget/widget_book/widget_house_infos3_bis.dart';

// class ReviewPageInfos extends StatefulWidget {
//   final Map<String, dynamic> logementData;
//   final int dureeDuSejour;
//   final String modeDePaiement;
//   final double totalPrice;
//   final DateTime? dateDebut;
//   final DateTime? dateFin;

//   const ReviewPageInfos({
//     super.key,
//     required this.logementData,
//     required this.dureeDuSejour,
//     required this.modeDePaiement,
//     required this.totalPrice,
//     this.dateDebut,
//     this.dateFin,
//   });

//   @override
//   State<ReviewPageInfos> createState() => _ReviewPageInfosState();
// }

// class _ReviewPageInfosState extends State<ReviewPageInfos> {
//   String _getPaymentImage(String mode) {
//     switch (mode) {
//       case 'Orange money':
//         return 'assets/logo-payment/om.png';
//       case 'MTN Money':
//         return 'assets/logo-payment/mtn.png';
//       case 'PayPal':
//         return 'assets/logo-payment/paypal.png';
//       default:
//         return 'assets/logo-payment/default.png';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final dynamic prixValue = widget.logementData['prix_par_nuit'];
//     double? prixParNuit;

//     if (prixValue is String) {
//       prixParNuit = double.tryParse(prixValue);
//     } else if (prixValue is double) {
//       prixParNuit = prixValue;
//     }

//     if (prixParNuit == null) {
//       prixParNuit = 0.0;
//       print(
//         'Erreur de conversion : le prix par nuit n\'est pas un nombre valide.',
//       );
//     }

//     // Accès au provider
//     final reservationProvider = Provider.of<ReservationProvider>(context);

//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Padding(
//                         padding: EdgeInsets.all(5),
//                         child: Icon(LucideIcons.arrowLeft),
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     const Text(
//                       'Facturation',
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const HomeScreen(),
//                           ),
//                         );
//                       },
//                       child: const Icon(LucideIcons.home),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 35),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     WidgetHouseInfos3Bis(logementData: widget.logementData),
//                     const SizedBox(height: 10),
//                     ReviewInfosDate(
//                       dateDebut: widget.dateDebut,
//                       dateFin: widget.dateFin,
//                       dureeDuSejour: widget.dureeDuSejour,
//                     ),
//                     const SizedBox(height: 30),
//                     WidgetAmount(
//                       prixParNuit: prixParNuit,
//                       dureeDuSejour: widget.dureeDuSejour,
//                     ),
//                     const SizedBox(height: 40),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ClipRRect(
//                           child: Image.asset(
//                             _getPaymentImage(widget.modeDePaiement),
//                             fit: BoxFit.cover,
//                             height: 40,
//                           ),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: const Text(
//                             'Change',
//                             style: TextStyle(
//                               color: Colors.blue,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // ✅ MODIFIÉ : Le bouton "Payez" appelle maintenant le provider.
//             GestureDetector(
//               onTap:
//                   reservationProvider.isLoading
//                       ? null
//                       : () async {
//                         // 1. Définir les détails de la réservation dans le provider
//                         final int logementId = widget.logementData['id'];
//                         // ✅ ATTENTION : Remplacez '123' par l'ID de l'utilisateur réel obtenu de votre service d'authentification.
//                         final int userId = 123;
//                         final DateTime dateDebut = widget.dateDebut!;
//                         final DateTime dateFin = widget.dateFin!;

//                         reservationProvider.setReservationDetails(
//                           logementId: logementId,
//                           userId: userId,
//                           dateDebut: dateDebut,
//                           dateFin: dateFin,
//                         );

//                         // 2. Confirmer la réservation
//                         await reservationProvider.confirmReservation();

//                         // 3. Afficher un message de succès ou d'erreur
//                         if (reservationProvider.errorMessage != null) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(reservationProvider.errorMessage!),
//                             ),
//                           );
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Réservation réussie !'),
//                             ),
//                           );
//                           // Optionnel : Naviguer vers un écran de confirmation
//                           // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ConfirmationPage()));
//                         }
//                       },
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 30,
//                   vertical: 15,
//                 ),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color:
//                       reservationProvider.isLoading ? Colors.grey : Colors.blue,
//                   borderRadius: BorderRadius.circular(100),
//                 ),
//                 child:
//                     reservationProvider.isLoading
//                         ? const Center(
//                           child: CircularProgressIndicator(color: Colors.white),
//                         )
//                         : const Text(
//                           'Payez',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w700,
//                             fontSize: 17,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//               ),
//             ),
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }
// }



//  ------ Ancien code 3
// import 'package:flutter/material.dart';
// import 'package:kunft/pages/home_screen.dart';
// import 'package:lucide_icons/lucide_icons.dart';

// import 'package:kunft/widget/widget_book/review_infos_date.dart';
// import 'package:kunft/widget/widget_book/widget_amount.dart';
// import 'package:kunft/widget/widget_book/widget_house_infos3_bis.dart';

// class ReviewPageInfos extends StatefulWidget {
//   final Map<String, dynamic> logementData;
//   final int dureeDuSejour;
//   final String modeDePaiement;
//   final double totalPrice;
//   final DateTime? dateDebut;
//   final DateTime? dateFin;

//   const ReviewPageInfos({
//     super.key,
//     required this.logementData,
//     required this.dureeDuSejour,
//     required this.modeDePaiement,
//     required this.totalPrice,
//     this.dateDebut,
//     this.dateFin,
//   });

//   @override
//   State<ReviewPageInfos> createState() => _ReviewPageInfosState();
// }

// class _ReviewPageInfosState extends State<ReviewPageInfos> {
//   String _getPaymentImage(String mode) {
//     switch (mode) {
//       case 'Orange money':
//         return 'assets/logo-payment/om.png';
//       case 'MTN Money':
//         return 'assets/logo-payment/mtn.png';
//       case 'PayPal':
//         return 'assets/logo-payment/paypal.png';
//       default:
//         return 'assets/logo-payment/default.png';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ✅ MODIFIÉ : Conversion du prix de String à double
//     final dynamic prixValue = widget.logementData['prix_par_nuit'];
//     double? prixParNuit;

//     if (prixValue is String) {
//       prixParNuit = double.tryParse(prixValue);
//     } else if (prixValue is double) {
//       prixParNuit = prixValue;
//     }

//     if (prixParNuit == null) {
//       // Gérer le cas où le prix ne peut pas être converti
//       prixParNuit = 0.0;
//       print(
//         'Erreur de conversion : le prix par nuit n\'est pas un nombre valide.',
//       );
//     }

//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Padding(
//                         padding: EdgeInsets.all(5),
//                         child: Icon(LucideIcons.arrowLeft),
//                       ),
//                     ),
//                     const SizedBox(width: 20),
//                     const Text(
//                       'Facturation',
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const HomeScreen(),
//                           ),
//                         );
//                       },
//                       child: const Icon(LucideIcons.home),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 35),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     WidgetHouseInfos3Bis(logementData: widget.logementData),
//                     const SizedBox(height: 10),
//                     ReviewInfosDate(
//                       dateDebut: widget.dateDebut,
//                       dateFin: widget.dateFin,
//                       dureeDuSejour: widget.dureeDuSejour,
//                     ),
//                     const SizedBox(height: 30),
//                     // ✅ MODIFIÉ : Utilisation de la nouvelle variable prixParNuit
//                     WidgetAmount(
//                       prixParNuit: prixParNuit,
//                       dureeDuSejour: widget.dureeDuSejour,
//                     ),
//                     const SizedBox(height: 40),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ClipRRect(
//                           child: Image.asset(
//                             _getPaymentImage(widget.modeDePaiement),
//                             fit: BoxFit.cover,
//                             height: 40,
//                           ),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: const Text(
//                             'Change',
//                             style: TextStyle(
//                               color: Colors.blue,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     //
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // GestureDetector(
//             //   child: Container(
//             //     padding: const EdgeInsets.symmetric(
//             //       horizontal: 30,
//             //       vertical: 15,
//             //     ),
//             //     width: double.infinity,
//             //     decoration: BoxDecoration(
//             //       color: Colors.blue,
//             //       borderRadius: BorderRadius.circular(100),
//             //     ),
//             //     child: const Text(
//             //       'Payez',
//             //       style: TextStyle(
//             //         color: Colors.white,
//             //         fontWeight: FontWeight.w700,
//             //         fontSize: 17,
//             //       ),
//             //       textAlign: TextAlign.center,
//             //     ),
//             //   ),
//             // ),

//             //
//             GestureDetector(
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
//                   'Payez',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 17,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }
// }




//   ------ Ancien code 2

// ignore_for_file: public_member_api_docs, sort_constructors_first

// import 'package:flutter/material.dart';
// import 'package:lucide_icons/lucide_icons.dart';

// import 'package:kunft/pages/book/payment_page.dart';
// import 'package:kunft/widget/widget_book/review_infos_date.dart';
// import 'package:kunft/widget/widget_book/widget_amount.dart';
// import 'package:kunft/widget/widget_book/widget_house_infos3_bis.dart';
// import 'package:kunft/widget/widget_book/widget_payment_mode.dart'; // ✅ Import du widget de mode de paiement

// class ReviewPageInfos extends StatefulWidget {
//   final Map<String, dynamic> logementData;
//   final int dureeDuSejour; // ✅ Ajout du paramètre
//   final String modeDePaiement; // ✅ Ajout du paramètre

//   const ReviewPageInfos({
//     super.key,
//     required this.logementData,
//     required this.dureeDuSejour,
//     required this.modeDePaiement,
//   });

//   @override
//   State<ReviewPageInfos> createState() => _ReviewPageInfosState();
// }

// class _ReviewPageInfosState extends State<ReviewPageInfos> {
//   // Fonction utilitaire pour obtenir l'image du mode de paiement
//   String _getPaymentImage(String mode) {
//     switch (mode) {
//       case 'Orange money':
//         return 'assets/logo-payment/om.png';
//       case 'MTN Money':
//         return 'assets/logo-payment/mtn.png';
//       case 'PayPal':
//         return 'assets/logo-payment/paypal.png';
//       default:
//         return 'assets/logo-payment/default.png'; // Image par défaut
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(top: 70, left: 10, right: 10),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 InkWell(
//                   onTap: () {
//                     // ✅ MODIFIÉ : Retour direct à l'écran précédent
//                     Navigator.pop(context);
//                   },
//                   child: const Padding(
//                     padding: EdgeInsets.all(5),
//                     child: Icon(LucideIcons.arrowLeft),
//                   ),
//                 ),
//                 const SizedBox(width: 20),
//                 const Text(
//                   'Facturation',
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 35),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     // ✅ AFFICHE LE WIDGET DU LOGEMENT
//                     WidgetHouseInfos3Bis(logementData: widget.logementData),
//                     const SizedBox(height: 10),
//                     // ✅ AFFICHE LA DURÉE DU SÉJOUR
//                     // ReviewInfosDate(dureeDuSejour: widget.dureeDuSejour, dateDebut: null, dateFin: null,),
//                     // ✅ Afficher les dates et la durée
//                     ReviewInfosDate(
//                       dateDebut:
//                           DateTime.now(), // Remplacer par la date de début réelle
//                       dateFin: DateTime.now().add(
//                         Duration(days: widget.dureeDuSejour),
//                       ), // Remplacer par la date de fin réelle
//                       dureeDuSejour: widget.dureeDuSejour,
//                     ),
//                     const SizedBox(height: 30),
//                     // ✅ Placeholder pour le widget du montant
//                     // Remplacez cette ligne par votre WidgetAmount
//                     WidgetAmount(),
//                     const SizedBox(height: 40),
//                     // ✅ AFFICHE LE MODE DE PAIEMENT
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ClipRRect(
//                           child: Image.asset(
//                             _getPaymentImage(widget.modeDePaiement),
//                             fit: BoxFit.cover,
//                             height: 40,
//                           ),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             // ✅ Navigation vers la page de paiement pour changer
//                             Navigator.pop(
//                               context,
//                               MaterialPageRoute(
//                                 builder:
//                                     (context) => PaymentPage(
//                                       logementData: widget.logementData,
//                                       dureeDuSejour: widget.dureeDuSejour,
//                                     ),
//                               ),
//                             );
//                           },
//                           child: const Text(
//                             'Change',
//                             style: TextStyle(
//                               color: Colors.blue,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // Bouton de Confimation
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//                 borderRadius: BorderRadius.circular(100),
//               ),
//               child: const Text(
//                 'Confirmé',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w700,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }
// }


// Ancien code 

// import 'package:flutter/material.dart';
// import 'package:kunft/pages/book/payment_page.dart';
// import 'package:kunft/pages/home_screen.dart';
// import 'package:kunft/pages/qr_code/qr_generator_page.dart';
// import 'package:kunft/pages/qr_code/qr_scanner_page.dart';
// import 'package:kunft/widget/widget_book/review_infos_date.dart';
// import 'package:kunft/widget/widget_book/review_infos_date2.dart';
// import 'package:kunft/widget/widget_book/widget_house_infos3_bis.dart';
// import 'package:lucide_icons/lucide_icons.dart';

// class ReviewPageInfos extends StatefulWidget {
//   const ReviewPageInfos({super.key});

//   @override
//   State<ReviewPageInfos> createState() => _ReviewPageInfosState();
// }

// class _ReviewPageInfosState extends State<ReviewPageInfos> {
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
//                     Navigator.pop(
//                       context,
//                       MaterialPageRoute(builder: (context) => HomeScreen()),
//                     );
//                   },
//                   child: Container(
//                     padding: EdgeInsets.all(5),
//                     child: Icon(LucideIcons.arrowLeft),
//                   ),
//                 ),
//                 SizedBox(width: 20),
//                 Text(
//                   'Facturation',
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
//                 ),
//               ],
//             ),
//             //
//             SizedBox(height: 35),
//             Column(
//               children: [
//                 WidgetHouseInfos3Bis(),
//                 //
//                 SizedBox(height: 10),
//                 //
//                 ReviewInfosDate(),
//                 //
//                 SizedBox(height: 30),
//                 //
//                 ReviewInfosDate2(),
//                 // Mode de paiement
//                 SizedBox(height: 40),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     ClipRRect(
//                       child: Image.asset(
//                         'assets/logo-payment/om.png',
//                         fit: BoxFit.cover,
//                         height: 40,
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         Navigator.pop(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => PaymentPage(),
//                           ),
//                         );
//                       },
//                       child: Text(
//                         'Change',
//                         style: TextStyle(
//                           color: Colors.blue,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 // Ligne Tenporaire
//                 Row(
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => const QrScannerPage(),
//                           ),
//                         );
//                       },
//                       child: const Text('Go to QR Scanner'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => const QrGeneratorPage(),
//                           ),
//                         );
//                       },
//                       child: const Text('Go to QR Generator'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             Spacer(),
//             // Bouton de Confimation
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//                 borderRadius: BorderRadius.circular(100),
//               ),
//               child: Text(
//                 'Confirmé',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w700,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             //
//             SizedBox(height: 40),
//           ],
//         ),
//       ),
//     );
//   }
// }
