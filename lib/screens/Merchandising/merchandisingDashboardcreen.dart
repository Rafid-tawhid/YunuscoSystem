import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yunusco_group/screens/Merchandising/merchandisingSummaryScreen.dart';
import 'package:yunusco_group/screens/Merchandising/purchase_approval_screen.dart';
import 'package:yunusco_group/screens/Merchandising/bom_screen.dart';
import 'package:yunusco_group/screens/Merchandising/work_order_screen.dart';
import 'package:yunusco_group/screens/Report/report_screen.dart';
import 'package:yunusco_group/screens/Merchandising/buyer_order_Screen.dart';
import 'package:yunusco_group/screens/Merchandising/costing_approval_screen.dart';
import '../../common_widgets/dashboard_item_card.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';

class MerchandisingScreen extends StatefulWidget {
  const MerchandisingScreen({super.key});

  @override
  State<MerchandisingScreen> createState() => _MerchandisingScreenState();
}

class _MerchandisingScreenState extends State<MerchandisingScreen> {
  late final List<DashboardMenuItem> menuItems;

  @override
  void initState() {
    super.initState();

    menuItems = [
      DashboardMenuItem(
        name: "Summary\nChart",
        icon: Icons.analytics_outlined,
        cardColor: const Color(0xFFEDE7F6), // Light lavender
        iconColor: const Color(0xFF673AB7), // Deep purple
        onTap: () => Navigator.push(context,
            CupertinoPageRoute(builder: (_) => MerchandisingSummaryScreen())),
      ),
      DashboardMenuItem(
        name: "Buyer\nOrders",
        icon: Icons.list_alt_outlined,
        cardColor: const Color(0xFFE0F2F1), // Light mint
        iconColor: const Color(0xFF009688), // Teal
        onTap: () => Navigator.push(
            context, CupertinoPageRoute(builder: (_) => BuyerOrderScreen())),
      ),
      DashboardMenuItem(
        name: "Costing\nApproval",
        icon: Icons.list,
        cardColor: const Color(0xFFFFF8E1), // Light yellow
        iconColor: const Color(0xFFFFB300), // Amber
        onTap: () => Navigator.push(context,
            CupertinoPageRoute(builder: (_) => CostingApprovalListScreen())),
      ),
      DashboardMenuItem(
        name: "Purchase\nApproval",
        icon: Icons.list,
        cardColor: const Color(0xFFFFEBEE), // Light coral
        iconColor: const Color(0xFFE57373), // Coral Red
        onTap: () => Navigator.push(context,
            CupertinoPageRoute(builder: (_) => PurchaseApprovalScreen())),
      ),
      DashboardMenuItem(
        name: "BOM",
        icon: Icons.calendar_today,
        cardColor: const Color(0xFFE8F5E9), // Light green
        iconColor: const Color(0xFF4CAF50), // Emerald Green
        onTap: () => Navigator.push(
            context, CupertinoPageRoute(builder: (_) => BomListScreen())),
      ),
      DashboardMenuItem(
        name: "WO",
        icon: Icons.work,
        cardColor: const Color(0xFFE3F2FD), // Soft indigo
        iconColor: const Color(0xFF3F51B5), // Indigo
        onTap: () => Navigator.push(
            context, CupertinoPageRoute(builder: (_) => WorkOrderScreen())),
      ),
      DashboardMenuItem(
        name: "Report",
        icon: Icons.analytics,
        cardColor: const Color(0xFFE1F5FE), // Light blue
        iconColor: const Color(0xFF2196F3), // Blue
        onTap: () => Navigator.push(context,
            CupertinoPageRoute(builder: (_) => ProductionStrengthScreen())),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(
          'Merchandising',
          style: customTextStyle(18, Colors.white, FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: myColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return ReusableDashboardCard(menu: menuItems[index]);
        },
      ),
    );
  }
}
