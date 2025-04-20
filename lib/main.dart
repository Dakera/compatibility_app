import 'package:flutter/material.dart';
import 'screens/interaction_check_screen.dart'; // <-- подключаем

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drug Compatibility Demo',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: const InteractionCheckScreen(), // <-- ставим как главный экран
    );
  }
}
