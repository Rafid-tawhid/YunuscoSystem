import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/account_provider.dart';
import 'package:yunusco_group/providers/auth_provider.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import 'package:yunusco_group/providers/inventory_provider.dart';
import 'package:yunusco_group/providers/management_provider.dart';
import 'package:yunusco_group/providers/merchandising_provider.dart';
import 'package:yunusco_group/providers/notofication_provider.dart';
import 'package:yunusco_group/providers/purchase_provider.dart';
import 'package:yunusco_group/providers/riverpods/planning_provider.dart';
import 'package:yunusco_group/providers/product_provider.dart';
import 'package:yunusco_group/service_class/notofication_helper.dart';

import 'launcher_screen.dart';
import 'package:provider/provider.dart' as legacy; // alias for provider package
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

//
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp();
    await setupNotificationChannel();
  }

//
  HttpOverrides.global = MyHttpOverrides();

    runApp(
      legacy.MultiProvider(
        providers: [
          legacy.ChangeNotifierProvider(create: (_) => AuthProvider()),
          legacy.ChangeNotifierProvider(create: (_) => MerchandisingProvider()),
          legacy.ChangeNotifierProvider(create: (_) => ManagementProvider()),
          legacy.ChangeNotifierProvider(create: (_) => ProductProvider()),
          legacy.ChangeNotifierProvider(create: (_) => InventoryPorvider()),
          // legacy.ChangeNotifierProvider(create: (_) => PlanningProvider()),
          legacy.ChangeNotifierProvider(create: (_) => HrProvider()),
          legacy.ChangeNotifierProvider(create: (_) => NotificationProvider()),
          legacy.ChangeNotifierProvider(create: (_) => AccountProvider()),
          legacy.ChangeNotifierProvider(create: (_) => PurchaseProvider()),
        ],
        child: ProviderScope(
          child: MyApp(),
        ),
      ),
    );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Yunusco System',
        navigatorKey: NavigationService.navigatorKey,
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: LauncherScreen());
  }
}

Future<void> setupNotificationChannel() async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // Match the ID in AndroidManifest.xml
    'High Importance Notifications',
    importance: Importance.high,
  );

  await FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // var server_key=await ServerKey.server_token();
  // debugPrint('server_key ${server_key}');
}
