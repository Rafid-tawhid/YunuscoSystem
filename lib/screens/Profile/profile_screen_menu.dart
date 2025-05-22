import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/screens/Profile/self_leave_application.dart';
import 'package:yunusco_group/utils/constants.dart';

import '../../utils/colors.dart';
import '../HR&PayRoll/performence_screen.dart';
import 'employee_attendance.dart';
import 'leave_history.dart';
import 'leave_history_screen.dart';

class ProfileScreenMenu extends StatefulWidget {
  ProfileScreenMenu({super.key});

  @override
  State<ProfileScreenMenu> createState() => _ProfileScreenMenuState();
}

class _ProfileScreenMenuState extends State<ProfileScreenMenu> {


  final List<Color> cardColors = [
    Color(0xFFFCE4EC), // Light Pink (for leave)
    Color(0xFFE1F5FE), // Light Blue (for history)
    Color(0xFFE8F5E9), // Light Green (for performance)
    Color(0xFFFFF8E1), // Light Amber (for attendance)
  ];

  final List<Color> iconColors = [
    Color(0xFFEC407A), // Pink
    Color(0xFF039BE5), // Blue
    Color(0xFF43A047), // Green
    Color(0xFFFFA000), // Amber
  ];

  final List<IconData> menuIcons = [
    Icons.airplanemode_active, // For Self Leave
    Icons.trending_up,             // For Leave History
    Icons.history,         // For Performance// For Attendance History
  ];

  // Menu list with all properties
  late List<Map<String, dynamic>> menuList = [];


  @override
  void initState() {
    setMenuList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Your primary color
        ),
        actionsIconTheme: IconThemeData(color: Colors.white),
        title: Text('Dashboard', style: customTextStyle(20, Colors.white, FontWeight.w600)),
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
          itemCount:3,
          itemBuilder: (context, index) {
            final menu = menuList[index];
            final colorIndex = index % cardColors.length;
            final iconData = menu['icon'];
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


  void goToScreen(index) {
    debugPrint('This is INDEX ${index}');
    if (index == 0) {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => LeaveApplicationScreen()));
    }
    if (index == 1) {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => PerformanceReportScreen()));
    }
    if (index == 2) {
     // Navigator.push(context, CupertinoPageRoute(builder: (context) => EmployeeLeaveHistoryScreen()));
      Navigator.push(context, CupertinoPageRoute(builder: (context) => LeaveHistoryScreen()));
    }

  }

  void setMenuList() {
     menuList = [
      {
        "code": 1,
        "name": "Self Leave",
        "cardColor": cardColors[0],
        "iconColor": iconColors[0],
        "icon": menuIcons[0],
      },
      {
        "code": 2,
        "name": "My\nPerformance",
        "cardColor": cardColors[1],
        "iconColor": iconColors[1],
        "icon": menuIcons[1],
      },
       {
         "code": 3,
         "name": "Leave\nHistory",
         "cardColor": cardColors[2],
         "iconColor": iconColors[2],
         "icon": menuIcons[2],
       },

    ];
  }
}
