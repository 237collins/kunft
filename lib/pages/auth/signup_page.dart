// Code okay avec vefication

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kunft/pages/auth/login_page.dart';
import 'package:kunft/pages/auth/pin_code.dart';

// Définissez votre URL de base d'API ici
const String API_BASE_URL = 'http://127.0.0.1:8000';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmedPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  String? _selectedRole;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmedPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  InputDecoration _inputDecoration(
    String label, {
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? toggleObscureText,
    Icon? prefixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 12),
      filled: true,
      fillColor: const Color(0xfff7f7f7),
      prefixIcon: prefixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xffd3d3d3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xffFFD055), width: 2),
      ),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: toggleObscureText,
            )
          : null,
    );
  }

  // --- FONCTION INSCRIPTION ---
  Future<void> _registerWithLaravel() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedRole == null) {
        _showErrorSnackBar("Veuillez sélectionner un type de compte.");
        return;
      }

      try {
        final response = await http.post(
          Uri.parse('$API_BASE_URL/api/register'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'phone': _phoneController.text.trim(),
            'password': _passwordController.text,
            'password_confirmation': _confirmedPasswordController.text,
            'role': _selectedRole,
          }),
        );

        if (response.statusCode == 201) {
          final userEmail = _emailController.text.trim();
          _showSuccessSnackBar(
            'Compte créé avec succès ! Un code de vérification a été envoyé à $userEmail.',
          );
          Navigator.pushReplacement(
            context,
            // ✅ Passe l'email de l'utilisateur à PinCodePage
            MaterialPageRoute(
              builder: (context) => PinCodePage(email: userEmail),
            ),
          );
        } else {
          final Map<String, dynamic> errorData = json.decode(response.body);
          String errorMessage = 'Erreur lors de l\'inscription.';

          if (errorData.containsKey('message')) {
            errorMessage = errorData['message'];
          }
          if (errorData.containsKey('errors')) {
            final Map<String, dynamic> errors = errorData['errors'];
            errors.forEach((key, value) {
              errorMessage += '\n- ${value[0]}';
            });
          }
          _showErrorSnackBar(errorMessage);
        }
      } catch (e) {
        _showErrorSnackBar(
          'Une erreur inattendue est survenue : ${e.toString()}',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // --- IMAGE HEADER ---
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              height: screenHeight * .25,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: Image.asset(
                  'assets/images/img02.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- TEXT HEADER ---
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Join the Archilles Community!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Sublimez votre séjour en choisissant le logement ideal.',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 20),

                // --- FORMULAIRE ---
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // USERNAME + ROLE
                        Row(
                          children: [
                            SizedBox(
                              width: screenWidth * .55,
                              child: TextFormField(
                                controller: _nameController,
                                style: const TextStyle(color: Colors.purple),
                                decoration: _inputDecoration('Nom'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer un nom d\'utilisateur.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 15),
                            SizedBox(
                              width: screenWidth * .36,
                              child: DropdownButtonFormField<String>(
                                value: _selectedRole,
                                decoration: _inputDecoration('Type de compte'),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'client',
                                    child: Text(
                                      'Client',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'hote-standard',
                                    child: Text(
                                      'Hôte standard',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedRole = value;
                                  });
                                },
                                validator: (value) =>
                                    value == null ? 'Choisissez un type' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // EMAIL
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.purple),
                          decoration: _inputDecoration('monadresse_@gmail.com'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre email.';
                            }
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+',
                            ).hasMatch(value)) {
                              return 'Veuillez entrer un email valide.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        // PHONE
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: _inputDecoration(
                            'Téléphone',
                            prefixIcon: const Icon(Icons.phone),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre numéro de téléphone.';
                            }
                            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'Veuillez n\'utiliser que des chiffres.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        // PASSWORD
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscureTextPassword,
                          decoration: _inputDecoration(
                            'Mot de passe',
                            isPassword: true,
                            obscureText: _obscureTextPassword,
                            toggleObscureText: () {
                              setState(() {
                                _obscureTextPassword = !_obscureTextPassword;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre mot de passe.';
                            }
                            if (value.length < 8) {
                              return 'Le mot de passe doit contenir au moins 8 caractères.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        // CONFIRM PASSWORD
                        TextFormField(
                          controller: _confirmedPasswordController,
                          obscureText: _obscureTextConfirmPassword,
                          decoration: _inputDecoration(
                            'Confirmer le mot de passe',
                            isPassword: true,
                            obscureText: _obscureTextConfirmPassword,
                            toggleObscureText: () {
                              setState(() {
                                _obscureTextConfirmPassword =
                                    !_obscureTextConfirmPassword;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez confirmer votre mot de passe.';
                            }
                            if (value != _passwordController.text) {
                              return 'Les mots de passe ne correspondent pas.';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // --- BUTTON ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _registerWithLaravel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffFFD055),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Créer mon Compte',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // --- LOGIN REDIRECT ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Vous avez déja un compte? ',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                Text.rich(
                  TextSpan(
                    text: ' Connectez-vous!',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.yellow.shade700,
                      fontWeight: FontWeight.w700,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // ✅ Navigue vers la page de connexion
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}



// le package des tel auto pose souci au lancement de l'app

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:kunft/pages/auth/login_page.dart';
// import 'package:kunft/pages/auth/pin_code.dart'; // Keep this import for the redirect in the `don't have an account` part

// // Définissez votre URL de base d'API ici
// const String API_BASE_URL = 'http://127.0.0.1:8000';

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});

//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmedPasswordController =
//       TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   bool _obscureTextPassword = true;
//   bool _obscureTextConfirmPassword = true;

//   String? _selectedRole;

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmedPasswordController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }

//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.green),
//     );
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.red),
//     );
//   }

//   InputDecoration _inputDecoration(
//     String label, {
//     bool isPassword = false,
//     bool obscureText = false,
//     VoidCallback? toggleObscureText,
//     Icon? prefixIcon,
//   }) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: const TextStyle(fontSize: 12),
//       filled: true,
//       fillColor: const Color(0xfff7f7f7),
//       prefixIcon: prefixIcon,
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Color(0xffd3d3d3)),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Color(0xffFFD055), width: 2),
//       ),
//       suffixIcon: isPassword
//           ? IconButton(
//               icon: Icon(
//                 obscureText ? Icons.visibility_off : Icons.visibility,
//                 color: Colors.grey,
//               ),
//               onPressed: toggleObscureText,
//             )
//           : null,
//     );
//   }

//   // --- FONCTION INSCRIPTION ---
//   Future<void> _registerWithLaravel() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       if (_selectedRole == null) {
//         _showErrorSnackBar("Veuillez sélectionner un type de compte.");
//         return;
//       }

//       try {
//         final response = await http.post(
//           Uri.parse('$API_BASE_URL/api/register'),
//           headers: {
//             'Content-Type': 'application/json',
//             'Accept': 'application/json',
//           },
//           body: jsonEncode({
//             'name': _nameController.text.trim(),
//             'email': _emailController.text.trim(),
//             'phone': _phoneController.text.trim(),
//             'password': _passwordController.text,
//             'password_confirmation': _confirmedPasswordController.text,
//             'role': _selectedRole,
//           }),
//         );

//         if (response.statusCode == 201) {
//           _showSuccessSnackBar(
//             'Compte créé avec succès ! Un code de vérification a été envoyé par mail.',
//           );
//           Navigator.pushReplacement(
//             context,
//             // ✅ Redirige vers PinCodePage
//             MaterialPageRoute(builder: (context) => const PinCodePage(email: '',)),
//           );
//         } else {
//           final Map<String, dynamic> errorData = json.decode(response.body);
//           String errorMessage = 'Erreur lors de l\'inscription.';

//           if (errorData.containsKey('message')) {
//             errorMessage = errorData['message'];
//           }
//           if (errorData.containsKey('errors')) {
//             final Map<String, dynamic> errors = errorData['errors'];
//             errors.forEach((key, value) {
//               errorMessage += '\n- ${value[0]}';
//             });
//           }
//           _showErrorSnackBar(errorMessage);
//         }
//       } catch (e) {
//         _showErrorSnackBar(
//           'Une erreur inattendue est survenue : ${e.toString()}',
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             // --- IMAGE HEADER ---
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               height: screenHeight * .25,
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(50),
//                   topRight: Radius.circular(50),
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//                 child: Image.asset(
//                   'assets/images/img02.jpg',
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // --- TEXT HEADER ---
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Join the Archilles Community!',
//                   style: TextStyle(
//                     fontSize: 32,
//                     fontWeight: FontWeight.w600,
//                     height: 1.2,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 const Text(
//                   'Sublimez votre séjour en choisissant le logement ideal.',
//                   style: TextStyle(fontSize: 12),
//                 ),
//                 const SizedBox(height: 20),

//                 // --- FORMULAIRE ---
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(18.0),
//                   ),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         // USERNAME + ROLE
//                         Row(
//                           children: [
//                             SizedBox(
//                               width: screenWidth * .49,
//                               child: TextFormField(
//                                 controller: _nameController,
//                                 style: const TextStyle(color: Colors.purple),
//                                 decoration: _inputDecoration('Nom'),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Veuillez entrer un nom d\'utilisateur.';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                             const SizedBox(width: 15),
//                             SizedBox(
//                               width: screenWidth * .42,
//                               child: DropdownButtonFormField<String>(
//                                 value: _selectedRole,
//                                 decoration: _inputDecoration('Type de compte'),
//                                 items: const [
//                                   DropdownMenuItem(
//                                     value: 'client',
//                                     child: Text('Client'),
//                                   ),
//                                   DropdownMenuItem(
//                                     value: 'hote',
//                                     child: Text('Hôte'),
//                                   ),
//                                 ],
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _selectedRole = value;
//                                   });
//                                 },
//                                 validator: (value) =>
//                                     value == null ? 'Choisissez un type' : null,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 15),

//                         // EMAIL
//                         TextFormField(
//                           controller: _emailController,
//                           keyboardType: TextInputType.emailAddress,
//                           style: const TextStyle(color: Colors.purple),
//                           decoration: _inputDecoration('monadresse_@gmail.com'),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Veuillez entrer votre email.';
//                             }
//                             if (!RegExp(
//                               r'^[^@]+@[^@]+\.[^@]+',
//                             ).hasMatch(value)) {
//                               return 'Veuillez entrer un email valide.';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 15),

//                         // PHONE
//                         TextFormField(
//                           controller: _phoneController,
//                           keyboardType: TextInputType.phone,
//                           decoration: _inputDecoration(
//                             'Téléphone',
//                             prefixIcon: const Icon(Icons.phone),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Veuillez entrer votre numéro de téléphone.';
//                             }
//                             if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
//                               return 'Veuillez n\'utiliser que des chiffres.';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 15),

//                         // PASSWORD
//                         TextFormField(
//                           controller: _passwordController,
//                           obscureText: _obscureTextPassword,
//                           decoration: _inputDecoration(
//                             'Mot de passe',
//                             isPassword: true,
//                             obscureText: _obscureTextPassword,
//                             toggleObscureText: () {
//                               setState(() {
//                                 _obscureTextPassword = !_obscureTextPassword;
//                               });
//                             },
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Veuillez entrer votre mot de passe.';
//                             }
//                             if (value.length < 8) {
//                               return 'Le mot de passe doit contenir au moins 8 caractères.';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 15),

//                         // CONFIRM PASSWORD
//                         TextFormField(
//                           controller: _confirmedPasswordController,
//                           obscureText: _obscureTextConfirmPassword,
//                           decoration: _inputDecoration(
//                             'Confirmer le mot de passe',
//                             isPassword: true,
//                             obscureText: _obscureTextConfirmPassword,
//                             toggleObscureText: () {
//                               setState(() {
//                                 _obscureTextConfirmPassword =
//                                     !_obscureTextConfirmPassword;
//                               });
//                             },
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Veuillez confirmer votre mot de passe.';
//                             }
//                             if (value != _passwordController.text) {
//                               return 'Les mots de passe ne correspondent pas.';
//                             }
//                             return null;
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 25),

//             // --- BUTTON ---
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _registerWithLaravel,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xffFFD055),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   'Créer mon Compte',
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 25),

//             // --- LOGIN REDIRECT ---
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'Vous avez déja un compte? ',
//                   style: TextStyle(fontSize: 12, color: Colors.black),
//                 ),
//                 Text.rich(
//                   TextSpan(
//                     text: ' Connectez-vous!',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.yellow.shade700,
//                       fontWeight: FontWeight.w700,
//                     ),
//                     recognizer: TapGestureRecognizer()
//                       ..onTap = () {
//                         // ✅ Navigue vers la page de connexion
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const LoginPage(),
//                           ),
//                         );
//                       },
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 35),
//           ],
//         ),
//       ),
//     );
//   }
// }



//Code statique mais fonctionnel


// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:kunft/pages/auth/login_page.dart';

// // Définissez votre URL de base d'API ici
// const String API_BASE_URL = 'http://127.0.0.1:8000';

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});

//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmedPasswordController =
//       TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   bool _obscureTextPassword = true;
//   bool _obscureTextConfirmPassword = true;

//   // ✅ Nouveau champ : rôle
//   String? _selectedRole;

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmedPasswordController.dispose();
//     super.dispose();
//   }

//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.green),
//     );
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.red),
//     );
//   }

//   InputDecoration _inputDecoration(
//     String label, {
//     bool isPassword = false,
//     bool obscureText = false,
//     VoidCallback? toggleObscureText,
//   }) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: const TextStyle(fontSize: 12),
//       filled: true,
//       fillColor: const Color(0xfff7f7f7),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Color(0xffd3d3d3)),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Color(0xffFFD055), width: 2),
//       ),
//       suffixIcon:
//           isPassword
//               ? IconButton(
//                 icon: Icon(
//                   obscureText ? Icons.visibility_off : Icons.visibility,
//                   color: Colors.grey,
//                 ),
//                 onPressed: toggleObscureText,
//               )
//               : null,
//     );
//   }

//   // --- FONCTION INSCRIPTION ---
//   Future<void> _registerWithLaravel() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       if (_selectedRole == null) {
//         _showErrorSnackBar("Veuillez sélectionner un type de compte.");
//         return;
//       }

//       try {
//         final response = await http.post(
//           Uri.parse('$API_BASE_URL/api/register'),
//           headers: {
//             'Content-Type': 'application/json',
//             'Accept': 'application/json',
//           },
//           body: jsonEncode({
//             'name': _nameController.text.trim(),
//             'email': _emailController.text.trim(),
//             'password': _passwordController.text,
//             'password_confirmation': _confirmedPasswordController.text,
//             'role': _selectedRole, // ✅ Envoi du rôle
//           }),
//         );

//         if (response.statusCode == 201) {
//           _showSuccessSnackBar(
//             'Compte créé avec succès ! Vous pouvez maintenant vous connecter.',
//           );
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const LoginPage()),
//           );
//         } else {
//           final Map<String, dynamic> errorData = json.decode(response.body);
//           String errorMessage = 'Erreur lors de l\'inscription.';

//           if (errorData.containsKey('message')) {
//             errorMessage = errorData['message'];
//           }
//           if (errorData.containsKey('errors')) {
//             final Map<String, dynamic> errors = errorData['errors'];
//             errors.forEach((key, value) {
//               errorMessage += '\n- ${value[0]}';
//             });
//           }
//           _showErrorSnackBar(errorMessage);
//         }
//       } catch (e) {
//         _showErrorSnackBar(
//           'Une erreur inattendue est survenue : ${e.toString()}',
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             // --- IMAGE HEADER ---
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               height: screenHeight * .31,
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(50),
//                   topRight: Radius.circular(50),
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//                 child: Image.asset(
//                   'assets/images/img02.jpg',
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 18),

//             // --- TEXT HEADER ---
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Join the Archilles Community!',
//                   style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
//                 ),
//                 const SizedBox(height: 12),
//                 const Text(
//                   'Sublimez votre séjour en choisissant le logement ideal.',
//                   style: TextStyle(fontSize: 12),
//                 ),
//                 const SizedBox(height: 20),

//                 // --- FORMULAIRE ---
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(18.0),
//                     // color: Colors.white,
//                   ),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         // USERNAME
//                         Row(
//                           children: [
//                             SizedBox(
//                               width: screenWidth * .45,
//                               child: TextFormField(
//                                 controller: _nameController,
//                                 style: const TextStyle(color: Colors.purple),
//                                 decoration: _inputDecoration('Nom'),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Veuillez entrer votre nom d\'utilisateur.';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                             //
//                             SizedBox(width: 15),
//                             //
//                             SizedBox(
//                               width: screenWidth * .45,
//                               // Code simple
//                               child: TextFormField(
//                                 controller:
//                                     _phoneController, // ⚠️ je te conseille de créer un vrai _phoneController pour plus de clarté
//                                 keyboardType: TextInputType.phone,
//                                 decoration: _inputDecoration('Téléphone'),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Veuillez entrer votre numéro de téléphone.';
//                                   }
//                                   // Exemple de regex simple pour numéro (tu peux l'adapter selon ton besoin et ton pays)
//                                   if (!RegExp(
//                                     r'^[0-9]{8,15}$',
//                                   ).hasMatch(value)) {
//                                     return 'Veuillez entrer un numéro valide (8 à 15 chiffres).';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 15),

//                         // EMAIL
//                         Row(
//                           children: [
//                             SizedBox(
//                               // height: 50,
//                               width: screenWidth * .6,
//                               child: TextFormField(
//                                 controller: _emailController,
//                                 keyboardType: TextInputType.emailAddress,
//                                 style: const TextStyle(color: Colors.purple),
//                                 decoration: _inputDecoration(
//                                   'monadresse_@gmail.com',
//                                 ),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Veuillez entrer votre email.';
//                                   }
//                                   if (!RegExp(
//                                     r'^[^@]+@[^@]+\.[^@]+',
//                                   ).hasMatch(value)) {
//                                     return 'Veuillez entrer un email valide.';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                             //
//                             const SizedBox(width: 15),
//                             // ✅ ROLE DROPDOWN
//                             SizedBox(
//                               width: screenWidth * .3,
//                               child: DropdownButtonFormField<String>(
//                                 value: _selectedRole,
//                                 decoration: _inputDecoration('Type de compte'),
//                                 items: const [
//                                   DropdownMenuItem(
//                                     value: 'client',
//                                     child: Text(
//                                       'Client',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ),
//                                   DropdownMenuItem(
//                                     value: 'hôte',
//                                     child: Text(
//                                       'Hôte',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _selectedRole = value;
//                                   });
//                                 },
//                                 validator:
//                                     (value) =>
//                                         value == null
//                                             ? 'Veuillez sélectionner un type de compte.'
//                                             : null,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 15),

//                         // PASSWORD
//                         TextFormField(
//                           controller: _passwordController,
//                           obscureText: _obscureTextPassword,
//                           decoration: _inputDecoration(
//                             'Mot de passe',
//                             isPassword: true,
//                             obscureText: _obscureTextPassword,
//                             toggleObscureText: () {
//                               setState(() {
//                                 _obscureTextPassword = !_obscureTextPassword;
//                               });
//                             },
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Veuillez entrer votre mot de passe.';
//                             }
//                             if (value.length < 8) {
//                               return 'Le mot de passe doit contenir au moins 8 caractères.';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 15),

//                         // CONFIRM PASSWORD
//                         TextFormField(
//                           controller: _confirmedPasswordController,
//                           obscureText: _obscureTextConfirmPassword,
//                           decoration: _inputDecoration(
//                             'Confirmer le mot de passe',
//                             isPassword: true,
//                             obscureText: _obscureTextConfirmPassword,
//                             toggleObscureText: () {
//                               setState(() {
//                                 _obscureTextConfirmPassword =
//                                     !_obscureTextConfirmPassword;
//                               });
//                             },
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Veuillez confirmer votre mot de passe.';
//                             }
//                             if (value != _passwordController.text) {
//                               return 'Les mots de passe ne correspondent pas.';
//                             }
//                             return null;
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 25),

