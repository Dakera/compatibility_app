import '../models/medication.dart';

final List<Medication> mockMedications = [
  Medication(
    name: 'Paracetamol',
    activeIngredient: 'Paracetamol',
    instruction: 'Take after food.',
    group: ['Analgesics'],
    warnings: ['May cause drowsiness'],
    upperIntakeLim: '4g/day',
    form: ['Tablet', 'Syrup'],
    tradeNames: ['Panadol', 'Calpol'],
    sideEffects: ['Nausea', 'Rash'],
  ),
  Medication(
    name: 'Ibuprofen',
    activeIngredient: 'Ibuprofen',
    instruction: 'Take with plenty of water.',
    group: ['NSAIDs'],
    warnings: ['Avoid alcohol'],
    upperIntakeLim: '1.2g/day (OTC)',
    form: ['Tablet'],
    tradeNames: ['Nurofen', 'Advil'],
    sideEffects: ['Stomach upset', 'Headache'],
  ),
];
