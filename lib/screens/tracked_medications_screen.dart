import 'package:flutter/material.dart';
import 'package:compatibility_app/widgets/track_dialog.dart';
import 'package:compatibility_app/classes/tracked_medications.dart';
import 'package:compatibility_app/data/tracked.dart';
import 'package:provider/provider.dart';
import '../screens/tracked_medications_detail_screen.dart';

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
  }

  // ВОССТАНОВЛЕНО: Метод _addMedication для кнопки FAB, без MedicationSelectionScreen
  void _addMedication() {
    // Здесь 'НазваниеЛекарства' должно быть динамическим,
    // например, взятым из поля ввода или из выбранного элемента.
    // Если добавляется новый препарат через FAB, medicationId будет сгенерирован в TrackMedicationDialog
    final String medicationNameToAdd = 'Новый препарат'; // Можно задать какое-то дефолтное название или оставить пустым

    showDialog<TrackedMedication>(
      context: context,
      builder: (BuildContext context) {
        return TrackMedicationDialog(
          medicationName: medicationNameToAdd,
          // medicationId: null, // Передаем null, чтобы TrackMedicationDialog сгенерировал новый ID
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Отслеживаемые лекарства'),
        backgroundColor: const Color.fromARGB(255, 10, 205, 219),
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
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                final medication = medications[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MedicationDetailScreen(
                            medicationId: medication.medicationId,
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
                          // ИЗМЕНЕНО: Условное отображение времени и частоты для уведомлений
                          if (medication.reminderTime != null && medication.frequency != null) ...[
                            Text(
                              'Частота: ${medication.frequency!.name}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              'Время: ${medication.reminderTime!.format(context)}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ] else ...[
                            Text(
                              'Уведомления не настроены',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                            ),
                          ],
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
        backgroundColor: const Color.fromARGB(255, 10, 205, 219),
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Добавить лекарство',
      ),
    );
  }
}