//             // --- BUTTON ---
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _registerWithLaravel,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xffFFD055),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   'Créer mon Compte',
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 25),

//             // --- LOGIN REDIRECT ---
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'already have account? ',
//                   style: TextStyle(fontSize: 12, color: Colors.black),
//                 ),
//                 Text.rich(
//                   TextSpan(
//                     text: ' log into your account now!',
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: Color(0xffFFD055),
//                     ),
//                     recognizer:
//                         TapGestureRecognizer()
//                           ..onTap = () {
//                             Navigator.pop(context);
//                           },
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 35),
//           ],
//         ),
//       ),
//     );
//   }
// }



// Ancien code du 6 Sept 2025


// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:kunft/pages/auth/login_page.dart'; // Import de LoginPage

// // Définissez votre URL de base d'API ici ou importez-la depuis un fichier de constantes si vous en avez un.
// const String API_BASE_URL =
//     'http://127.0.0.1:8000'; // Assurez-vous que c'est l'URL correcte de votre backend Laravel

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});

//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmedPasswordController =
//       TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   bool _obscureTextPassword = true;
//   bool _obscureTextConfirmPassword = true;

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmedPasswordController.dispose();
//     super.dispose();
//   }

//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.green),
//     );
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.red),
//     );
//   }

//   InputDecoration _inputDecoration(
//     String label, {
//     bool isPassword = false,
//     bool obscureText = false,
//     VoidCallback? toggleObscureText,
//   }) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: const TextStyle(fontSize: 12),
//       filled: true,
//       fillColor: const Color(0xfff7f7f7),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Color(0xffd3d3d3)),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Color(0xffFFD055), width: 2),
//       ),
//       suffixIcon:
//           isPassword
//               ? IconButton(
//                 icon: Icon(
//                   obscureText ? Icons.visibility_off : Icons.visibility,
//                   color: Colors.grey,
//                 ),
//                 onPressed: toggleObscureText,
//               )
//               : null,
//     );
//   }

