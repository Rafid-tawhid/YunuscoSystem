import 'dart:convert';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/notofication_provider.dart';
import 'package:yunusco_group/screens/notification_screen.dart';

import '../screens/HR&PayRoll/requested_car_list.dart';
import '../screens/HR&PayRoll/widgets/vehicle_accept_rej_screen.dart';
import '../screens/login_screen.dart';
import 'api_services.dart';


class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

class NotificationServices {

  // static Future<AccessToken> getFirebaseBearerToken() async {
  //   final accountCredentials = ServiceAccountCredentials.fromJson(
  //       json.decode(await rootBundle.loadString('images/utils/server_key.json')));
  //
  //   final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
  //
  //   final client = await clientViaServiceAccount(accountCredentials, scopes);
  //
  //   final token = await client.credentials.accessToken;
  //   client.close();
  //
  //   return token;
  // }



  static Future<void> setupPushNotifications(BuildContext context) async {
    try {
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

      // 1. Request permission (platform-aware)
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: true, // iOS-only: Allow sending notifications without explicit permission
      );

      debugPrint('Notification permission status: ${settings.authorizationStatus}');

      // 2. Handle permission denied or limited (e.g., iOS "provisional")
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        await _openAppSettingsOrShowRationale(context);
        return;
      }

      // 3. Get and handle FCM token
      String? token = await _firebaseMessaging.getToken();
      if (token == null) {
        debugPrint('Failed to get FCM token');
        return;
      }

      debugPrint("FCM Token: $token");
      await _sendTokenToServer(token); // Send to your backend

      // 4. Handle token refresh (e.g., on app restore or reinstall)
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        debugPrint("FCM Token refreshed: $newToken");
        _sendTokenToServer(newToken);
      });

      // 5. Set up foreground/background message handlers
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessageClick);

      // 6. Configure for iOS/macOS
      if (Platform.isIOS || Platform.isMacOS) {
        await _firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert: true, // Show heads-up notification
          badge: true, // Update app badge
          sound: true, // Play sound
        );
      }

      // 7. Handle initial notification (app opened from terminated state)
      RemoteMessage? initialMessage =
      await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationClick(initialMessage);
      }

    } catch (e, stackTrace) {
      debugPrint('Error setting up push notifications: $e\n$stackTrace');
      // Optional: Log error to analytics (e.g., Sentry, Firebase Crashlytics)
    }
  }

// --- Helper Methods ---

  static Future<void> _openAppSettingsOrShowRationale(BuildContext context) async {
    // Show a dialog explaining why permissions are needed
    bool? shouldOpenSettings = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Notifications Disabled'),
        content: Text(
          'Enable notifications in Settings to receive important updates.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Open Settings'),
          ),
        ],
      ),
    );

    if (shouldOpenSettings == true) {
      await AppSettings.openAppSettings(); // Using the `app_settings` package
    }
  }

  static Future<void> _sendTokenToServer(String token) async {
    // Implement your API call here

    ApiService apiService=ApiService();
   var res=await apiService.postData('api/user/CheckDeviceToken',{
      "roleId": DashboardHelpers.currentUser!.roleId,
      "FirebaseDeviceToken": token,
      "Userid": DashboardHelpers.currentUser!.userId
    });
   if(res!=null){
     debugPrint('Sending token to server successfully.....');
   }
  }
  //

  static void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground message Title: ${message.notification?.title}');
    debugPrint('Notification Data: ${message.data}');

    //count increase
    final context = NavigationService.navigatorKey.currentContext;
    var np=context!.read<NotificationProvider>();
    np.addCount();
    _showNotification(message); // Your existing notification display logic
  }

  static void _handleBackgroundMessageClick(RemoteMessage message) {
    debugPrint('App opened from background: ${message.data}');
    _handleNotificationClick(message); // Navigate to a specific screen
  }


  static Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/ic_launcher');
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    final InitializationSettings initializationSettings = InitializationSettings(
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



  //
  static Future<void> _showNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    if (notification != null) {
      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription: 'This channel is used for important notifications.',
            icon: android?.smallIcon ?? '@drawable/ic_launcher',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }
  static void _handleNotificationClick(RemoteMessage message) {
    debugPrint("Notification clicked with data: ${message.data}");
    // Extract navigation route from payload or use default
    _navigateToRoute(message.data);
  }

  static void _handleNotificationClickFromTap(String? payload) {
    if (payload != null) {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      debugPrint("Notification clicked with payload: $data");
      _navigateToRoute(data);
    }
  }

  static void _navigateToRoute(Map<String, dynamic> data) {
    // Use navigatorKey from your MaterialApp
    final context = NavigationService.navigatorKey.currentContext;
    if (context == null) return;

    if(data['type']=="VehicleRequest"){
      //
      Navigator.push(context, CupertinoPageRoute(builder: (context) => VehicleRequestListScreen()));
    }
    else {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => NotificationsScreen()));
    }


  }
}



