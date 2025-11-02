import 'dart:convert';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/notofication_provider.dart';
import 'package:yunusco_group/screens/notification_screen.dart';
import 'package:yunusco_group/utils/constants.dart';

import '../common_widgets/blank_screen_notification.dart';
import '../screens/HR&PayRoll/doc_appointment_requisation.dart';
import '../screens/HR&PayRoll/requested_car_list.dart';
import '../screens/Purchasing/purchase_requisation_list.dart';
import '../screens/login_screen.dart';
import 'api_services.dart';



class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();
}

class NotificationServices {
  static Future<void> setupPushNotifications(BuildContext context) async {
    try {
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

      NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: true,
      );

      debugPrint(
          'Notification permission status: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        await _openAppSettingsOrShowRationale(context);
        return;
      }

      String? token = await firebaseMessaging.getToken();
      if (token == null) {
        debugPrint('Failed to get FCM token');
        return;
      }

      debugPrint("FCM Token: $token");
      await _sendTokenToServer(token, context);

      firebaseMessaging.onTokenRefresh.listen((newToken) {
        debugPrint("FCM Token refreshed: $newToken");
        _sendTokenToServer(newToken, context);
      });

      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp
          .listen(_handleBackgroundMessageClick);

      if (Platform.isIOS || Platform.isMacOS) {
        await firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      }

      RemoteMessage? initialMessage =
      await firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationClick(initialMessage);
      }
    } catch (e, stackTrace) {
      debugPrint('Error setting up push notifications: $e\n$stackTrace');
    }
  }

  static Future<void> _openAppSettingsOrShowRationale(
      BuildContext context) async {
    bool? shouldOpenSettings = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications Disabled'),
        content: const Text(
          'Enable notifications in Settings to receive important updates.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );

    if (shouldOpenSettings == true) {
      await AppSettings.openAppSettings();
    }
  }

  static Future<void> _sendTokenToServer(String token, BuildContext ctx) async {
    ApiService apiService = ApiService();
    var res = await apiService.postData('api/user/CheckDeviceToken', {
      "roleId": DashboardHelpers.currentUser!.roleId,
      "FirebaseDeviceToken": token,
      "Userid": DashboardHelpers.currentUser!.userId
    });
    if (res != null) {
      debugPrint('Sending token to server successfully.....');
    } else {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.remove('token');
      AppConstants.token = '';
      Navigator.pushReplacement(
          ctx, MaterialPageRoute(builder: (ctx) => const LoginScreen()));
    }
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground message Title: ${message.notification?.title}');
    debugPrint('Notification Data: ${message.data}');

    final context = NavigationService.navigatorKey.currentContext;
    if (context != null) {
      var np = context.read<NotificationProvider>();
      np.addCount();
    }

    _showNotification(message);
  }

  static void _handleBackgroundMessageClick(RemoteMessage message) {
    debugPrint('App opened from background: ${message.data}');
    _handleNotificationClick(message);
  }

  static Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/ic_launcher');
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings(),
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationClickFromTap(response.payload);
      },
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // ✅ Updated: Include title & body in payload
  static Future<void> _showNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    if (notification != null) {
      // Add notification details into payload along with existing data
      final payloadData = {
        ...message.data,
        'notification_title': notification.title,
        'notification_body': notification.body,
      };

      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
            'This channel is used for important notifications.',
            icon: android?.smallIcon ?? '@drawable/ic_launcher',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(payloadData),
      );
    }
  }

  static void _handleNotificationClick(RemoteMessage message) {
    debugPrint("Notification clicked with data: ${message.data}");
    final Map<String, dynamic> combinedData = {
      ...message.data,
      'notification_title': message.notification?.title,
      'notification_body': message.notification?.body,
    };
    _navigateToRouteFromNotification(combinedData);
  }

  static void _handleNotificationClickFromTap(String? payload) {
    if (payload != null) {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      debugPrint("Notification clicked with payload: $data");
      _navigateToRouteFromNotification(data);
    }
  }

  static void _navigateToRouteFromNotification(Map<String, dynamic> data) {
    debugPrint('This Is The Notification Navigation Data');
    debugPrint('-----------------------------------------');
    debugPrint('Data: $data');

    final context = NavigationService.navigatorKey.currentContext;
    if (context == null) return;

    final type = data['type'];

    if (type == "VehicleRequest") {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => VehicleRequestListScreen()),
      );
    } else if (type == "MedicalLeave") {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => DocAppoinmentReq()),
      );
    } else if (type == "PurchaseRequisition") {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
            builder: (context) => PurchaseRequisitionListScreen()),
      );
    } else if (type == "MedicalGatePass") {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
            builder: (context) => BlankScreenNotification(data: data)),
      );
    } else {
      // ✅ Default: Show BlankScreenNotification with title/body
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
            builder: (context) => BlankScreenNotification(data: data)),
      );
    }
  }
}


