import 'package:flutter/material.dart';
import 'login_page.dart'; // আপনার লগইন পেজ ফাইলটি ইম্পোর্ট করুন

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // গ্লোবালি থিম চেঞ্জ করার ফাংশনটি অ্যাক্সেস করার জন্য
  static _MyAppState? of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ডিফল্টভাবে Light Mode সেট করা আছে
  ThemeMode _themeMode = ThemeMode.light;

  // থিম পরিবর্তন করার মেথড
  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Find Loc',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: _themeMode, // অ্যাপের বর্তমান থিম মোড নির্ধারণ করবে
      home: LoginPage(), // আপনার মূল লগইন পেজটি আগের মতোই ঠিক রাখা হয়েছে
    );
  }
}