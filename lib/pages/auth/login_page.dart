// Nouveau code de connexion avec Telephone

import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kunft/provider/ReservationProvider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import 'package:kunft/pages/auth/signup_page.dart';
import 'package:kunft/pages/home_screen.dart';
import 'package:kunft/provider/UserProvider.dart'; // Assurez-vous que le chemin est correct
import 'package:kunft/widget/login_message/sliding_text_kit.dart';

const String API_BASE_URL = 'http://127.0.0.1:8000';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  bool _isLoading = false;
  bool _rememberMe = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {Color color = Colors.green}) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  // --- Connexion avec Laravel via téléphone ---
  Future<void> _loginWithLaravel() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$API_BASE_URL/api/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'phone': _phoneController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        if (data.containsKey('token') && data.containsKey('user')) {
          final laravelToken = data['token'];
          final userData = data['user'];

          final userProvider = Provider.of<UserProvider>(
            context,
            listen: false,
          );

          if (_rememberMe) {
            await userProvider.saveUserAndToken(laravelToken, userData);
          } else {
            userProvider.setTokenAndUser(laravelToken, userData);
          }

          // ✅ NOUVEAU: Récupérer le ReservationProvider
          final reservationProvider = Provider.of<ReservationProvider>(
            context,
            listen: false,
          );

          // ✅ NOUVEAU: Lancer la récupération des réservations de l'utilisateur
          await reservationProvider.fetchUserReservations(
            authToken: laravelToken,
          );

          _showSnackBar("Connexion réussie !");

          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        } else {
          _showSnackBar('Réponse du serveur incomplète.', color: Colors.red);
        }
      } else {
        String errorMessage = 'Erreur lors de la connexion.';
        if (data.containsKey('message')) {
          errorMessage = data['message'];
        } else if (data.containsKey('errors')) {
          final errors = data['errors'] as Map<String, dynamic>;
          errorMessage +=
              '\n' + errors.values.map((e) => '- ${e[0]}').join('\n');
        }
        _showSnackBar(errorMessage, color: Colors.red);
      }
    } catch (e) {
      _showSnackBar(
        'Une erreur inattendue est survenue: ${e.toString()}',
        color: Colors.red,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
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
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              height: screenHeight * .3,
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
            const SizedBox(height: 30),
            const Text(
              'Ravi de te revoir!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const SlidingTextKit(),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Téléphone',
                      labelStyle: const TextStyle(fontSize: 12),
                      filled: true,
                      fillColor: const Color(0xfff7f7f7),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xffd3d3d3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0x80ffd055),
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre numéro de téléphone.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      labelStyle: const TextStyle(fontSize: 12),
                      filled: true,
                      fillColor: const Color(0xfff7f7f7),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xffd3d3d3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0x50ffd055),
                          width: 2,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
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
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _rememberMe = !_rememberMe;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        _rememberMe
                            ? LucideIcons.checkSquare
                            : LucideIcons.square,
                        color: _rememberMe
                            ? Colors.yellow.shade700
                            : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      const Text('Se souvenir de moi'),
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: 'Mot de passe oublié ?',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.yellow.shade700,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Votre logique pour la réinitialisation du mot de passe
                      },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _loginWithLaravel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffFFD055),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Commençons',
                        style: TextStyle(color: Colors.black),
                      ),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Vous n\'avez pas de compte? ',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                Text.rich(
                  TextSpan(
                    text: ' Enregistrez-vous ici !',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.yellow.shade700,
                      fontWeight: FontWeight.w700,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ),
                        );
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

//  Connexion avec LAravel UserProvider email

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'dart:convert';

// import 'package:kunft/pages/auth/signup_page.dart';
// import 'package:kunft/pages/home_screen.dart'; // Home page
// import 'package:kunft/provider/UserProvider.dart'; // Importez votre UserProvider

// // Define your API base URL here or import it from a constants file if you have one.
// const String API_BASE_URL =
//     'http://127.0.0.1:8000'; // Assurez-vous que c'est l'URL correcte de votre backend Laravel

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   bool _obscureText = true;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
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

