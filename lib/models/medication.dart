class Medication {
  final String name;
  final String activeIngredient;
  final String instruction;
  final List<String> group;
  final List<String> warnings;
  final String upperIntakeLim;
  final List<String> form;
  final List<String> tradeNames;
  final List<String> sideEffects;

  Medication({
    required this.name,
    required this.activeIngredient,
    required this.instruction,
    required this.group,
    required this.warnings,
    required this.upperIntakeLim,
    required this.form,
    required this.tradeNames,
    required this.sideEffects,
  });
}
