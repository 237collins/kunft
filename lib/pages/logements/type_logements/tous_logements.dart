import 'package:flutter/material.dart';

class TousLogements extends StatefulWidget {
  const TousLogements({super.key});

  @override
  State<TousLogements> createState() => _TousLogementsState();
}

class _TousLogementsState extends State<TousLogements> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [Text('Tous les logements test')]);
  }
}
