import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz; // Импорт данных для всех часовых поясов
import 'package:flutter/material.dart'; // For TimeOfDay
import 'package:compatibility_app/classes/app_notification.dart';
import 'package:compatibility_app/classes/tracked_medications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform; // Для определения платформы


class NotificationManager {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationManager._privateConstructor();
  static final NotificationManager _instance = NotificationManager._privateConstructor();
  factory NotificationManager() {
    return _instance;
  }

  Future<void> initializeNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    tz.initializeTimeZones();
    final String? timeZoneName;
    try {
      timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName!));
      print('Локальный часовой пояс установлен: $timeZoneName');
    } catch (e) {
      print('Ошибка при получении локального часового пояса: $e');
      try {
        // Устанавливаем часовой пояс 'Asia/Krasnoyarsk' как запасной
        tz.setLocalLocation(tz.getLocation('Asia/Krasnoyarsk'));
        print('Установлен запасной часовой пояс: Asia/Krasnoyarsk');
      } catch (innerError) {
        tz.setLocalLocation(tz.getLocation('UTC'));
        print('Не удалось установить специфический запасной часовой пояс. Установлен UTC.');
      }
    }


    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // ИСПРАВЛЕНО: Настройки инициализации для Windows. defaultIcon КРАЙНЕ ВАЖЕН для Windows.
    const WindowsInitializationSettings initializationSettingsWindows =
        WindowsInitializationSettings(
      appName: 'Drug Compatibility App', // Замените на фактическое название вашего приложения
      appUserModelId: 'compatibility_app', // Замените на ваш фактический Application ID (соответствует PackageName в MSIX)
      guid: 'ba4b9563-e767-4362-8125-5a4a0f3515ee', // СГЕНЕРИРУЙТЕ СВОЙ УНИКАЛЬНЫЙ GUID!
      iconPath: 'resources/app_icon.ico', // ДОБАВЛЕНО: Указывает на иконку приложения Windows
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
      windows: initializationSettingsWindows,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        final String? payload = notificationResponse.payload;
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
      },
      onDidReceiveBackgroundNotificationResponse: (NotificationResponse notificationResponse) {
        final String? payload = notificationResponse.payload;
        if (payload != null) {
          debugPrint('background notification payload: $payload');
        }
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    print('Уведомления инициализированы.');
  }

  Future<void> scheduleNotification(AppNotification notification) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      notification.notificationTime.hour,
      notification.notificationTime.minute,
    );

    // Если время уведомления уже прошло сегодня, планируем его на завтра
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'medication_channel_id',
      'Напоминания о лекарствах',
      channelDescription: 'Уведомления для напоминаний о приеме лекарств',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const DarwinNotificationDetails darwinPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const WindowsNotificationDetails windowsPlatformChannelSpecifics =
        WindowsNotificationDetails(); // Здесь оставляем пустым, т.к. icon устанавливается в InitializationSettings

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: darwinPlatformChannelSpecifics,
      macOS: darwinPlatformChannelSpecifics,
      windows: windowsPlatformChannelSpecifics,
    );

    DateTimeComponents? matchComponents;
    switch (notification.frequency) {
      case NotificationFrequency.daily:
        matchComponents = DateTimeComponents.time;
        break;
      case NotificationFrequency.everyTwoDays:
        matchComponents = null;
        break;
      case NotificationFrequency.weekly:
        matchComponents = DateTimeComponents.dayOfWeekAndTime;
        break;
      case NotificationFrequency.monthly:
        matchComponents = DateTimeComponents.dayOfMonthAndTime;
        break;
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notification.id,
      'Напоминание о лекарстве: ${notification.medicationName}',
      'Пришло время принять ваше лекарство!',
      scheduledDate,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: defaultTargetPlatform == TargetPlatform.windows
        ? null
        : matchComponents,
      payload: notification.medicationId,
    );
    print('Запланировано уведомление для ${notification.medicationName} с частотой ${notification.frequency.name} на ${scheduledDate.hour}:${scheduledDate.minute}.');
    if (defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.macOS) {
      print('Примечание для десктопной платформы: Возможно, повторяющиеся уведомления не поддерживаются, уведомление может сработать однократно.');
    }
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    print('Уведомление с ID $id отменено.');
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    print('Все уведомления отменены.');
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotificationRequests;
  }
}
