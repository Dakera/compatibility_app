import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:compatibility_app/classes/tracked_medications.dart';
import 'package:compatibility_app/services/notification_manager.dart'; // ИМПОРТ: NotificationManager

class TrackedMedicationsStore extends ChangeNotifier {
  final List<TrackedMedication> _trackedMedications = [];

  List<TrackedMedication> get trackedMedications => List.unmodifiable(_trackedMedications);

  TrackedMedicationsStore._privateConstructor();
  static final TrackedMedicationsStore _instance = TrackedMedicationsStore._privateConstructor();
  factory TrackedMedicationsStore() {
    return _instance;
  }

  void addMedication(TrackedMedication medication) {
    _trackedMedications.add(medication);
    notifyListeners();
    print('Medication added to store: ${medication.customName}');
  }

  // ИЗМЕНЕНО: Метод removeMedication теперь отменяет уведомление
  void removeMedication(String medicationId) {
    final int initialLength = _trackedMedications.length;
    _trackedMedications.removeWhere((med) {
      if (med.medicationId == medicationId) {
        // Если у этого медикамента было уведомление, отменяем его
        if (med.notificationId != null) {
          NotificationManager().cancelNotification(med.notificationId!);
          print('Canceled notification for ${med.customName} with ID ${med.notificationId}');
        }
        return true; // Удаляем медикамент
      }
      return false;
    });

    if (_trackedMedications.length < initialLength) {
      notifyListeners();
      print('Medication removed from store: $medicationId');
    } else {
      print('Medication not found in store: $medicationId');
    }
  }

  void clearAllMedications() {
    // При очистке всех медикаментов, также отменяем все уведомления
    NotificationManager().cancelAllNotifications();
    _trackedMedications.clear();
    notifyListeners();
    print('All medications cleared from store, and all notifications cancelled.');
  }
}
