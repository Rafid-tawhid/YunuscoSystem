import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yunusco_group/screens/Import/shipment_breakdown.dart';

import '../../common_widgets/dashboard_item_card.dart';
import '../../utils/colors.dart';
import 'master_lc_list_screen.dart';

class ExportImportDashboard extends StatelessWidget {
  const ExportImportDashboard({super.key});


  @override
  Widget build(BuildContext context) {
    late List<DashboardMenuItem> menuItems;
    menuItems = [
      DashboardMenuItem(
        name: "Export\nLC",
        icon: Icons.summarize_outlined,
        cardColor: Colors.orange.shade100,
        iconColor: Colors.orange,
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context)=>MasterLCListScreen()));
        },
      ),
      DashboardMenuItem(
        name: "Shipment\nInfo",
        icon: Icons.account_tree,
        cardColor: Colors.blue.shade100,
        iconColor: Colors.blue,
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context)=>ShipmentBreakdownDashboard()));
        },
      ),

    ];

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text(
          'Export Dashboard',
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
