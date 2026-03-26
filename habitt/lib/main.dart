import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const HabittApp());
}

class HabittApp extends StatelessWidget {
  const HabittApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}