//   // --- FONCTION PRINCIPALE : Connexion avec Laravel ---
//   Future<void> _loginWithLaravel() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       try {
//         print('DEBUG: Tentative de connexion avec Laravel...');
//         final response = await http.post(
//           Uri.parse('$API_BASE_URL/api/login'), // Endpoint de connexion Laravel
//           headers: {
//             'Content-Type': 'application/json',
//             'Accept': 'application/json',
//           },
//           body: jsonEncode({
//             'email': _emailController.text.trim(),
//             'password': _passwordController.text.trim(),
//           }),
//         );

//         print('DEBUG: Réponse Laravel (login) status: ${response.statusCode}');
//         print('DEBUG: Réponse Laravel (login) body: ${response.body}');

//         if (response.statusCode == 200) {
//           final data = jsonDecode(response.body);
//           final laravelToken = data['token'];
//           final userData = data['user'];

//           if (laravelToken != null &&
//               laravelToken.isNotEmpty &&
//               userData != null) {
//             // Accède au UserProvider via Provider
//             final userProvider = Provider.of<UserProvider>(
//               context,
//               listen: false,
//             );

//             // Sauvegarde le token et les infos utilisateur via le provider
//             await userProvider.saveUserAndToken(laravelToken, userData);

//             print('DEBUG: Laravel token and user data saved to UserProvider.');
//             _showSuccessSnackBar("Connexion réussie !");

//             // ✅ REDIRECTION VERS HOMESCREEN
//             print('DEBUG: Navigating to HomeScreen...');
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => const HomeScreen()),
//             );
//           } else {
//             print(
//               'DEBUG: Réponse Laravel était 200, mais les données nécessaires sont manquantes ("token" ou "user").',
//             );
//             _showErrorSnackBar(
//               'Le backend Laravel n\'a pas renvoyé les données de connexion complètes.',
//             );
//           }
//         } else {
//           final Map<String, dynamic> errorData = json.decode(response.body);
//           String errorMessage = 'Erreur lors de la connexion.';

//           if (errorData.containsKey('message')) {
//             errorMessage = errorData['message'];
//           }
//           if (errorData.containsKey('errors')) {
//             final Map<String, dynamic> errors = errorData['errors'];
//             errors.forEach((key, value) {
//               errorMessage +=
//                   '\n- ${value[0]}'; // Affiche la première erreur pour chaque champ
//             });
//           }
//           _showErrorSnackBar(errorMessage);
//           print('DEBUG: Erreur de connexion Laravel: $errorMessage');
//         }
//       } catch (e) {
//         _showErrorSnackBar(
//           'Une erreur inattendue est survenue : ${e.toString()}',
//         );
//         print('DEBUG: Erreur générale lors de la connexion: $e');
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
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(50),
//                   topRight: Radius.circular(50),
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//               ),
//               height: screenHeight * .3,
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
//             const SizedBox(height: 30),
//             const Text(
//               'Welcome Back!',
//               style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Your dream property is just a login away.',
//               style: TextStyle(fontSize: 12),
//             ),
//             const SizedBox(height: 20),
//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: _emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     style: const TextStyle(color: Colors.purple),
//                     decoration: InputDecoration(
//                       labelText: 'username@gmail.com',
//                       labelStyle: const TextStyle(fontSize: 12),
//                       filled: true,
//                       fillColor: const Color(0xfff7f7f7),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(color: Color(0xffd3d3d3)),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(
//                           color: Color(0xffffd055),
//                           width: 2,
//                         ),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Veuillez entrer votre email.';
//                       }
//                       if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                         return 'Veuillez entrer un email valide.';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 15),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextFormField(
//                           controller: _passwordController,
//                           obscureText: _obscureText,
//                           decoration: InputDecoration(
//                             labelText: '********',
//                             labelStyle: const TextStyle(fontSize: 12),
//                             filled: true,
//                             fillColor: const Color(0xfff7f7f7),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: const BorderSide(
//                                 color: Color(0xffd3d3d3),
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: const BorderSide(
//                                 color: Color(0xffffd055),
//                                 width: 2,
//                               ),
//                             ),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _obscureText
//                                     ? Icons.visibility_off
//                                     : Icons.visibility,
//                                 color: Colors.grey,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _obscureText = !_obscureText;
//                                 });
//                               },
//                             ),
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
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 15),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: const [
//                     Icon(Icons.check_box_sharp),
//                     Text('Remember my login info'),
//                   ],
//                 ),
//                 Text.rich(
//                   TextSpan(
//                     text: 'forgot your password?',
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: Color(0xffFFD055),
//                     ),
//                     recognizer:
//                         TapGestureRecognizer()
//                           ..onTap = () {
//                             print('Mot de passe oublié cliqué!');
//                           },
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _loginWithLaravel,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xffFFD055),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(100),
//                   ),
//                 ),
//                 child: const Text(
//                   'Get Logged In',
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 25),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'don\'t have an account? ',
//                   style: TextStyle(fontSize: 12, color: Colors.black),
//                 ),
//                 Text.rich(
//                   TextSpan(
//                     text: 'create your account now!',
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: Color(0xffFFD055),
//                     ),
//                     recognizer:
//                         TapGestureRecognizer()
//                           ..onTap = () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const SignUpPage(),
//                               ),
//                             );
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

