import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kunft/pages/home_screen.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CreateNewPassword extends StatefulWidget {
  const CreateNewPassword({super.key});

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _passwordError;

  void _validatePassword() {
    setState(() {
      if (_passwordController.text != _confirmPasswordController.text) {
        _passwordError = 'Les mots de passe ne correspondent pas.';
      } else {
        _passwordError = null;
      }
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Créer un mot de passe'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                child: SvgPicture.asset(
                  'assets/svg/Forgot_password.svg',
                  fit: BoxFit.cover,
                  height: 320, // Définir une hauteur
                  // colorFilter: const ColorFilter.mode(
                  //   Colors.blue,
                  //   BlendMode.srcIn,
                  // ), // Changer la couleur (optionnel)
                ),
              ),
              const Text(
                'Créez votre nouveau mot de passe',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 35),
              _buildPasswordField(
                controller: _passwordController,
                obscureText: _obscureText1,
                labelText: 'Nouveau mot de passe',
                onVisibilityToggle: () {
                  setState(() {
                    _obscureText1 = !_obscureText1;
                  });
                },
              ),
              const SizedBox(height: 30),
              _buildPasswordField(
                controller: _confirmPasswordController,
                obscureText: _obscureText2,
                labelText: 'Confirmer le mot de passe',
                errorText: _passwordError,
                onVisibilityToggle: () {
                  setState(() {
                    _obscureText2 = !_obscureText2;
                  });
                },
              ),
              const SizedBox(height: 40),
              // -------- Validation ------
              GestureDetector(
                onTap: () {
                  setState(() {
                    // Logique pour "Se souvenir de moi"
                  });
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.checkCircle, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Se souvenir de moi'),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              GestureDetector(
                onTap: () {
                  _validatePassword();
                  if (_passwordError == null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'Continuer',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscureText,
    required String labelText,
    required VoidCallback onVisibilityToggle,
    String? errorText,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: 'Entrez un mot de passe',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: onVisibilityToggle,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
        errorText: errorText,
      ),
    );
  }
}

// --- Ancien de code

// import 'package:flutter/material.dart';
// import 'package:kunft/pages/home_screen.dart';
// import 'package:lucide_icons/lucide_icons.dart';

// class CreateNewPassword extends StatefulWidget {
//   const CreateNewPassword({super.key});

//   @override
//   State<CreateNewPassword> createState() => _CreateNewPasswordState();
// }

// class _CreateNewPasswordState extends State<CreateNewPassword> {
//   bool _obscureText1 = true;
//   bool _obscureText2 = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text('Créer un mot de passe'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           children: [
//             // const TopNavigation(pageName: 'Créer un mot de passe'),
//             //
//             ClipRRect(
//               child: Image.asset('assets/password/CN-psw.png', scale: 0.4),
//             ),
//             //
//             const Text(
//               'Créé votre nouveau mot de passe',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//             ),
//             const SizedBox(height: 35),
//             // ------- Saisie de mot de passe -----------
//             Column(
//               children: [
//                 TextField(
//                   obscureText: _obscureText1,
//                   decoration: InputDecoration(
//                     labelText: 'Nouveau mot de passe',
//                     hintText: 'Entrez un mot de passe',
//                     prefixIcon: const Icon(Icons.lock),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscureText1 ? Icons.visibility_off : Icons.visibility,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _obscureText1 = !_obscureText1;
//                         });
//                       },
//                     ),
//                     // Bordures pour les différents états
//                     border: const OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                       borderSide: BorderSide(color: Colors.grey),
//                     ),
//                     enabledBorder: const OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                       borderSide: BorderSide(color: Colors.grey, width: 1.0),
//                     ),
//                     focusedBorder: const OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                       borderSide: BorderSide(color: Colors.blue, width: 2.0),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 TextField(
//                   obscureText: _obscureText2,
//                   decoration: InputDecoration(
//                     labelText: 'Confirmer le mot de passe',
//                     hintText: 'Confirmez votre mot de passe',
//                     prefixIcon: const Icon(Icons.lock),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscureText2 ? Icons.visibility_off : Icons.visibility,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _obscureText2 = !_obscureText2;
//                         });
//                       },
//                     ),
//                     // Bordures pour les différents états
//                     border: const OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                       borderSide: BorderSide(color: Colors.grey),
//                     ),
//                     enabledBorder: const OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                       borderSide: BorderSide(color: Colors.grey, width: 1.0),
//                     ),
//                     focusedBorder: const OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                       borderSide: BorderSide(color: Colors.blue, width: 2.0),
//                     ),
//                     // Exemple d'un état d'erreur
//                     errorBorder: const OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                       borderSide: BorderSide(color: Colors.red, width: 1.0),
//                     ),
//                     focusedErrorBorder: const OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                       borderSide: BorderSide(color: Colors.red, width: 2.0),
//                     ),
//                     errorText: false
//                         ? null
//                         : "Les mots de passe ne correspondent pas.", // Mettez votre logique de validation ici
//                   ),
//                 ),
//               ],
//             ),
//             //
//             const SizedBox(height: 30),
//             // -------- Validation ------
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   // _rememberMe = !_rememberMe;
//                 });
//               },
//               child: const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Ajoute la fonction de de stokage de token ici
//                   Icon(LucideIcons.checkCircle, color: Colors.blue),
//                   SizedBox(width: 8),
//                   Text('Se souvenir de moi'),

//                   // ---------- Affichage de la modale ----------
//                 ],
//               ),
//             ),
//             //
//             //
//             const SizedBox(height: 60),
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const HomeScreen()),
//                 );
//               },
//               child: Container(
//                 alignment: Alignment.bottomCenter,
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 10,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
//                   borderRadius: BorderRadius.circular(30),
//                   // boxShadow: [
//                   //   BoxShadow(
//                   //     offset: Offset(0, 0),
//                   //     blurRadius: 6,
//                   //     spreadRadius: 5,
//                   //     color: Colors.blue,
//                   //   ),
//                   // ],
//                 ),
//                 child: const Text(
//                   'Continue',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w800,
//                     fontSize: 16,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//             // const WidgetOkayDialog(),
//           ],
//         ),
//       ),
//     );
//   }
// }
