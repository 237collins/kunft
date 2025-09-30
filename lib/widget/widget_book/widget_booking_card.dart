import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kunft/pages/book/review_page.dart';

class WidgetBookingCard extends StatefulWidget {
  // ✅ Variables for dynamic data - These become immutable properties of the widget
  final Map<String, dynamic> reservationData; // ✅  Passe toutes les données
  final String imageUrl;
  final String title;
  final String location;
  final String price;
  final String reservationStatuts;
  final DateTime dateDebut;
  final DateTime dateFin;

  const WidgetBookingCard({
    Key? superkey,
    required this.reservationData,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.price,
    required this.reservationStatuts,
    required this.dateDebut,
    required this.dateFin,
  }) : super(key: superkey);

  @override
  State<WidgetBookingCard> createState() => _WidgetBookingCardState();
}

class _WidgetBookingCardState extends State<WidgetBookingCard> {
  // Méthode pour afficher le statut avec la bonne couleur
  Color _getStatutsColor(String statuts) {
    if (statuts.toLowerCase() == 'confirmée') {
      return Colors.green.shade700;
    }
    if (statuts.toLowerCase() == 'en_cours' ||
        statuts.toLowerCase() == 'en_attente') {
      return const Color(0xFF256AFD);
    }
    return Colors.grey;
  }

  // Calcul de la durée du séjour
  int getDureeDuSejour(DateTime start, DateTime end) {
    return end.difference(start).inDays;
  }

  @override
  Widget build(BuildContext context) {
    // We access the widget's properties using `widget.`
    final int dureeDuSejour = getDureeDuSejour(
      widget.dateDebut,
      widget.dateFin,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 5),
            spreadRadius: 3,
            blurRadius: 3,
            color: Color(0x66d9d9d9),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 90,
                height: 90,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    height: 90,
                    width: 90,
                    // Image en cas d'ereur
                    // errorBuilder: (context, error, stackTrace) => Image.network(
                    //   'https://placehold.co/600x400',
                    //   fit: BoxFit.cover,
                    //   height: 90,
                    //   width: 90,
                    // ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 230,
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        '${DateFormat('d MMM yyyy', 'fr_FR').format(widget.dateDebut)} - ${DateFormat('d MMM yyyy', 'fr_FR').format(widget.dateFin)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        ' ($dureeDuSejour jours)',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.price,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'BebasNeue',
                              color: Color(0xFF256AFD),
                            ),
                          ),
                          const Text(
                            ' xaf',
                            style: TextStyle(
                              fontFamily: 'BebasNeue',
                              color: Color(0xFF256AFD),
                            ),
                          ),
                          Text(
                            ' pour $dureeDuSejour jours',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      // Affichage du Statut  de la reservation
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(
                            width: 1,
                            color: _getStatutsColor(widget.reservationStatuts),
                          ),
                        ),
                        child: Text(
                          widget.reservationStatuts,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _getStatutsColor(widget.reservationStatuts),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Divider(color: Colors.black12),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  // ---------- Nouvelle methode de calcule -------
                  onTap: () {
                    // Calcul de la durée du séjour
                    final DateTime dateDebut = widget.dateDebut;
                    final DateTime dateFin = widget.dateFin;
                    final int dureeDuSejour = dateFin
                        .difference(dateDebut)
                        .inDays;

                    // Récupération du prix total
                    final double totalPrice =
                        double.tryParse(
                          widget.reservationData['prix_total'].toString(),
                        ) ??
                        0.0;

                    // Récupération du mode de paiement (si stocké dans la réservation)
                    final String modeDePaiement =
                        widget.reservationData['payment_mode'] ??
                        'Non spécifié';

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewPageInfos(
                          logementData: widget.reservationData['logement'],
                          // ✅ Passez les valeurs calculées et récupérées
                          dureeDuSejour: dureeDuSejour,
                          totalPrice: totalPrice,
                          modeDePaiement: modeDePaiement,
                          dateDebut: dateDebut,
                          dateFin: dateFin,
                          isReadOnly: true,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF256AFD),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Text(
                      'Détails',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6.5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 2.5,
                      color: const Color(0xFF256AFD),
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    'Confirmez',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF256AFD),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



// -------- Code Statique


// import 'package:flutter/material.dart';

// class WidgetBookingCard extends StatefulWidget {
//   const WidgetBookingCard({super.key});

//   @override
//   State<WidgetBookingCard> createState() => _WidgetBookingCardState();
// }

// class _WidgetBookingCardState extends State<WidgetBookingCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             offset: Offset(0, 0),
//             spreadRadius: 2,
//             blurRadius: 3,
//             color: Color(0x26d9d9d9),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             // crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadiusGeometry.circular(15),
//                 child: Image.network(
//                   'https://picsum.photos/200/200',
//                   fit: BoxFit.cover,
//                   height: 90,
//                 ),
//               ),
//               //
//               SizedBox(width: 12),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,

//                 children: [
//                   SizedBox(
//                     width: 230,
//                     child: Text(
//                       'Big title',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                       ),
//                       maxLines: 1,
//                       softWrap: true,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   Row(
//                     children: [
//                       Text(
//                         'Dec 23 - 27, 2022',
//                         style: TextStyle(fontSize: 12, color: Colors.black87),
//                       ),
//                       Text(
//                         ' (5 days)',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.black87,
//                           // fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                   //
//                   SizedBox(height: 10),
//                   Row(
//                     // crossAxisAlignment: CrossAxisAlignment.end,
//                     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             '100 000',
//                             style: TextStyle(
//                               fontSize: 25,
//                               fontWeight: FontWeight.w800,
//                               fontFamily: 'BebasNeue',
//                               color: Color(0xFF256AFD),
//                             ),
//                           ),
//                           Text(
//                             ' xaf',
//                             style: TextStyle(
//                               fontFamily: 'BebasNeue',
//                               color: Color(0xFF256AFD),
//                             ),
//                           ),
//                           Text(' / 5 days', style: TextStyle(fontSize: 9)),
//                         ],
//                       ),
//                       // Fonction d'affichage de status
//                       SizedBox(width: 20),
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 5,
//                           vertical: 2,
//                         ),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(7),
//                           border: Border.all(
//                             width: 1,
//                             color: Color(0xFF256AFD).shade700,
//                           ),
//                         ),
//                         child: Text(
//                           'En attente',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xFF256AFD).shade700,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           //
//           SizedBox(height: 6),
//           Divider(color: Colors.black12),
//           SizedBox(height: 5),
//           Row(
//             children: [
//               Expanded(
//                 child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 8),
//                   decoration: BoxDecoration(
//                     color: Color(0xFF256AFD),
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                   child: Text(
//                     'Details',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w700,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//               //
//               SizedBox(width: 20),
//               Expanded(
//                 child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 6.5),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(width: 2.5, color: Color(0xFF256AFD)),
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                   child: Text(
//                     'Confirmez',
//                     style: TextStyle(
//                       color: Color(0xFF256AFD),
//                       fontWeight: FontWeight.w700,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
