import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../firebase_options.dart';

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("Handling background message: ${message.messageId}");
  await setupFlutterNotifications();
  await showFlutterNotification(message);
}

/// Create an Android notification channel for normal notifications.
late AndroidNotificationChannel normalNotificationChannel;
late DarwinInitializationSettings darwinInitializationSettings;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }

  // Define the notification channel for normal notifications
  normalNotificationChannel = const AndroidNotificationChannel(
    'normal_notifications', // id
    'Normal Notifications', // title
    description: 'This channel is used for normal notifications.',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
  );

  darwinInitializationSettings = const DarwinInitializationSettings();

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Register the Android notification channel
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(normalNotificationChannel);

  // Initialize settings for both platforms
  final initializationSettings = InitializationSettings(
    android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: darwinInitializationSettings,
  );

  // Initialize the plugin
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  isFlutterLocalNotificationsInitialized = true;
  debugPrint("Notification setup completed.");
}

Future<void> showFlutterNotification(RemoteMessage message) async {
  String title = message.notification?.title ?? 'No Title';
  String body = message.notification?.body ?? 'No Body';
  String? imageUrl = message.data["notify_image"] ??
      message.notification?.apple?.imageUrl;

  final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  AndroidNotificationDetails androidDetails;
  DarwinNotificationDetails? iosDetails;

  if (imageUrl != null && imageUrl.isNotEmpty) {
    try {
      // Download image
      final http.Response response = await http.get(Uri.parse(imageUrl));
      final Uint8List bytes = response.bodyBytes;
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = '${tempDir.path}/$id.jpg';
      final File file = File(filePath);
      await file.writeAsBytes(bytes);

      // Android BigPicture
      final bigPicture = BigPictureStyleInformation(
        FilePathAndroidBitmap(filePath),
        contentTitle: title,
        summaryText: body,
      );

      androidDetails = AndroidNotificationDetails(
        normalNotificationChannel.id,
        normalNotificationChannel.name,
        channelDescription: normalNotificationChannel.description,
        styleInformation: bigPicture,
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      );

      // iOS attachment
      iosDetails = DarwinNotificationDetails(
        attachments: [DarwinNotificationAttachment(filePath)],
      );
    } catch (e) {
      debugPrint("Image download failed: $e");

      // fallback if image fails
      androidDetails = AndroidNotificationDetails(
        normalNotificationChannel.id,
        normalNotificationChannel.name,
        channelDescription: normalNotificationChannel.description,
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      );

      iosDetails = const DarwinNotificationDetails();
    }
  } else {
    // No image case
    androidDetails = AndroidNotificationDetails(
      normalNotificationChannel.id,
      normalNotificationChannel.name,
      channelDescription: normalNotificationChannel.description,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    iosDetails = const DarwinNotificationDetails();
  }

  var notificationDetails = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );

  if (!kIsWeb) {
    flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails);
  }
}
