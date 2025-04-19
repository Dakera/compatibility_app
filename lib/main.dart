import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MedCompatibilityApp());
}

class MedCompatibilityApp extends StatelessWidget {
  const MedCompatibilityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medication Compatibility',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
