import 'package:flutter/material.dart';

// ВСЕ ENUMS ТЕПЕРЬ ОПРЕДЕЛЕНЫ ЗДЕСЬ
enum MedicationForm {
  tablet,
  capsule,
  syrup,
}

enum DosageUnit {
  mg,
  ml,
}

// Переименовал MedicationFrequency в NotificationFrequency, чтобы использовать только один enum
// для частоты и в TrackedMedication, и в TrackMedicationDialog.
enum NotificationFrequency {
  daily,
  everyTwoDays, // Это было 'everyOtherDay', изменил на 'everyTwoDays' для соответствия
  weekly,
  monthly, 
}

class TrackedMedication {
  final String medicationId;
  final String customName; // Optional, for display purposes
  final MedicationForm form; // Используем enum
  final double dosage;
  final DosageUnit dosageUnit; // Используем enum
  final TimeOfDay reminderTime;
  final NotificationFrequency frequency; // Используем enum

  TrackedMedication({
    required this.medicationId,
    this.customName = '',
    required this.form,
    required this.dosage,
    required this.dosageUnit,
    required this.reminderTime,
    required this.frequency,
  });
}