// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class TopNavigation extends StatefulWidget {
  final String pageName;

  const TopNavigation({Key? superkey, required this.pageName})
    : super(key: superkey);

  @override
  State<TopNavigation> createState() => _TopNavigationState();
}

class _TopNavigationState extends State<TopNavigation> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_outlined),
        ),
        const SizedBox(width: 10),
        Text(
          // 'data',
          widget.pageName,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
