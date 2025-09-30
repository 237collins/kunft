import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kunft/pages/auth/forgot_password/OTP_Code.dart';
import 'package:lucide_icons/lucide_icons.dart';

// Définissez une énumération pour vos options de réinitialisation
enum ResetOption { sms, mail }

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  // Une seule variable pour gérer l'option sélectionnée
  ResetOption? _selectedOption;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Mot de passe oublié'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            children: [
              // const TopNavigation(pageName: 'Forgot Password'),
              Transform.translate(
                offset: const Offset(0, -20),
                child: ClipRRect(
                  child: SvgPicture.asset(
                    'assets/svg/Forgot_password.svg',
                    fit: BoxFit.cover,
                    height: screenHeight * .39, // Définir une hauteur
                  ),
                ),
              ),
              //
              Transform.translate(
                offset: const Offset(0, -50),
                child: Column(
                  children: [
                    SizedBox(
                      width: screenWidth * 0.9,
                      child: const Text(
                        'Veuillez sélectionner le mode de réinitialisation du mot de passe',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                        softWrap: true,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    //
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        // Bloc de sélection pour l'option SMS
                        _buildOption(
                          option: ResetOption.sms,
                          icon: LucideIcons.messagesSquare,
                          title: 'via sms',
                          subtitle: '+237 697 **** 66',
                        ),
                        const SizedBox(height: 30),
                        // Bloc de sélection pour l'option e-mail
                        _buildOption(
                          option: ResetOption.mail,
                          icon: LucideIcons.mail,
                          title: 'via mail',
                          subtitle: 'user***@gmail.com',
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 5, 16, 40),
        child: GestureDetector(
          onTap: () {
            if (_selectedOption != null) {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const OtpCode()),
              // ); // Annulation temporaire
            } else {
              // Affichez un message d'erreur ou une notification si rien n'est sélectionné\
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Veuillez sélectionner une option !'),
                  duration: Duration(
                    seconds: 3,
                  ), // Durée d'affichage de la SnackBar
                  behavior: SnackBarBehavior.floating,
                ),
              );
              print('Veuillez sélectionner une option !');
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: Color(0xFF256AFD),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              'Continue',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  // Créez une méthode pour construire chaque option de réinitialisation
  Widget _buildOption({
    required ResetOption option,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    // Vérifie si l'option actuelle est celle sélectionnée
    final isSelected = _selectedOption == option;

    return InkWell(
      onTap: () {
        setState(() {
          // Si l'option actuelle est déjà sélectionnée, la désélectionner, sinon la sélectionner
          _selectedOption = isSelected ? null : option;
        });
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            width: isSelected ? 2 : 0.5,
            color: isSelected ? Color(0xFF256AFD) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0x1a2196F3),
              child: Icon(icon, color: Color(0xFF256AFD)),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 8, color: Colors.grey),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// Ancien code Statique


// import 'package:flutter/material.dart';
// import 'package:kunft/pages/auth/forgot_password/OTP_Code.dart';
// import 'package:kunft/widget/simple_navigation/top_navigation.dart';
// import 'package:lucide_icons/lucide_icons.dart';

// class ForgotPassword extends StatefulWidget {
//   const ForgotPassword({super.key});

//   @override
//   State<ForgotPassword> createState() => _ForgotPasswordState();
// }

// class _ForgotPasswordState extends State<ForgotPassword> {
//   bool _isSelected = false; // Variable pour suivre l'état de sélection
//   bool _isSelected2 = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(top: 70, left: 16, right: 16),
//         child: Center(
//           child: Column(
//             children: [
//               const TopNavigation(pageName: 'Forgot Password'),
//               ClipRRect(
//                 child: Image.asset(
//                   'assets/password/FP-psw.png',
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               const Text(
//                 'Veuillez sélectionner le mode de reinitialisation du mot de passe',
//                 style: TextStyle(fontSize: 16, color: Colors.black87),
//                 textAlign: TextAlign.center,
//               ),
//               //
//               const SizedBox(height: 25),
//               //
//               Column(
//                 children: [
//                   // Assurez-vous que ce code est dans la méthode `build` d'une classe State
//                   InkWell(
//                     onTap: () {
//                       setState(() {
//                         // Inverse l'état de sélection
//                         _isSelected = !_isSelected;
//                       });
//                       // Ajoutez ici toute autre action à effectuer au clic
//                       print('L\'état de sélection est : $_isSelected');
//                     },
//                     borderRadius: BorderRadius.circular(30),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 40,
//                       ),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(30),
//                         // La bordure est maintenant plus fine et de couleur grise par défaut
//                         // et devient épaisse et bleue au clic
//                         border: Border.all(
//                           width: _isSelected
//                               ? 2
//                               : 0.5, // La largeur change pour un effet de focus
//                           color: _isSelected
//                               ? Color(0xFF256AFD)
//                               : Colors.grey.shade300, // La couleur change
//                         ),
//                       ),
//                       child: const Row(
//                         children: [
//                           CircleAvatar(
//                             backgroundColor: Color(0x1a2196F3),
//                             child: Icon(
//                               LucideIcons.messagesSquare,
//                               color: Color(0xFF256AFD),
//                             ),
//                           ),
//                           SizedBox(width: 20),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'via sms',
//                                 style: TextStyle(
//                                   fontSize: 8,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               SizedBox(height: 5),
//                               Text(
//                                 '+237 697 **** 66',
//                                 style: TextStyle(fontWeight: FontWeight.w700),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   //
//                   const SizedBox(height: 30),
//                   //
//                   InkWell(
//                     onTap: () {
//                       setState(() {
//                         // Inverse l'état de sélection
//                         _isSelected2 = !_isSelected2;
//                       });
//                       // Ajoutez ici toute autre action à effectuer au clic
//                       print('L\'état de sélection est : $_isSelected2');
//                     },
//                     borderRadius: BorderRadius.circular(30),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 40,
//                       ),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(30),
//                         // La bordure est maintenant plus fine et de couleur grise par défaut
//                         // et devient épaisse et bleue au clic
//                         border: Border.all(
//                           width: _isSelected2
//                               ? 2
//                               : 0.5, // La largeur change pour un effet de focus
//                           color: _isSelected2
//                               ? Color(0xFF256AFD)
//                               : Colors.grey.shade300, // La couleur change
//                         ),
//                       ),
//                       child: const Row(
//                         children: [
//                           CircleAvatar(
//                             backgroundColor: Color(0x1a2196F3),
//                             child: Icon(
//                               LucideIcons.messagesSquare,
//                               color: Color(0xFF256AFD),
//                             ),
//                           ),
//                           SizedBox(width: 20),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'via mail',
//                                 style: TextStyle(
//                                   fontSize: 8,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               SizedBox(height: 5),
//                               Text(
//                                 'user***@gmail.com',
//                                 style: TextStyle(fontWeight: FontWeight.w700),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   //
//                   const SizedBox(height: 50),
//                   //
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const OtpCode(),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 16,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Color(0xFF256AFD),
//                         borderRadius: BorderRadius.circular(30),
//                         // boxShadow: const [
//                         //   BoxShadow(
//                         //     offset: Offset(0, 0),
//                         //     blurRadius: 6,
//                         //     spreadRadius: 5,
//                         //     color: Color(0xFF256AFD),
//                         //   ),
//                         // ],
//                       ),
//                       child: const Text(
//                         'Continue',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
