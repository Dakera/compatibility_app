enum InteractionSeverity { red, yellow, green }

class Interaction {
  final List<String> medications;
  final InteractionSeverity severity;
  final String description;

  Interaction({
    required this.medications,
    required this.severity,
    required this.description,
  });

  /// Проверка, включает ли эта запись нужные два лекарства
  bool involves(String med1, String med2) {
    return medications.contains(med1) && medications.contains(med2);
  }
}
