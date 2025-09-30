import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final int duration;
  final VoidCallback onTimerEnd;

  const CountdownTimer({
    super.key,
    required this.duration,
    required this.onTimerEnd,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late int _start;

  @override
  void initState() {
    super.initState();
    _start = widget.duration; // Utilise la durée passée en paramètre
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
          widget.onTimerEnd(); // Appelle la fonction de rappel
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$_start ', // Ajout de l'unité 's' pour la clarté
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF256AFD),
          ),
        ),
        //
        const Text(
          's', // Ajout de l'unité 's' pour la clarté
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            // color: Color(0xFF256AFD),
          ),
        ),
      ],
    );
  }
}
