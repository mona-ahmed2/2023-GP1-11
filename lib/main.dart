import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wjjhni/Screens/chatbot_screen.dart';
import 'package:wjjhni/Screens/home_screen.dart';
import 'package:wjjhni/Screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
     
     
    );
  }
}
