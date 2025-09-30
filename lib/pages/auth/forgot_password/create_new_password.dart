import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kunft/pages/home_screen.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:kunft/provider/UserProvider.dart';

class CreateNewPassword extends StatefulWidget {
  final String email;
  final String token;

  const CreateNewPassword({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _rememberMe = false; // ✅ Nouvelle variable d'état

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un mot de passe.';
    }
    if (value.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères.';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer votre mot de passe.';
    }
    if (value != _passwordController.text) {
      return 'Les mots de passe ne correspondent pas.';
    }
    return null;
  }

  Future<void> _onContinue() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final success = await userProvider.resetPassword(
        email: widget.email,
        token: widget.token,
        newPassword: _passwordController.text,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mot de passe mis à jour avec succès!'),
            backgroundColor: Colors.green,
          ),
        );
        // Redirection vers l'écran d'accueil
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              userProvider.errorMessage ??
                  'La réinitialisation a échoué. Veuillez réessayer.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
                  'assets/svg/create_password.svg',
                  fit: BoxFit.cover,
                  height: 380,
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        'Créez votre nouveau mot de passe',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
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
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 30),
                      _buildPasswordField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureText2,
                        labelText: 'Confirmer le mot de passe',
                        onVisibilityToggle: () {
                          setState(() {
                            _obscureText2 = !_obscureText2;
                          });
                        },
                        validator: _validateConfirmPassword,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _rememberMe = !_rememberMe;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _rememberMe
                          ? LucideIcons.checkCircle
                          : LucideIcons.circle,
                      color: const Color(0xFF256AFD),
                    ),
                    const SizedBox(width: 8),
                    const Text('Se souvenir de moi'),
                  ],
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 5, 16, 40),
        child: GestureDetector(
          onTap: _isLoading ? null : _onContinue,
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool obscureText,
    required String labelText,
    required VoidCallback onVisibilityToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: 'Entrez un mot de passe',
        floatingLabelStyle: const TextStyle(color: Color(0xFF256AFD)),
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
          borderSide: BorderSide(color: Color(0xFF256AFD), width: 2.0),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
      ),
      validator: validator,
    );
  }
}






// --------- Bien fonctionnel mais sans l'option se seouvenir de moi ---------


// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:kunft/pages/home_screen.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import 'package:provider/provider.dart';
// import 'package:kunft/provider/UserProvider.dart';

// class CreateNewPassword extends StatefulWidget {
//   final String email;
//   final String token;

//   const CreateNewPassword({
//     super.key,
//     required this.email,
//     required this.token,
//   });

//   @override
//   State<CreateNewPassword> createState() => _CreateNewPasswordState();
// }

// class _CreateNewPasswordState extends State<CreateNewPassword> {
//   bool _obscureText1 = true;
//   bool _obscureText2 = true;
//   bool _isLoading = false;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();

//   @override
//   void dispose() {
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Veuillez entrer un mot de passe.';
//     }
//     if (value.length < 8) {
//       return 'Le mot de passe doit contenir au moins 8 caractères.';
//     }
//     return null;
//   }

//   String? _validateConfirmPassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Veuillez confirmer votre mot de passe.';
//     }
//     if (value != _passwordController.text) {
//       return 'Les mots de passe ne correspondent pas.';
//     }
//     return null;
//   }

//   Future<void> _onContinue() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });

//       final userProvider = Provider.of<UserProvider>(context, listen: false);

//       final success = await userProvider.resetPassword(
//         email: widget.email,
//         token: widget.token,
//         newPassword: _passwordController.text,
//       );

//       if (!mounted) return;

//       setState(() {
//         _isLoading = false;
//       });

//       if (success) {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Mot de passe mis à jour avec succès!'),
//             backgroundColor: Colors.green,
//           ),
//         );
//         // Redirection vers l'écran d'accueil
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => const HomeScreen()),
//           (Route<dynamic> route) => false,
//         );
//       } else {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               userProvider.errorMessage ??
//                   'La réinitialisation a échoué. Veuillez réessayer.',
//             ),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text('Créer un mot de passe'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               ClipRRect(
//                 child: SvgPicture.asset(
//                   'assets/svg/create_password.svg',
//                   fit: BoxFit.cover,
//                   height: 380,
//                 ),
//               ),
//               Transform.translate(
//                 offset: const Offset(0, -20),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       const Text(
//                         'Créez votre nouveau mot de passe',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w400,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 35),
//                       _buildPasswordField(
//                         controller: _passwordController,
//                         obscureText: _obscureText1,
//                         labelText: 'Nouveau mot de passe',
//                         onVisibilityToggle: () {
//                           setState(() {
//                             _obscureText1 = !_obscureText1;
//                           });
//                         },
//                         validator: _validatePassword,
//                       ),
//                       const SizedBox(height: 30),
//                       _buildPasswordField(
//                         controller: _confirmPasswordController,
//                         obscureText: _obscureText2,
//                         labelText: 'Confirmer le mot de passe',
//                         onVisibilityToggle: () {
//                           setState(() {
//                             _obscureText2 = !_obscureText2;
//                           });
//                         },
//                         validator: _validateConfirmPassword,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 40),
//               GestureDetector(
//                 onTap: () {
//                   // Logique pour "Se souvenir de moi"
//                 },
//                 child: const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(LucideIcons.checkCircle, color: Color(0xFF256AFD)),
//                     SizedBox(width: 8),
//                     Text('Se souvenir de moi'),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 60),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.fromLTRB(16, 5, 16, 40),
//         child: GestureDetector(
//           onTap: _isLoading ? null : _onContinue,
//           child: Container(
//             height: 60,
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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