//   // --- FONCTION PRINCIPALE D'INSCRIPTION AVEC LARAVEL ---
//   Future<void> _registerWithLaravel() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       // Afficher un indicateur de chargement si nécessaire
//       // showDialog(...);

//       try {
//         print('DEBUG: Tentative d\'inscription avec Laravel...');
//         final response = await http.post(
//           Uri.parse(
//             '$API_BASE_URL/api/register',
//           ), // Endpoint d'inscription Laravel
//           headers: {
//             'Content-Type': 'application/json',
//             'Accept': 'application/json',
//           },
//           body: jsonEncode({
//             'name': _nameController.text.trim(),
//             'email': _emailController.text.trim(),
//             'password': _passwordController.text,
//             'password_confirmation':
//                 _confirmedPasswordController.text, // Nécessaire pour Laravel
//           }),
//         );

//         print(
//           'DEBUG: Réponse Laravel (register) status: ${response.statusCode}',
//         );
//         print('DEBUG: Réponse Laravel (register) body: ${response.body}');

//         if (response.statusCode == 201) {
//           // 201 Created est typique pour une nouvelle ressource
//           _showSuccessSnackBar(
//             'Compte créé avec succès ! Vous pouvez maintenant vous connecter.',
//           );
//           print(
//             'DEBUG: Inscription Laravel réussie. Redirection vers LoginPage.',
//           );

