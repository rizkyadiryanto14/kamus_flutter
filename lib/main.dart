import 'package:flutter/material.dart';
import 'package:kamus_new/screens/splash_screen.dart';
import 'package:kamus_new/screens/welcome_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home:  SplashScreen(),
    );
  }
}