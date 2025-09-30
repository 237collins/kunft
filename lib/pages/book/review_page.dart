import 'package:flutter/material.dart';
import 'package:kunft/pages/home_screen.dart';
import 'package:kunft/pages/profile_screen/elements/my_booking.dart';
import 'package:kunft/provider/ReservationProvider.dart';
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
  final bool isReadOnly;

  const ReviewPageInfos({
    super.key,
    required this.logementData,
    required this.dureeDuSejour,
    required this.modeDePaiement,
    required this.totalPrice,
    this.dateDebut,
    this.dateFin,
    this.isReadOnly = false,
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

    // ✅ On écoute le provider pour le chargement et les erreurs
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
                      'Estimation',
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
                        // ------- Ancien navigation simple ------
                        // InkWell(
                        //   onTap: () {
                        //     Navigator.pop(context);
                        //   },
                        //   child: const Text(
                        //     'Changer',
                        //     style: TextStyle(
                        //       color: Color(0xFF256AFD),
                        //       fontWeight: FontWeight.w700,
                        //     ),
                        //   ),
                        // ),
                        // ----- Fin -----

                        // -------- Nouvelle navigation ----------
                        InkWell(
                          // ✅ Désactive la navigation si la page est en mode lecture seule
                          onTap: widget.isReadOnly
                              ? null
                              : () {
                                  Navigator.pop(context);
                                },
                          child: Text(
                            'Changer',
                            style: TextStyle(
                              color:
                                  widget
                                      .isReadOnly // ✅ Change la couleur du texte si désactivé
                                  ? Colors.grey
                                  : const Color(0xFF256AFD),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        // ------- Fin. ------------
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // -------- Nouvelle Logique avec en plus le read only,
            // ------ pour l'affichage de details d'une reservation
            GestureDetector(
              // 1. Logique du onTap : Désactiver si isReadOnly est vrai
              onTap: widget.isReadOnly
                  ? null
                  : reservationProvider.isLoading
                  ? null
                  : () async {
                      // Vérification des données essentielles avant l'appel
                      if (widget.logementData['id'] == null ||
                          widget.dateDebut == null ||
                          widget.dateFin == null) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Impossible de confirmer : données de réservation manquantes.',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        return;
                      }

                      // ✅ 1. Appel du Provider : Ajout de widget.modeDePaiement
                      await reservationProvider.confirmReservation(
                        context,
                        logementData: widget.logementData,
                        dateDebut: widget.dateDebut!,
                        dateFin: widget.dateFin!,
                        paymentMode: widget
                            .modeDePaiement, // ✅ NOUVEAU : Envoi du mode de paiement
                      );

                      // 2. Vérifier le résultat après l'appel
                      if (reservationProvider.errorMessage != null) {
                        // Gestion des erreurs...
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(reservationProvider.errorMessage!),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        // Succès et Redirection...
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Demande de réservation réussie !'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const MyBooking(),
                            ),
                            (Route<dynamic> route) => false,
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
                  // Logique de la couleur : Changer en gris si isReadOnly est vrai
                  color: widget.isReadOnly
                      ? Colors.grey.shade600
                      : reservationProvider.isLoading
                      ? Colors.grey
                      : const Color(0xFF256AFD),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: reservationProvider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Text(
                        // Logique du texte : Changer le texte en mode lecture seule
                        widget.isReadOnly
                            ? 'Détails'
                            : 'Demander une réservation',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
            ),

            // GestureDetector(
            //   // 1. Logique du onTap : Désactiver si isReadOnly est vrai
            //   onTap:
            //       widget
            //           .isReadOnly // ✅ Si isReadOnly est vrai, onTap est null (désactivé)
            //       ? null
            //       : reservationProvider.isLoading
            //       ? null
            //       : () async {
            //           // Vérification des données avant l'appel
            //           if (widget.logementData['id'] == null ||
            //               widget.dateDebut == null ||
            //               widget.dateFin == null) {
            //             if (mounted) {
            //               ScaffoldMessenger.of(context).showSnackBar(
            //                 const SnackBar(
            //                   content: Text(
            //                     'Impossible de confirmer : données de réservation manquantes.',
            //                   ),
            //                   backgroundColor: Colors.red,
            //                 ),
            //               );
            //             }
            //             return;
            //           }

            //           // 1. Appeler la méthode du provider
            //           await reservationProvider.confirmReservation(
            //             context,
            //             logementData: widget.logementData,
            //             dateDebut: widget.dateDebut!,
            //             dateFin: widget.dateFin!,
            //           );

            //           // 2. Vérifier le résultat après l'appel
            //           if (reservationProvider.errorMessage != null) {
            //             // Gestion des erreurs...
            //             if (mounted) {
            //               ScaffoldMessenger.of(context).showSnackBar(
            //                 SnackBar(
            //                   content: Text(reservationProvider.errorMessage!),
            //                   backgroundColor: Colors.red,
            //                 ),
            //               );
            //             }
            //           } else {
            //             // Succès et Redirection...
            //             if (mounted) {
            //               ScaffoldMessenger.of(context).showSnackBar(
            //                 const SnackBar(
            //                   content: Text('Demande de réservation réussie !'),
            //                   backgroundColor: Colors.green,
            //                 ),
            //               );
            //               Navigator.of(context).pushAndRemoveUntil(
            //                 MaterialPageRoute(
            //                   builder: (context) => const MyBooking(),
            //                 ),
            //                 (Route<dynamic> route) => false,
            //               );
            //             }
            //           }
            //         },
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 30,
            //       vertical: 15,
            //     ),
            //     width: double.infinity,
            //     decoration: BoxDecoration(
            //       // 2. Logique de la couleur : Changer en gris si isReadOnly est vrai
            //       color: widget.isReadOnly
            //           ? Colors
            //                 .grey
            //                 .shade600 // Nouvelle couleur pour l'état figé
            //           : reservationProvider.isLoading
            //           ? Colors.grey
            //           : const Color(0xFF256AFD),
            //       borderRadius: BorderRadius.circular(100),
            //     ),
            //     child: reservationProvider.isLoading
            //         ? const Center(
            //             child: CircularProgressIndicator(color: Colors.white),
            //           )
            //         : Text(
            //             // 3. Logique du texte : Changer le texte en mode lecture seule
            //             widget.isReadOnly
            //                 ? 'Mode Lecture' // Texte quand le mode est figé
            //                 : 'Demander une réservation', // Texte pour la création
            //             style: const TextStyle(
            //               color: Colors.white,
            //               fontWeight: FontWeight.w700,
            //               fontSize: 17,
            //             ),
            //             textAlign: TextAlign.center,
            //           ),
            //   ),
            // ),

            // -------- Fin ----------
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
//                               color: Color(0xFF256AFD),
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
//                       : Color(0xFF256AFD),
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