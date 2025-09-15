import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helper_class/dashboard_helpers.dart';
import '../providers/auth_provider.dart';
import '../screens/Profile/user_access_type.dart';
import '../screens/login_screen.dart';
import '../utils/google_drive.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: MediaQuery.of(context).size.width * 0.8,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (DashboardHelpers.currentUser != null)
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF000044),
                    Color(0xFF1A0033), // Adds a subtle purple tone
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage(
                      'assets/images/icon.png',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    DashboardHelpers.currentUser!.userName ?? 'Sarah Johnson',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    DashboardHelpers.currentUser!.designation ??
                        'sarah.johnson@example.com',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.black54),
            title: const Text('Home'),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
              // Navigate to home (already here)
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.black54),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to settings
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductCatalogScreen()));
              //  Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangePasswordScreen()));
              //  Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchDropdownScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.black54),
            title: const Text('Production'),
            onTap: () {
              Navigator.pop(context);

              /// Navigate to this screen from another widget
              if(DashboardHelpers.currentUser!.loginName=='38389'){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserFormScreen(),
                  ),
                );
              }

            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await context.read<AuthProvider>().logout();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}
