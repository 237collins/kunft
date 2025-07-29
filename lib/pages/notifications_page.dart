import 'package:flutter/material.dart';
import 'package:kunft/pages/home_screen.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 70, left: 15, right: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Fleche de retour
                      InkWell(
                        onTap: () {
                          setState(() {});
                          Navigator.pop(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),

                      SizedBox(width: 8),
                      Text(
                        // Titre de la nav
                        'Notification',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          // Apres remet en blanc
                          color: Colors.black,
                        ),
                      ),
                      //
                    ],
                  ),
                  //
                  Icon(Icons.more_outlined),
                ],
              ),
              //
              SizedBox(height: 130),
              Column(
                children: [
                  ClipRRect(
                    child: Image.asset(
                      'assets/images/BG_notification.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    'Vide',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      // Apres remet en blanc
                      color: Colors.black,
                    ),
                  ),
                  //
                  Text(
                    'Vous n\'avez aucune notification pouv le moment',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      // Apres remet en blanc
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              //
              // Widget Contenu à afficher
              // Appel widget
              SizedBox(height: 20),

              // Column(
              //   children: [
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Row(
              //           children: [
              //             Container(
              //               padding: EdgeInsets.all(12),
              //               decoration: BoxDecoration(
              //                 color: Colors.blue,
              //                 borderRadius: BorderRadius.circular(50),
              //               ),
              //               child: Icon(
              //                 Icons.calendar_month,
              //                 color: Colors.white,
              //               ),
              //             ),
              //             //
              //             SizedBox(width: 15),
              //             Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Text(
              //                   'Reservation Réussite',
              //                   style: TextStyle(
              //                     fontSize: 16,
              //                     fontWeight: FontWeight.bold,
              //                     // Apres remet en blanc
              //                     color: Colors.black,
              //                   ),
              //                 ),
              //                 SizedBox(height: 4),
              //                 Row(
              //                   children: [
              //                     Text('Date jj Mois Année'),
              //                     Text('   |   '),
              //                     Text('20:50 PM'),
              //                   ],
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //         //
              //         Container(
              //           padding: EdgeInsets.symmetric(
              //             horizontal: 4,
              //             vertical: 5,
              //           ),
              //           decoration: BoxDecoration(
              //             color: Colors.blue,
              //             borderRadius: BorderRadius.circular(5),
              //           ),
              //           child: Text(
              //             'Nouveau',
              //             style: TextStyle(
              //               fontSize: 10,
              //               color: Colors.white,
              //               fontWeight: FontWeight.w700,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //     //
              //     SizedBox(height: 15),
              //     Text(
              //       'Félicitation! Vous effectuez la réservation du logement pour Nbres de jours à Prix. Profitez du service',
              //       style: TextStyle(
              //         fontSize: 12,
              //         // color: Colors.white,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
