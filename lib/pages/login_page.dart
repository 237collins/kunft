import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kunft/pages/signup_page.dart';
// import 'package:immo/pages/sign_up_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Déclaration des contrôleurs
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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

    return Scaffold(
      // appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Padding(
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
            SizedBox(height: 30),
            Column(
              children: [
                Text(
                  'Welcome Back!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 16),
                Text(
                  'Your dream property is just a login away.',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Début formulaire
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    style: TextStyle(color: Colors.purple),
                    decoration: InputDecoration(
                      // prefixIcon: Icon(Icons.email, color: Colors.grey),
                      labelText: 'userneame@gmail.com',
                      labelStyle: TextStyle(fontSize: 12),
                      filled: true,
                      fillColor: Color(0xfff7f7f7),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xffd3d3d3)),
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

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            // prefixIcon: Icon(Icons.lock, color: Colors.grey),
                            labelText: '********',
                            labelStyle: TextStyle(fontSize: 12),
                            filled: true,
                            fillColor: Color(0xfff7f7f7),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Color(0xffd3d3d3)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 15),
                      Icon(Icons.visibility_off),
                    ],
                  ),

                  SizedBox(height: 15),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_box_sharp),
                    Text('Remember my login info '),
                  ],
                ),
                Text.rich(
                  TextSpan(
                    text: ' forgot your password?',
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
                                builder: (context) => SignUpPage(),
                              ),
                            );
                          },
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
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
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Text(
                  'Get Logget In',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),

            SizedBox(height: 25),

            // Texte cliquable pour une redirection
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'don\'t have an account? ',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                Text.rich(
                  TextSpan(
                    text: ' create your account now !',
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
                                builder: (context) => SignUpPage(),
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
