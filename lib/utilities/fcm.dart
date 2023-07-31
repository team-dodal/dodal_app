import 'dart:io';

import 'package:dodal_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
late AndroidNotificationChannel channel;
bool isFlutterLocalNotificationsInitialized = false; // 셋팅여부 판단 flag

class Fcm {
  static late String token;

  static Future<void> setupNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    if (Platform.isAndroid) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Channel',
        description: 'notification',
        importance: Importance.high,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    await Fcm.requestPermission();
    // 토큰 요청
    await Fcm.getToken();
    // 셋팅flag 설정
    isFlutterLocalNotificationsInitialized = true;
  }

  static requestPermission() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static foregroundNotification(RemoteMessage message) async {
    if (!await getNotificationValue()) return;
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      // 웹이 아니면서 안드로이드이고, 알림이 있는경우
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: "@mipmap/ic_launcher",
          ),
        ),
      );
    }
  }

  @pragma('vm:entry-point')
  static Future<void> backgroundNotification(RemoteMessage message) async {
    if (!await getNotificationValue()) return;
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await Fcm.setupNotifications(); // 셋팅 메소드
    //showFlutterNotification(message);  // 로컬노티
  }

  static Future<String?> getToken() async {
    // ios
    String? token;
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      token = await FirebaseMessaging.instance.getAPNSToken();
    }
    // aos
    else {
      token = await FirebaseMessaging.instance.getToken();
    }
    Fcm.token = token!;
    return token;
  }
}

Future<bool> getNotificationValue() async {
  final pref = await SharedPreferences.getInstance();
  return pref.getBool('notification_allow') ?? true;
}
