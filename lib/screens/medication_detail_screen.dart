import 'package:flutter/material.dart';
import '../models/medication.dart';

class MedicationDetailScreen extends StatelessWidget {
  final Medication medication;

  const MedicationDetailScreen({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(medication.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSection('Active Ingredient', medication.activeIngredient),
            _buildSection('Instruction', medication.instruction),
            _buildSection('Groups', medication.group.join(', ')),
            _buildSection('Warnings', medication.warnings.join(', ')),
            _buildSection('Upper Intake Limit', medication.upperIntakeLim),
            _buildSection('Form', medication.form.join(', ')),
            _buildSection('Trade Names', medication.tradeNames.join(', ')),
            _buildSection('Side Effects', medication.sideEffects.join(', ')),
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
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(content),
        ],
      ),
    );
  }
}
