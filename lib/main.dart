import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const UpNowApp());
}

class UpNowApp extends StatefulWidget {
  const UpNowApp({super.key});

  @override
  State<UpNowApp> createState() => _UpNowAppState();
}

class _UpNowAppState extends State<UpNowApp> {
  ThemeMode _themeMode = ThemeMode.system; // default system theme

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UpNow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        onThemeChanged: _toggleTheme, // 🔥 Pass toggle function to Splash/Home
      ),
    );
  }
}
