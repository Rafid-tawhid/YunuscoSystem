import 'package:flutter/material.dart';
import 'package:yunusco_group/screens/Inventory/product_history_screen.dart';
import 'package:yunusco_group/screens/Products/garments_requisation_screen.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:yunusco_group/utils/constants.dart';
import '../../common_widgets/dashboard_item_card.dart';
import 'comperative_statement_list.dart';
import 'inventory_screen.dart';
import 'mis_asset_inventory.dart';

class InventoryHomeScreen extends StatelessWidget {
  const InventoryHomeScreen({super.key});

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
      DashboardMenuItem(
        name: 'Comparative\nStatement',
        icon: Icons.file_copy_outlined,
        cardColor: const Color(0xFFEEDDF8),
        iconColor: const Color(0xFFD97FF1),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ComperativeStatementList()));
        }, // dummy
      ),
      DashboardMenuItem(
        name: 'Purchase\nHistory',
        icon: Icons.file_copy_outlined,
        cardColor: const Color(0xFFEEDDF8),
        iconColor: const Color(0xFF71A8FF),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductHistoryScreen()));
        }, // dummy
      ),
      DashboardMenuItem(
        name: 'MIS\nAssets',
        icon: Icons.videogame_asset,
        cardColor: const Color(0xFFFFFFFF),
        iconColor: const Color(0xFFA6F688),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>MisAssetsScreen()));
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
