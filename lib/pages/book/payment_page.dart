import 'package:flutter/material.dart';
import 'package:kunft/pages/book/date_page.dart';
import 'package:kunft/pages/book/review_page.dart';
import 'package:kunft/widget/Dialog/widget_okay_dialog.dart';
import 'package:kunft/widget/widget_book/widget_payment_mode.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueAccent,
      body: Padding(
        padding: const EdgeInsets.only(top: 70, left: 15, right: 15),
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DatePage()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Icon(LucideIcons.arrowLeft),
                  ),
                ),
                SizedBox(width: 20),
                Text('Mode de paiement'),
              ],
            ),
            //
            SizedBox(height: 35),
            Column(
              children: [
                Text(
                  'Choissisez un mode de paiement',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 50),
                //
                WidgetPaymentMode(
                  imgPayment: 'assets/logo-payment/om.png',
                  text: 'Orange money',
                ),
                //
                SizedBox(height: 40),
                //
                WidgetPaymentMode(
                  imgPayment: 'assets/logo-payment/mtn.png',
                  text: 'MTN Money',
                ),
                //
                SizedBox(height: 40),
                //
                WidgetPaymentMode(
                  imgPayment: 'assets/logo-payment/paypal.png',
                  text: 'PayPal',
                ),
              ],
            ),
            Spacer(),
            // Bouton de Confimation
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReviewPageInfos(),
                  ),
                );
              },
              child: Container(
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
            ),
            //
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const WidgetOkayDialog(),
                );
              },
              child: const Text("Simuler Échec de Paiement"),
            ),

            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
