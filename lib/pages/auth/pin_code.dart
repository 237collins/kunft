import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kunft/widget/simple_navigation/top_navigation.dart';
import 'login_page.dart'; // Assure-toi d'importer ta LoginPage

// Définissez votre URL de base d'API ici
const String API_BASE_URL = 'http://127.0.0.1:8000';

class PinCodePage extends StatefulWidget {
  // ✅ L'e-mail de l'utilisateur est requis pour la vérification API
  final String email;
  const PinCodePage({super.key, required this.email});

  @override
  State<PinCodePage> createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage> {
  List<String> _pin = ["", "", "", ""];
  List<bool> _isVisible = [false, false, false, false];
  int _currentIndex = 0;
  bool _isLoading = false;

  void _addDigit(String digit) {
    if (_currentIndex < 4) {
      setState(() {
        _pin[_currentIndex] = digit;
        _isVisible[_currentIndex] = true;
      });

      Timer(const Duration(milliseconds: 500), () {
        if (mounted && _currentIndex > 0) {
          setState(() {
            _isVisible[_currentIndex - 1] = false;
          });
        }
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

  // --- Validation du code via API ---
  void _onContinue() async {
    String code = _pin.join();

    if (code.length < 4) {
      _showMessage("Veuillez saisir les 4 chiffres du code.", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        // Remplace par ton URL d'API
        Uri.parse('$API_BASE_URL/api/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email, // ✅ Envoi de l'e-mail avec le code
          'verification_code': int.parse(code),
        }),
      );

      setState(() => _isLoading = false);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // ✅ Code correct et vérifié
        _showMessage(responseData['message'], isError: false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else if (response.statusCode == 400) {
        // ❌ Code invalide ou expiré (selon votre backend)
        _showMessage(responseData['message'], isError: true);
        _resetPin();
      } else {
        // 🚨 Autres erreurs serveur
        _showMessage(
          responseData['message'] ?? "Erreur serveur. Veuillez réessayer.",
          isError: true,
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showMessage("Impossible de se connecter au serveur.", isError: true);
      debugPrint("Erreur API : $e");
    }
  }

  void _resetPin() {
    setState(() {
      _pin = ["", "", "", ""];
      _isVisible = [false, false, false, false];
      _currentIndex = 0;
    });
  }

  void _showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TopNavigation(pageName: 'Vérification de compte'),
              const SizedBox(height: 60),
              const Text(
                'Veuillez saisir le code d\'activation',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
                            ? Color(0xFF256AFD)
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

              // --- Bouton Continue ---
              ElevatedButton(
                onPressed: _isLoading ? null : _onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF256AFD),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Continue",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),

              const SizedBox(height: 20),

              // --- Clavier numérique ---
              _buildKeypad(),
            ],
          ),
        ),
      ),
    );
  }

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
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: keys.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 25,
          crossAxisSpacing: 0,
          childAspectRatio: 2,
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

// ---------- Ancien Code Statique

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:kunft/widget/simple_navigation/top_navigation.dart';

// class PinCodePage extends StatefulWidget {
//   const PinCodePage({super.key});

//   @override
//   State<PinCodePage> createState() => _PinCodePageState();
// }

// class _PinCodePageState extends State<PinCodePage> {
//   // Stocke les chiffres saisis
//   List<String> _pin = ["", "", "", ""];

//   // Indique si un chiffre est temporairement visible
//   List<bool> _isVisible = [false, false, false, false];

//   int _currentIndex = 0;

//   void _addDigit(String digit) {
//     if (_currentIndex < 4) {
//       setState(() {
//         _pin[_currentIndex] = digit;
//         _isVisible[_currentIndex] = true; // Affiche temporairement
//       });

//       // Après 1 seconde, masque le chiffre
//       Timer(const Duration(seconds: 1), () {
//         setState(() {
//           _isVisible[_currentIndex - 1] = false;
//         });
//       });

//       _currentIndex++;
//     }
//   }

//   void _deleteDigit() {
//     if (_currentIndex > 0) {
//       setState(() {
//         _currentIndex--;
//         _pin[_currentIndex] = "";
//         _isVisible[_currentIndex] = false;
//       });
//     }
//   }

//   void _onContinue() {
//     String code = _pin.join();
//     print("Code entré : $code");
//     // 👉 Ici tu fais ton appel backend pour valider le code
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const TopNavigation(pageName: 'Vérification de compte'),
//                   InkWell(
//                     onTap: () {
//                       Navigator.pop(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const PinCodePage(),
//                         ),
//                       );
//                     },
//                     child: Text(
//                       'Ignorer',
//                       style: TextStyle(
//                         // fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                         color: Color(0xFF256AFD).shade700,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 60),
//               const Text(
//                 'Veuillez saisir le code d\'activation ',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//               ),
//               const SizedBox(height: 70),
//               // --- Cases PIN ---
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(4, (index) {
//                   return Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 8),
//                     width: 60,
//                     height: 50,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: _currentIndex == index
//                             ? Color(0xFF256AFD)
//                             : Colors.grey.shade300,
//                         width: 1,
//                       ),
//                       color: _currentIndex == index
//                           ? const Color(0x1a2196F3)
//                           : Colors.white,
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Text(
//                       _pin[index].isEmpty
//                           ? ""
//                           : (_isVisible[index] ? _pin[index] : "●"),
//                       style: const TextStyle(fontSize: 22),
//                     ),
//                   );
//                 }),
//               ),
//               const SizedBox(height: 70),

//               // --- Bouton Continue ---
//               ElevatedButton(
//                 onPressed: _onContinue,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF256AFD),
//                   minimumSize: const Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 child: const Text(
//                   "Continue",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//               // const SizedBox(height: 30),

//               // --- Clavier numérique ---
//               _buildKeypad(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Clavier numérique
//   Widget _buildKeypad() {
//     List<String> keys = [
//       "1",
//       "2",
//       "3",
//       "4",
//       "5",
//       "6",
//       "7",
//       "8",
//       "9",
//       "*",
//       "0",
//       "<",
//     ];

//     return SizedBox(
//       // height: 400, // 📌 Ajuste ici pour réduire la taille du clavier
//       child: GridView.builder(
//         physics: const NeverScrollableScrollPhysics(), // empêche le scroll
//         shrinkWrap: true,
//         itemCount: keys.length,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           mainAxisSpacing: 25,
//           crossAxisSpacing: 0,
//           childAspectRatio: 2,
//         ),
//         itemBuilder: (context, index) {
//           String key = keys[index];
//           return GestureDetector(
//             onTap: () {
//               if (key == "<") {
//                 _deleteDigit();
//               } else if (key != "*") {
//                 _addDigit(key);
//               }
//             },
//             child: Container(
//               alignment: Alignment.center,
//               // decoration: BoxDecoration(
//               //   color: Colors.grey.shade200,
//               //   shape: BoxShape.circle,
//               // ),
//               child: key == "<"
//                   ? const Icon(Icons.backspace_outlined)
//                   : Text(
//                       key,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
