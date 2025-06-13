import 'package:flutter/material.dart';
import 'package:compatibility_app/classes/tracked_medications.dart'; // Для NotificationFrequency

class AppNotification {
  final int id; // Уникальный ID для уведомления (требуется для flutter_local_notifications)
  final String medicationId; // ID отслеживаемого препарата, к которому относится уведомление
  final String medicationName; // Название препарата для отображения в уведомлении
  final TimeOfDay notificationTime; // Время уведомления
  final NotificationFrequency frequency; // Частота уведомления
  final bool isActive; // Флаг активности уведомления (можно включать/выключать)

  AppNotification({
    required this.id,
    required this.medicationId,
    required this.medicationName,
    required this.notificationTime,
    required this.frequency,
    this.isActive = true, // По умолчанию уведомление активно
  });

  // Метод для создания AppNotification из TrackedMedication
  // Этот метод будет вызываться, когда пользователь решает создать уведомление
  static AppNotification? fromTrackedMedication({
    required String medicationId,
    required String medicationName,
    required TimeOfDay? reminderTime,
    required NotificationFrequency? frequency,
  }) {
    if (reminderTime == null || frequency == null) {
      return null; // Если время или частота отсутствуют, уведомление создать нельзя
    }

    // Генерируем уникальный ID для уведомления.
    // Важно, чтобы этот ID был уникальным для каждого уведомления,
    // иначе новые уведомления будут перезаписывать старые.
    // Можно использовать хэш от medicationId + time + frequency.
    // Для простоты пока используем простой хэш.
    final int notificationId = Object.hash(medicationId, reminderTime.hour, reminderTime.minute, frequency).abs();

    return AppNotification(
      id: notificationId,
      medicationId: medicationId,
      medicationName: medicationName,
      notificationTime: reminderTime,
      frequency: frequency,
    );
  }
}
