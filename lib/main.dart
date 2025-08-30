import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  // ✅ Load env variables
  await dotenv.load(fileName: ".env");
  runApp(const UpNowApp()); // ✅ Updated name
}

class UpNowApp extends StatefulWidget { // ✅ Changed from MyApp -> UpNowApp
  const UpNowApp({super.key});

  @override
  State<UpNowApp> createState() => _UpNowAppState();
}

class _UpNowAppState extends State<UpNowApp> {
  bool isDark = false; // ✅ default light theme

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "UpNow News",
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      home: SplashScreen(
        onThemeChanged: (val) {
          setState(() => isDark = val);
        },
      ),
    );
  }
}
