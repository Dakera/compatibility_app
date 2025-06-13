import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/interaction_check_screen.dart';
import 'package:compatibility_app/data/tracked.dart';
import 'package:compatibility_app/services/notification_manager.dart'; // ИМПОРТ: NotificationManager

void main() async {
  // Важно: Убедитесь, что Flutter binding инициализирован перед использованием плагинов
  WidgetsFlutterBinding.ensureInitialized();

  // ИНИЦИАЛИЗАЦИЯ: Инициализируем NotificationManager
  await NotificationManager().initializeNotifications();

  runApp(
    ChangeNotifierProvider(
      create: (context) => TrackedMedicationsStore(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drug Compatibility App',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: const InteractionCheckScreen(),
    );
  }
}
