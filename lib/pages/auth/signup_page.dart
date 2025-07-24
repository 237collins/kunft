import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kunft/pages/auth/login_page.dart'; // Import de LoginPage

// Définissez votre URL de base d'API ici ou importez-la depuis un fichier de constantes si vous en avez un.
const String API_BASE_URL = 'http://127.0.0.1:8000';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Déplacez les contrôleurs et la clé de formulaire dans l'état et utilisez '_' pour les rendre privés
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmedPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Pour gérer l'état de visibilité du mot de passe (si vous voulez l'implémenter ici aussi)
  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  @override
  void dispose() {
    // Nettoyez les contrôleurs quand le widget est supprimé
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmedPasswordController.dispose();
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

  // Fonction utilitaire pour la décoration des champs de texte
  InputDecoration _inputDecoration(
    String label, {
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? toggleObscureText,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 12),
      filled: true,
      fillColor: const Color(0xfff7f7f7),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xffd3d3d3)),
      ),
      focusedBorder: OutlineInputBorder(
        // Style pour le focus
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xffFFD055), width: 2),
      ),
      suffixIcon:
          isPassword
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

  // --- FONCTION PRINCIPALE D'INSCRIPTION ET SYNCHRONISATION LARAVEL ---
  Future<void> _firebaseRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // 1. Création du compte Firebase
        print('DEBUG: Tentative de création de compte Firebase...');
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ); // Pas de trim sur le mot de passe avant Firebase

        final User? firebaseUser = userCredential.user;

        if (firebaseUser != null) {
          final uid = firebaseUser.uid;
          final name = _nameController.text.trim();
          final email = _emailController.text.trim();

          print('DEBUG: Compte Firebase créé. UID: $uid, Email: $email');

          // 2. Envoi des données vers ton backend Laravel pour enregistrement
          print('DEBUG: Envoi des données utilisateur à Laravel...');
          final response = await http.post(
            Uri.parse(
              '$API_BASE_URL/api/register-from-firebase',
            ), // Assurez-vous que cette route existe
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'firebase_uid': uid,
              'name': name,
              'email': email,
              // Vous pouvez ajouter d'autres champs si votre API les attend (ex: 'phone')
            }),
          );

          print(
            'DEBUG: Réponse Laravel (register-from-firebase) status: ${response.statusCode}',
          );
          print(
            'DEBUG: Réponse Laravel (register-from-firebase) body: ${response.body}',
          );

          if (response.statusCode == 201 || response.statusCode == 200) {
            _showSuccessSnackBar('Compte créé et synchronisé avec succès !');
            print(
              'DEBUG: Synchronisation Laravel réussie. Redirection vers LoginPage.',
            );

            // ✅ Redirection vers LoginPage après succès
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ), // Utilisation de const
            );
          } else {
            // Si Laravel renvoie une erreur après création Firebase, il faut gérer
            // potentiellement la suppression de l'utilisateur Firebase si l'enregistrement Laravel échoue.
            // C'est un scénario de "rollback" plus avancé. Pour l'instant, on affiche l'erreur.
            _showErrorSnackBar(
              'Erreur côté serveur lors de la synchronisation: ${response.body}',
            );
            print('DEBUG: Erreur de synchronisation Laravel: ${response.body}');
          }
        } else {
          _showErrorSnackBar(
            'Erreur: Utilisateur Firebase non retourné après création.',
          );
          print(
            'DEBUG: Firebase user is null after createUserWithEmailAndPassword.',
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'email-already-in-use') {
          errorMessage = 'Cet email est déjà utilisé par un autre compte.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'L\'adresse email est mal formatée.';
        } else if (e.code == 'weak-password') {
          errorMessage = 'Le mot de passe est trop faible.';
        } else {
          errorMessage = 'Erreur Firebase: ${e.message}';
        }
        _showErrorSnackBar("Échec de l'inscription Firebase : $errorMessage");
        print('DEBUG: FirebaseAuthException: $e');
      } catch (e) {
        // Erreurs générales (réseau, JSON, etc.)
        _showErrorSnackBar(
          'Une erreur inattendue est survenue : ${e.toString()}',
        );
        print('DEBUG: Erreur générale lors de l\'inscription: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  30,
                ), // Ajusté à 30 pour correspondre à ClipRRect
              ),
              height: screenHeight * .21,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'assets/images/img02.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  // Ajout de const
                  'Join the Archilles Community!',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16), // Ajout de const
                const Text(
                  // Ajout de const
                  'Start your journey to finding the perfect property.',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 20), // Ajout de const
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.0),
                    color: Colors.white,
                  ),
                  child: Form(
                    key: _formKey, // Utilisez la clé de l'état
                    child: Column(
                      children: [
                        TextFormField(
                          controller:
                              _nameController, // Utilisez le contrôleur de l'état
                          style: const TextStyle(
                            color: Colors.purple,
                          ), // Ajout de const
                          decoration: _inputDecoration('Username'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre nom d\'utilisateur.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15), // Ajout de const
                        TextFormField(
                          controller:
                              _emailController, // Utilisez le contrôleur de l'état
                          keyboardType:
                              TextInputType
                                  .emailAddress, // Type de clavier approprié
                          style: const TextStyle(
                            color: Colors.purple,
                          ), // Ajout de const
                          decoration: _inputDecoration('username@gmail.com'),
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
                        const SizedBox(height: 15), // Ajout de const
                        TextFormField(
                          controller:
                              _passwordController, // Utilisez le contrôleur de l'état
                          obscureText:
                              _obscureTextPassword, // Utilisez l'état de visibilité
                          decoration: _inputDecoration(
                            'Password',
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
                            if (value.length < 6) {
                              return 'Le mot de passe doit contenir au moins 6 caractères.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15), // Ajout de const
                        TextFormField(
                          controller:
                              _confirmedPasswordController, // Utilisez le contrôleur de l'état
                          obscureText:
                              _obscureTextConfirmPassword, // Utilisez l'état de visibilité
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
                              // Compare avec le contrôleur du mot de passe
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
            const SizedBox(height: 25), // Ajout de const
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _firebaseRegister, // Appel de la fonction d'inscription
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffFFD055), // Ajout de const
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ), // Ajout de const
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  // Ajout de const
                  'Let’s Get Started',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 25), // Ajout de const
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  // Ajout de const
                  'already have account? ',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                Text.rich(
                  TextSpan(
                    text: ' log into your account now!',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xffFFD055),
                    ), // Ajout de const
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            // Utilisation de Navigator.pop pour revenir à la page précédente (LoginPage)
                            // ou Navigator.pushReplacement si vous voulez une nouvelle instance
                            Navigator.pop(
                              context,
                            ); // Revenir à la LoginPage existante
                            // Ou si vous préférez une nouvelle instance de LoginPage:
                            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                          },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



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
