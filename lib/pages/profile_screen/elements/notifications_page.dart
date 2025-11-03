import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kunft/pages/home_screen1/home_screen.dart';
import 'package:kunft/widget/notifications_elements/widget_booking_pay_fail.dart';
import 'package:kunft/widget/notifications_elements/widget_booking_pay_succes.dart';
import 'package:kunft/widget/notifications_elements/widget_booking_succes.dart';
import 'package:kunft/widget/notifications_elements/widget_notification_list_empty.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Notifications'),
      ),
      backgroundColor: Colors.white,
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(height: 20),

              // Bloc non utile pour le moment
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Row(
              //       children: [
              //         // Fleche de retour
              //         InkWell(
              //           onTap: () {
              //             setState(() {});
              //             Navigator.pop(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) => const HomeScreen(),
              //               ),
              //             );
              //           },
              //           child: const Icon(
              //             Icons.arrow_back,
              //             size: 30,
              //             color: Colors.black,
              //           ),
              //         ),

              //         const SizedBox(width: 8),
              //         const Text(
              //           // Titre de la nav
              //           'Notification',
              //           style: TextStyle(
              //             fontSize: 18,
              //             fontWeight: FontWeight.w700,
              //             // Apres remet en blanc
              //             color: Colors.black,
              //           ),
              //         ),
              //         //
              //       ],
              //     ),
              //     //
              //     const Icon(Icons.more_outlined),
              //   ],
              // ),
              //
              // const SizedBox(height: 130),
              // --------------------
              //  Bloc quand la liste est veide
              // ---------------------
              // WidgetNotificationListEmpty(),
              //
              // Widget Contenu à afficher sur condition
              // Appel widget
              WidgetBookingSucces(),
              SizedBox(height: 20),
              WidgetBookingPaymentFail(),
              SizedBox(height: 20),
              WidgetBookingPaymentSucces(),
            ],
          ),
        ),
      ),
    );
  }
}
