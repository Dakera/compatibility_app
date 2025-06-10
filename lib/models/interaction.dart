import '../classes/medication.dart';
import '../classes/medication_instruction.dart';
import '../data/mock_instructions.dart';
import '../data/mock_medications.dart';

enum InteractionSeverity { red, yellow, green }

List<Interaction> generateInteractions(List<Medication> medications) {
  final List<Interaction> interactions = [];

  for (int i = 0; i < medications.length; i++) {
    for (int j = i + 1; j < medications.length; j++) {
      final medA = medications[i];
      final medB = medications[j];

      final instructionA = _getInteractionsSection(medA.instructionId).toLowerCase();
      final instructionB = _getInteractionsSection(medB.instructionId).toLowerCase();

      final medAGroup = _getMedicationGroups(medA.instructionId);
      final medBGroup = _getMedicationGroups(medB.instructionId);

      final medAName = medA.name.toLowerCase();
      final medBName = medB.name.toLowerCase();

      bool medGroupMatch = medBGroup.any((group) => medAGroup.contains(group));

      final medNameMentioned = instructionA.contains(medBName) ||
          instructionB.contains(medAName);

      if (medNameMentioned) {
        interactions.add(Interaction(
          medications: [medA.name, medB.name],
          severity: InteractionSeverity.red,
          description:
              '${medA.name} упоминается в инструкции к препарату ${medB.name}, что может свидетельствовать о серьёзном взаимодействии.',
        ));
      } else if (medGroupMatch) {
        interactions.add(Interaction(
          medications: [medA.name, medB.name],
          severity: InteractionSeverity.yellow,
          description:
              'В инструкции одного из препаратов обнаружено упоминание группы другого, что может свидетельствовать о возможном взаимодействии.',
        ));
      } else {
        interactions.add(Interaction(
          medications: [medA.name, medB.name],
          severity: InteractionSeverity.green,
          description:
              'Взаимодействие между ${medA.name} и ${medB.name} не обнаружено.',
        ));
      }
    }
  }

  return interactions;
}

String _getInteractionsSection(String instructionId) {
  final instruction = mockInstructions.firstWhere(
    (i) => i.id == instructionId,
    orElse: () => MedicationInstruction(
      id: instructionId,
      medicationName: '',
      fullText: '',
    ),
  );
  return instruction.interactionsSection ?? '';
}

List<String> _getMedicationGroups(String instructionId) {
  final medication = mockMedications.firstWhere(
    (m) => m.instructionId == instructionId,
    orElse: () => Medication(
      id: '',
      name: '',
      activeIngredient: '',
      instructionId: '',
      group: [],
      warnings: [],
      upperIntakeLim: '',
      form: [],
      tradeNames: [],
      sideEffects: [],
    ),
  );
  return medication.group;
}

class Interaction {
  final List<String> medications;
  final InteractionSeverity severity;
  final String description;

  Interaction({
    required this.medications,
    required this.severity,
    required this.description,
  });
}
