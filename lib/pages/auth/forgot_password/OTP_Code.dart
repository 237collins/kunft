import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kunft/pages/auth/forgot_password/create_new_password.dart';
import 'package:kunft/widget/login_message/reset_password/count_down_timer.dart';
import 'package:kunft/widget/simple_navigation/top_navigation.dart';

class OtpCode extends StatefulWidget {
  const OtpCode({super.key});

  @override
  State<OtpCode> createState() => _OtpCodeState();
}

// Fonction du Compte a rebour
void _handleTimerEnd() {
  // Action à effectuer lorsque le compte à rebours est terminé
  print("Le compte à rebours est terminé ! On peut re-envoyer un code.");
}

class _OtpCodeState extends State<OtpCode> {
  // Stocke les chiffres saisis
  List<String> _pin = ["", "", "", ""];

  // Indique si un chiffre est temporairement visible
  List<bool> _isVisible = [false, false, false, false];

  int _currentIndex = 0;

  void _addDigit(String digit) {
    if (_currentIndex < 4) {
      setState(() {
        _pin[_currentIndex] = digit;
        _isVisible[_currentIndex] = true; // Affiche temporairement
      });

      // Après 1 seconde, masque le chiffre
      Timer(const Duration(seconds: 1), () {
        setState(() {
          _isVisible[_currentIndex - 1] = false;
        });
      });

      _currentIndex++;
    }
  }

  void _deleteDigit() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _pin[_currentIndex] = "";
        _isVisible[_currentIndex] = false;
      });
    }
  }

  void _onContinue() {
    String code = _pin.join();
    print("Code entré : $code");
    // 👉 Ici tu fais ton appel backend pour valider le code
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Vérification le code OTP'),
      ),
      // backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // TopNavigation(pageName: 'Vérification le code OTP'),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.pop(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => const OtpCode(),
                  //       ),
                  //     );
                  //   },
                  //   child: Text(
                  //     'Ignorer',
                  //     style: TextStyle(
                  //       // fontSize: 16,
                  //       fontWeight: FontWeight.w700,
                  //       color: Colors.blue.shade700,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              // const SizedBox(height: 60),
              const Column(
                children: [
                  Text(
                    'Veuillez saisir le code envoyé au ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  //
                  Text(
                    '+237 697 ***** 66',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              const SizedBox(height: 70),
              // --- Cases PIN ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 60,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _currentIndex == index
                            ? Colors.blue
                            : Colors.grey.shade300,
                        width: 1,
                      ),
                      color: _currentIndex == index
                          ? const Color(0x1a2196F3)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      _pin[index].isEmpty
                          ? ""
                          : (_isVisible[index] ? _pin[index] : "●"),
                      style: const TextStyle(fontSize: 22),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 70),
              // --- Temos d'attente ---
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Réinitialisation du code dans ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  // Appel du timer
                  CountdownTimer(
                    duration: 60, // Démarre le compte à rebours à 60 secondes
                    onTimerEnd:
                        _handleTimerEnd, // Appelle cette fonction à la fin
                  ),
                ],
              ),
              //
              const SizedBox(height: 30),
              //
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateNewPassword(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'Vérifié',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 70),

              // --- Clavier numérique ---
              _buildKeypad(),
            ],
          ),
        ),
      ),
    );
  }
  // ------ Ajouter une option de qui fait descendre le clavier
  // après la saisie du code

  // Clavier numérique
  Widget _buildKeypad() {
    List<String> keys = [
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "*",
      "0",
      "<",
    ];

    return SizedBox(
      // height: 400, // 📌 Ajuste ici pour réduire la taille du clavier
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(), // empêche le scroll
        shrinkWrap: true,
        itemCount: keys.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 25,
          crossAxisSpacing: 0,
          childAspectRatio: 3.5,
        ),
        itemBuilder: (context, index) {
          String key = keys[index];
          return GestureDetector(
            onTap: () {
              if (key == "<") {
                _deleteDigit();
              } else if (key != "*") {
                _addDigit(key);
              }
            },
            child: Container(
              alignment: Alignment.center,
              // decoration: BoxDecoration(
              //   color: Colors.grey.shade200,
              //   shape: BoxShape.circle,
              // ),
              child: key == "<"
                  ? const Icon(Icons.backspace_outlined)
                  : Text(
                      key,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
