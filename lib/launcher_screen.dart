import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/auth_provider.dart';
import 'package:yunusco_group/utils/colors.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({super.key});
  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {

  @override
  void initState() {
    super.initState();
    setToken();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColors.primaryColor,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void getUserInfo() {
    // ✅ Use Provider instead of creating a new instance!
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.loadUser().then((v) {
      DashboardHelpers.navigationUser(context);
    });
  }

  void setToken() async {
    var token = await DashboardHelpers.getString('token');
    if (token != '') {
      DashboardHelpers.setToken(token);
    }
  }
}
