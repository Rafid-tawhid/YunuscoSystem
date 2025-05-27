import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:yunusco_group/utils/constants.dart';

// class HrDepartmentListApp extends StatefulWidget {
//
//   @override
//   State<HrDepartmentListApp> createState() => _DepartmentListScreenState();
// }
//
// class _DepartmentListScreenState extends State<HrDepartmentListApp> {
//
//    List<Color> cardColors = [
//     Color(0xFFE3F2FD), // Light Blue
//     Color(0xFFE8F5E9), // Light Green
//     Color(0xFFFFF8E1), // Light Amber
//     Color(0xFFF3E5F5), // Light Purple
//     Color(0xFFFFEBEE), // Light Red
//     Color(0xFFE0F7FA), // Light Cyan
//   ];
//
//    List<Color> iconColors = [
//     Color(0xFF1E88E5), // Blue
//     Color(0xFF43A047), // Green
//     Color(0xFFFB8C00), // Orange
//     Color(0xFF8E24AA), // Purple
//     Color(0xFFE53935), // Red
//     Color(0xFF00ACC1), // Teal
//   ];
//   @override
//   void initState() {
//     var hp = context.read<HrProvider>();
//     hp.getHRMenuList();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         iconTheme: IconThemeData(
//           color: Colors.white, // Your primary color
//         ),
//         actionsIconTheme: IconThemeData(
//           color: Colors.white
//         ),
//         title: Text('Departments',
//             style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 24)),
//         centerTitle: true,
//         backgroundColor: myColors.primaryColor,
//         elevation: 10,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(20),
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.blue[50]!, Colors.white],
//           ),
//         ),
//         child: Consumer<HrProvider>(
//             builder: (context, pro, _) =>
//             pro.hrMenuList.isEmpty ? Center(
//               child: Text('No Data Found'),
//             ) :
//             GridView.builder(
//               padding: EdgeInsets.all(16),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 childAspectRatio: 1,
//               ),
//               itemCount: pro.hrMenuList.length,
//               itemBuilder: (context, index) {
//                 final department = pro.hrMenuList[index];
//                 final colorIndex = index % cardColors.length;
//                 final iconData = _getDepartmentIcon(department['name']);
//                 return Container(
//                   decoration: BoxDecoration(
//                     color: cardColors[colorIndex],
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 6,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Material(
//                     color: Colors.transparent,
//                     child: InkWell(
//                       borderRadius: BorderRadius.circular(16),
//                       onTap: () {},
//                       splashColor: iconColors[colorIndex].withOpacity(0.2),
//                       highlightColor: iconColors[colorIndex].withOpacity(0.1),
//                       child: Padding(
//                         padding: EdgeInsets.all(16),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               padding: EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: iconColors[colorIndex].withOpacity(0.2),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Icon(
//                                 iconData,
//                                 size: 32,
//                                 color: iconColors[colorIndex],
//                               ),
//                             ),
//                             SizedBox(height: 16),
//                             Text(
//                               department['name'],
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.black87,
//                               ),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             )
//         ),
//       ),
//
//     );
//   }
//
// // Helper function to assign icons
//   IconData _getDepartmentIcon(String name) {
//     name = name.toLowerCase();
//
//     if (name.contains('accessories')) return Icons.shopping_bag_outlined;
//     if (name.contains('account')) return Icons.account_balance_outlined;
//     if (name.contains('audit')) return Icons.assignment_turned_in_outlined;
//     if (name.contains('commercial')) return Icons.business_center_outlined;
//     if (name.contains('production')) return Icons.factory_outlined;
//     if (name.contains('customer')) return Icons.headset_mic_outlined;
//     if (name.contains('hr')) return Icons.people_alt_outlined;
//     if (name.contains('ie')) return Icons.engineering_outlined;
//     if (name.contains('lab')) return Icons.science_outlined;
//     if (name.contains('management')) return Icons.leaderboard_outlined;
//     if (name.contains('merchandising')) return Icons.store_mall_directory_outlined;
//     if (name.contains('mis')) return Icons.laptop_mac_outlined;
//     if (name.contains('planning')) return Icons.calendar_today_outlined;
//     if (name.contains('product dev')) return Icons.developer_board_outlined;
//     if (name.contains('quality')) return Icons.verified_outlined;
//     if (name.contains('sales')) return Icons.attach_money_outlined;
//     if (name.contains('sample')) return Icons.content_cut_outlined;
//     if (name.contains('store')) return Icons.storefront_outlined;
//     if (name.contains('supply')) return Icons.local_shipping_outlined;
//     if (name.contains('technical')) return Icons.build_outlined;
//     if (name.contains('design')) return Icons.design_services_outlined;
//     if (name.contains('digital')) return Icons.online_prediction_outlined;
//     if (name.contains('admin')) return Icons.admin_panel_settings_outlined;
//     if (name.contains('business')) return Icons.business_outlined;
//
//     return Icons.work_outlined;
//   }
// }