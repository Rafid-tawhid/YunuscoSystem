// management_dashboard_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/management_provider.dart';
import 'package:yunusco_group/screens/Management/widgets/show_departments.dart';
import 'package:yunusco_group/screens/Management/widgets/show_lines.dart';
import 'package:yunusco_group/screens/Management/widgets/show_sections.dart';
import 'package:yunusco_group/screens/Management/widgets/unit_screen.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../common_widgets/dashboard_item_card.dart';
import 'management_screen.dart';

class ManagementDashboardScreen extends StatefulWidget {
  const ManagementDashboardScreen({super.key});

  @override
  State<ManagementDashboardScreen> createState() =>
      _ManagementDashboardScreenState();
}

class _ManagementDashboardScreenState extends State<ManagementDashboardScreen> {
  late List<DashboardMenuItem> menuItems;

  @override
  void initState() {
    super.initState();
    getAllManagementData();
  }

  void getAllManagementData() async {
    var hp = context.read<ManagementProvider>();
    Future.microtask(() {
      hp.getAllDropdownInfoForJobcard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final managementProvider = context.watch<ManagementProvider>();
    final dropdownInfo = managementProvider.allDropdownInfoForJobcard;

    menuItems = [
      DashboardMenuItem(
        name: "Production\nSummary",
        icon: Icons.business,
        cardColor: Colors.blue.shade100,
        iconColor: Colors.blue,
        onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => ManagementProductionScreen()),
        ),
      ),
      DashboardMenuItem(
        name: "Departments",
        icon: Icons.business,
        cardColor: Colors.green.shade100,
        iconColor: Colors.green,
        onTap: dropdownInfo?.departments?.isNotEmpty == true
            ? () => Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => DepartmentsScreen()),
                )
            : () {},
      ),
      DashboardMenuItem(
        name: "Sections",
        icon: Icons.view_list,
        cardColor: Colors.orange.shade100,
        iconColor: Colors.orange,
        onTap: dropdownInfo?.sections?.isNotEmpty == true
            ? () => Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => SectionScreen()),
                )
            : () {},
      ),
      DashboardMenuItem(
        name: "Lines",
        icon: Icons.line_style,
        cardColor: Colors.purple.shade100,
        iconColor: Colors.purple,
        onTap: dropdownInfo?.lines?.isNotEmpty == true
            ? () => Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => LineScreen()),
                )
            : () {},
      ),
      DashboardMenuItem(
        name: "Units",
        icon: Icons.location_city,
        cardColor: Colors.red.shade100,
        iconColor: Colors.red,
        onTap: dropdownInfo?.units?.isNotEmpty == true
            ? () => Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => UnitScreen()),
                )
            : () {},
      ),
      DashboardMenuItem(
        name: "Designations",
        icon: Icons.work,
        cardColor: Colors.grey.shade300,
        iconColor: Colors.grey,
        onTap: () {
          print('Designations tapped');
        },
      ),
      DashboardMenuItem(
        name: "Divisions",
        icon: Icons.category,
        cardColor: Colors.grey.shade300,
        iconColor: Colors.grey,
        onTap: () {
          print('Divisions tapped');
        },
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text(
          'Management',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: myColors.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.2,
          ),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            return ReusableDashboardCard(menu: menuItems[index]);
          },
        ),
      ),
    );
  }
}
