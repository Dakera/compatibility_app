import 'package:flutter/material.dart';
import '../models/interaction.dart';
import '../data/mock_medications.dart';
import 'interaction_card.dart';
import 'package:compatibility_app/classes/medication.dart'; // Импортируем класс Medication

class InteractionBody extends StatelessWidget {
  final TextEditingController medController;
  // ИЗМЕНЕНО: selectedMedications теперь List<Medication>
  final List<Medication> selectedMedications;
  final List<Interaction> foundInteractions;
  final void Function() onCheck;
  final void Function() onClear;
  // ИЗМЕНЕНО: onRemoveMed теперь принимает Medication
  final void Function(Medication) onRemoveMed;
  // ИЗМЕНЕНО: onAddMed теперь принимает String (и будет преобразовывать в Medication в родительском виджете)
  final void Function(String) onAddMed;
  // ДОБАВЛЕНО: Новый коллбэк для отслеживания препарата из InteractionCard
  final void Function(Medication) onTrackMed;


  const InteractionBody({
    super.key,
    required this.medController,
    required this.selectedMedications,
    required this.foundInteractions,
    required this.onCheck,
    required this.onClear,
    required this.onRemoveMed,
    required this.onAddMed,
    required this.onTrackMed, // ИНИЦИАЛИЗАЦИЯ НОВОГО ПОЛЯ
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
                // Возвращаем имена для автозаполнения
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
                    suffixIcon: IconButton( // Добавим кнопку для явного добавления
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          onAddMed(controller.text);
                          controller.clear(); // Очищаем поле после добавления
                        }
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      onAddMed(value);
                    }
                  },
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
                            onAddMed(option); // Передаем выбранное имя в родительский виджет
                            onSelected(option); // Для RawAutocomplete
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
                    label: Text(med.name), // Используем med.name
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () => onRemoveMed(med), // Передаем объект Medication
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
                  final interaction = foundInteractions[index];
                  // ИЗМЕНЕНО: Передаем onTrackMed в InteractionCard
                  return InteractionCard(
                    interaction: interaction,
                    onTrackMed: onTrackMed,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
