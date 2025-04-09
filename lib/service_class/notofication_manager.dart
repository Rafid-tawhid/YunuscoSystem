import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationManager {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> setupPushNotifications() async {
    // Request permission (iOS)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM token (unique device ID)
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token"); // Save this token for sending messages

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  }

  @pragma('vm:entry-point')
 static  Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
    print("Handling background message: ${message.notification?.title}");
  }




}


