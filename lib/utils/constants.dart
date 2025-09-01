import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/home_page.dart';

class AppConstants {
  // 🔗 API Base URLs
   //tatic const String baseUrl = "https://192.168.15.6:5630/";
  // demo
   // static const String baseUrl = "http://192.168.15.6:8090/";// static const String
   static final  baseUrl = "http://202.74.243.118:8090/"; //real public

  static const String apiKey = "AIzaSyAwpFYRk4i1gCEXqDepia2LXtsNuuMHkEY";
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
  Menu(52, 'assets/images/report.png', 'Medical',
      false), // ID matched (assuming you add report.png)
];
List<Map<String, dynamic>> allDepartmentList = [
  {"id": 1, "name": "Accessories"},
  {"id": 2, "name": "Accounts & Finance"},
  {"id": 3, "name": "Audit & Internal Control"},
  {"id": 4, "name": "Business Assessment"},
  {"id": 5, "name": "Commercial"},
  {"id": 6, "name": "Production & Quality"},
  {"id": 7, "name": "Customer Service"},
  {"id": 8, "name": "Data Entry"},
  {"id": 9, "name": "Design"},
  {"id": 10, "name": "HR Admin & Compliance"},
  {"id": 11, "name": "IE"},
  {"id": 12, "name": "LAB"},
  {"id": 13, "name": "Logistic"},
  {"id": 14, "name": "Maintenance old"},
  {"id": 15, "name": "Management"},
  {"id": 16, "name": "Merchandising"},
  {"id": 17, "name": "MIS"},
  {"id": 18, "name": "Planning"},
  {"id": 19, "name": "Product Development"},
  {"id": 20, "name": "Production"},
  {"id": 21, "name": "Quality Control"},
  {"id": 22, "name": "Sales & Marketing"},
  {"id": 23, "name": "Sample & CAD"},
  {"id": 24, "name": "Store"},
  {"id": 25, "name": "Supply Chain"},
  {"id": 26, "name": "Technical"},
  {"id": 27, "name": "Quality Assurance"},
  {"id": 28, "name": "Operations"},
  {"id": 29, "name": "Tag"},
  {"id": 30, "name": "Design & Product Development"},
  {"id": 31, "name": "Extra"},
  {"id": 32, "name": "Flexo"},
  {"id": 33, "name": "Heat Transfer"},
  {"id": 34, "name": "Medical"},
  {"id": 35, "name": "PFL"},
  {"id": 36, "name": "Pre-Press"},
  {"id": 37, "name": "Printing"},
  {"id": 38, "name": "Purchase"},
  {"id": 39, "name": "Sample & Technical"},
  {"id": 40, "name": "Sourcing"},
  {"id": 41, "name": "Thermal"},
  {"id": 42, "name": "Maintenance"},
  {"id": 43, "name": "Woven"},
  {"id": 44, "name": "Knitting"},
  {"id": 45, "name": "Technical & Planning"},
  {"id": 46, "name": "HR & GA"},
  {"id": 47, "name": "Facility Maintenance"},
  {"id": 48, "name": "Digital Marketing"},
  {"id": 49, "name": "Admin & Accounts"},
  {"id": 50, "name": "Administration"},
  {"id": 51, "name": "Administration"},
  {"id": 52, "name": "Design Studio"},
  {"id": 53, "name": "Business Development"},
  {"id": 54, "name": "Creative Product Development"}
];

/// Represents the different statuses for leave applications class LeaveStatus {
  // Status code constants static const int pendingLeaveNormalUser = 1;
  const int secondPersonApproval = 2;
  const int rejected = 3;
  const int departmentHeadLeaveApply = 4;
  const int approved = 22;


//1020643123653-i7hnm79159l9ts7qicofnqrnu20bc6j8.apps.googleusercontent.com
