class Medication {
  final String id;
  final String name;
  final String activeIngredient;
  final List<String> group;
  final List<String> form;
  final List<String> tradeNames;
  final List<String> sideEffects;
  final List<String> warnings;
  final String instructionId;
  final String? upperIntakeLim;

  Medication({
    required this.id,
    required this.name,
    required this.activeIngredient,
    required this.group,
    required this.form,
    required this.tradeNames,
    required this.sideEffects,
    required this.warnings,
    required this.instructionId,
    required this.upperIntakeLim,
  });
}
