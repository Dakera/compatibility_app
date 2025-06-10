import 'package:flutter/material.dart';
import '../models/interaction.dart';
import '../data/mock_medications.dart';
import '../data/mock_instructions.dart';
import '../classes/medication_instruction.dart';
import 'package:compatibility_app/classes/medication.dart'; // Импортируем класс Medication
import 'package:collection/collection.dart'; // Для firstWhereOrNull

class InteractionCard extends StatelessWidget {
  final Interaction interaction;
  // ДОБАВЛЕНО: Коллбэк для отслеживания препарата
  final void Function(Medication) onTrackMed;

  const InteractionCard({
    super.key,
    required this.interaction,
    required this.onTrackMed, // ИНИЦИАЛИЗАЦИЯ НОВОГО ПОЛЯ
  });

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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getSeverityIcon(interaction.severity),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    interaction.medications.join(' + '),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              interaction.severity.name.toUpperCase(),
              style: TextStyle(
                color: getColor(interaction.severity),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(interaction.description),
            const SizedBox(height: 12),
            ...interaction.medications.map((medName) {
              // ИСПОЛЬЗУЕМ firstWhereOrNull для надежности
              final Medication? med = mockMedications.firstWhereOrNull(
                (m) => m.name == medName,
              );

              // Обрабатываем случай, если препарат не найден (хотя не должен)
              if (med == null) {
                return const Text('Ошибка: препарат не найден для отображения деталей.');
              }

              // ИСПОЛЬЗУЕМ firstWhereOrNull для надежности
              final MedicationInstruction? instruction = mockInstructions.firstWhereOrNull(
                (i) => i.id == med.instructionId,
              );

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(med.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Действующее вещество: ${med.activeIngredient}'),
                        Text('Группа: ${med.group.join(', ')}'),
                        Text('Формы выпуска: ${med.form.join(', ')}'),
                        Text('Также известен как: ${med.tradeNames.join(', ')}'),
                        Text('Побочные эффекты: ${med.sideEffects.join(', ')}'),
                        if (med.warnings.isNotEmpty)
                          Text('❗ Предупреждения: ${med.warnings.join(', ')}'),
                        const SizedBox(height: 8),
                        Text('Инструкция:', style: TextStyle(fontWeight: FontWeight.w600)),
                        if (instruction != null) ...[
                          if (instruction.warningsSection != null && instruction.warningsSection!.isNotEmpty)
                            Text('⚠️ ${instruction.warningsSection!}'),
                          if (instruction.interactionsSection != null && instruction.interactionsSection!.isNotEmpty)
                            Text('💊 ${instruction.interactionsSection!}'),
                          if (instruction.usageSection != null && instruction.usageSection!.isNotEmpty)
                            Text('📋 ${instruction.usageSection!}'),
                        ] else ...[
                          const Text('Инструкция не найдена.'),
                        ],
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.bookmark_add_outlined),
                            label: const Text('Отслеживать'),
                            onPressed: () {
                              // ИЗМЕНЕНО: Вызываем коллбэк onTrackMed и передаем полный объект Medication
                              onTrackMed(med);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