// // Nouveau code de connexion avec LAravel

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart'; // ✅ RETIRÉ : Plus besoin de Firebase Auth
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// import 'package:kunft/pages/auth/signup_page.dart';
// import 'package:kunft/pages/home_screen.dart'; // Home page

// // Define your API base URL here or import it from a constants file if you have one.
// const String API_BASE_URL =
//     'http://127.0.0.1:8000'; // Assurez-vous que c'est l'URL correcte de votre backend Laravel

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   bool _obscureText = true;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
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

//   // --- FONCTION PRINCIPALE : Connexion avec Laravel ---
//   Future<void> _loginWithLaravel() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       // Optionnel: Afficher un indicateur de chargement (ex: showDialog avec CircularProgressIndicator)
//       // showDialog(context: context, builder: (context) => Center(child: CircularProgressIndicator()));

//       try {
//         print('DEBUG: Tentative de connexion avec Laravel...');
//         final response = await http.post(
//           Uri.parse('$API_BASE_URL/api/login'), // Endpoint de connexion Laravel
//           headers: {
//             'Content-Type': 'application/json',
//             'Accept': 'application/json',
//           },
//           body: jsonEncode({
//             'email': _emailController.text.trim(),
//             'password': _passwordController.text.trim(),
//           }),
//         );

//         print('DEBUG: Réponse Laravel (login) status: ${response.statusCode}');
//         print('DEBUG: Réponse Laravel (login) body: ${response.body}');

//         if (response.statusCode == 200) {
//           // 200 OK est typique pour une connexion réussie
//           final data = jsonDecode(response.body);
//           final laravelToken = data['token'];