//           // Redirection vers LoginPage après succès
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const LoginPage()),
//           );
//         } else {
//           // Gérer les erreurs de validation ou autres erreurs du serveur Laravel
//           final Map<String, dynamic> errorData = json.decode(response.body);
//           String errorMessage = 'Erreur lors de l\'inscription.';

//           if (errorData.containsKey('message')) {
//             errorMessage = errorData['message'];
//           }
//           if (errorData.containsKey('errors')) {
//             // Si Laravel renvoie des erreurs de validation détaillées
//             final Map<String, dynamic> errors = errorData['errors'];
//             errors.forEach((key, value) {
//               errorMessage +=
//                   '\n- ${value[0]}'; // Affiche la première erreur pour chaque champ
//             });
//           }
//           _showErrorSnackBar(errorMessage);
//           print('DEBUG: Erreur d\'inscription Laravel: $errorMessage');
//         }
//       } catch (e) {
//         // Erreurs générales (réseau, JSON, etc.)
//         _showErrorSnackBar(
//           'Une erreur inattendue est survenue : ${e.toString()}',
//         );
//         print('DEBUG: Erreur générale lors de l\'inscription: $e');
//       } finally {
//         // Masquer l'indicateur de chargement
//         // Navigator.of(context).pop();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               height: screenHeight * .21,
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(50),
//                   topRight: Radius.circular(50),
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//                 child: Image.asset(
//                   'assets/images/img02.jpg',
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Join the Archilles Community!',
//                   style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Start your journey to finding the perfect property.',
//                   style: TextStyle(fontSize: 12),
//                 ),
//                 const SizedBox(height: 20),
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(18.0),
//                     color: Colors.white,
//                   ),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         TextFormField(
//                           controller: _nameController,
//                           style: const TextStyle(color: Colors.purple),
//                           decoration: _inputDecoration('Username'),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Veuillez entrer votre nom d\'utilisateur.';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 15),
//                         TextFormField(
//                           controller: _emailController,
//                           keyboardType: TextInputType.emailAddress,
//                           style: const TextStyle(color: Colors.purple),
//                           decoration: _inputDecoration('username@gmail.com'),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Veuillez entrer votre email.';
//                             }
//                             if (!RegExp(
//                               r'^[^@]+@[^@]+\.[^@]+',
//                             ).hasMatch(value)) {
//                               return 'Veuillez entrer un email valide.';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 15),
//                         TextFormField(
//                           controller: _passwordController,
//                           obscureText: _obscureTextPassword,
//                           decoration: _inputDecoration(
//                             'Password',
//                             isPassword: true,
//                             obscureText: _obscureTextPassword,
//                             toggleObscureText: () {
//                               setState(() {
//                                 _obscureTextPassword = !_obscureTextPassword;
//                               });
//                             },
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Veuillez entrer votre mot de passe.';
//                             }
//                             if (value.length < 8) {
//                               // Laravel Sanctum par défaut exige 8 caractères
//                               return 'Le mot de passe doit contenir au moins 8 caractères.';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 15),
//                         TextFormField(
//                           controller: _confirmedPasswordController,
//                           obscureText: _obscureTextConfirmPassword,
//                           decoration: _inputDecoration(
//                             'Confirmer le mot de passe',
//                             isPassword: true,
//                             obscureText: _obscureTextConfirmPassword,
//                             toggleObscureText: () {
//                               setState(() {
//                                 _obscureTextConfirmPassword =
//                                     !_obscureTextConfirmPassword;
//                               });
//                             },
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Veuillez confirmer votre mot de passe.';
//                             }
//                             if (value != _passwordController.text) {
//                               return 'Les mots de passe ne correspondent pas.';
//                             }
//                             return null;
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 25),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed:
//                     _registerWithLaravel, // ✅ Appel de la nouvelle fonction d'inscription
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xffFFD055),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   'Let’s Get Started',
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 25),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'already have account? ',
//                   style: TextStyle(fontSize: 12, color: Colors.black),
//                 ),
//                 Text.rich(
//                   TextSpan(
//                     text: ' log into your account now!',
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: Color(0xffFFD055),
//                     ),
//                     recognizer:
//                         TapGestureRecognizer()
//                           ..onTap = () {
//                             Navigator.pop(context);
//                           },
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// Ancien code pour l'authentification avec firebase

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:kunft/pages/auth/login_page.dart'; // Import de LoginPage

