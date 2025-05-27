import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import 'package:yunusco_group/screens/HR&PayRoll/performence_screen.dart';
import 'package:yunusco_group/screens/Profile/self_leave_application.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:yunusco_group/utils/constants.dart';

import '../Profile/leave_history.dart';
import '../Profile/leave_history_screen.dart';
import '../Profile/my_pay_slip_screen.dart';
import 'attandence_screen.dart';
import 'depertments_screen.dart';
import '../Profile/employee_jobcard_report.dart';

class HrMainMenuScreen extends StatefulWidget {
  @override
  State<HrMainMenuScreen> createState() => _DepartmentListScreenState();
}

class _DepartmentListScreenState extends State<HrMainMenuScreen> {
  final List<Color> cardColors = [
    Color(0xFFE3F2FD), // Department Attendance (Light Blue - Professional)
    Color(0xFFE8F5E9), // Performance (Light Green - Growth)
    Color(0xFFFFF3E0), // Leave Applications (Light Orange - Action/Pending)
    Color(0xFFEDE7F6), // Job Card (Light Purple - Organization)
    Color(0xFFFCE4EC), // Self Leave (Light Pink - Personal/Urgent)
    Color(0xFFE0F7FA), // Leave History (Light Cyan - Past Records)
    Color(0xFFE8EAF6), // Pay Slip (Light Indigo - Financial)
  ];

  final List<IconData> menuIcons = [
    Icons.people_alt,          // Department Attendance (team focus)
    Icons.assessment,          // Performance (metrics)
    Icons.work_history,        // Leave Applications (work timeline)
    Icons.assignment,          // Job Card (task assignment)
    Icons.airplane_ticket,     // Self Leave (personal time off)
    Icons.history_toggle_off,  // Leave History (past records)
    Icons.receipt,             // Pay Slip (financial document)
  ];
  final List<Color> iconColors = [
    Colors.blue[800]!,    // Dark Blue
    Colors.green[700]!,   // Dark Green
    Colors.orange[800]!,  // Dark Orange
    Colors.purple[700]!,  // Dark Purple
    Colors.pink[600]!,    // Dark Pink
    Colors.cyan[700]!,    // Dark Cyan
    Colors.indigo[700]!,  // Dark Indigo
  ];

  List<Map<String,dynamic>> menuList=[];

  @override
  void initState() {
    setMenuItems();
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
        title: Text('HR & Payroll', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
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
          itemCount: 7,
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
    debugPrint('This is called ${index}');
    if (index == 0) {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => AllDepartmentAttendance()));
    }
    if (index == 1) {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => PerformanceReportScreen()));
    }
    if (index == 2) {

      Navigator.push(context, CupertinoPageRoute(builder: (context) => LeaveHistoryScreen()));
    }
    if (index == 3) {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => EmployeeJobCardReportScreen()));
    }
    if (index == 4) {
      //EmployeeLeaveHistoryScreen
      Navigator.push(context, CupertinoPageRoute(builder: (context) => LeaveApplicationScreen()));
    }
    if (index == 5) {
      // Navigator.push(context, CupertinoPageRoute(builder: (context) => ()));
      Navigator.push(context, CupertinoPageRoute(builder: (context) => EmployeeLeaveHistoryScreen()));
    }
    if (index == 6) {
      Navigator.push(context, CupertinoPageRoute(builder: (context) => EmployeePaySlip()));
    }
  }

  void setMenuItems() {
   menuList = [

      {
        "code": 0,
        "name": "Department\nAttendance",
        "cardColor": cardColors[0],
        "iconColor": iconColors[0],
        "icon": Icons.person_pin_outlined, // Matches 'attendance' in your function
      },
      {
        "code": 1,
        "name": "Performance",
        "cardColor": cardColors[1],
        "iconColor": iconColors[1],
        "icon": Icons.favorite, // Direct match in your function
      },
      {
        "code": 2,
        "name": "Leave Applications",
        "cardColor": cardColors[2],
        "iconColor": iconColors[2],
        "icon": Icons.history, // From your function's last condition
      },
      {
        "code": 3,
        "name": "Job Card",
        "cardColor": cardColors[3],
        "iconColor": iconColors[3],
        "icon": Icons.person_pin_outlined, // Same as department attendance
      },
      {
        "code": 4,
        "name": "Self Leave",
        "cardColor": cardColors[4],
        "iconColor": iconColors[4],
        "icon": menuIcons[4],
      },
      {
        "code": 5,
        "name": "Leave\nHistory",
        "cardColor": cardColors[5],
        "iconColor": iconColors[5],
        "icon": menuIcons[5],
      },
      {
        "code": 6,
        "name": "Pay Slip",
        "cardColor": cardColors[6],
        "iconColor": iconColors[6],
        "icon": menuIcons[6],
      },
    ];
  }
}

//     menuList = [
//       {
//         "code": 1,
//         "name": "Self Leave",
//         "cardColor": cardColors[0],
//         "iconColor": iconColors[0],
//         "icon": menuIcons[0],
//       },
//       {
//         "code": 2,
//         "name": "My\nPerformance",
//         "cardColor": cardColors[1],
//         "iconColor": iconColors[1],
//         "icon": menuIcons[1],
//       },
//        {
//          "code": 3,
//          "name": "Leave\nHistory",
//          "cardColor": cardColors[2],
//          "iconColor": iconColors[2],
//          "icon": menuIcons[2],
//        },
//        {
//          "code": 4,
//          "name": "Pay Slip",
//          "cardColor": cardColors[3],
//          "iconColor": iconColors[3],
//          "icon": menuIcons[3],
//        },
//
//     ];
