import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/auth_provider.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import 'package:yunusco_group/providers/inventory_provider.dart';
import 'package:yunusco_group/providers/management_provider.dart';
import 'package:yunusco_group/providers/merchandising_provider.dart';
import 'package:yunusco_group/providers/planning_provider.dart';
import 'package:yunusco_group/providers/product_provider.dart';
import 'package:yunusco_group/screens/home_page.dart';
import 'package:yunusco_group/utils/server_key.dart';

import 'launcher_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(Platform.isAndroid){
    await Firebase.initializeApp();
    await setupNotificationChannel();
  }

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MerchandisingProvider()),
        ChangeNotifierProvider(create: (_) => ManagementProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => InventoryPorvider()),
        ChangeNotifierProvider(create: (_) => PlanningProvider()),
        ChangeNotifierProvider(create: (_) => HrProvider()),
      ],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: LauncherScreen()
    );
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
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // var server_key=await ServerKey.server_token();
  // debugPrint('server_key ${server_key}');

}