// // Définissez votre URL de base d'API ici ou importez-la depuis un fichier de constantes si vous en avez un.
// const String API_BASE_URL = 'http://127.0.0.1:8000';

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});

//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   // Déplacez les contrôleurs et la clé de formulaire dans l'état et utilisez '_' pour les rendre privés
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmedPasswordController =
//       TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   // Pour gérer l'état de visibilité du mot de passe (si vous voulez l'implémenter ici aussi)
//   bool _obscureTextPassword = true;
//   bool _obscureTextConfirmPassword = true;

//   @override
//   void dispose() {
//     // Nettoyez les contrôleurs quand le widget est supprimé
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmedPasswordController.dispose();
//     super.dispose();
//   }

//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.green),
//     );
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.red),
//     );
//   }

//   // Fonction utilitaire pour la décoration des champs de texte
//   InputDecoration _inputDecoration(
//     String label, {
//     bool isPassword = false,
//     bool obscureText = false,
//     VoidCallback? toggleObscureText,
//   }) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: const TextStyle(fontSize: 12),
//       filled: true,
//       fillColor: const Color(0xfff7f7f7),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Color(0xffd3d3d3)),
//       ),
//       focusedBorder: OutlineInputBorder(
//         // Style pour le focus
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Color(0xffFFD055), width: 2),
//       ),
//       suffixIcon:
//           isPassword
//               ? IconButton(
//                 icon: Icon(
//                   obscureText ? Icons.visibility_off : Icons.visibility,
//                   color: Colors.grey,
//                 ),
//                 onPressed: toggleObscureText,
//               )
//               : null,
//     );
//   }

