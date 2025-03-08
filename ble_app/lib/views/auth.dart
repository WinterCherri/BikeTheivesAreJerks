import 'package:ble_app/views/ble_scanner.dart';
import 'package:ble_app/views/login.dart';
import 'package:ble_app/views/logout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Logout();
          }
          else {
            return LoginPage();
          }
        }
      ),
    );
  }
}