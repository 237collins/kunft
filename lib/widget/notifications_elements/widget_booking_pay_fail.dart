import 'package:flutter/material.dart';

class WidgetBookingPaymentFail extends StatefulWidget {
  const WidgetBookingPaymentFail({super.key});

  @override
  State<WidgetBookingPaymentFail> createState() =>
      _WidgetBookingPaymentFailState();
}

class _WidgetBookingPaymentFailState extends State<WidgetBookingPaymentFail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 3),
            spreadRadius: 5,
            blurRadius: 6,
            color: Color(0x1aFF3208),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF3208),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.monetization_on_sharp,
                      color: Colors.white,
                    ),
                  ),
                  //
                  const SizedBox(width: 15),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Paiement Echoué ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          // Apres remet en blanc
                          // color: Colors.black,
                          color: Color(0xFFFF3208),
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'Date jj Mois Année',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFF3208),
                            ),
                          ),
                          Text(
                            '   |   ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFF3208),
                            ),
                          ),
                          Text(
                            '20:50 PM',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFF3208),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              //
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF3208),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  'Nouveau',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          //
          const SizedBox(height: 15),
          const Text(
            'Félicitation! Vous effectuez la réservation du logement pour Nbres de jours à Prix. Profitez du service',
            style: TextStyle(
              fontSize: 12,
              // color: Colors.white,
              // fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
