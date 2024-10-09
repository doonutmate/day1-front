import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotification {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static String? _token;

  static Future init() async {
    NotificationSettings response = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if(response.alert.name == "enabled"){

    }
    else{

    }


    _token = await _firebaseMessaging.getToken();
    print("device token : $_token");
  }

  static Future localNotiInit() async {
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsDarwin,
    );

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showSimpleNotification({
    required String title,
    required String body,
  }) async {
    try {
      const NotificationDetails notificationDetails =
          NotificationDetails(iOS: DarwinNotificationDetails(badgeNumber: 1));
      await _flutterLocalNotificationsPlugin.show(
          0, title, body, notificationDetails);
    } catch (e) {
      print(e);
    }
  }
}
