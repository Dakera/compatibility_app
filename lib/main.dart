import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Импортируем Provider
import 'screens/interaction_check_screen.dart';
import 'package:compatibility_app/data/tracked.dart'; // Импортируем ваш TrackedMedicationsStore

void main() {
  runApp(
    // Оборачиваем все приложение в ChangeNotifierProvider
    ChangeNotifierProvider(
      create: (context) => TrackedMedicationsStore(), // Создаем и предоставляем экземпляр стора
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drug Compatibility Demo',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: const InteractionCheckScreen(),
    );
  }
}