//   // --- FONCTION PRINCIPALE D'INSCRIPTION ET SYNCHRONISATION LARAVEL ---
//   Future<void> _firebaseRegister() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       try {
//         // 1. Création du compte Firebase
//         print('DEBUG: Tentative de création de compte Firebase...');
//         UserCredential userCredential = await FirebaseAuth.instance
//             .createUserWithEmailAndPassword(
//               email: _emailController.text.trim(),
//               password: _passwordController.text,
//             ); // Pas de trim sur le mot de passe avant Firebase

//         final User? firebaseUser = userCredential.user;

//         if (firebaseUser != null) {
//           final uid = firebaseUser.uid;
//           final name = _nameController.text.trim();
//           final email = _emailController.text.trim();

//           print('DEBUG: Compte Firebase créé. UID: $uid, Email: $email');

//           // 2. Envoi des données vers ton backend Laravel pour enregistrement
//           print('DEBUG: Envoi des données utilisateur à Laravel...');
//           final response = await http.post(
//             Uri.parse(
//               '$API_BASE_URL/api/register-from-firebase',
//             ), // Assurez-vous que cette route existe
//             headers: {
//               'Content-Type': 'application/json',
//               'Accept': 'application/json',
//             },
//             body: jsonEncode({
//               'firebase_uid': uid,
//               'name': name,
//               'email': email,
//               // Vous pouvez ajouter d'autres champs si votre API les attend (ex: 'phone')
//             }),
//           );

//           print(
//             'DEBUG: Réponse Laravel (register-from-firebase) status: ${response.statusCode}',
//           );
//           print(
//             'DEBUG: Réponse Laravel (register-from-firebase) body: ${response.body}',
//           );

//           if (response.statusCode == 201 || response.statusCode == 200) {
//             _showSuccessSnackBar('Compte créé et synchronisé avec succès !');
//             print(
//               'DEBUG: Synchronisation Laravel réussie. Redirection vers LoginPage.',
//             );

