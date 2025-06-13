import 'package:flutter/material.dart';
import '../models/interaction.dart';
import '../data/mock_medications.dart'; // Для доступа к Medication объектам
import '../data/tracked.dart';
import '../widgets/interaction_body.dart'; // Мы внесем изменения в этот виджет
import '../screens/tracked_medications_screen.dart';
import 'medication_list_screen.dart';
import 'package:compatibility_app/classes/medication.dart'; // Импортируем класс Medication
import 'package:collection/collection.dart'; // Для firstWhereOrNull
import '../widgets/track_dialog.dart'; // For TrackMedicationDialog

class InteractionCheckScreen extends StatefulWidget {
  const InteractionCheckScreen({super.key});

  @override
  State<InteractionCheckScreen> createState() => _InteractionCheckScreenState();
}

class _InteractionCheckScreenState extends State<InteractionCheckScreen> {
  List<Interaction> foundInteractions = [];
  final TextEditingController _medController = TextEditingController();
  // ИЗМЕНЕНО: Теперь храним объекты Medication, а не просто строки
  final List<Medication> _selectedMedications = [];

  @override
  void dispose() {
    _medController.dispose();
    super.dispose();
  }

  void clearInteractions() {
    setState(() {
      foundInteractions.clear();
    });
  }

  void checkInteractions() {
    // checkInteractions теперь работает напрямую с Medication объектами
    final results = generateInteractions(_selectedMedications);

    setState(() {
      foundInteractions = results;
    });
  }

  // ИЗМЕНЕНО: Принимает Medication объект для удаления
  void removeMedication(Medication med) {
    setState(() {
      _selectedMedications.removeWhere((m) => m.id == med.id);
    });
    // После удаления медикамента, возможно, стоит перепроверить взаимодействия
    checkInteractions();
  }

  // НОВЫЙ МЕТОД: Для открытия TrackMedicationDialog с конкретным препаратом
  void _trackMedication(Medication medicationToTrack) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return TrackMedicationDialog(
          medicationName: medicationToTrack.name, // Передаем название
          medicationId: medicationToTrack.id,     // Передаем ID
        );
      },
    );
  }

  Color getColor(InteractionSeverity severity) {
    switch (severity) {
      case InteractionSeverity.red:
        return Colors.red;
      case InteractionSeverity.yellow:
        return Colors.orange;
      case InteractionSeverity.green:
        return Colors.green;
    }
  }

  Icon getSeverityIcon(InteractionSeverity severity) {
  switch (severity) {
    case InteractionSeverity.red:
      return const Icon(Icons.block, color: Colors.red);
    case InteractionSeverity.yellow:
      return const Icon(Icons.error_outline, color: Colors.orange);
    case InteractionSeverity.green:
      return const Icon(Icons.check_circle_outline, color: Colors.green);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Проверка взаимодействий'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Отслеживаемые',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TrackedMedicationsScreen(
                    initialMedications: TrackedMedicationsStore().trackedMedications,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'Все препараты',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MedicationListScreen()),
              );
            },
          ),
        ],
      ),
      body: InteractionBody(
        medController: _medController,
        // ИЗМЕНЕНО: onAddMed теперь получает строку, но преобразует ее в Medication
        onAddMed: (String medName) {
          final Medication? foundMedication = mockMedications.firstWhereOrNull(
            (m) => m.name.toLowerCase() == medName.toLowerCase(),
          );
          if (foundMedication != null && !_selectedMedications.any((m) => m.id == foundMedication.id)) {
            setState(() {
              _selectedMedications.add(foundMedication);
              _medController.clear();
            });
            checkInteractions(); // Перепроверяем взаимодействия после добавления
          } else if (foundMedication == null) {
            // Опционально: показать сообщение пользователю, что препарат не найден
            print('Препарат "$medName" не найден в данных.');
          }
        },
        selectedMedications: _selectedMedications, // Теперь List<Medication>
        foundInteractions: foundInteractions,
        onCheck: checkInteractions,
        onClear: clearInteractions,
        onRemoveMed: removeMedication, // Передаем обновленный метод
        onTrackMed: _trackMedication, // НОВЫЙ КОЛЛБЭК: Передаем метод отслеживания
      ),
    );
  }
}
