import 'package:flutter/material.dart';
import 'package:compatibility_app/widgets/track_dialog.dart';
import 'package:compatibility_app/classes/tracked_medications.dart';
import 'package:compatibility_app/data/tracked.dart';
import 'package:provider/provider.dart';
// ИМПОРТ: Добавляем новый экран деталей
import 'package:compatibility_app/screens/tracked_medications_detail_screen.dart'; // ПУТЬ МОЖЕТ ОТЛИЧАТЬСЯ

class TrackedMedicationsScreen extends StatefulWidget {
  final List<TrackedMedication> initialMedications;

  const TrackedMedicationsScreen({
    super.key,
    this.initialMedications = const [],
  });

  @override
  State<TrackedMedicationsScreen> createState() => _TrackedMedicationsScreenState();
}

class _TrackedMedicationsScreenState extends State<TrackedMedicationsScreen> {
  @override
  void initState() {
    super.initState();
    // Если вы хотите, чтобы начальные медикаменты добавлялись в стор при открытии экрана,
    // это можно сделать здесь. Однако обычно стор управляет своими данными сам.
    // Если TrackedMedicationsStore уже содержит данные, нет необходимости в этом.
    // for (var med in widget.initialMedications) {
    //   TrackedMedicationsStore().addMedication(med);
    // }
  }

  void _addMedication() {
    final String medicationNameToAdd = 'НазваниеЛекарства'; // Замените на реальное название

    showDialog<TrackedMedication>(
      context: context,
      builder: (BuildContext context) {
        return TrackMedicationDialog(
          medicationName: medicationNameToAdd,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Отслеживаемые лекарства'),
        backgroundColor: const Color.fromARGB(255, 10, 205, 219), // Добавляем цвет для AppBar
      ),
      body: Consumer<TrackedMedicationsStore>(
        builder: (context, store, child) {
          final medications = store.trackedMedications;

          if (medications.isEmpty) {
            return const Center(
              child: Text('Пока нет отслеживаемых лекарств. Добавьте первое!'),
            );
          } else {
            return ListView.builder(
              itemCount: medications.length,
              padding: const EdgeInsets.all(8.0), // Добавляем небольшой отступ для карточек
              itemBuilder: (context, index) {
                final medication = medications[index];
                return Card( // Оборачиваем каждый ListTile в Card
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  child: InkWell( // Делаем карточку кликабельной
                    onTap: () {
                      // Переход на экран деталей при нажатии
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MedicationDetailScreen(
                            medicationId: medication.medicationId, // Передаем ID отслеживаемого препарата
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            medication.customName,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Дозировка: ${medication.dosage} ${medication.dosageUnit.name}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            'Частота: ${medication.frequency.name}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            'Время: ${medication.reminderTime.format(context)}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          // Можете добавить другие детали здесь
                          Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                store.removeMedication(medication.medicationId);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMedication,
        backgroundColor: Colors.teal, // Добавляем цвет для FAB
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Добавить лекарство',
      ),
    );
  }
}
