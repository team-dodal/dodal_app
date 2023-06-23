import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// 백그라운드 핸들러
Future<void> backgroundHandler(RemoteMessage message) async {
  if (Fcm.isAllow) {
    print("Handling a background message: ${message.messageId}");
  }
}

class Fcm {
  static final messaging = FirebaseMessaging.instance;
  static late String? token;
  static late bool isAllow;
  // foreground에서의 푸시 알림 표시를 위한 알림 중요도 설정 (안드로이드)
  static const channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Channel',
    description: 'notification',
    importance: Importance.max,
  );
  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static init() async {
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    token = await messaging.getToken();

    await requestPermission();

    // foreground 에서의 푸시 알림 표시를 위한 local notifications 설정
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    foregroundHandler();
  }

  static requestPermission() async {
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    final permission = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    isAllow = permission.authorizationStatus == AuthorizationStatus.authorized;
  }

  static foregroundHandler() {
    // foreground 푸시 알림 핸들링
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (message.notification != null && android != null) {
        if (isAllow) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification?.title,
              notification?.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  icon: "@mipmap/ic_launcher",
                ),
              ));
          print(
              'Message also contained a notification: ${message.notification}');
        }
      }
    });
  }
}
