import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sport_elite_app/sport_elite_app_screen/view/sport_elite_app.dart';
import 'package:timezone/data/latest.dart' as tz;

import '../messaging_screen/entity/user.dart';
import '../messaging_screen/messaging_view.dart';

String userdataUID = "";
String userdataUsername = "";
String userdataEmail = "";

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

class NotificationService {
//NotificationService a singleton object
  static final NotificationService _notificationService =
  NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channelId = '123';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (
            int id,
            String? title,
            String? body,
            String? payload,
            ) async {
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(body.toString()),
            onPressed: () async {
              navigatorKey.currentState?.push(
                MaterialPageRoute(
                  builder: (context) => const MessagingView(),
                ),
              );
            },
          );
        });

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: null);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        var userData = UserData(
          uid: userdataUID,
          email: userdataEmail,
          username: userdataUsername,
        );
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => const MessagingView(),
          ),
        );
      },
    );
  }

  Future<void> showNotifications(String channelID, int id, String username,
      String body, String uid, String email) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      username,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          uid,
          'channel name',
          playSound: true,
          priority: Priority.high,
          importance: Importance.high,
        ),
        iOS: IOSNotificationDetails(
          sound: 'default',
          presentAlert: true,
          presentBadge: true,
        ),
      ),
    );
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

Future selectNotification(String? payload) async {}