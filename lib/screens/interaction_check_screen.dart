import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../models/interaction.dart';
import '../data/mock_interactions.dart';
import '../data/mock_medications.dart';
import 'medication_list_screen.dart';
import '../models/medication.dart';

class InteractionCheckScreen extends StatefulWidget {
  const InteractionCheckScreen({super.key});

  @override
  State<InteractionCheckScreen> createState() => _InteractionCheckScreenState();
}

class _InteractionCheckScreenState extends State<InteractionCheckScreen> {
  //List<String> selectedMeds = [];
  List<Interaction> foundInteractions = [];
  final TextEditingController _medController = TextEditingController();
  List<String> _selectedMedications = [];

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
    final results = <Interaction>[];

    for (int i = 0; i < _selectedMedications.length; i++) {
      for (int j = i + 1; j < _selectedMedications.length; j++) {
        final med1 = _selectedMedications[i];
        final med2 = _selectedMedications[j];

        final interaction = mockInteractions.firstWhere(
          (interaction) =>
              interaction.medications.contains(med1) &&
              interaction.medications.contains(med2),
          orElse: () => Interaction(
            medications: [med1, med2],
            severity: InteractionSeverity.green,
            description: 'No known interaction.',
          ),
        );

        results.add(interaction);
      }
    }

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
    final medicationNames = mockMedications.map((m) => m.name).toList();

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


            MultiSelectDialogField<String>(
              items: medicationNames.map((e) => MultiSelectItem(e, e)).toList(),
              title: const Text('Medications'),
              buttonText: const Text('Select Medications'),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal),
                borderRadius: BorderRadius.circular(8),
              ),
              onConfirm: (values) {
                setState(() {
                  _selectedMedications = values;
                });
              },
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
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ExpansionTile(
                        leading: getSeverityIcon(interaction.severity),
                        title: Text(
                          interaction.medications.join(' + '),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          interaction.severity.name.toUpperCase(),
                          style: TextStyle(color: getColor(interaction.severity)),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                            child: Text(interaction.description),
                          ),
                          ...interaction.medications.map((medName) {
                            final med = mockMedications.firstWhere(
                              (m) => m.name == medName,
                                orElse: () => throw Exception('Medication with name $medName not found'),
                            );
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      med.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    const SizedBox(height: 6),
                                    Text('Active ingradient: ${med.activeIngredient}'),
                                    Text('Group: ${med.group.join(', ')}'),
                                    Text('Forms: ${med.form.join(', ')}'),
                                    Text('Also known as: ${med.tradeNames.join(', ')}'),
                                    Text('Side effects: ${med.sideEffects.join(', ')}'),
                                    //if (med.contraindications.isNotEmpty)
                                    //  Text('⚠ Contraindications: ${med.contraindications.join(', ')}'),
                                    if (med.warnings.isNotEmpty)
                                      Text('❗ Warnings: ${med.warnings.join(', ')}'),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    );


                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
