import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/screens/HR&PayRoll/performence_screen.dart';
import 'package:yunusco_group/screens/HR&PayRoll/vehicle_requisition_screen.dart';
import 'package:yunusco_group/screens/Profile/self_leave_application.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../common_widgets/dashboard_item_card.dart';
import '../Accounts/pf_info_screen.dart';
import '../Profile/capture_nid_info.dart';
import '../Profile/leave_history.dart';
import '../Profile/leave_history_screen.dart';
import '../Profile/my_pay_slip_screen.dart';
import 'attandence_screen.dart';
import 'board_room_booking_screen.dart';
import '../Profile/employee_jobcard_report.dart';
import 'it_ticketing_webview.dart';
import 'meeting_screen_new.dart';
import 'it_ticketing_generate_screen.dart';

class HrMainMenuScreen extends StatefulWidget {
  const HrMainMenuScreen({super.key});

  @override
  State<HrMainMenuScreen> createState() => _DepartmentListScreenState();
}

class _DepartmentListScreenState extends State<HrMainMenuScreen> {
  final List<Color> cardColors = [
    Color(0xFFE3F2FD),
    Color(0xFFE8F5E9),
    Color(0xFFFFF3E0),
    Color(0xFFEDE7F6),
    Color(0xFFFCE4EC),
    Color(0xFFE0F7FA),
    Color(0xFFE8EAF6),
  ];

  final List<Color> iconColors = [
    Colors.blue[800]!,
    Colors.green[700]!,
    Colors.orange[800]!,
    Colors.purple[700]!,
    Colors.pink[600]!,
    Colors.cyan[700]!,
    Colors.indigo[700]!,
  ];

  List<DashboardMenuItem> menuItems = [];

  @override
  void initState() {
    setMenuItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actionsIconTheme: IconThemeData(color: Colors.white),
        title: Text('HR & Payroll', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        backgroundColor: myColors.primaryColor,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return ReusableDashboardCard(menu: menuItems[index]);
        },
      ),
    );
  }

  void goToScreen(int index) {
    debugPrint('This is called $index');
    switch (index) {
      case 0:
        if (DashboardHelpers.currentUser!.isDepartmentHead == true) {
          Navigator.push(context, CupertinoPageRoute(builder: (context) => AllDepartmentAttendance()));
        } else {
          DashboardHelpers.showAlert(msg: 'Not Available');
        }
        break;
      case 1:
        Navigator.push(context, CupertinoPageRoute(builder: (context) => PerformanceReportScreen()));
        break;
      case 2:
        Navigator.push(context, CupertinoPageRoute(builder: (context) => LeaveHistoryScreen()));
        break;
      case 3:
        Navigator.push(context, CupertinoPageRoute(builder: (context) => EmployeeJobCardReportScreen()));
        break;
      case 4:
        Navigator.push(context, CupertinoPageRoute(builder: (context) => LeaveApplicationScreen()));
        break;
      case 5:
        Navigator.push(context, CupertinoPageRoute(builder: (context) => EmployeeLeaveHistoryScreen()));
        break;
      case 6:
        Navigator.push(context, CupertinoPageRoute(builder: (context) => EmployeePaySlip()));
        break;
      case 7:
        //Navigator.push(context, CupertinoPageRoute(builder: (context) => BoardRoomBookingScreen()));
        Navigator.push(context, CupertinoPageRoute(builder: (context) => MeetingsScreen()));
        break;
      case 8:
        Navigator.push(context, CupertinoPageRoute(builder: (context) => VehicleRequisitionForm()));
        break;

    }
  }

  void setMenuItems() {
    menuItems = [
      DashboardMenuItem(
        name: "Department\nAttendance",
        icon: Icons.person_pin_outlined,
        cardColor: cardColors[0],
        iconColor: iconColors[0],
        onTap: () => goToScreen(0),
      ),
      DashboardMenuItem(
        name: "Performance",
        icon: Icons.favorite,
        cardColor: cardColors[1],
        iconColor: iconColors[1],
        onTap: () => goToScreen(1),
      ),
      DashboardMenuItem(
        name: "Leave Applications",
        icon: Icons.history,
        cardColor: cardColors[2],
        iconColor: iconColors[2],
        onTap: () => goToScreen(2),
      ),
      DashboardMenuItem(
        name: "Job Card",
        icon: Icons.person_pin_outlined,
        cardColor: cardColors[3],
        iconColor: iconColors[3],
        onTap: () => goToScreen(3),
      ),
      DashboardMenuItem(
        name: "Self Leave",
        icon: Icons.airplane_ticket,
        cardColor: cardColors[4],
        iconColor: iconColors[4],
        onTap: () => goToScreen(4),
      ),
      DashboardMenuItem(
        name: "Leave\nHistory",
        icon: Icons.history_toggle_off,
        cardColor: cardColors[5],
        iconColor: iconColors[5],
        onTap: () => goToScreen(5),
      ),
      DashboardMenuItem(
        name: "Pay Slip",
        icon: Icons.receipt,
        cardColor: cardColors[6],
        iconColor: iconColors[6],
        onTap: () => goToScreen(6),
      ),
      DashboardMenuItem(
        name: "Call a \nMeeting",
        icon: Icons.room,
        cardColor: cardColors[3], // Using purple from index 3
        iconColor: iconColors[3], // Using purple from index 3
        onTap: () => goToScreen(7),
      ),
      DashboardMenuItem(
        name: "Vehicle\n Requisition",
        icon: Icons.car_repair_rounded,
        cardColor: cardColors[5], // Using cyan from index 5
        iconColor: iconColors[6], // Using indigo from index 6
        onTap: () => goToScreen(8),
      ),

      DashboardMenuItem(
        name: 'Provident Fund',
        icon: Icons.wallet,
        cardColor: Colors.orange.shade100,
        iconColor: Colors.orangeAccent.shade700,
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PfInfoScreen()));
        },
      ),

      DashboardMenuItem(
        name: 'IT Ticket',
        icon: Icons.wallet,
        cardColor: Colors.green.shade100,
        iconColor: Colors.greenAccent.shade700,
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UrlLauncherScreen()));
        },
      ),

      DashboardMenuItem(
        name: 'NID Extractor',
        icon: Icons.add_card_outlined,
        cardColor: Colors.white,
        iconColor: Colors.purple.shade700,
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NidExtractorScreen()));

        },
      ),
    ];
  }
}
