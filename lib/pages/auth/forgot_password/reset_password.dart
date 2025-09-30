import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kunft/pages/auth/forgot_password/OTP_Code.dart';
import 'package:kunft/provider/UserProvider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _inputController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {Color color = Colors.green}) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.fixed, // ✅ Solution 1: Utilisez fixed
      ),
    );
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer une adresse valide.';
    }
    String emailRegex = r'^[^@]+@[^@]+\.[^@]+';
    String phoneRegex = r'^\+?[\d\s-]{10,15}$';

    if (!RegExp(emailRegex).hasMatch(value) &&
        !RegExp(phoneRegex).hasMatch(value)) {
      return 'Veuillez entrer un e-mail ou un numéro de téléphone valide.';
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Affichez l'indicateur de chargement
      });

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final emailOrPhone = _inputController.text;

      final success = await userProvider.sendResetPasswordLink(emailOrPhone);

      setState(() {
        _isLoading = false; // Cachez l'indicateur de chargement
      });

      if (!mounted) {
        return;
      }

      if (success) {
        _showSnackBar('Un code a été envoyé à votre adresse.');
        // Navigue vers la page OTP si l'envoi a réussi
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OtpCode(email: emailOrPhone)),
        );
      } else {
        // Afficher une SnackBar en cas d'échec
        _showSnackBar(
          userProvider.errorMessage ?? 'Une erreur est survenue.',
          color: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Réinitialiser le mot de passe'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              SvgPicture.asset(
                'assets/svg/mail_sent1.svg',
                fit: BoxFit.cover,
                height: screenHeight * .4,
              ),
              const Text(
                'Veuillez entrer votre numéro de téléphone ou e-mail pour recevoir le code de réinitialisation.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 35),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _inputController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail ou numéro de téléphone',
                    hintText: 'Entrez votre information de contact',
                    floatingLabelStyle: TextStyle(color: Color(0xFF256AFD)),
                    prefixIcon: Icon(LucideIcons.mailSearch),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(
                        color: Color(0xFF256AFD),
                        width: 2.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.red, width: 1.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.red, width: 2.0),
                    ),
                  ),
                  validator: _validateInput,
                ),
              ),
              // const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(
          16,
          5,
          16,
          30,
        ), // ✅ Solution 2: Réduction du padding à 15
        child: GestureDetector(
          onTap: _isLoading
              ? null
              : _submitForm, // Désactive le bouton si l'API est en cours d'appel
          child: Container(
            height: 60,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF256AFD),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Continuer',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}




// ---------- okay mais plante --------

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:kunft/pages/auth/forgot_password/OTP_Code.dart';
// import 'package:kunft/provider/UserProvider.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:provider/provider.dart';

// class ResetPassword extends StatefulWidget {
//   const ResetPassword({super.key});

//   @override
//   State<ResetPassword> createState() => _ResetPasswordState();
// }

// class _ResetPasswordState extends State<ResetPassword> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _inputController = TextEditingController();
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _inputController.dispose();
//     super.dispose();
//   }

//   String? _validateInput(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Veuillez entrer une adresse valide.';
//     }
//     String emailRegex = r'^[^@]+@[^@]+\.[^@]+';
//     String phoneRegex = r'^\+?[\d\s-]{10,15}$';

//     if (!RegExp(emailRegex).hasMatch(value) &&
//         !RegExp(phoneRegex).hasMatch(value)) {
//       return 'Veuillez entrer un e-mail ou un numéro de téléphone valide.';
//     }
//     return null;
//   }

//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true; // Affichez l'indicateur de chargement
//       });

//       final userProvider = Provider.of<UserProvider>(context, listen: false);
//       final emailOrPhone = _inputController.text;

//       final success = await userProvider.sendResetPasswordLink(emailOrPhone);

//       setState(() {
//         _isLoading = false; // Cachez l'indicateur de chargement
//       });

//       // ✅ Utilisez le `mounted` pour vérifier si le widget est toujours dans l'arbre.
//       // C'est la bonne pratique pour éviter les erreurs de contexte.
//       if (!mounted) {
//         return;
//       }

//       if (success) {
//         // Navigue vers la page OTP si l'envoi a réussi
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => OtpCode(email: emailOrPhone)),
//         );
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Un code a été envoyé à votre adresse.'),
//             backgroundColor: Colors.green,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       } else {
//         // Afficher une SnackBar en cas d'échec
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               userProvider.errorMessage ?? 'Une erreur est survenue.',
//             ),
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text('Réinitialiser le mot de passe'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               SvgPicture.asset(
//                 'assets/svg/mail_sent1.svg',
//                 fit: BoxFit.cover,
//                 height: screenHeight * .4,
//               ),
//               const Text(
//                 'Veuillez entrer votre numéro de téléphone ou e-mail pour recevoir le code de réinitialisation.',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 35),
//               Form(
//                 key: _formKey,
//                 child: TextFormField(
//                   controller: _inputController,
//                   decoration: const InputDecoration(
//                     labelText: 'E-mail ou numéro de téléphone',
//                     hintText: 'Entrez votre information de contact',
//                     floatingLabelStyle: TextStyle(color: Color(0xFF256AFD)),
//                     prefixIcon: Icon(LucideIcons.mailSearch),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                       borderSide: BorderSide(color: Colors.grey),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                       borderSide: BorderSide(color: Colors.grey, width: 1.0),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                       borderSide: BorderSide(
//                         color: Color(0xFF256AFD),
//                         width: 2.0,
//                       ),
//                     ),
//                     errorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                       borderSide: BorderSide(color: Colors.red, width: 1.0),
//                     ),
//                     focusedErrorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                       borderSide: BorderSide(color: Colors.red, width: 2.0),
//                     ),
//                   ),
//                   validator: _validateInput,
//                 ),
//               ),
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.fromLTRB(16, 5, 16, 15),
//         child: GestureDetector(
//           onTap: _isLoading
//               ? null
//               : _submitForm, // Désactive le bouton si l'API est en cours d'appel
//           child: Container(
//             height: 60,
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
//             decoration: BoxDecoration(
//               color: const Color(0xFF256AFD),
//               borderRadius: BorderRadius.circular(30),
//             ),
//             child: Center(
//               child: _isLoading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : const Text(
//                       'Continuer',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w800,
//                         fontSize: 16,
//                       ),
//                     ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



// ----- Okay mais avec souci de snack ------

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:kunft/pages/auth/forgot_password/OTP_Code.dart';
// import 'package:kunft/provider/UserProvider.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:provider/provider.dart';

// class ResetPassword extends StatefulWidget {
//   const ResetPassword({super.key});

//   @override
//   State<ResetPassword> createState() => _ResetPasswordState();
// }

// class _ResetPasswordState extends State<ResetPassword> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _inputController = TextEditingController();
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _inputController.dispose();
//     super.dispose();
//   }

//   String? _validateInput(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Veuillez entrer une adresse valide.';
//     }
//     String emailRegex = r'^[^@]+@[^@]+\.[^@]+';
//     String phoneRegex = r'^\+?[\d\s-]{10,15}$';

//     if (!RegExp(emailRegex).hasMatch(value) &&
//         !RegExp(phoneRegex).hasMatch(value)) {
//       return 'Veuillez entrer un e-mail ou un numéro de téléphone valide.';
//     }
//     return null;
//   }

//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true; // Affichez l'indicateur de chargement
//       });

//       final userProvider = Provider.of<UserProvider>(context, listen: false);
//       final emailOrPhone = _inputController.text;

//       final success = await userProvider.sendResetPasswordLink(emailOrPhone);

//       setState(() {
//         _isLoading = false; // Cachez l'indicateur de chargement
//       });

//       // ✅ Utilisez le `mounted` pour vérifier si le widget est toujours dans l'arbre.
//       // C'est la bonne pratique pour éviter les erreurs de contexte.
//       if (!mounted) {
//         return;
//       }

//       if (success) {
//         // Navigue vers la page OTP si l'envoi a réussi
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => OtpCode(email: emailOrPhone)),
//         );
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Un code a été envoyé à votre adresse.'),
//             backgroundColor: Colors.green,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       } else {
//         // Afficher une SnackBar en cas d'échec
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               userProvider.errorMessage ?? 'Une erreur est survenue.',
//             ),
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text('Réinitialiser le mot de passe'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               SvgPicture.asset(
//                 'assets/svg/mail_sent1.svg',
//                 fit: BoxFit.cover,
//                 height: screenHeight * .4,
//               ),
//               const Text(
//                 'Veuillez entrer votre numéro de téléphone ou e-mail pour recevoir le code de réinitialisation.',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 35),
//               Form(
//                 key: _formKey,
//                 child: TextFormField(
//                   controller: _inputController,
//                   decoration: const InputDecoration(
//                     labelText: 'E-mail ou numéro de téléphone',
//                     hintText: 'Entrez votre information de contact',
//                     floatingLabelStyle: TextStyle(color: Color(0xFF256AFD)),
//                     prefixIcon: Icon(LucideIcons.mailSearch),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                       borderSide: BorderSide(color: Colors.grey),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                       borderSide: BorderSide(color: Colors.grey, width: 1.0),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                       borderSide: BorderSide(
//                         color: Color(0xFF256AFD),
//                         width: 2.0,
//                       ),
//                     ),
//                     errorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                       borderSide: BorderSide(color: Colors.red, width: 1.0),
//                     ),
//                     focusedErrorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                       borderSide: BorderSide(color: Colors.red, width: 2.0),
//                     ),
//                   ),
//                   validator: _validateInput,
//                 ),
//               ),
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.fromLTRB(16, 5, 16, 40),
//         child: GestureDetector(
//           onTap: _isLoading
//               ? null
//               : _submitForm, // Désactive le bouton si l'API est en cours d'appel
//           child: Container(
//             height: 60,
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
//             decoration: BoxDecoration(
//               color: const Color(0xFF256AFD),
//               borderRadius: BorderRadius.circular(30),
//             ),
//             child: Center(
//               child: _isLoading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : const Text(
//                       'Continuer',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w800,
//                         fontSize: 16,
//                       ),
//                     ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }




// ------ Okay mais souic de context


// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:kunft/pages/auth/forgot_password/OTP_Code.dart';
// import 'package:kunft/provider/UserProvider.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:provider/provider.dart';

// class ResetPassword extends StatefulWidget {
//   const ResetPassword({super.key});

//   @override
//   State<ResetPassword> createState() => _ResetPasswordState();
// }

// class _ResetPasswordState extends State<ResetPassword> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _inputController = TextEditingController();
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _inputController.dispose();
//     super.dispose();
//   }

//   String? _validateInput(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Veuillez entrer une adresse valide.';
//     }
//     String emailRegex = r'^[^@]+@[^@]+\.[^@]+';
//     String phoneRegex = r'^\+?[\d\s-]{10,15}$';

//     if (!RegExp(emailRegex).hasMatch(value) &&
//         !RegExp(phoneRegex).hasMatch(value)) {
//       return 'Veuillez entrer votre addresse e-mail ';
//     }
//     return null;
//   }

//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true; // Affichez l'indicateur de chargement
//       });

//       final userProvider = Provider.of<UserProvider>(context, listen: false);
//       final emailOrPhone = _inputController.text;

//       final success = await userProvider.sendResetPasswordLink(emailOrPhone);

//       setState(() {
//         _isLoading = false; // Cachez l'indicateur de chargement
//       });

//       if (success) {
//         // Rediriger vers la page OTP si l'envoi de l'e-mail a réussi
//         // Note: C'est un exemple, la logique du token est gérée par l'API
//         if (!mounted) return;
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => OtpCode(email: emailOrPhone)),
//         );
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Un code a été envoyé à votre adresse.'),
//             backgroundColor: Colors.green,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       } else {
//         // Afficher une SnackBar en cas d'échec
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               userProvider.errorMessage ?? 'Une erreur est survenue.',
//             ),
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text('Réinitialiser le mot de passe'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               SvgPicture.asset(
//                 'assets/svg/mail_sent1.svg',
//                 fit: BoxFit.cover,
//                 height: screenHeight * .4,
//               ),
//               const Text(
//                 // 'Veuillez entrer votre numéro de téléphone ou e-mail pour recevoir le code de réinitialisation.',
//                 'Veuillez entrer votre e-mail pour recevoir le code de réinitialisation.',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 30),
//               Form(
//                 key: _formKey,
//                 child: TextFormField(
//                   controller: _inputController,
//                   decoration: const InputDecoration(
//                     labelText: 'E-mail ou numéro de téléphone',
//                     hintText: 'Entrez votre information de contact',
//                     floatingLabelStyle: TextStyle(color: Color(0xFF256AFD)),
//                     prefixIcon: Icon(LucideIcons.mailSearch),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                       borderSide: BorderSide(color: Colors.grey),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                       borderSide: BorderSide(color: Colors.grey, width: 1.0),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                       borderSide: BorderSide(
//                         color: Color(0xFF256AFD),
//                         width: 2.0,
//                       ),
//                     ),
//                     errorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                       borderSide: BorderSide(color: Colors.red, width: 1.0),
//                     ),
//                     focusedErrorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                       borderSide: BorderSide(color: Colors.red, width: 2.0),
//                     ),
//                   ),
//                   validator: _validateInput,
//                 ),
//               ),
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.fromLTRB(16, 5, 16, 40),
//         child: GestureDetector(
//           onTap: _isLoading
//               ? null
//               : _submitForm, // Désactive le bouton si l'API est en cours d'appel
//           child: Container(
//             height: 60,
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
//             decoration: BoxDecoration(
//               color: const Color(0xFF256AFD),
//               borderRadius: BorderRadius.circular(30),
//             ),
//             child: Center(
//               child: _isLoading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : const Text(
//                       'Continuer',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w800,
//                         fontSize: 16,
//                       ),
//                     ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



// ------------- Code Statique ---------------


// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:kunft/pages/auth/forgot_password/OTP_Code.dart';
// import 'package:lucide_icons/lucide_icons.dart';

// class ResetPassword extends StatefulWidget {
//   const ResetPassword({super.key});

//   @override
//   State<ResetPassword> createState() => _ResetPasswordState();
// }

// class _ResetPasswordState extends State<ResetPassword> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _inputController = TextEditingController();

//   @override
//   void dispose() {
//     _inputController.dispose();
//     super.dispose();
//   }

//   String? _validateInput(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Veuillez entrer une addresse valide.';
//     }
//     // Regex pour valider un e-mail
//     String emailRegex = r'^[^@]+@[^@]+\.[^@]+';
//     // Regex pour valider un numéro de téléphone simple
//     String phoneRegex = r'^\+?[\d\s-]{10,15}$';

//     if (!RegExp(emailRegex).hasMatch(value) &&
//         !RegExp(phoneRegex).hasMatch(value)) {
//       return ' '; // 2e message en cas de données invalide
//     }
//     return null;
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       // Si la validation est réussie, on peut passer à l'écran de code OTP
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const OtpCode()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text('Réinitialiser le mot de passe'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               SvgPicture.asset(
//                 'assets/svg/mail_sent1.svg',
//                 fit: BoxFit.cover,
//                 height: screenHeight * .4,
//               ),
//               Transform.translate(
//                 offset: const Offset(0, 0),
//                 child: Column(
//                   children: [
//                     const Text(
//                       'Veuillez entrer votre numéro de téléphone ou e-mail pour recevoir le code de réinitialisation.',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w400,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 35),
//                     Form(
//                       key: _formKey,
//                       child: TextFormField(
//                         controller: _inputController,
//                         decoration: const InputDecoration(
//                           labelText: 'E-mail',
//                           hintText: 'Entrez votre information de contact',
//                           floatingLabelStyle: TextStyle(
//                             color: Color(0xFF256AFD),
//                           ),
//                           prefixIcon: Icon(LucideIcons.mailSearch),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(30.0),
//                             ),
//                             borderSide: BorderSide(color: Colors.grey),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(30.0),
//                             ),
//                             borderSide: BorderSide(
//                               color: Colors.grey,
//                               width: 1.0,
//                             ),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(30.0),
//                             ),
//                             borderSide: BorderSide(
//                               color: Color(0xFF256AFD),
//                               width: 2.0,
//                             ),
//                           ),
//                           errorBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(30.0),
//                             ),
//                             borderSide: BorderSide(
//                               color: Colors.red,
//                               width: 1.0,
//                             ),
//                           ),
//                           focusedErrorBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(30.0),
//                             ),
//                             borderSide: BorderSide(
//                               color: Colors.red,
//                               width: 2.0,
//                             ),
//                           ),
//                         ),
//                         validator: _validateInput,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.fromLTRB(16, 5, 16, 40),
//         child: GestureDetector(
//           onTap: _submitForm,
//           child: Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
//             decoration: BoxDecoration(
//               color: const Color(0xFF256AFD),
//               borderRadius: BorderRadius.circular(30),
//             ),
//             child: const Text(
//               'Continuer',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w800,
//                 fontSize: 16,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
