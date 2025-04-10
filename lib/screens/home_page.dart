import 'dart:async';import 'dart:convert';import 'dart:io' show Platform;import 'package:firebase_core/firebase_core.dart';import 'package:firebase_messaging/firebase_messaging.dart';import 'package:flutter/cupertino.dart';import 'package:flutter/material.dart';import 'package:provider/provider.dart';import 'package:shared_preferences/shared_preferences.dart';import 'package:yunusco_group/helper_class/dashboard_helpers.dart';import 'package:yunusco_group/providers/auth_provider.dart';import 'package:yunusco_group/service_class/notofication_helper.dart';import 'package:yunusco_group/utils/constants.dart';import '../providers/management_provider.dart';import 'Management/management_screen.dart';import 'Products/product_screen.dart';import 'login_screen.dart';import 'Merchandising/merchandisingScreen.dart';import 'dart:async';import 'dart:convert';import 'dart:io' show Platform;import 'package:firebase_messaging/firebase_messaging.dart';import 'package:flutter/cupertino.dart';import 'package:flutter/material.dart';import 'package:flutter_local_notifications/flutter_local_notifications.dart';import 'package:provider/provider.dart';import 'package:shared_preferences/shared_preferences.dart';import 'package:yunusco_group/helper_class/dashboard_helpers.dart';import 'package:yunusco_group/providers/auth_provider.dart';import 'package:yunusco_group/service_class/notofication_helper.dart';import '../providers/management_provider.dart';import 'Management/management_screen.dart';import 'login_screen.dart';import 'Merchandising/merchandisingScreen.dart';class HomeScreen extends StatefulWidget {  final String? buttonLabel;  final bool? isOnTp;  const HomeScreen({Key? key, this.buttonLabel, this.isOnTp}) : super(key: key);  @override  _HomeScreenState createState() => _HomeScreenState();}class _HomeScreenState extends State<HomeScreen> {  int myIndex = 0;  List<Menu> menus = [];  List<dynamic> moduleList = [];  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =  FlutterLocalNotificationsPlugin();  Future<void> _getModules() async {    menus = [      Menu(44, 'assets/images/purchase.png', 'Purchasing', false),      Menu(6, 'assets/images/management.png', 'Management', false),      Menu(45, 'assets/images/button-trims.png', 'Trims Sales', false),      Menu(1, 'assets/images/button-merch.png', 'Merchandising', false),      Menu(1, 'assets/images/planbold.png', 'Planning', false),      Menu(44, 'assets/images/prodbold.png', 'Production', false),      Menu(6, 'assets/images/INVENTORY-min.png', 'Inventory', false),      Menu(45, 'assets/images/ATTENDANCE-min.png', 'Accounts', false),      Menu(1, 'assets/images/hrbold.png', 'HR & Payroll', false),      Menu(1, 'assets/images/button-repo.png', 'Reports', false),      Menu(1, 'assets/images/button-sec.png', 'Settings', false),      Menu(1, 'assets/images/button-exim.png', 'Export Import', false),    ];    //set token    AppConstants.token=await DashboardHelpers.getString('token');    // final pref = await SharedPreferences.getInstance();    // token = pref.getString('token');    // role = pref.getString('role');    // userName = pref.getString('userName');    // designation = pref.getString('designation');    // moduleList = jsonDecode(pref.getString('list') ?? '[]');    // for (var item in moduleList) {    //   int appModuleId = int.parse(item['moduleId'].toString());    //   for (var menu in menus) {    //     if (appModuleId == menu.id) {    //       setState(() {    //         menu.isVisible = true;    //       });    //     }    //   }    // }  }  Future<void> _logout() async {    final pref = await SharedPreferences.getInstance();    await pref.clear();    Navigator.pushReplacement(        context, MaterialPageRoute(builder: (context) => LoginScreen()));  }  @override  void initState() {    super.initState();    _getModules();    _initializeNotifications();    _setupPushNotifications();  }  Future<void> _initializeNotifications() async {    const AndroidInitializationSettings initializationSettingsAndroid =    AndroidInitializationSettings('@mipmap/ic_launcher');    final InitializationSettings initializationSettings = InitializationSettings(      android: initializationSettingsAndroid,      iOS: DarwinInitializationSettings(),    );    await flutterLocalNotificationsPlugin.initialize(      initializationSettings,      onDidReceiveNotificationResponse: (NotificationResponse response) {        _handleNotificationClickFromTap(response.payload);      },    );    const AndroidNotificationChannel channel = AndroidNotificationChannel(      'high_importance_channel',      'High Importance Notifications',      description: 'This channel is used for important notifications.',      importance: Importance.max,    );    await flutterLocalNotificationsPlugin        .resolvePlatformSpecificImplementation<        AndroidFlutterLocalNotificationsPlugin>()        ?.createNotificationChannel(channel);  }  Future<void> _setupPushNotifications() async {    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;    NotificationSettings settings = await _firebaseMessaging.requestPermission(      alert: true,      badge: true,      sound: true,    );    String? token = await _firebaseMessaging.getToken();    debugPrint("FCM Token: $token");    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);    FirebaseMessaging.onMessage.listen((RemoteMessage message) {      debugPrint("Got a message in foreground! ${message.toString()}");      _showNotification(message);    });    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {      debugPrint("Message opened from background: ${message.toString()}");      _handleNotificationClick(message);    });  }  Future<void> _showNotification(RemoteMessage message) async {    final notification = message.notification;    final android = message.notification?.android;    if (notification != null) {      await flutterLocalNotificationsPlugin.show(        notification.hashCode,        notification.title,        notification.body,        NotificationDetails(          android: AndroidNotificationDetails(            'high_importance_channel',            'High Importance Notifications',            channelDescription: 'This channel is used for important notifications.',            icon: android?.smallIcon ?? '@mipmap/ic_launcher',            importance: Importance.max,            priority: Priority.high,          ),          iOS: DarwinNotificationDetails(            presentAlert: true,            presentBadge: true,            presentSound: true,          ),        ),        payload: jsonEncode(message.data),      );    }  }  void _handleNotificationClick(RemoteMessage message) {    debugPrint("Notification clicked with data: ${message.data}");    // Add your navigation logic here based on message data  }  void _handleNotificationClickFromTap(String? payload) {    if (payload != null) {      final data = jsonDecode(payload) as Map<String, dynamic>;      debugPrint("Notification clicked with payload: $data");      // Add your navigation logic here based on payload    }  }  @pragma('vm:entry-point')  static Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {    await Firebase.initializeApp();    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =    FlutterLocalNotificationsPlugin();    const AndroidInitializationSettings initializationSettingsAndroid =    AndroidInitializationSettings('@mipmap/ic_launcher');    final InitializationSettings initializationSettings = InitializationSettings(      android: initializationSettingsAndroid,      iOS: DarwinInitializationSettings(),    );    await flutterLocalNotificationsPlugin.initialize(initializationSettings);    final notification = message.notification;    final android = message.notification?.android;    if (notification != null) {      await flutterLocalNotificationsPlugin.show(        notification.hashCode,        notification.title,        notification.body,        NotificationDetails(          android: AndroidNotificationDetails(            'high_importance_channel',            'High Importance Notifications',            channelDescription: 'This channel is used for important notifications.',            icon: android?.smallIcon ?? '@mipmap/ic_launcher',            importance: Importance.max,            priority: Priority.high,          ),          iOS: DarwinNotificationDetails(            presentAlert: true,            presentBadge: true,            presentSound: true,          ),        ),        payload: jsonEncode(message.data),      );    }  }  @override  Widget build(BuildContext context) {    return Scaffold(      body: Container(        decoration: BoxDecoration(          image: DecorationImage(            image: AssetImage('assets/images/nbn2-min.png'),            fit: BoxFit.fill,          ),        ),        child: Column(          children: [            SizedBox(height: 100),            Image.asset(              'assets/images/logo1-min.png',              height: 120,              width: 200,            ),            Expanded(              child: GridView.builder(                padding: const EdgeInsets.all(10.0),                itemCount: menus.length,                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(                    crossAxisCount: 2),                itemBuilder: (context, index) {                  return GestureDetector(                    onTap: () {                      setState(() {                        myIndex = index;                      });                      _navigateToScreen(index);                    },                    child: Card(                      color: menus[index].isVisible                          ? Colors.blueAccent                          : Colors.white,                      child: Column(                        mainAxisAlignment: MainAxisAlignment.center,                        children: [                          Image.asset(menus[index].icon, height: 50),                          Text(menus[index].title),                        ],                      ),                    ),                  );                },              ),            ),          ],        ),      ),    );  }  void _navigateToScreen(num index) {    debugPrint('Index ${index}');    switch (index) {      case 3:        Navigator.push(context,            CupertinoPageRoute(builder: (context) => MerchandisingScreen()));        break;      case 1:        Navigator.push(context,            CupertinoPageRoute(builder: (context) => ManagementScreen()));        break;      case 5:        Navigator.push(context,            CupertinoPageRoute(builder: (context) => MainProductScreen()));        break;      default:        return;    }  }}class Menu {  final int id;  final String icon;  final String title;  bool isVisible;  Menu(this.id, this.icon, this.title, this.isVisible);}