//           if (laravelToken != null && laravelToken.isNotEmpty) {
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.setString(
//               'token',
//               laravelToken,
//             ); // Stocke le token Laravel
//             print(
//               'DEBUG: Laravel token saved to SharedPreferences: ${laravelToken.substring(0, 30)}...',
//             );
//             _showSuccessSnackBar("Connexion réussie !");

//             // ✅ REDIRECTION VERS HOMESCREEN
//             // Puisque Firebase n'est plus utilisé, nous ne passons plus d'objet User de Firebase.
//             // La HomeScreen devra gérer la récupération des infos utilisateur via l'API Laravel si elle en a besoin.
//             print('DEBUG: Navigating to HomeScreen...');
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const HomeScreen(),
//               ), // Passer null ou un objet utilisateur Laravel si HomeScreen l'attend
//             );
//           } else {
//             print(
//               'DEBUG: Réponse Laravel était 200, mais pas de clé "token" ou token vide.',
//             );
//             _showErrorSnackBar(
//               'Le backend Laravel n\'a pas renvoyé de token de connexion.',
//             );
//           }
//         } else {
//           // Gérer les erreurs de validation, identifiants invalides, ou autres erreurs du serveur Laravel
//           final Map<String, dynamic> errorData = json.decode(response.body);
//           String errorMessage = 'Erreur lors de la connexion.';

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
//           print('DEBUG: Erreur de connexion Laravel: $errorMessage');
//         }
//       } catch (e) {
//         // Erreurs générales (réseau, JSON, etc.)
//         _showErrorSnackBar(
//           'Une erreur inattendue est survenue : ${e.toString()}',
//         );
//         print('DEBUG: Erreur générale lors de la connexion: $e');
//       } finally {
//         // Optionnel: Masquer l'indicateur de chargement
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
//               decoration: const BoxDecoration(
//                 // Utilisation de const
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(50),
//                   topRight: Radius.circular(50),
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//               ),
//               height: screenHeight * .3,
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.only(
//                   // Utilisation de const
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
//             const SizedBox(height: 30),
//             const Text(
//               'Welcome Back!',
//               style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Your dream property is just a login away.',
//               style: TextStyle(fontSize: 12),
//             ),
//             const SizedBox(height: 20),
//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: _emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     style: const TextStyle(color: Colors.purple),
//                     decoration: InputDecoration(
//                       labelText: 'username@gmail.com',
//                       labelStyle: const TextStyle(fontSize: 12),
//                       filled: true,
//                       fillColor: const Color(0xfff7f7f7),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(color: Color(0xffd3d3d3)),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(
//                           color: Color(0xffffd055),
//                           width: 2,
//                         ),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Veuillez entrer votre email.';
//                       }
//                       if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                         return 'Veuillez entrer un email valide.';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 15),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextFormField(
//                           controller: _passwordController,
//                           obscureText: _obscureText,
//                           decoration: InputDecoration(
//                             labelText: '********',
//                             labelStyle: const TextStyle(fontSize: 12),
//                             filled: true,
//                             fillColor: const Color(0xfff7f7f7),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: const BorderSide(
//                                 color: Color(0xffd3d3d3),
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: const BorderSide(
//                                 color: Color(0xffffd055),
//                                 width: 2,
//                               ),
//                             ),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _obscureText
//                                     ? Icons.visibility_off
//                                     : Icons.visibility,
//                                 color: Colors.grey,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _obscureText = !_obscureText;
//                                 });
//                               },
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Veuillez entrer votre mot de passe.';
//                             }
//                             // Laravel Sanctum par défaut exige 8 caractères minimum pour l'inscription
//                             // Assurez-vous que cette validation correspond à votre backend si vous l'avez modifiée
//                             if (value.length < 8) {
//                               return 'Le mot de passe doit contenir au moins 8 caractères.';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 15),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: const [
//                     Icon(Icons.check_box_sharp),
//                     Text('Remember my login info'),
//                   ],
//                 ),
//                 Text.rich(
//                   TextSpan(
//                     text: 'forgot your password?',
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: Color(0xffFFD055),
//                     ),
//                     recognizer:
//                         TapGestureRecognizer()
//                           ..onTap = () {
//                             print('Mot de passe oublié cliqué!');
//                           },
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed:
//                     _loginWithLaravel, // ✅ Appel de la nouvelle fonction de connexion
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xffFFD055),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(100),
//                   ),
//                 ),
//                 child: const Text(
//                   'Get Logged In',
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 25),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'don\'t have an account? ',
//                   style: TextStyle(fontSize: 12, color: Colors.black),
//                 ),
//                 Text.rich(
//                   TextSpan(
//                     text: 'create your account now!',
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: Color(0xffFFD055),
//                     ),
//                     recognizer:
//                         TapGestureRecognizer()
//                           ..onTap = () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder:
//                                     (context) =>
//                                         const SignUpPage(), // Utilisation de const
//                               ),
//                             );
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

// Nouveau code avec Auth Actif mais ne communique pas avec Laravel

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:http/http.dart' as http; // Import for HTTP requests
// import 'package:shared_preferences/shared_preferences.dart'; // Import for SharedPreferences
// import 'dart:convert'; // Import for jsonEncode/jsonDecode

// import 'package:kunft/pages/auth/signup_page.dart';
// import 'package:kunft/pages/home_screen.dart'; // Home page

// // Define your API base URL here or import it from a constants file if you have one.
// const String API_BASE_URL = 'http://127.0.0.1:8000';

// // Change: LoginPage must be a StatefulWidget to manage TextEditingController and asynchronous logic
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   // Move controllers and form key into the state
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   // To manage password visibility state
//   bool _obscureText = true;

//   @override
//   void dispose() {
//     // Clean up controllers when the widget is removed
//     _emailController.dispose();
//     _passwordController.dispose();
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

//   // --- FUNCTION: Send Firebase ID Token to Laravel Backend ---
//   Future<void> _sendFirebaseTokenToLaravel(String firebaseIdToken) async {
//     print(
//       'DEBUG: _sendFirebaseTokenToLaravel called with token: ${firebaseIdToken.substring(0, 30)}...',
//     );
//     try {
//       final response = await http.post(
//         Uri.parse('$API_BASE_URL/api/firebase-login'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: jsonEncode({'idToken': firebaseIdToken}),
//       );

//       print('DEBUG: Laravel (firebase-login) status: ${response.statusCode}');
//       print('DEBUG: Laravel (firebase-login) body: ${response.body}');

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final laravelToken = data['token'];

//         if (laravelToken != null && laravelToken.isNotEmpty) {
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           await prefs.setString(
//             'token',
//             laravelToken,
//           ); // Store the Laravel token
//           print(
//             'DEBUG: Laravel token saved to SharedPreferences: ${laravelToken.substring(0, 30)}...',
//           );
//           _showSuccessSnackBar("Connexion Laravel réussie!");

//           // ✅ REDIRECTION TO HOMESCREEN HAPPENS HERE
//           final user = FirebaseAuth.instance.currentUser;
//           if (user != null) {
//             print('DEBUG: Navigating to HomeScreen...');
//             Navigator.pushReplacement(
//               // Use pushReplacement to prevent returning to the login page
//               context,
//               MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
//             );
//           } else {
//             print(
//               'DEBUG: Firebase user is null after successful Laravel sync. This is unexpected.',
//             );
//             _showErrorSnackBar(
//               'Erreur: Utilisateur Firebase non trouvé après synchronisation.',
//             );
//           }
//         } else {
//           print(
//             'DEBUG: Laravel response was 200, but no "token" key or empty token found in body.',
//           );
//           _showErrorSnackBar('Le backend Laravel n\'a pas renvoyé de token.');
//         }
//       } else {
//         print(
//           'DEBUG: Laravel /firebase-login call failed with status ${response.statusCode}: ${response.body}',
//         );
//         _showErrorSnackBar(
//           'Erreur Laravel: ${response.statusCode} - ${response.body}',
//         );
//       }
//     } catch (e) {
//       print('DEBUG: Network or Laravel sync error: $e');
//       _showErrorSnackBar('Erreur réseau ou synchronisation Laravel: $e');
//     }
//   }

//   // --- FUNCTION: Login with Firebase and Synchronize with Laravel ---
//   Future<void> _loginWithFirebase() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       print('DEBUG: Attempting Firebase login...');
//       try {
//         final UserCredential userCredential = await FirebaseAuth.instance
//             .signInWithEmailAndPassword(
//               email:
//                   _emailController.text.trim(), // Use .trim() to remove spaces
//               password: _passwordController.text.trim(),
//             );

//         // Firebase login successful
//         _showSuccessSnackBar("Connexion Firebase réussie!");
//         print(
//           'DEBUG: Firebase login successful for user: ${userCredential.user?.email}',
//         );

//         // Get Firebase ID Token
//         final User? firebaseUser = userCredential.user;
//         if (firebaseUser != null) {
//           String? firebaseIdToken = await firebaseUser.getIdToken();
//           if (firebaseIdToken != null && firebaseIdToken.isNotEmpty) {
//             print('DEBUG: Firebase ID Token obtained. Sending to Laravel...');
//             // Send the ID Token to your Laravel backend to get the Sanctum token
//             await _sendFirebaseTokenToLaravel(firebaseIdToken);
//           } else {
//             print('DEBUG: Failed to get Firebase ID Token or it was empty.');
//             _showErrorSnackBar(
//               'Impossible d\'obtenir le token d\'ID Firebase.',
//             );
//           }
//         } else {
//           print(
//             'DEBUG: Firebase user is null after successful Firebase login. This is unexpected.',
//           );
//           _showErrorSnackBar(
//             'Utilisateur Firebase non trouvé après connexion.',
//           );
//         }
//       } on FirebaseAuthException catch (e) {
//         String errorMessage;
//         if (e.code == 'user-not-found') {
//           errorMessage = 'Aucun utilisateur trouvé pour cet email.';
//         } else if (e.code == 'wrong-password') {
//           errorMessage = 'Mot de passe incorrect.';
//         } else if (e.code == 'invalid-email') {
//           errorMessage = 'Adresse email mal formatée.';
//         } else {
//           errorMessage = 'Erreur Firebase: ${e.message}';
//         }
//         _showErrorSnackBar("Échec de connexion : $errorMessage");
//         print('DEBUG: Firebase Auth Exception: $e');
//       } catch (e) {
//         _showErrorSnackBar(
//           "Une erreur inattendue est survenue : ${e.toString()}",
//         );
//         print('DEBUG: General error during login: $e');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: SingleChildScrollView(
//         // Use SingleChildScrollView to prevent keyboard overflow
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             // Container for the image (might be too tall for some screens, adjust if necessary)
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(50),
//                   topRight: Radius.circular(50),
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//               ),
//               height: screenHeight * .3,
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
//             const SizedBox(height: 30),
//             const Text(
//               'Welcome Back!',
//               style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Your dream property is just a login away.',
//               style: TextStyle(fontSize: 12),
//             ),
//             const SizedBox(height: 20),
//             Form(
//               key: _formKey, // Use the state's key
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: _emailController, // Use the state's controller
//                     keyboardType:
//                         TextInputType.emailAddress, // Appropriate keyboard type
//                     style: const TextStyle(color: Colors.purple),
//                     decoration: InputDecoration(
//                       labelText: 'username@gmail.com',
//                       labelStyle: const TextStyle(fontSize: 12),
//                       filled: true,
//                       fillColor: const Color(0xfff7f7f7),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(color: Color(0xffd3d3d3)),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         // Added focus style
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(
//                           color: Color(0xffffd055),
//                           width: 2,
//                         ),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Veuillez entrer votre email.';
//                       }
//                       if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                         // Email validation
//                         return 'Veuillez entrer un email valide.';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 15),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextFormField(
//                           controller:
//                               _passwordController, // Use the state's controller
//                           obscureText:
//                               _obscureText, // Use the _obscureText state
//                           decoration: InputDecoration(
//                             labelText: '********',
//                             labelStyle: const TextStyle(fontSize: 12),
//                             filled: true,
//                             fillColor: const Color(0xfff7f7f7),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: const BorderSide(
//                                 color: Color(0xffd3d3d3),
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               // Added focus style
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: const BorderSide(
//                                 color: Color(0xffffd055),
//                                 width: 2,
//                               ),
//                             ),
//                             suffixIcon: IconButton(
//                               // Icon to toggle password visibility
//                               icon: Icon(
//                                 _obscureText
//                                     ? Icons.visibility_off
//                                     : Icons.visibility,
//                                 color: Colors.grey,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _obscureText = !_obscureText;
//                                 });
//                               },
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Veuillez entrer votre mot de passe.';
//                             }
//                             if (value.length < 6) {
//                               // Simple password length validation
//                               return 'Le mot de passe doit contenir au moins 6 caractères.';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 15),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: const [
//                     Icon(Icons.check_box_sharp),
//                     Text('Remember my login info'),
//                   ],
//                 ),
//                 Text.rich(
//                   TextSpan(
//                     text: 'forgot your password?',
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: Color(0xffFFD055),
//                     ),
//                     recognizer:
//                         TapGestureRecognizer()
//                           ..onTap = () {
//                             // TODO: Implement navigation to password recovery
//                             print('Mot de passe oublié cliqué!');
//                           },
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _loginWithFirebase, // Call the login function
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xffFFD055),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(100),
//                   ),
//                 ),
//                 child: const Text(
//                   'Get Logged In',
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 25),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'don\'t have an account? ',
//                   style: TextStyle(fontSize: 12, color: Colors.black),
//                 ),
//                 Text.rich(
//                   TextSpan(
//                     text: 'create your account now!',
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: Color(0xffFFD055),
//                     ),
//                     recognizer:
//                         TapGestureRecognizer()
//                           ..onTap = () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => SignUpPage(),
//                               ),
//                             );
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

// print('API Call /logements...');
//   print('Response status : ${response.statusCode}');
//   print('Response body : ${response.body}');

//Ancien code

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:kunft/pages/signup_page.dart';
// // import 'package:immo/pages/sign_up_page.dart';

// import 'package:http/http.dart' as http;
// import 'dart:convert';

// Future<void> login(String email, String password) async {
//   final response = await http.post(
//     Uri.parse('http://127.0.0.1:8000/api/login'), // ← ou ton IP locale
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode({'email': email, 'password': password}),
//   );

//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);
//     final token = data['token'];
//     print('Connexion réussie : $token');
//     // TODO: tu pourras ici stocker le token avec shared_preferences
//   } else {
//     print('Erreur : ${response.body}');
//   }
// }

// class LoginPage extends StatelessWidget {
//   const LoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Déclaration des contrôleurs
//     final screenHeight = MediaQuery.of(context).size.height;
//     // final screenWidth = MediaQuery.of(context).size.width;

//     final emailController = TextEditingController();
//     final passwordController = TextEditingController();
//     final formKey = GlobalKey<FormState>();

//     // Fonction pour afficher le SnackBar
//     void showSuccessSnackBar() {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Connexion réussie!'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     }

//     return Scaffold(
//       // appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(50),
//               ),
//               height: screenHeight * .3,
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
//             SizedBox(height: 30),
//             Column(
//               children: [
//                 Text(
//                   'Welcome Back!',
//                   style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'Your dream property is just a login away.',
//                   style: TextStyle(fontSize: 12),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             // Début formulaire
//             Form(
//               key: formKey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: emailController,
//                     style: TextStyle(color: Colors.purple),
//                     decoration: InputDecoration(
//                       // prefixIcon: Icon(Icons.email, color: Colors.grey),
//                       labelText: 'userneame@gmail.com',
//                       labelStyle: TextStyle(fontSize: 12),
//                       filled: true,
//                       fillColor: Color(0xfff7f7f7),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(color: Color(0xffd3d3d3)),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 15),

//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextFormField(
//                           controller: passwordController,
//                           obscureText: true,
//                           decoration: InputDecoration(
//                             // prefixIcon: Icon(Icons.lock, color: Colors.grey),
//                             labelText: '********',
//                             labelStyle: TextStyle(fontSize: 12),
//                             filled: true,
//                             fillColor: Color(0xfff7f7f7),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: BorderSide(color: Color(0xffd3d3d3)),
//                             ),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your password';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                       SizedBox(width: 15),
//                       Icon(Icons.visibility_off),
//                     ],
//                   ),

//                   SizedBox(height: 15),
//                 ],
//               ),
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.check_box_sharp),
//                     Text('Remember my login info '),
//                   ],
//                 ),
//                 Text.rich(
//                   TextSpan(
//                     text: ' forgot your password?',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Color(0xffFFD055),
//                       // fontWeight: FontWeight.bold,
//                     ),
//                     recognizer:
//                         TapGestureRecognizer()
//                           ..onTap = () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => SignUpPage(),
//                               ),
//                             );
//                           },
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   login(emailController.text, passwordController.text);
//                   if (formKey.currentState?.validate() ?? false) {
//                     showSuccessSnackBar();
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xffFFD055),
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(100),
//                   ),
//                 ),
//                 child: Text(
//                   'Get Logget In',
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ),
//             ),

//             SizedBox(height: 25),

//             // Texte cliquable pour une redirection
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'don\'t have an account? ',
//                   style: TextStyle(fontSize: 12, color: Colors.black),
//                 ),
//                 Text.rich(
//                   TextSpan(
//                     text: ' create your account now !',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Color(0xffFFD055),
//                       // fontWeight: FontWeight.bold,
//                     ),
//                     recognizer:
//                         TapGestureRecognizer()
//                           ..onTap = () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => SignUpPage(),
//                               ),
//                             );
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
