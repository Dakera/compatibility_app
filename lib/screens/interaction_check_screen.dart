import 'package:flutter/material.dart';
//import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../models/interaction.dart';
import '../data/mock_medications.dart';
import 'medication_list_screen.dart';
import '../widgets/interaction_card.dart';
import '../widgets/interaction_body.dart';

class InteractionCheckScreen extends StatefulWidget {
  const InteractionCheckScreen({super.key});

  @override
  State<InteractionCheckScreen> createState() => _InteractionCheckScreenState();
}

class _InteractionCheckScreenState extends State<InteractionCheckScreen> {
  List<Interaction> foundInteractions = [];
  final TextEditingController _medController = TextEditingController();
  final List<String> _selectedMedications = [];

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
    final selected = mockMedications
        .where((m) => _selectedMedications.contains(m.name))
        .toList();

    final results = generateInteractions(selected);

    setState(() {
      foundInteractions = results;
    });
  }

  void removeMedication(String med) {
  setState(() {
    _selectedMedications.remove(med);
  });
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
    //final medicationNames = mockMedications.map((m) => m.name).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Drug Interactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'All Medications',
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
        selectedMedications: _selectedMedications,
        foundInteractions: foundInteractions,
        onCheck: checkInteractions,
        onClear: clearInteractions,
        onRemoveMed: removeMedication,
        onAddMed: (med) {
          if (!_selectedMedications.contains(med)) {
            setState(() {
              _selectedMedications.add(med);
              _medController.clear();
            });
          }
        },
      ),
    );
  }
}
