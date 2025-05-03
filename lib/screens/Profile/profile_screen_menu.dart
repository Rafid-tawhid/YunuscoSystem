import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/screens/Profile/self_leave_application.dart';

import '../../utils/colors.dart';
import 'employee_attendance.dart';
import 'leave_history_screen.dart';

class ProfileScreenMenu extends StatefulWidget {
  ProfileScreenMenu({super.key});

  @override
  State<ProfileScreenMenu> createState() => _ProfileScreenMenuState();
}

class _ProfileScreenMenuState extends State<ProfileScreenMenu> {
  List<Color> cardColors = [
    Color(0xFFE3F2FD), // Light Blue
    Color(0xFFE8F5E9), // Light Green
    Color(0xFFFFF8E1), // Light Amber
    Color(0xFFF3E5F5), // Light Purple
    Color(0xFFFFEBEE), // Light Red
    Color(0xFFE0F7FA), // Light Cyan
  ];

  List<Color> iconColors = [
    Color(0xFFE53935), // Red
    Color(0xFF00ACC1), // Teal
    Color(0xFF1E88E5), // Blue
    Color(0xFF43A047), // Green
    Color(0xFFFB8C00), // Orange
    Color(0xFF8E24AA), // Purple
  ];

  List<Map<String, dynamic>> menuList = [
    {
      "code": 1,
      "name": "Self Leave"
    },
    {
      "code": 2,
      "name": "Leave\nHistory"
    },
    {
      "code": 3,
      "name": "Performance"
    },
    {
      "code": 4,
      "name": "Attendance\nHistory"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Your primary color
        ),
        actionsIconTheme: IconThemeData(
            color: Colors.white
        ),
        title: Text('Dashboard',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24)),
        centerTitle: true,
        backgroundColor: myColors.primaryColor,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.white],
          ),
        ),
        child: GridView.builder(
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            final menu = menuList[index];
            final colorIndex = index % cardColors.length;
            final iconData = _getDepartmentIcon(index);
            return Container(
              decoration: BoxDecoration(
                color: cardColors[colorIndex],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    goToScreen(index);
                  },
                  splashColor: iconColors[colorIndex].withOpacity(0.2),
                  highlightColor: iconColors[colorIndex].withOpacity(0.1),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: iconColors[colorIndex].withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            iconData,
                            size: 32,
                            color: iconColors[colorIndex],
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          menu['name'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),

    );
  }

// Helper function to assign icons
  IconData _getDepartmentIcon(int index) {

    if(index==0){
      return Icons.leave_bags_at_home_sharp;
    }
    else if(index==1){
      return Icons.history_outlined;
    }
    else if(index==2){
      return Icons.add_chart_outlined;
    }
    else if(index==3){
      return Icons.history_edu;
    }

    return Icons.work_outlined;
  }

  void goToScreen(index) {
    debugPrint('This is called ${index}');
    if (index == 0) {
      Navigator.push(context, CupertinoPageRoute(builder: (context)=>LeaveApplicationScreen()));
    }
    if (index == 1) {
     //
      Navigator.push(context, CupertinoPageRoute(builder: (context)=>LeaveHistoryScreen()));
    }
    if (index == 2) {
      DashboardHelpers.showAlert(msg: 'No Data');
    }
    if (index == 3) {
      //
      Navigator.push(context, CupertinoPageRoute(builder: (context)=>AttendanceReportScreen()));
    }

  }
}
