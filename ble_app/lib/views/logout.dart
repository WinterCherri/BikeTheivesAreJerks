import 'package:ble_app/views/auth.dart';
import 'package:ble_app/views/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});

  void signUserOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logout'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => signUserOut(context),
          child: Text('Sign Out'),
        ),
      ),
    );
  }
}