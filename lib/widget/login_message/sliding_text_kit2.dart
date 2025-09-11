import 'dart:async';
import 'package:flutter/material.dart';

class SlidingText extends StatefulWidget {
  const SlidingText({super.key});

  @override
  _SlidingTextState createState() => _SlidingTextState();
}

class _SlidingTextState extends State<SlidingText> {
  final List<String> messages = [
    "Le meublé idéal est à portée de connexion.",
    "Trouvez le meublé parfait en un instant.",
    "Votre confort commence ici.",
    "Réservez facilement, vivez pleinement.",
  ];

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % messages.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.3),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Text(
        messages[_currentIndex],
        key: ValueKey<int>(
          _currentIndex,
        ), // important pour que l’animation marche
        style: const TextStyle(fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }
}
