import 'package:flutter/material.dart';
import 'package:collection/collection.dart'; // Для firstWhereOrNull
import 'package:compatibility_app/data/mock_medications.dart';
import 'package:compatibility_app/data/mock_instructions.dart';
import 'package:compatibility_app/classes/medication.dart';
import 'package:compatibility_app/classes/medication_instruction.dart';

class MedicationDetailScreen extends StatelessWidget {
  final String medicationId;

  const MedicationDetailScreen({super.key, required this.medicationId});

  @override
  Widget build(BuildContext context) {
    // Надежный поиск Medication по ID
    final Medication? medication = mockMedications.firstWhereOrNull(
      (m) => m.id == medicationId,
    );

    // Надежный поиск MedicationInstruction по instructionId
    final MedicationInstruction? instruction = medication != null
        ? mockInstructions.firstWhereOrNull(
            (inst) => inst.id == medication.instructionId,
          )
        : null;

    if (medication == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ошибка')),
        body: const Center(
          child: Text('Препарат не найден.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(medication.name),
        backgroundColor: Colors.teal, // Добавляем цвет для AppBar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Раздел "Общая информация"
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Общая информация',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildDetailRow(context, 'Активное вещество:', medication.activeIngredient),
                    _buildDetailRow(context, 'Группа:', medication.group.join(', ')),
                    _buildDetailRow(context, 'Форма выпуска:', medication.form.join(', ')),
                    _buildDetailRow(context, 'Торговые названия:', medication.tradeNames.join(', ')),
                    _buildDetailRow(context, 'Предельная доза:', medication.upperIntakeLim ?? 'Нет данных'),
                  ],
                ),
              ),
            ),

            // Раздел "Побочные эффекты"
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Побочные эффекты',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      medication.sideEffects.join(', '),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),

            // Раздел "Предупреждения"
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Предупреждения',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      medication.warnings.join(', '),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),

            // Раздел "Полная инструкция" (из mock_instructions.dart)
            if (instruction != null)
              Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Полная инструкция',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      _buildInstructionSection(context, 'Общая информация:', instruction.fullText),
                      _buildInstructionSection(context, 'Применение:', instruction.usageSection ?? ''),
                      _buildInstructionSection(context, 'Особые указания:', instruction.warningsSection ?? ''),
                      _buildInstructionSection(context, 'Взаимодействия:', instruction.interactionsSection ?? ''),
                    ],
                  ),
                ),
              )
            else
              Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Инструкция не найдена.'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Вспомогательный метод для построения строк деталей
  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // Фиксированная ширина для лейбла
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  // Вспомогательный метод для построения секций инструкции
  Widget _buildInstructionSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
