import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:ride_now/core/components/app_entry_point.dart';
import 'package:ride_now/core/helpers/enums/user_type.dart';
import 'package:ride_now/core/helpers/safe_print.dart';
import 'package:ride_now/core/services/network/api_constants.dart';
import 'package:ride_now/core/services/routing/routing_endpoints.dart';
import '../../../google_auth.dart';
import '../../helpers/secure_storage/secure_storage.dart';
import '../../helpers/shared_pref.dart';
import '../../helpers/shared_pref_keys.dart';
import '../../permissions/notification.dart';
import '../call/call_service.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:ride_now/core/helpers/secure_storage/secure_keys.dart';

class FirebaseMessagingService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    await requestNotificationPermission();

    _initializeLocalNotifications();
    _handleFCMToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleIncomingMessage(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessageNavigation(message);
    });

    FirebaseMessaging.onBackgroundMessage(handleFCMBackgroundMessage);
  }

  /// **Handles FCM token & updates Firestore**
  static Future<void> _handleFCMToken() async {
    String? token = await _messaging.getToken();
    if (token != null) {
      await _saveTokenToFirestore(token);
    }

    _messaging.onTokenRefresh.listen((newToken) async {
      await _saveTokenToFirestore(newToken);
    });
  }

  static Future<void> _saveTokenToFirestore(String token) async {
    final userId = SharedPref.getString(key: MySharedKeys.userId);
    if (userId != null) {
      await SecureStorageService.writeData(SecureKeys.deviceToken, token);
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'deviceToken': token,
      });
    }
  }

  static void _initializeLocalNotifications() {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    _localNotifications.initialize(settings);
  }

  static Future<void> _handleIncomingMessage(RemoteMessage message) async {
    safePrint("FCM Message Received: ${message.data}");

    String title = message.notification?.title ?? 'New Notification';
    String body = message.notification?.body ?? '';
    String? userId = message.data['userId'];

    if (userId != null) {
      await saveNotificationToFirestore(userId, title, body);
    }
    if (message.data.containsKey('channelId')) {
      String callerName = message.data['callerName'];
      String channelId = message.data['channelId'];
      CallService.showIncomingCall(callerName, channelId);
      if (appNavKey.currentState?.canPop() ?? false) {
        appNavKey.currentState?.pop();
      }
      appNavKey.currentState
          ?.pushNamed(RoutingEndpoints.audioCall, arguments: channelId);
    } else {
      _showLocalNotification(title: title, body: body);
    }
  }

  static Future<void> saveNotificationToFirestore(
      String userId, String title, String body) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (!userDoc.exists) {
      safePrint('User does not exist, cannot save notification.');
      return;
    }


    String? deviceToken = userDoc['deviceToken'];

    await FirebaseFirestore.instance.collection('notifications').add({
      'userId': userId,
      'deviceToken': deviceToken,
      'title': title,
      'body': body,
      'isRead': false,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> _showLocalNotification(
      {required String title, required String body}) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel_id',
      'General Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      0, // Notification ID
      title,
      body,
      notificationDetails,
    );
  }

  static void _handleMessageNavigation(RemoteMessage message) {
    if (message.data.containsKey('channelId')) {
      String channelId = message.data['channelId'];
      _joinCall(channelId);
    }
  }

  static Future<void> handleFCMBackgroundMessage(RemoteMessage message) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await _handleIncomingMessage(message);
  }

  static void _joinCall(String channelId) {
    appNavKey.currentState
        ?.pushNamed(RoutingEndpoints.audioCall, arguments: channelId);
  }
}

Future<void> sendNotificationToSpecificUser({
  required String title,
  required String body,
  required String senderId,
  required String receiverId,
  required String deviceToken,
}) async {
  final accessCredentials = await getAccessToken();
  final accessToken = accessCredentials.accessToken.data;

  Dio dio = Dio();
  const url =
      'https://fcm.googleapis.com/v1/projects/project1-8cafd/messages:send';

  final response = await dio.post(
    url,
    options: Options(
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    ),
    data: {
      'message': {
        'token': deviceToken,
        'notification': {
          'title': title,
          'body': body,
        },
        'data': {
          'senderId': senderId,
          'receiverId': receiverId,
        }
      }
    },
  );

  if (response.statusCode == 200) {
    safePrint('Notification sent successfully: ${response.data}');

    await FirebaseFirestore.instance.collection('notifications').add({
      'title': title,
      'body': body,
      'senderId': senderId,
      'receiverId': receiverId,
      'deviceToken': deviceToken,
      'isRead': false,
      'timestamp': FieldValue.serverTimestamp(),
    });
  } else {
    safePrint('Failed to send notification: ${response.data}');
  }
}

Future<void> sendNotification({
  required String title,
  required String body,
  required String topic,
}) async {
  final accessCredentials = await getAccessToken();
  final accessToken = accessCredentials.accessToken.data;

  Dio dio = Dio();
  const url =
      'https://fcm.googleapis.com/v1/projects/project1-8cafd/messages:send';

  final response = await dio.post(
    url,
    options: Options(
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    ),
    data: {
      'message': {
        'topic': topic,
        'notification': {
          'title': title,
          'body': body,
        },
      }
    },
  );

  if (response.statusCode == 200) {
    safePrint('Notification sent successfully: ${response.data}');

    QuerySnapshot driverSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('type', isEqualTo: UserType.driver.name)
        .get();

    for (var driverDoc in driverSnapshot.docs) {
      String driverId = driverDoc.id;
      String? driverToken = driverDoc['deviceToken'];

      await FirebaseFirestore.instance.collection('notifications').add({
        'title': title,
        'body': body,
        'senderId': 'system',
        'receiverId': driverId,
        'deviceToken': driverToken ?? '',
        'isRead': false,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  } else {
    safePrint('Failed to send notification: ${response.data}');
  }
}

Future<void> sendNotificationCaller({
  required String fcmToken,
  required String title,
  required String body,
  String? callerName,
  String? channelId,
}) async {
  String serverUrl = AgoraConstants.serverUrl;
  safePrint("Sending Notification via: $serverUrl");

  final Map<String, dynamic> message = {
    "to": fcmToken,
    "notification": {"title": title, "body": body},
    "data": {},
  };

  if (callerName != null && channelId != null) {
    message["data"] = {"callerName": callerName, "channelId": channelId};
  }

  final response = await http.post(
    Uri.parse(serverUrl),
    headers: {
      "Content-Type": "application/json",
      "Authorization":
          "key=AAAAe-V0xx8:APA91bEhZx-sb3kybBetY9RPBpqvD0Ftyp7so5a95Am5XG_B9ZZBxwqmOvlAd9eq509n_yVy1Lt7PwRR6nnJNjthsKgY-b51JmmQ9DF8MfitXWgWQUcD5HEcbwJDkYUWVmxq5Zn7mSg8",
    },
    body: json.encode(message),
  );

  if (response.statusCode == 200) {
    safePrint("Notification sent successfully!");
  } else {
    safePrint("Failed to send notification: ${response.statusCode}");
  }
}
