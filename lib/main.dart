import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projeto/routes/navigationbarapp.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MaterialApp(
        title: "",
        home: NavigationBarApp(),
      ),
    );
  }
}
