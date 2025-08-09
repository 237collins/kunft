import 'package:flutter/material.dart';
import 'package:kunft/pages/book/payment_page.dart';
import 'package:kunft/pages/home_screen.dart';
import 'package:kunft/widget/widget_book/review_infos_date.dart';
import 'package:kunft/widget/widget_book/review_infos_date2.dart';
import 'package:kunft/widget/widget_book/widget_house_infos3_bis.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ReviewPageInfos extends StatefulWidget {
  const ReviewPageInfos({super.key});

  @override
  State<ReviewPageInfos> createState() => _ReviewPageInfosState();
}

class _ReviewPageInfosState extends State<ReviewPageInfos> {
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
                    Navigator.pop(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Icon(LucideIcons.arrowLeft),
                  ),
                ),
                SizedBox(width: 20),
                Text('Review Page Infos'),
              ],
            ),
            //
            SizedBox(height: 20),
            Column(
              children: [
                WidgetHouseInfos3Bis(
                  imgHouse: '',
                  houseName: 'Maison Test',
                  price: '35 000',
                  locate:
                      'Douala, Voici ma vue permettant de créer les logements, je voudrais que tu l\'ajuste en tenant des nouveaux champs que j\'ai ajoutés, le champs suivants : adresse devient ville (ville en liste déroulante, Yaoundé, ',
                  ownerName: 'Icon',
                  time: '11h',
                ),
                //
                SizedBox(height: 20),
                //
                ReviewInfosDate(),
                //
                SizedBox(height: 30),
                //
                ReviewInfosDate2(),
                // Mode de paiement
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      child: Image.asset(
                        'assets/logo-payment/om.png',
                        fit: BoxFit.cover,
                        height: 40,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Change',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            // Bouton de Confimation
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                'Confirmé',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            //
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
