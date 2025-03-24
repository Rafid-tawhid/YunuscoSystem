import 'package:flutter/material.dart';import 'package:provider/provider.dart';import 'package:yunusco_group/providers/auth_provider.dart';import 'package:yunusco_group/screens/home_page.dart';import 'package:yunusco_group/screens/login_screen.dart';class LauncherScreen extends StatefulWidget {  const LauncherScreen({super.key});  @override  State<LauncherScreen> createState() => _LauncherScreenState();}class _LauncherScreenState extends State<LauncherScreen> {  @override  void initState() {    super.initState();    getUserInfo();  }  @override  Widget build(BuildContext context) {    return Scaffold(      body: Consumer<AuthProvider>(        builder: (context, auth, _) {          if (auth.isLoading) {            return const Center(child: CircularProgressIndicator());          }          return auth.isAuthenticated ? const HomeScreen() : const LoginScreen();        },      ),    );  }  void getUserInfo() async {    // ✅ Use Provider instead of creating a new instance!    final authProvider = Provider.of<AuthProvider>(context, listen: false);    await authProvider.loadUser();  }}