//             // ✅ Redirection vers LoginPage après succès
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const LoginPage(),
//               ), // Utilisation de const
//             );
//           } else {
//             // Si Laravel renvoie une erreur après création Firebase, il faut gérer
//             // potentiellement la suppression de l'utilisateur Firebase si l'enregistrement Laravel échoue.
//             // C'est un scénario de "rollback" plus avancé. Pour l'instant, on affiche l'erreur.
//             _showErrorSnackBar(
//               'Erreur côté serveur lors de la synchronisation: ${response.body}',
//             );
//             print('DEBUG: Erreur de synchronisation Laravel: ${response.body}');
//           }
//         } else {
//           _showErrorSnackBar(
//             'Erreur: Utilisateur Firebase non retourné après création.',
//           );
//           print(
//             'DEBUG: Firebase user is null after createUserWithEmailAndPassword.',
//           );
//         }
//       } on FirebaseAuthException catch (e) {
//         String errorMessage;
//         if (e.code == 'email-already-in-use') {
//           errorMessage = 'Cet email est déjà utilisé par un autre compte.';
//         } else if (e.code == 'invalid-email') {
//           errorMessage = 'L\'adresse email est mal formatée.';
//         } else if (e.code == 'weak-password') {
//           errorMessage = 'Le mot de passe est trop faible.';
//         } else {
//           errorMessage = 'Erreur Firebase: ${e.message}';
//         }
//         _showErrorSnackBar("Échec de l'inscription Firebase : $errorMessage");
//         print('DEBUG: FirebaseAuthException: $e');
//       } catch (e) {
//         // Erreurs générales (réseau, JSON, etc.)
//         _showErrorSnackBar(
//           'Une erreur inattendue est survenue : ${e.toString()}',
//         );
//         print('DEBUG: Erreur générale lors de l\'inscription: $e');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(
//                   30,
//                 ), // Ajusté à 30 pour correspondre à ClipRRect
//               ),
//               height: screenHeight * .21,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(50),
//                   topRight: Radius.circular(50),
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//                 child: Image.asset(
//                   'assets/images/img02.jpg',
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   // Ajout de const
//                   'Join the Archilles Community!',
//                   style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
//                 ),
//                 const SizedBox(height: 16), // Ajout de const
//                 const Text(
//                   // Ajout de const
//                   'Start your journey to finding the perfect property.',
//                   style: TextStyle(fontSize: 12),
//                 ),
//                 const SizedBox(height: 20), // Ajout de const
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(18.0),
//                     color: Colors.white,
//                   ),
//                   child: Form(
//                     key: _formKey, // Utilisez la clé de l'état
//                     child: Column(
//                       children: [
//                         TextFormField(
//                           controller:
//                               _nameController, // Utilisez le contrôleur de l'état
//                           style: const TextStyle(
//                             color: Colors.purple,
//                           ), // Ajout de const
//                           decoration: _inputDecoration('Username'),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Veuillez entrer votre nom d\'utilisateur.';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 15), // Ajout de const
//                         TextFormField(
//                           controller:
//                               _emailController, // Utilisez le contrôleur de l'état
//                           keyboardType:
//                               TextInputType
//                                   .emailAddress, // Type de clavier approprié
//                           style: const TextStyle(
//                             color: Colors.purple,
//                           ), // Ajout de const
//                           decoration: _inputDecoration('username@gmail.com'),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Veuillez entrer votre email.';
//                             }
//                             if (!RegExp(
//                               r'^[^@]+@[^@]+\.[^@]+',
//                             ).hasMatch(value)) {
//                               return 'Veuillez entrer un email valide.';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 15), // Ajout de const
//                         TextFormField(
//                           controller:
//                               _passwordController, // Utilisez le contrôleur de l'état
//                           obscureText:
//                               _obscureTextPassword, // Utilisez l'état de visibilité
//                           decoration: _inputDecoration(
//                             'Password',
//                             isPassword: true,
//                             obscureText: _obscureTextPassword,
//                             toggleObscureText: () {
//                               setState(() {
//                                 _obscureTextPassword = !_obscureTextPassword;
//                               });
//                             },
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Veuillez entrer votre mot de passe.';
//                             }
//                             if (value.length < 6) {
//                               return 'Le mot de passe doit contenir au moins 6 caractères.';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 15), // Ajout de const
//                         TextFormField(
//                           controller:
//                               _confirmedPasswordController, // Utilisez le contrôleur de l'état
//                           obscureText:
//                               _obscureTextConfirmPassword, // Utilisez l'état de visibilité
//                           decoration: _inputDecoration(
//                             'Confirmer le mot de passe',
//                             isPassword: true,
//                             obscureText: _obscureTextConfirmPassword,
//                             toggleObscureText: () {
//                               setState(() {
//                                 _obscureTextConfirmPassword =
//                                     !_obscureTextConfirmPassword;
//                               });
//                             },
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Veuillez confirmer votre mot de passe.';
//                             }
//                             if (value != _passwordController.text) {
//                               // Compare avec le contrôleur du mot de passe
//                               return 'Les mots de passe ne correspondent pas.';
//                             }
//                             return null;
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 25), // Ajout de const
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed:
//                     _firebaseRegister, // Appel de la fonction d'inscription
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xffFFD055), // Ajout de const
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 16,
//                   ), // Ajout de const
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: const Text(
//                   // Ajout de const
//                   'Let’s Get Started',
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 25), // Ajout de const
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   // Ajout de const
//                   'already have account? ',
//                   style: TextStyle(fontSize: 12, color: Colors.black),
//                 ),
//                 Text.rich(
//                   TextSpan(
//                     text: ' log into your account now!',
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: Color(0xffFFD055),
//                     ), // Ajout de const
//                     recognizer:
//                         TapGestureRecognizer()
//                           ..onTap = () {
//                             // Utilisation de Navigator.pop pour revenir à la page précédente (LoginPage)
//                             // ou Navigator.pushReplacement si vous voulez une nouvelle instance
//                             Navigator.pop(
//                               context,
//                             ); // Revenir à la LoginPage existante
//                             // Ou si vous préférez une nouvelle instance de LoginPage:
//                             // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
//                           },
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// Ancien code ci bas 

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:kunft/pages/home_screen.dart';
// // import 'package:immo/pages/home_screen.dart';

// import 'package:http/http.dart' as http;
// import 'dart:convert';

// Future<void> register(
//   String name,
//   String email,
//   String password,
//   String confirmPassword,
// ) async {
//   final response = await http.post(
//     Uri.parse('http://127.0.0.1:8000/api/register'),
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode({
//       'name': name,
//       'email': email,
//       'password': password,
//       'password_confirmation': confirmPassword,
//     }),
//   );

//   if (response.statusCode == 201) {
//     final data = jsonDecode(response.body);
//     final token = data['token'];
//     print('Inscription réussie : $token');
//   } else {
//     print('Erreur : ${response.body}');
//   }
// }

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});

//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confimedPasswordController = TextEditingController();

//   final formKey = GlobalKey<FormState>();

//   // Fonction pour afficher le SnackBar
//   // void showSuccessSnackBar() {
//   //   ScaffoldMessenger.of(context).showSnackBar(
//   //     SnackBar(
//   //       content: Text('Création de compte réussie!'),
//   //       backgroundColor: Colors.green,
//   //     ),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       // appBar: AppBar(),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//                 height: screenHeight * .21,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(50),
//                     topRight: Radius.circular(50),
//                     bottomLeft: Radius.circular(30),
//                     bottomRight: Radius.circular(30),
//                   ),
//                   child: Image.asset(
//                     'assets/images/img02.jpg',
//                     fit: BoxFit.cover,
//                     width: double.infinity,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 24),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Join the Archilles Community!',
//                     style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'Start your journey to finding the perfect property.',
//                     style: TextStyle(fontSize: 12),
//                   ),
//                   SizedBox(height: 20),
//                   // Début formulaire
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(18.0),
//                       color: Colors.white,
//                     ),
//                     child: Form(
//                       key: formKey,
//                       child: Column(
//                         children: [
//                           TextFormField(
//                             controller: nameController,
//                             style: TextStyle(color: Colors.purple),
//                             decoration: InputDecoration(
//                               // prefixIcon: Icon(Icons.person, color: Colors.grey),
//                               labelText: 'Username',
//                               labelStyle: TextStyle(fontSize: 12),
//                               filled: true,
//                               fillColor: Color(0xfff7f7f7),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                                 borderSide: BorderSide(
//                                   color: Color(0xffd3d3d3),
//                                 ),
//                               ),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your username';
//                               }
//                               return null;
//                             },
//                           ),
//                           SizedBox(height: 15),

