// import 'dart:io';
// import 'dart:math';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:app_settings/app_settings.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:help_abode_worker_app_ver_2/helper_functions/dashboard_helpers.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
//
// class NotificationServices {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//   final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   //
//   Future<void> requestForPermission() async {
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: true,
//       criticalAlert: true,
//       provisional: true,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('Permission granted');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('Permission granted provosional');
//     } else {
//       AppSettings.openAppSettings(type: AppSettingsType.notification)
//           .then((value) {});
//       print('Permission denied');
//     }
//   }
//
//   //
//   initLocalNotification(BuildContext context, RemoteMessage message) async {
//     var androidSettings =
//         AndroidInitializationSettings('@mipmap/launcher_icon');
//     var iosSettings = const DarwinInitializationSettings();
//
//     var intialization =
//         InitializationSettings(android: androidSettings, iOS: iosSettings);
//
//     await _localNotificationsPlugin.initialize(intialization,
//         onDidReceiveNotificationResponse: (payload) {
//       //this is called when notification is clicked
//       handleMessage(context, message);
//     });
//   }
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   Future<void> showNotification(RemoteMessage message) async {
//     // Create a notification channel for Android
//     AndroidNotificationChannel channel = AndroidNotificationChannel(
//       Random.secure().nextInt(1000).toString(),
//       'High Importance Notification',
//       importance: Importance.high,
//     );
//
//     // Android notification details
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       channel.id.toString(),
//       channel.name.toString(),
//       channelDescription: 'My loading description',
//       priority: Priority.high,
//       importance: Importance.max,
//       ticker: 'Ticker',
//     );
//
//     // iOS notification details
//     DarwinNotificationDetails iosNotificationDetails =
//         DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//
//     // Notification details for both platforms
//     NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//       iOS: iosNotificationDetails,
//     );
//
//     // Show the notification
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       message.notification?.title ?? 'No Title',
//       message.notification?.body ?? 'No Body',
//       notificationDetails,
//     );
//
//     print('Notification shown successfully.');
//   }
//
// // Initialize the local notifications plugin (should be called in your main method or initState)
//   Future<void> initializeNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings();
//
//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   //
//   void firebaseInit(
//     BuildContext context,
//   ) {
//     FirebaseMessaging.onMessage.listen((message) async {
//       print('MESSING ${message.data}');
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       print('Title :${message.notification!.title.toString()}');
//       print('Body : ${message.notification!.body.toString()}');
//       print('Data : ${message.data.toString()}');
//       print('Status : ${message.data['status']}');
//       print('Image SEND: ${message.data['image']}');
//
//       if (message.data['status'] == 'Provider Approved') {
//         print('Provider Approved');
//         DashboardHelpers.checkForFirstLogin(context);
//       }
//       if (Platform.isAndroid) {
//         initLocalNotification(context, message);
//         showNotification(message);
//         forGroundMessage();
//       }
//       if (Platform.isIOS) {
//         initLocalNotification(context, message);
//         showNotification(message);
//         forGroundMessage();
//       }
//     });
//   }
//
//   Future<String> getTokens() async {
//     String? token = await messaging.getToken();
//     return token!;
//   }
//
//   void isTokenExperied() {
//     messaging.onTokenRefresh.listen((event) {
//       event.toString();
//       print('refresh');
//     });
//   }
//
//   //
//   void handleMessage(BuildContext context, RemoteMessage message) {
//     print('Notification RemoteMessage ${message.data.toString()}');
//     if (message.data['status'] == 'Provider Approved.') {}
//   }
//   //
//   // Future<void> setupInteractMessage(BuildContext context) async {
//   //   //when app is terminated
//   //   RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//   //
//   //   if (initialMessage != null) {
//   //     handleMessage(context, initialMessage);
//   //   }
//   //
//   //   //when app is in background
//   //   FirebaseMessaging.onMessageOpenedApp.listen((event) {
//   //     handleMessage(context, event);
//   //   });
//   // }
//   //
//   // downloadFile(String url, String fileName) async {
//   //   final directory = await getApplicationDocumentsDirectory();
//   //   final filePath = '${directory.path}/$fileName';
//   //   final response = await http.get(Uri.parse(url));
//   //   final file = File(filePath);
//   //   await file.writeAsBytes(response.bodyBytes);
//   //   return filePath;
//   // }
//
//   // static sendDeviceTokenToServerForSendingPushNotification(String token) async {
//   //   var data;
//   //
//   //   String deviceInfo = await getDeviceData();
//   //   print('device INFO ${deviceInfo}');
//   //   try {
//   //     final response = await http.post(
//   //       Uri.parse('https://pencilbox.edu.bd/api/save_new_device'),
//   //       body: {'device_id': token, 'device_info': deviceInfo},
//   //     );
//   //     if (response.statusCode == 200) {
//   //       data = jsonDecode(response.body.toString());
//   //       print('DEVICE TOKEN RESPONSE ${data}');
//   //       return data;
//   //     } else {
//   //       data = jsonDecode(response.body.toString());
//   //       // print('DEVICE TOKEN FALSE ${data}');
//   //       return data;
//   //     }
//   //   } catch (e) {
//   //     print('DEVICE TOKEN ERROR ${e}');
//   //     return data;
//   //   }
//   // }
//   //
//   // static Future<String> getDeviceData() async {
//   //   String deviceAllInfo = '';
//   //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//   //   if (Platform.isAndroid) {
//   //     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//   //     print('Device Model: ${androidInfo.model}');
//   //     print('Android Version: ${androidInfo.version.release}');
//   //     deviceAllInfo = {'Device Model': androidInfo.model, 'Android Version': androidInfo.version.release, 'Device Name': androidInfo.brand}.toString();
//   //   } else if (Platform.isIOS) {
//   //     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
//   //     print('Device Model: ${iosInfo.utsname.machine}');
//   //     print('iOS Version: ${iosInfo.systemVersion}');
//   //     deviceAllInfo = {'Device Model': iosInfo.model, 'Android Version': iosInfo.systemVersion, 'Device Name': iosInfo.name}.toString();
//   //   }
//   //
//   //   print('DEVICE ALL INFO ${deviceAllInfo}');
//   //
//   //   return deviceAllInfo;
//   // }
//   //
//   // static Future<dynamic> getAllNotification() async {
//   //   var data;
//   //   final apiKey = 'pencilbox@app.notify';
//   //   final url = Uri.parse('https://pencilbox.edu.bd/api/get_latest_notifications?api_key=$apiKey');
//   //
//   //   try {
//   //     final response = await http.get(url);
//   //     print('Notification : ${response}');
//   //
//   //     if (response.statusCode == 200) {
//   //       data = jsonDecode(response.body.toString());
//   //
//   //       return data;
//   //     } else {
//   //       data = jsonDecode(response.body.toString());
//   //       // print('DEVICE TOKEN FALSE ${data}');
//   //       data = null;
//   //       return data;
//   //     }
//   //   } catch (e) {
//   //     data = null;
//   //     return data;
//   //   }
//   // }
//   //
//   Future forGroundMessage() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//             alert: true, badge: true, sound: true);
//   }
//
//   Future<String> _downloadAndSaveFile(String url, String fileName) async {
//     final Directory directory = await getApplicationDocumentsDirectory();
//     final String filePath = '${directory.path}/$fileName';
//     final http.Response response = await http.get(Uri.parse(url));
//     final File file = File(filePath);
//     await file.writeAsBytes(response.bodyBytes);
//     return filePath;
//   }
// }
