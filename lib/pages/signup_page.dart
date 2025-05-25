import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kunft/pages/home_screen.dart';
// import 'package:immo/pages/home_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Fonction pour afficher le SnackBar
  void showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connexion réussie!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                height: screenHeight * .21,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
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
              SizedBox(height: 24),
              Text(
                'Join the Archilles Community!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16),
              Text(
                'Start your journey to finding the perfect property.',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 20),
              // Début formulaire
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.0),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: userNameController,
                          style: TextStyle(color: Colors.purple),
                          decoration: InputDecoration(
                            // prefixIcon: Icon(Icons.person, color: Colors.grey),
                            labelText: 'Username',
                            labelStyle: TextStyle(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),

                        TextFormField(
                          controller: emailController,
                          style: TextStyle(color: Colors.purple),
                          decoration: InputDecoration(
                            // prefixIcon: Icon(Icons.email, color: Colors.grey),
                            labelText: 'userneame@gmail.com',
                            labelStyle: TextStyle(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 15),

                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            // prefixIcon: Icon(Icons.lock, color: Colors.grey),
                            labelText: 'Password',
                            labelStyle: TextStyle(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),

                        Icon(Icons.visibility_off),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      showSuccessSnackBar();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffFFD055),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Let’s Get Started',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),

              SizedBox(height: 12),

              SizedBox(height: 25),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     Text(
              //       'or continue with',
              //       style: TextStyle(fontSize: 12, color: Colors.black),
              //     ),
              //     Text.rich(
              //       TextSpan(
              //         text: 'Test Home page',
              //         style: TextStyle(
              //           fontSize: 12,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.orange,
              //           // fontWeight: FontWeight.bold,
              //         ),
              //         recognizer:
              //             TapGestureRecognizer()
              //               ..onTap = () {
              //                 Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                     builder: (context) => HomeScreen(),
              //                   ),
              //                 );
              //               },
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'already have account? ',
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                  Text.rich(
                    TextSpan(
                      text: ' log into your account now!',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xffFFD055),
                        // fontWeight: FontWeight.bold,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
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
      ),
    );
  }
}
