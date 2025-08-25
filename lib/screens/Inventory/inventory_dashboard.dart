import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yunusco_group/screens/Products/garments_requisation_screen.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:yunusco_group/utils/constants.dart';
import '../../common_widgets/dashboard_item_card.dart';
import 'inventory_screen.dart';

class InventoryHomeScreen extends StatelessWidget {
  InventoryHomeScreen({super.key});



  @override
  Widget build(BuildContext context) {
    final List<DashboardMenuItem> menuItems = [
      DashboardMenuItem(
        name: 'Inventory\nSummary',
        icon: Icons.assessment,
        cardColor: const Color(0xFFE3F2FD),
        iconColor: const Color(0xFF2196F3),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => InventoryStockScreen()),
          );
        }, // dummy
      ),
      DashboardMenuItem(
        name: 'Garments\nRequisition',
        icon: Icons.assured_workload,
        cardColor: const Color(0xFFF1F8E9),
        iconColor: const Color(0xFF43A047),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => GarmentsRequisitionScreen()),
          );
        }, // dummy
      ),
    ];
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(
          'Inventory Menu',
          style: customTextStyle(18, Colors.white, FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: myColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: menuItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
              final item = menuItems[index];

              return ReusableDashboardCard(menu: item);
            },
        ),
      ),
    );
  }
}
