import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const UpNowApp());
}

class UpNowApp extends StatelessWidget {
  const UpNowApp({super.key}); // ✅ super.key use kiya

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UpNow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // sabse pehle splash screen khulegi
    );
  }
}