//                           TextFormField(
//                             controller: emailController,
//                             style: TextStyle(color: Colors.purple),
//                             decoration: InputDecoration(
//                               // prefixIcon: Icon(Icons.email, color: Colors.grey),
//                               labelText: 'userneame@gmail.com',
//                               labelStyle: TextStyle(fontSize: 12),
//                               filled: true,
//                               fillColor: Color(0xfff7f7f7),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                                 borderSide: BorderSide(
//                                   color: Color(0xffd3d3d3),
//                                 ),
//                               ),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your email';
//                               }
//                               return null;
//                             },
//                           ),

//                           SizedBox(height: 15),

//                           Row(
//                             children: [
//                               Expanded(
//                                 child: TextFormField(
//                                   controller: passwordController,
//                                   obscureText: true,
//                                   decoration: InputDecoration(
//                                     // prefixIcon: Icon(Icons.lock, color: Colors.grey),
//                                     labelText: 'Password',
//                                     labelStyle: TextStyle(fontSize: 12),
//                                     filled: true,
//                                     fillColor: Color(0xfff7f7f7),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       borderSide: BorderSide(
//                                         color: Color(0xffd3d3d3),
//                                       ),
//                                     ),
//                                   ),
//                                   validator: (value) {
//                                     if (value == null || value.isEmpty) {
//                                       return 'Please enter your password';
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                               ),
//                               SizedBox(width: 15),

//                               Icon(Icons.visibility_off),
//                             ],
//                           ),

//                           // Ancien code obselete
//                           // Row(
//                           //   children: [
//                           //     Expanded(
//                           //       child: TextFormField(
//                           //         controller: confimedPasswordController,
//                           //         obscureText: true,
//                           //         decoration: InputDecoration(
//                           //           // prefixIcon: Icon(Icons.lock, color: Colors.grey),
//                           //           labelText: 'Password',
//                           //           labelStyle: TextStyle(fontSize: 12),
//                           //           filled: true,
//                           //           fillColor: Color(0xfff7f7f7),
//                           //           enabledBorder: OutlineInputBorder(
//                           //             borderRadius: BorderRadius.circular(12),
//                           //             borderSide: BorderSide(
//                           //               color: Color(0xffd3d3d3),
//                           //             ),
//                           //           ),
//                           //         ),
//                           //         validator: (value) {
//                           //           if (value == null || value.isEmpty) {
//                           //             return 'Please confim your password';
//                           //           }
//                           //           return null;
//                           //         },
//                           //       ),
//                           //     ),
//                           //   ],
//                           // ),
//                           SizedBox(height: 15),
//                           // Nouveau code okay
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: TextFormField(
//                                   controller: confimedPasswordController,
//                                   obscureText: true,
//                                   decoration: InputDecoration(
//                                     // prefixIcon: Icon(Icons.lock, color: Colors.grey), // Si vous voulez une icône
//                                     labelText:
//                                         'Confirmer le mot de passe', // Texte plus explicite
//                                     labelStyle: TextStyle(fontSize: 12),
//                                     filled: true,
//                                     fillColor: Color(0xfff7f7f7),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                       borderSide: BorderSide(
//                                         color: Color(0xffd3d3d3),
//                                       ),
//                                     ),
//                                   ),
//                                   validator: (value) {
//                                     if (value == null || value.isEmpty) {
//                                       return 'Veuillez confirmer votre mot de passe.'; // Message plus français
//                                     }
//                                     // COMPARISON WITH THE ORIGINAL PASSWORD FIELD
//                                     if (value != passwordController.text) {
//                                       // <<< C'EST ÇA L'AJOUT IMPORTANT
//                                       return 'Les mots de passe ne correspondent pas.';
//                                     }
//                                     return null; // La validation est réussie
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               SizedBox(height: 25),
//               //  Ancien code
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     if (formKey.currentState?.validate() ?? false) {
//                       await register(
//                         nameController.text,
//                         emailController.text,
//                         passwordController.text,
//                         passwordController.text,
//                       );
//                       // showSuccessSnackBar();
//                     }
//                   },

//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xffFFD055),
//                     padding: EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: Text(
//                     'Let’s Get Started',
//                     style: TextStyle(color: Colors.black),
//                   ),
//                 ),
//               ),

//               //
//               SizedBox(height: 12),

//               SizedBox(height: 25),

//               // Row(
//               //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               //   children: [
//               //     Text(
//               //       'or continue with',
//               //       style: TextStyle(fontSize: 12, color: Colors.black),
//               //     ),
//               //     Text.rich(
//               //       TextSpan(
//               //         text: 'Test Home page',
//               //         style: TextStyle(
//               //           fontSize: 12,
//               //           fontWeight: FontWeight.bold,
//               //           color: Colors.orange,
//               //           // fontWeight: FontWeight.bold,
//               //         ),
//               //         recognizer:
//               //             TapGestureRecognizer()
//               //               ..onTap = () {
//               //                 Navigator.push(
//               //                   context,
//               //                   MaterialPageRoute(
//               //                     builder: (context) => HomeScreen(),
//               //                   ),
//               //                 );
//               //               },
//               //       ),
//               //     ),
//               //   ],
//               // ),
//               SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'already have account? ',
//                     style: TextStyle(fontSize: 12, color: Colors.black),
//                   ),
//                   Text.rich(
//                     TextSpan(
//                       text: ' log into your account now!',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Color(0xffFFD055),
//                         // fontWeight: FontWeight.bold,
//                       ),
//                       recognizer:
//                           TapGestureRecognizer()
//                             ..onTap = () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => HomeScreen(),
//                                 ),
//                               );
//                             },
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
