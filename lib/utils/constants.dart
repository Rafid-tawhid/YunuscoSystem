import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/home_page.dart';

class AppConstants {
  // 🔗 API Base URLs
  //Testing
  //static const String baseUrl = "https://192.168.15.6:5630/";
  // demo
  //static const String baseUrl = "http://192.168.15.6:8090/";
  // static const String
  static final  baseUrl = "http://202.74.243.118:8090/"; //real public

 // static const String apiKey = "AIzaSyAwpFYRk4i1gCEXqDepia2LXtsNuuMHkEY";
  static String token = ''; // 📱 Screen Dimensions
  static const int screenWidth = 428;
  static const int screenHeight = 926;
  static const int screenRegWidth = 428;
  static const int screenRegHeight = 841; // 📝 Text Styles

  static TextStyle title = GoogleFonts.inter(
    fontSize: 16,
    color: Colors.black,
    fontWeight: FontWeight.w700,
  );

  static TextStyle sub_title = GoogleFonts.inter(
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );

  //
  //
  static TextStyle body = GoogleFonts.inter(
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.w400,
  ); // ℹ️ Dynamic Text Style Function
  static TextStyle customTextStyle(
          double size, Color color, FontWeight weight) =>
      GoogleFonts.inter(
        fontSize: size,
        color: color,
        fontWeight: weight,
      );
  static TextStyle customNormalStyle() => GoogleFonts.inter(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      );
}

TextStyle customTextStyle(double size, Color color, FontWeight weight) =>
    GoogleFonts.inter(
      fontSize: size,
      color: color,
      fontWeight: weight,
    ); //
List<Menu> fullModuleList = [
  Menu(7, 'assets/images/purchase.png', 'Purchasing',
      false), // ID matched from moduleList
  Menu(44, 'assets/images/management.png', 'Management', false), // ID matched
  Menu(1, 'assets/images/hrbold.png', 'HR & Payroll', false), // ID matched
  Menu(6, 'assets/images/button-merch.png', 'Merchandising',
      false), // ID matched
  Menu(8, 'assets/images/planbold.png', 'Planning', false), // ID matched
  Menu(9, 'assets/images/prodbold.png', 'IE', false), // ID matched
  Menu(10, 'assets/images/prodbold.png', 'Cutting', false), // ID matched
  Menu(11, 'assets/images/prodbold.png', 'Sewing', false), // ID matched
  Menu(12, 'assets/images/prodbold.png', 'Finishing', false), // ID matched
  Menu(13, 'assets/images/INVENTORY-min.png', 'Inventory', false), // ID matched
  Menu(4, 'assets/images/ATTENDANCE-min.png', 'Accounts',
      false), // ID matched (Accounts is ID 4)
  Menu(14, 'assets/images/button-exim.png', 'Export Import',
      false), // ID matched // Menu(17, 'assets/images/button-trims.png', 'Trims Sales', false),  // ID matched
  Menu(18, 'assets/images/button-sec.png', 'Settings',
      false), // ID matched // Menu(5, 'assets/images/button-trims.png', 'Sample', false),        // ID matched
  Menu(0, 'assets/images/ATTENDANCE-min.png', 'Profile',
      false), // Kept ID 0 (not in moduleList)
  Menu(45, 'assets/images/prodbold.png', 'Production', false), // ID matched
  Menu(46, 'assets/images/report.png', 'Reports',
      false), // ID matched (assuming you add report.png)
  Menu(52, 'assets/images/medical.png', 'Medical',
      false), // ID matched (assuming you add report.png)
];



class PurchaseStatus {
  static String deptHeadApproved='DeptHeadApproved';
  static String deptHeadRejected='DeptHeadRejected';
  static String managementApproved='ManagementApproved';
  static String managementRejected='ManagementRejected';
}

class ItTicketStatus {
  static const String pending='Pending';
  static const String appointmentTime='Waiting';
  static const String inProgress='InProgress';
  static const String completed='Completed';
}

