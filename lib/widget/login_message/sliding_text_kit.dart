import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SlidingTextKit extends StatelessWidget {
  const SlidingTextKit({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 30, // ajuste selon ton design
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 12, color: Colors.black),
        child: AnimatedTextKit(
          repeatForever: true, // boucle infinie
          pause: const Duration(seconds: 4), // ⏳ change toutes les 4s
          animatedTexts: [
            RotateAnimatedText("Le meublé idéal est à portée de connexion."),
            RotateAnimatedText("Trouvez le meublé parfait en un instant."),
            RotateAnimatedText("Votre confort commence ici."),
            RotateAnimatedText("Réservez facilement, vivez pleinement."),
          ],
        ),
      ),
    );
  }
}

// type d'animatiom
// FadeAnimatedText("...")

// TyperAnimatedText("...") (style machine à écrire 🖊️)

// ScaleAnimatedText("...")
