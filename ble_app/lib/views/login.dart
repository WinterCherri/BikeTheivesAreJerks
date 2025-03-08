import 'package:ble_app/components/authButtons.dart';
import 'package:ble_app/components/textField.dart';
import 'package:ble_app/views/signup.dart';
import 'package:ble_app/views/auth.dart'; // Import Auth
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // user sign in
  void signIn(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully signed in')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Auth()), // Navigate back to Auth
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign in')),
        );
      }
    }
  }

  void signUpNav(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 100.0), // Adjust the top padding as needed
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.account_circle, size: 100),
                  SizedBox(height: 50),
                  Text(
                    'Sign in to your account',
                    style: TextStyle(color: Colors.grey[700], fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),

                  // Email
                  Textfield(
                    controller: emailController,
                    hintText: 'Enter Email',
                    obscureText: false,
                  ),
                  SizedBox(height: 10),
                  // Password
                  Textfield(
                    controller: passwordController,
                    hintText: 'Enter Password',
                    obscureText: true,
                  ),
                  SizedBox(height: 50),

                  AuthButtons(
                    onTap: () => signIn(context),
                    displayText: 'Sign In',
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Divider(thickness: 0.5, color: Colors.blueGrey),
                  ),
                  AuthButtons(
                    onTap: () => signUpNav(context),
                    displayText: 'Create Account',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
