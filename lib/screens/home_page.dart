import 'dart:async';import 'dart:convert';import 'dart:io' show Platform;import 'package:flutter/material.dart';import 'package:provider/provider.dart';import 'package:shared_preferences/shared_preferences.dart';import 'package:yunusco_group/helper_class/dashboard_helpers.dart';import 'package:yunusco_group/providers/auth_provider.dart';import 'login_screen.dart';class HomeScreen extends StatefulWidget {  final String? buttonLabel;  final bool? isOnTp;  const HomeScreen({Key? key, this.buttonLabel, this.isOnTp}) : super(key: key);  @override  _HomeScreenState createState() => _HomeScreenState();}class _HomeScreenState extends State<HomeScreen> {  int myIndex = 0;  SharedPreferences? sharedPreferences;  String? token, role, userName, designation;  List<Menu> menus = [];  List<dynamic> moduleList = [];  Future<void> _getModules() async {    menus = [      Menu(44, 'assets/images/prodbold.png', 'Products', false),      Menu(6, 'assets/images/merchanbold.png', 'Merchandising', false),      Menu(45, 'assets/images/produbold.png', 'Production', false),      Menu(1, 'assets/images/hrbold.png', 'Human Resource', false),    ];    final pref = await SharedPreferences.getInstance();    token = pref.getString('token');    role = pref.getString('role');    userName = pref.getString('userName');    designation = pref.getString('designation');    moduleList = jsonDecode(pref.getString('list') ?? '[]');    for (var item in moduleList) {      int appModuleId = int.parse(item['moduleId'].toString());      for (var menu in menus) {        if (appModuleId == menu.id) {          setState(() {            menu.isVisible = true;          });        }      }    }  }  Future<void> _logout() async {    final pref = await SharedPreferences.getInstance();    await pref.clear();    Navigator.pushReplacement(        context, MaterialPageRoute(builder: (context) => LoginScreen()));  }  @override  void initState() {    super.initState();    _getModules();  }  @override  Widget build(BuildContext context) {    return Scaffold(      body: SafeArea(        child: Container(          decoration: BoxDecoration(            image: DecorationImage(              image: AssetImage('assets/images/nbn2-min.png'),              fit: BoxFit.fill,            ),          ),          child: Column(            children: [                      Image.asset(                  'assets/images/logo1-min.png',                  height: 120,                  width: 200,                ),                      Expanded(                child: GridView.builder(                  padding: const EdgeInsets.all(10.0),                  itemCount: menus.length,                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(                      crossAxisCount: 2),                  itemBuilder: (context, index) {                    return GestureDetector(                      onTap: () {                        setState(() {                          myIndex = index;                        });                        var ap=context.read<AuthProvider>();                        debugPrint(ap.user!.toJson().toString());                       // _navigateToScreen(menus[index]);                      },                      child: Card(                        color: menus[index].isVisible                            ? Colors.blueAccent                            : Colors.grey,                        child: Column(                          mainAxisAlignment: MainAxisAlignment.center,                          children: [                            Image.asset(menus[index].icon, height: 50),                            Text(menus[index].title),                          ],                        ),                      ),                    );                  },                ),              ),            ],          ),        ),      ),    );  }  void _navigateToScreen(Menu menu) {    if (!menu.isVisible) return;    // Widget screen;    // switch (menu.id) {    //   case 6:    //     screen = MerchandisingScreen();    //     break;    //   case 45:    //     screen = ProductionCharts();    //     break;    //   case 1:    //     screen = MainHRDashBoard(username: userName ?? '', designation: designation ?? '');    //     break;    //   case 44:    //     screen = MainProductScreen();    //     break;    //   default:    //     return;    // }    // Navigator.push(context, MaterialPageRoute(builder: (context) => screen));  }}class Menu {  final int id;  final String icon;  final String title;  bool isVisible;  Menu(this.id, this.icon, this.title, this.isVisible);}