import 'package:flutter/material.dart';
import '../data/mock_medications.dart';
import 'medication_detail_screen.dart';

class MedicationListScreen extends StatelessWidget {
  const MedicationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Medications'),
      ),
      body: ListView.builder(
        itemCount: mockMedications.length,
        itemBuilder: (context, index) {
          final medication = mockMedications[index];
          return ListTile(
            title: Text(medication.name),
            subtitle: Text(medication.activeIngredient),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MedicationDetailScreen(medication: medication),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
