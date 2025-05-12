import 'package:flutter/material.dart';
//import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../models/interaction.dart';
import '../data/mock_medications.dart';
import 'medication_list_screen.dart';
import '../widgets/interaction_card.dart';

class InteractionCheckScreen extends StatefulWidget {
  const InteractionCheckScreen({super.key});

  @override
  State<InteractionCheckScreen> createState() => _InteractionCheckScreenState();
}

class _InteractionCheckScreenState extends State<InteractionCheckScreen> {
  //List<String> selectedMeds = [];
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: RawAutocomplete<String>(
                textEditingController: _medController,
                focusNode: FocusNode(),
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return mockMedications
                      .where((m) => m.name.toLowerCase().contains(textEditingValue.text.toLowerCase()))
                      .map((m) => m.name); // Преобразуем в Iterable<String>
                },
                displayStringForOption: (option) => option,
                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: 'Enter medication',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      suffixIcon: const Icon(Icons.search),
                    ),
                  );
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(8),
                      child: ListView(
                        padding: const EdgeInsets.all(8.0),
                        shrinkWrap: true,
                        children: options.map((option) {
                          return ListTile(
                            title: Text(option),
                            onTap: () {
                              if (!_selectedMedications.contains(option)) {
                                setState(() {
                                  _selectedMedications.add(option);
                                  _medController.clear();
                                });
                              }
                              onSelected(option);
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),

            if (_selectedMedications.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Wrap(
                  spacing: 8,
                  children: _selectedMedications.map((med) {
                    return Chip(
                      label: Text(med),
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () {
                        setState(() {
                          _selectedMedications.remove(med);
                        });
                      },
                    );
                  }).toList(),
                ),
              ),

            const SizedBox(height: 16),
            Row( 
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _selectedMedications.length >= 2 ? checkInteractions : null,
                  child: const Text('Check Interactions'),
                ),
                const SizedBox(width: 12), // расстояние между кнопками
                ElevatedButton(
                  onPressed: () {
                    clearInteractions();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Clear Interactions')),
              ]
            ),
            const SizedBox(height: 16),
            if (foundInteractions.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: foundInteractions.length,
                  itemBuilder: (context, index) {
                    final interaction = foundInteractions[index];
                    return InteractionCard(interaction: interaction); // refactored to use interaction_card.dart
                  },

                ),
              ),
          ],
        ),
      ),
    );
  }
}