//   Widget _buildPasswordField({
//     required TextEditingController controller,
//     required bool obscureText,
//     required String labelText,
//     required VoidCallback onVisibilityToggle,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         labelText: labelText,
//         hintText: 'Entrez un mot de passe',
//         floatingLabelStyle: const TextStyle(color: Color(0xFF256AFD)),
//         prefixIcon: const Icon(Icons.lock),
//         suffixIcon: IconButton(
//           icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
//           onPressed: onVisibilityToggle,
//         ),
//         border: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(30.0)),
//           borderSide: BorderSide(color: Colors.grey),
//         ),
//         enabledBorder: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(30.0)),
//           borderSide: BorderSide(color: Colors.grey, width: 1.0),
//         ),
//         focusedBorder: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(30.0)),
//           borderSide: BorderSide(color: Color(0xFF256AFD), width: 2.0),
//         ),
//         errorBorder: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(30.0)),
//           borderSide: BorderSide(color: Colors.red, width: 1.0),
//         ),
//         focusedErrorBorder: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(30.0)),
//           borderSide: BorderSide(color: Colors.red, width: 2.0),
//         ),
//       ),
//       validator: validator,
//     );
//   }
// }


// -------- Code statique ----------


// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:kunft/pages/home_screen.dart';
// import 'package:lucide_icons/lucide_icons.dart';

// class CreateNewPassword extends StatefulWidget {
//   const CreateNewPassword({
//     super.key,
//     required String email,
//     required String token,
//   });

//   @override
//   State<CreateNewPassword> createState() => _CreateNewPasswordState();
// }

// class _CreateNewPasswordState extends State<CreateNewPassword> {
//   bool _obscureText1 = true;
//   bool _obscureText2 = true;
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   String? _passwordError;

//   void _validatePassword() {
//     setState(() {
//       if (_passwordController.text != _confirmPasswordController.text) {
//         _passwordError = 'Les mots de passe ne correspondent pas.';
//       } else {
//         _passwordError = null;
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text('Créer un mot de passe'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               ClipRRect(
//                 child: SvgPicture.asset(
//                   'assets/svg/create_password.svg',
//                   fit: BoxFit.cover,
//                   height: 380, // Définir une hauteur
//                 ),
//               ),
//               Transform.translate(
//                 offset: const Offset(0, -20),
//                 child: Column(
//                   children: [
//                     const Text(
//                       'Créez votre nouveau mot de passe',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w400,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 35),
//                     _buildPasswordField(
//                       controller: _passwordController,
//                       obscureText: _obscureText1,
//                       labelText: 'Nouveau mot de passe',
//                       onVisibilityToggle: () {
//                         setState(() {
//                           _obscureText1 = !_obscureText1;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 30),
//                     _buildPasswordField(
//                       controller: _confirmPasswordController,
//                       obscureText: _obscureText2,
//                       labelText: 'Confirmer le mot de passe',
//                       errorText: _passwordError,
//                       onVisibilityToggle: () {
//                         setState(() {
//                           _obscureText2 = !_obscureText2;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 40),
//               // -------- Validation ------
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     // Logique pour "Se souvenir de moi"
//                   });
//                 },
//                 child: const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(LucideIcons.checkCircle, color: Color(0xFF256AFD)),
//                     SizedBox(width: 8),
//                     Text('Se souvenir de moi'),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 60),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.fromLTRB(16, 5, 16, 40),
//         child: GestureDetector(
//           onTap: () {
//             _validatePassword();
//             if (_passwordError == null) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const HomeScreen()),
//               );
//             }
//           },
//           child: Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
//             decoration: BoxDecoration(
//               color: Color(0xFF256AFD),
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

//   Widget _buildPasswordField({
//     required TextEditingController controller,
//     required bool obscureText,
//     required String labelText,
//     required VoidCallback onVisibilityToggle,
//     String? errorText,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         labelText: labelText,
//         hintText: 'Entrez un mot de passe',
//         floatingLabelStyle: const TextStyle(color: Color(0xFF256AFD)),
//         prefixIcon: const Icon(Icons.lock),
//         suffixIcon: IconButton(
//           icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
//           onPressed: onVisibilityToggle,
//         ),
//         border: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(30.0)),
//           borderSide: BorderSide(color: Colors.grey),
//         ),
//         enabledBorder: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(30.0)),
//           borderSide: BorderSide(color: Colors.grey, width: 1.0),
//         ),
//         focusedBorder: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(30.0)),
//           borderSide: BorderSide(color: Color(0xFF256AFD), width: 2.0),
//         ),
//         errorBorder: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(30.0)),
//           borderSide: BorderSide(color: Colors.red, width: 1.0),
//         ),
//         focusedErrorBorder: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(30.0)),
//           borderSide: BorderSide(color: Colors.red, width: 2.0),
//         ),
//         errorText: errorText,
//       ),
//     );
//   }
// }

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
//                       borderSide: BorderSide(color: Color(0xFF256AFD), width: 2.0),
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
//                       borderSide: BorderSide(color: Color(0xFF256AFD), width: 2.0),
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
//                   Icon(LucideIcons.checkCircle, color: Color(0xFF256AFD)),
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
//                   color: Color(0xFF256AFD),
//                   borderRadius: BorderRadius.circular(30),
//                   // boxShadow: [
//                   //   BoxShadow(
//                   //     offset: Offset(0, 0),
//                   //     blurRadius: 6,
//                   //     spreadRadius: 5,
//                   //     color: Color(0xFF256AFD),
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
