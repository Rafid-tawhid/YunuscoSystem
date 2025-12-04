import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/models/qc_difference_model.dart';
import 'package:yunusco_group/models/qc_pass_summary_model.dart';
import 'package:yunusco_group/providers/product_provider.dart';
import 'package:yunusco_group/screens/Products/production_dashboard.dart';
import 'package:yunusco_group/screens/Products/production_efficiency_screen.dart';
import 'package:yunusco_group/screens/Products/production_qc_screen.dart';
import 'package:yunusco_group/screens/Products/qc_difference_screen.dart';
import 'package:yunusco_group/screens/Products/qc_monthly_summary.dart';
import 'package:yunusco_group/screens/Products/widgets/production_screen.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:yunusco_group/utils/constants.dart';

import '../../common_widgets/dashboard_item_card.dart';
import '../../models/production_qc_model.dart';
import '../../providers/riverpods/production_provider.dart';
import 'error_summary.dart';
import 'get_all_style_screen.dart';
import 'machine_problem_request.dart';
import 'widgets/buyers_screen.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductHomeScreen extends ConsumerWidget {

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final List<DashboardMenuItem> menuItems = [
      DashboardMenuItem(
        name: 'Production\nSummary',
        icon: Icons.summarize,
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
        icon: Icons.trending_up,
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
        icon: Icons.calendar_today,
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
        icon: Icons.business_center,
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
        icon: Icons.insights,
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
      DashboardMenuItem(
        name: 'QC\nReport',
        icon: Icons.analytics,
        cardColor: const Color(0xFFE0F2F1), // Light teal
        iconColor: const Color(0xFF00796B), // Dark teal
        onTap: () async {
          final today = DateTime.now();
          final yesterday = today.subtract(const Duration(days: 1));
          final yesterdayFormatted = DashboardHelpers.convertDateTime(yesterday.toString(), pattern: 'yyyy-MM-dd');
          await ref.read(qcDataProvider.notifier).loadQcData(yesterdayFormatted);
          final qcDataAsync = ref.watch(qcDataProvider);

          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => ProductionQcListScreen()),
          );
        },
      ),
      DashboardMenuItem(
        name: 'QC\nDifference',
        icon: Icons.compare_arrows,
        cardColor: const Color(0xFFFCE4EC), // Light pink
        iconColor: const Color(0xFFC2185B), // Dark pink
        onTap: () async {
          final today = DateTime.now();
          final yesterday = today.subtract(const Duration(days: 1));
          final todayFormatted = DashboardHelpers.convertDateTime(DateTime.now().toString(), pattern: 'yyyy-MM-dd');
          final yesterdayFormatted = DashboardHelpers.convertDateTime(yesterday.toString(), pattern: 'yyyy-MM-dd');
          await ref.read(differenceDataProvider.notifier).loadDifferenceData(todayFormatted, yesterdayFormatted);
          final asyncDiffData = ref.watch(differenceDataProvider);
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => QcDifferenceDashboard()),
          );
        },
      ),

      DashboardMenuItem(
        name: 'QC\nSummary',
        icon: Icons.analytics,
        cardColor: const Color(0xFFEFF6FF), // Light blue
        iconColor: const Color(0xFF1D4ED8), // Deep blue
        onTap: () async {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => QcPassSummaryScreen()),
          );
        },
      ),

      DashboardMenuItem(
        name: 'Error\nSummary',
        icon: Icons.insights,
        cardColor: const Color(0xFFFFF4E6), // Light orange
        iconColor: const Color(0xFFEA580C), // Deep orange
        onTap: () async {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => ErrorSummaryScreen()),
          );
        },
      ),

      DashboardMenuItem(
        name: 'Machine\nBreakdown',
        icon: Icons.insights,
        cardColor: const Color(0xFFC4B0EF), // Light orange
        iconColor: Colors.purple, // Deep orange
        onTap: () async {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => MachineRepairScreen()),
          );
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

