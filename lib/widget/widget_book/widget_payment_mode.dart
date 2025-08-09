// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class WidgetPaymentMode extends StatefulWidget {
  final String imgPayment;
  final String text;

  const WidgetPaymentMode({
    Key? superkey,
    required this.imgPayment,
    required this.text,
  }) : super(key: superkey);

  @override
  State<WidgetPaymentMode> createState() => _WidgetPaymentModeState();
}

class _WidgetPaymentModeState extends State<WidgetPaymentMode> {
  bool _isToggled = false;

  void _toggleIcon() {
    setState(() {
      _isToggled = !_isToggled; // Inverse l'état à chaque clic
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              // width: 90,
              // height: 40,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  // img
                  widget.imgPayment,
                  fit: BoxFit.scaleDown,
                  height: 23,
                  width: 23,
                ),
              ),
            ),
            //
            SizedBox(width: 20),
            //
            Text(
              // Titre
              widget.text,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        GestureDetector(
          onTap: _toggleIcon,
          child: Icon(
            _isToggled ? LucideIcons.checkCircle : LucideIcons.circle,
            color: _isToggled ? Colors.green : Colors.black,
          ),
        ),
      ],
    );
  }
}
