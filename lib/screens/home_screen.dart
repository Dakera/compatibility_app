import 'package:flutter/material.dart';
import '../data/mock_medications.dart';
import 'medication_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Compatibility'),
      ),
      body: ListView.builder(
        itemCount: mockMedications.length,
        itemBuilder: (context, index) {
          final med = mockMedications[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(med.name),
              subtitle: Text(med.activeIngredient),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        MedicationDetailScreen(medication: med),
                  ),
                );              },
            ),
          );
        },
      ),
    );
  }
}
