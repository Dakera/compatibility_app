import '../models/interaction.dart';

final List<Interaction> mockInteractions = [
  Interaction(
    medications: ['Paracetamol', 'Ibuprofen'],
    severity: InteractionSeverity.yellow,
    description: 'May increase the risk of stomach bleeding when taken together.',
  ),
  Interaction(
    medications: ['Ibuprofen', 'Aspirin'],
    severity: InteractionSeverity.red,
    description: 'Ibuprofen may interfere with the antiplatelet effect of aspirin.',
  ),
  Interaction(
    medications: ['Paracetamol', 'Aspirin'],
    severity: InteractionSeverity.green,
    description: 'No known significant interaction.',
  ),
];
