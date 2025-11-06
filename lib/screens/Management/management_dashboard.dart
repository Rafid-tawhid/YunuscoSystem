// management_dashboard_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/management_provider.dart';
import 'package:yunusco_group/screens/Management/shipment_info_screen.dart';
import 'package:yunusco_group/screens/Management/widgets/kaizan_screen.dart';
import 'package:yunusco_group/screens/Management/widgets/show_departments.dart';
import 'package:yunusco_group/screens/Management/widgets/show_lines.dart';
import 'package:yunusco_group/screens/Management/widgets/show_sections.dart';
import 'package:yunusco_group/screens/Management/widgets/unit_screen.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../common_widgets/dashboard_item_card.dart';
import 'mmr_dhu_screen.dart';
import 'production_strength_screen.dart';
import 'announcement_screen.dart';
import 'efficiency_report_screen.dart';
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
        icon: Icons.analytics_outlined,
        cardColor: Colors.blue.shade50,
        iconColor: Colors.blue.shade700,
        onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => ManagementProductionScreen()),
        ),
      ),
      DashboardMenuItem(
        name: "Item wise\nEfficiency",
        icon: Icons.trending_up_rounded,
        cardColor: Colors.green.shade50,
        iconColor: Colors.green.shade700,
        onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => EfficiencyScreen()),
        ),
      ),
      DashboardMenuItem(
        name: "Production\nStrength",
        icon: Icons.bolt_rounded,
        cardColor: Colors.orange.shade50,
        iconColor: Colors.orange.shade700,
        onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => ProductionStrengthScreen()),
        ),
      ),
      DashboardMenuItem(
        name: "Shipment\nInfo",
        icon: Icons.local_shipping_rounded,
        cardColor: Colors.purple.shade50,
        iconColor: Colors.purple.shade700,
        onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => ShipmentInfoScreen()),
        ),
      ),
      DashboardMenuItem(
        name: "DHU",
        icon: Icons.punch_clock_sharp,
        cardColor: Colors.green.shade50,
        iconColor: Colors.green.shade700,
        onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => DHUScreen()),
        ),
      ),
      DashboardMenuItem(
        name: "Departments",
        icon: Icons.account_tree_rounded,
        cardColor: Colors.indigo.shade50,
        iconColor: Colors.indigo.shade700,
        onTap: dropdownInfo?.departments?.isNotEmpty == true
            ? () => Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => DepartmentsScreen()),
        )
            : () {},
      ),
      DashboardMenuItem(
        name: "Sections",
        icon: Icons.view_quilt_rounded,
        cardColor: Colors.teal.shade50,
        iconColor: Colors.teal.shade700,
        onTap: dropdownInfo?.sections?.isNotEmpty == true
            ? () => Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => SectionScreen()),
        )
            : () {},
      ),
      DashboardMenuItem(
        name: "Lines",
        icon: Icons.schema_rounded,
        cardColor: Colors.pink.shade50,
        iconColor: Colors.pink.shade700,
        onTap: dropdownInfo?.lines?.isNotEmpty == true
            ? () => Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => LineScreen()),
        )
            : () {},
      ),
      DashboardMenuItem(
        name: "Units",
        icon: Icons.apartment_rounded,
        cardColor: Colors.deepOrange.shade50,
        iconColor: Colors.deepOrange.shade700,
        onTap: dropdownInfo?.units?.isNotEmpty == true
            ? () => Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => UnitScreen()),
        )
            : () {},
      ),

      DashboardMenuItem(
        name: "Kaizan",
        icon: Icons.auto_awesome_rounded,
        cardColor: Colors.amber.shade50,
        iconColor: Colors.amber.shade700,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>KaizanCountScreen()));
        },
      ),
      DashboardMenuItem(
        name: "Announcement",
        icon: Icons.campaign_rounded,
        cardColor: Colors.red.shade50,
        iconColor: Colors.red.shade700,
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context)=>AnnouncementScreen()));
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
