import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/product_provider.dart';
import 'package:yunusco_group/screens/Products/production_dashboard.dart';
import 'package:yunusco_group/screens/Products/production_efficiency_screen.dart';
import 'package:yunusco_group/screens/Products/widgets/production_screen.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:yunusco_group/utils/constants.dart';

import '../../common_widgets/dashboard_item_card.dart';
import 'get_all_style_screen.dart';
import 'widgets/buyers_screen.dart';

class ProductHomeScreen extends StatelessWidget {
  const ProductHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DashboardMenuItem> menuItems = [
      DashboardMenuItem(
        name: 'Production\nSummary',
        icon: Icons.assessment,
        cardColor: const Color(0xFFE3F2FD), // Light blue
        iconColor: const Color(0xFF1976D2), // Dark blue
        onTap: () async {
          var pp = context.read<ProductProvider>();
          await pp.getAllProductionDashboard();
          pp.getAllDhuInfo(DateTime.now());
          if (pp.productionDashboardModel != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductionDashboard()),
            );
          }
        },
      ),
      DashboardMenuItem(
        name: 'Production\nEfficiency',
        icon: Icons.assured_workload,
        cardColor: const Color(0xFFE8F5E9), // Light green
        iconColor: const Color(0xFF388E3C), // Dark green
        onTap: () async {
          var pp = context.read<ProductProvider>();
          var currentDate = convertDate(DateTime.now());
          await pp.getProductionEfficiencyReport(currentDate);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductionEfficiencyScreen()),
          );
        },
      ),
      DashboardMenuItem(
        name: 'Production\nMonthly/Yearly',
        icon: Icons.calendar_month,
        cardColor: const Color(0xFFFFEBEE), // Light red
        iconColor: const Color(0xFFD32F2F), // Dark red
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ProductionSummaryScreen()),
          );
        },
      ),
      DashboardMenuItem(
        name: 'Buyers',
        icon: Icons.people_alt_outlined,
        cardColor: const Color(0xFFF3E5F5), // Light purple
        iconColor: const Color(0xFF7B1FA2), // Dark purple
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BuyersScreen()),
          );
        },
      ),
      DashboardMenuItem(
        name: 'Stylewise\nEfficiency',
        icon: Icons.style_sharp,
        cardColor: const Color(0xFFFFF8E1), // Light amber
        iconColor: const Color(0xFFFFA000), // Dark amber
        onTap: () async {
          var pp = context.read<ProductProvider>();
          await pp.getAllStyleData();
          if (pp.buyerStyleList.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StyleSelectionScreen()),
            );
          }
        },
      ),
    ];
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(
          'Production Menu',
          style: customTextStyle(18, Colors.white, FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: myColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1,
          ),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            return ReusableDashboardCard(
              menu: DashboardMenuItem(
                name: menuItems[index].name,
                icon: menuItems[index].icon,
                cardColor: menuItems[index].cardColor,
                iconColor: menuItems[index].iconColor,
                onTap: () => menuItems[index].onTap(),
              ),
            );
          },
        ),
      ),
    );
  }

  String convertDate(DateTime date) {
    // Get the individual components
    String year = date.year.toString();
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');

    // Combine them in YYYY-MM-DD format
    return '$year-$month-$day';
  }
}
