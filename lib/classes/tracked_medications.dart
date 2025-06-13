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

enum NotificationFrequency {
  daily,
  everyTwoDays,
  weekly,
  monthly,
}

class TrackedMedication {
  final String medicationId;
  final String customName;
  final MedicationForm form;
  final double dosage;
  final DosageUnit dosageUnit;
  final TimeOfDay? reminderTime;
  final NotificationFrequency? frequency;
  final int? notificationId; // НОВОЕ: ID связанного уведомления

  TrackedMedication({
    required this.medicationId,
    this.customName = '',
    required this.form,
    required this.dosage,
    required this.dosageUnit,
    this.reminderTime,
    this.frequency,
    this.notificationId, // НОВОЕ: Добавляем в конструктор
  });
}
