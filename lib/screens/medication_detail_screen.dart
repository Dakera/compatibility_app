import 'package:flutter/material.dart';
import '../classes/medication.dart';
import '../classes/medication_instruction.dart'; // класс MedicationInstruction
import '../data/mock_instructions.dart'; // mockInstructions

class MedicationDetailScreen extends StatelessWidget {
  final Medication medication;

  const MedicationDetailScreen({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    final instruction = mockInstructions.firstWhere(
      (instr) => instr.id == medication.instructionId,
      orElse: () => MedicationInstruction(
        id: medication.instructionId,
        medicationName: medication.name,
        fullText: 'Инструкция не найдена',
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(medication.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSection('Активное вещество', medication.activeIngredient),
            _buildSection('Группы', medication.group.join(', ')),
            _buildSection('Форма выпуска', medication.form.join(', ')),
            _buildSection('Торговые названия', medication.tradeNames.join(', ')),
            _buildSection('Побочные эффекты', medication.sideEffects.join(', ')),
            _buildSection('Предупреждения', medication.warnings.join(', ')),
            if (medication.upperIntakeLim != null)
              _buildSection('Допустимая суточная доза', medication.upperIntakeLim!),
            const Divider(height: 32),
            _buildSection('Полный текст инструкции', instruction.fullText),
            if (instruction.usageSection != null)
              _buildSection('Способ применения', instruction.usageSection!),
            if (instruction.warningsSection != null)
              _buildSection('Меры предосторожности', instruction.warningsSection!),
            if (instruction.interactionsSection != null)
              _buildSection('Взаимодействия', instruction.interactionsSection!),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(content),
        ],
      ),
    );
  }
}
