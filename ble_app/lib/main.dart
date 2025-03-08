import 'package:ble_app/firebase_options.dart';
import 'package:ble_app/views/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLE Scanner test2',
      theme: ThemeData(primarySwatch: Colors.red),
      home: Auth(),
    );
  }
}

