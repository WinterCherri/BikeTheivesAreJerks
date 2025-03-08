import 'package:ble_app/components/authButtons.dart';
import 'package:ble_app/components/textField.dart';
import 'package:ble_app/views/auth.dart'; // Import Auth
import 'package:ble_app/views/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  Future<void> createAccount(BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // no functionality to store first name and last name
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account created successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Auth()), // Navigate back to Auth
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create account')),
        );
      }
    }
  }

  void loginPageNav(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
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
              padding: const EdgeInsets.only(top: 50.0), // Adjust the top padding as needed
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.account_circle_outlined, size: 100),
                  SizedBox(height: 50),
                  Text(
                    'Create an account',
                    style: TextStyle(color: Colors.grey[700], fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),

                  // First Name
                  Textfield(
                    controller: firstNameController,
                    hintText: 'Enter First Name',
                    obscureText: false,
                  ),
                  SizedBox(height: 10),

                  // Last Name
                  Textfield(
                    controller: lastNameController,
                    hintText: 'Enter Last Name',
                    obscureText: false,
                  ),
                  SizedBox(height: 10),

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
                    onTap: () => createAccount(context),
                    displayText: 'Create Account',
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Divider(thickness: 0.5, color: Colors.blueGrey),
                  ),
                  AuthButtons(
                    onTap: () => loginPageNav(context),
                    displayText: 'Return to Login Page',
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
