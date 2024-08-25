import 'package:flutter/material.dart';
import './pages/home_page.dart';
import './utils/commons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Commons.initialize(context);
    return MaterialApp(
      title: 'SociPie',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF4D35E),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

/// Signup
/// 