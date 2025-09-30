import 'package:flutter/material.dart';

class WidgetBookingSucces extends StatefulWidget {
  const WidgetBookingSucces({super.key});

  @override
  State<WidgetBookingSucces> createState() => _WidgetBookingSuccesState();
}

class _WidgetBookingSuccesState extends State<WidgetBookingSucces> {
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
            color: Color(0x1a256AFD),
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
                      color: const Color(0xFF256AFD),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                    ),
                  ),
                  //
                  const SizedBox(width: 15),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reservation Réussite',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          // Apres remet en blanc
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'Date jj Mois Année',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('   |   '),
                          Text(
                            '20:50 PM',
                            style: TextStyle(fontWeight: FontWeight.w600),
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
                  color: const Color(0xFF256AFD),
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
