import '../models/medication.dart';

enum InteractionSeverity { red, yellow, green }

List<Interaction> generateInteractions(List<Medication> medications) {
  final List<Interaction> interactions = [];

  for (int i = 0; i < medications.length; i++) {
    for (int j = i + 1; j < medications.length; j++) {
      final medA = medications[i];
      final medB = medications[j];

      final commonGroups = medA.group.toSet().intersection(medB.group.toSet());
      final instructionA = medA.instruction.toLowerCase();
      final instructionB = medB.instruction.toLowerCase();
      final medAName = medA.name.toLowerCase();
      final medBName = medB.name.toLowerCase();

      final medAGroupMatch = medB.group.any((group) => instructionA.contains(group.toLowerCase()));
      final medBGroupMatch = medA.group.any((group) => instructionB.contains(group.toLowerCase()));
      final medNameMentioned =
          instructionA.contains(medBName) || instructionB.contains(medAName);

      // Серьёзное взаимодействие — общие группы
      if (commonGroups.isNotEmpty) {
        interactions.add(Interaction(
          medications: [medA.name, medB.name],
          severity: InteractionSeverity.red,
          description:
              'Препараты ${medA.name} и ${medB.name} относятся к пересекающимся фармакологическим группам: ${commonGroups.join(', ')}. Возможны серьёзные взаимодействия.',
        ));
      }
      // Средняя степень — препарат явно упомянут в инструкции другого
      else if (medNameMentioned) {
        interactions.add(Interaction(
          medications: [medA.name, medB.name],
          severity: InteractionSeverity.yellow,
          description:
              'Препарат ${medA.name} упоминается в инструкции к препарату ${medB.name}, что может указывать на потенциальное взаимодействие.',
        ));
      }
      // Лёгкая степень — упоминание групп в инструкции
      else if (medAGroupMatch || medBGroupMatch) {
        interactions.add(Interaction(
          medications: [medA.name, medB.name],
          severity: InteractionSeverity.yellow,
          description:
              'В инструкции одного из препаратов обнаружено упоминание группы другого, что может свидетельствовать о возможном взаимодействии.',
        ));
      }
      // Нет значимых взаимодействий
      else {
        interactions.add(Interaction(
          medications: [medA.name, medB.name],
          severity: InteractionSeverity.green,
          description: 'Взаимодействие между ${medA.name} и ${medB.name} не обнаружено.',
        ));
      }
    }
  }

  return interactions;
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
