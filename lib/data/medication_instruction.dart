class MedicationInstruction {
  final String id;
  //final String activeIngredient;
  //final String group;
  final String medicationName;
  final String fullText;
  final String? interactionsSection;
  final String? usageSection;
  final String? warningsSection;

  MedicationInstruction({
    required this.id,
    //required this.activeIngredient,
    //required this.group,
    required this.medicationName,
    required this.fullText,
    this.interactionsSection,
    this.usageSection,
    this.warningsSection,
  });
}
