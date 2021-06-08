import 'package:aloe/models/UserPlant.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channel_id = "123";

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_logo');

    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {});
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
    });

    tz.initializeTimeZones();
  }

  void scheduleNotificationForNextWatering(UserPlant userPlant) async {
    var now = new DateTime.now();
    await flutterLocalNotificationsPlugin.zonedSchedule(
        userPlant.hashCode,
        "Aloe",
        "N'oubliez pas d'arroser " + userPlant.name,
        tz.TZDateTime.now(tz.local).add(new Duration(
            //seconds: 1)),
            days: computeWatering(userPlant.wateringRequirements) -
                (now.day - userPlant.wateringDate.day),
            seconds: 10)),
        const NotificationDetails(
            android: AndroidNotificationDetails("Aloe", "Aloe", 'Rappel')),
        payload: "Rappel",
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void cancelNotification(UserPlant plant) async {
    await flutterLocalNotificationsPlugin.cancel(plant.hashCode);
  }

  void cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  int computeWatering(String frequency) {
    int frequencyInDays = 0;
    if (frequency == "1 fois par semaine") {
      frequencyInDays = 7;
    } else if (frequency == "2 fois par semaine") {
      frequencyInDays = 3;
    } else if (frequency == "3 fois par semaine") {
      frequencyInDays = 2;
    }

    return frequencyInDays;
  }
}
