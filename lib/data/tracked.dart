import 'package:flutter/foundation.dart'; // Для ChangeNotifier
import 'package:flutter/material.dart'; // Для TimeOfDay, если используется в TrackedMedication
import 'package:compatibility_app/classes/tracked_medications.dart'; // Импортируем ваш класс TrackedMedication

// Этот класс будет хранить ваши отслеживаемые медикаменты
// и уведомлять слушателей об изменениях.
class TrackedMedicationsStore extends ChangeNotifier {
  // Приватный список для хранения медикаментов
  final List<TrackedMedication> _trackedMedications = [];

  // Геттер для получения копии списка.
  // Возвращаем List.unmodifiable, чтобы избежать внешних изменений напрямую.
  List<TrackedMedication> get trackedMedications => List.unmodifiable(_trackedMedications);

  // Приватный конструктор для синглтона
  TrackedMedicationsStore._privateConstructor();

  // Единственный экземпляр класса
  static final TrackedMedicationsStore _instance = TrackedMedicationsStore._privateConstructor();

  // Фабричный конструктор для доступа к экземпляру
  factory TrackedMedicationsStore() {
    return _instance;
  }

  // Метод для добавления медикамента
  void addMedication(TrackedMedication medication) {
    _trackedMedications.add(medication);
    notifyListeners(); // Уведомляем всех, кто слушает этот стор, об изменении
    print('Medication added to store: ${medication.customName}');
  }

  // Метод для удаления медикамента (опционально, но полезно)
  void removeMedication(String medicationId) {
    _trackedMedications.removeWhere((med) => med.medicationId == medicationId);
    notifyListeners();
    print('Medication removed from store: $medicationId');
  }

  // Если вы хотите очистить список (например, для тестирования)
  void clearAllMedications() {
    _trackedMedications.clear();
    notifyListeners();
    print('All medications cleared from store.');
  }
}
