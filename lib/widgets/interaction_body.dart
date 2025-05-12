import 'package:flutter/material.dart';
import '../models/interaction.dart';
import '../data/mock_medications.dart';
import '../screens/medication_list_screen.dart';
import 'interaction_card.dart';

class InteractionBody extends StatelessWidget {
  final TextEditingController medController;
  final List<String> selectedMedications;
  final List<Interaction> foundInteractions;
  final void Function() onCheck;
  final void Function() onClear;
  final void Function(String) onRemoveMed;
  final void Function(String) onAddMed;

  const InteractionBody({
    super.key,
    required this.medController,
    required this.selectedMedications,
    required this.foundInteractions,
    required this.onCheck,
    required this.onClear,
    required this.onRemoveMed,
    required this.onAddMed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: RawAutocomplete<String>(
              textEditingController: medController,
              focusNode: FocusNode(),
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return mockMedications
                    .where((m) => m.name.toLowerCase().contains(textEditingValue.text.toLowerCase()))
                    .map((m) => m.name);
              },
              displayStringForOption: (option) => option,
              fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Введите название лекарства',
                    hintText: 'Например: Цитрамон',
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
                            onAddMed(option);
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
          if (selectedMedications.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Wrap(
                spacing: 8,
                children: selectedMedications.map((med) {
                  return Chip(
                    label: Text(med),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () => onRemoveMed(med),
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: selectedMedications.length >= 2 ? onCheck : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedMedications.length >= 2 ? Colors.blue : Colors.grey,
                ),
                child: const Text('Проверить взаимодействия'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: onClear,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                child: const Text('Очистить'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (foundInteractions.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: foundInteractions.length,
                itemBuilder: (context, index) {
                  return InteractionCard(interaction: foundInteractions[index]);
                },
              ),
            ),
        ],
      ),
    );
  }
}
