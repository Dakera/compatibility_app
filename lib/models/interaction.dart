import '../models/medication.dart';

enum InteractionSeverity { red, yellow, green }

List<Interaction> generateInteractions(List<Medication> medications) {
  final List<Interaction> interactions = [];

  for (int i = 0; i < medications.length; i++) {
    for (int j = i + 1; j < medications.length; j++) {
      final medA = medications[i];
      final medB = medications[j];

      //final commonGroups = medA.group.toSet().intersection(medB.group.toSet());
      final instructionA = medA.instruction.toLowerCase();
      final instructionB = medB.instruction.toLowerCase();
      final medAName = medA.name.toLowerCase();
      final medBName = medB.name.toLowerCase();

      final medAGroupMatch = medB.group.any((group) => instructionA.contains(group.toLowerCase()));
      final medBGroupMatch = medA.group.any((group) => instructionB.contains(group.toLowerCase()));
      final medNameMentioned =
          instructionA.contains(medBName) || instructionB.contains(medAName);

      if (medNameMentioned && (medAGroupMatch || medBGroupMatch)) {
        interactions.add(Interaction(
          medications: [medA.name, medB.name],
          severity: InteractionSeverity.red,
          description:
              'Препарат ${medA.name} упоминается в инструкции к препарату ${medB.name}, что может свидетельствовать о серьёзном взаимодействии.',
        ));
      }
      else if (medAGroupMatch || medBGroupMatch) {
        interactions.add(Interaction(
          medications: [medA.name, medB.name],
          severity: InteractionSeverity.yellow,
          description:
              'В инструкции одного из препаратов обнаружено упоминание группы другого, что может свидетельствовать о возможном взаимодействии.',
        ));
      }
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
