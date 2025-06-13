import Flutter
import UIKit
import flutter_local_notifications // Импорт

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FlutterLocalNotificationsPlugin.set </*your AppDelegate class*/>() // Добавьте эту строку
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
// Не забудьте заменить <your AppDelegate class> на имя вашего класса AppDelegate, если оно отличается.
// Если вы используете Swift, убедитесь, что ваш класс AppDelegate наследуется от FlutterAppDelegate.