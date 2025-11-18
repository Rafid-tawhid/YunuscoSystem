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
import 'get_all_style_screen.dart';
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
        icon: Icons.compare_arrows,
        cardColor: const Color(0x18BBC5EF), // Light pink
        iconColor: const Color(0xFF180243), // Dark pink
        onTap: () async {
          List<QcPassSummaryModel> dataList=[];
          for(var i in summaryList){
            dataList.add(QcPassSummaryModel.fromJson(i));
          }

          final now = DateTime.now();

          // // Get the first day of previous month
          // final firstDayCurrentMonth = DateTime(now.year, now.month, 1);
          //
          // // Get the last day of previous month
          // final lastDayCurrentMonth = DateTime(now.year, now.month, 0);
          // final todayFormatted = DashboardHelpers.convertDateTime(firstDayCurrentMonth.toString(), pattern: 'yyyy-MM-dd');
          // final yesterdayFormatted = DashboardHelpers.convertDateTime(lastDayCurrentMonth.toString(), pattern: 'yyyy-MM-dd');
          //
          //
          // await ref.read(differenceDataProvider.notifier).loadDifferenceData(todayFormatted, yesterdayFormatted);
          // final asyncDiffData = ref.watch(differenceDataProvider);

          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => QcPassSummaryScreen(monthlyData: dataList,)),
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

var summaryList=[
  {
    "Day": "2025-10-01T00:00:00",
    "TotalPass": 955,
    "TotalDefect": 50,
    "TotalDefectiveGarments": 6,
    "TotalReject": 6,
    "TotalAlterCheck": 9
  },
  {
    "Day": "2025-10-02T00:00:00",
    "TotalPass": 3410,
    "TotalDefect": 279,
    "TotalDefectiveGarments": 249,
    "TotalReject": 0,
    "TotalAlterCheck": 276
  },
  {
    "Day": "2025-10-06T00:00:00",
    "TotalPass": 5670,
    "TotalDefect": 314,
    "TotalDefectiveGarments": 275,
    "TotalReject": 0,
    "TotalAlterCheck": 314
  },
  {
    "Day": "2025-10-07T00:00:00",
    "TotalPass": 5697,
    "TotalDefect": 270,
    "TotalDefectiveGarments": 235,
    "TotalReject": 0,
    "TotalAlterCheck": 270
  },
  {
    "Day": "2025-10-08T00:00:00",
    "TotalPass": 7040,
    "TotalDefect": 375,
    "TotalDefectiveGarments": 321,
    "TotalReject": 0,
    "TotalAlterCheck": 375
  },
  {
    "Day": "2025-10-09T00:00:00",
    "TotalPass": 4884,
    "TotalDefect": 247,
    "TotalDefectiveGarments": 225,
    "TotalReject": 0,
    "TotalAlterCheck": 247
  },
  {
    "Day": "2025-10-11T00:00:00",
    "TotalPass": 5409,
    "TotalDefect": 264,
    "TotalDefectiveGarments": 243,
    "TotalReject": -1,
    "TotalAlterCheck": 256
  },
  {
    "Day": "2025-10-12T00:00:00",
    "TotalPass": 8886,
    "TotalDefect": 637,
    "TotalDefectiveGarments": 629,
    "TotalReject": 0,
    "TotalAlterCheck": 637
  },
  {
    "Day": "2025-10-13T00:00:00",
    "TotalPass": 12103,
    "TotalDefect": 684,
    "TotalDefectiveGarments": 652,
    "TotalReject": 0,
    "TotalAlterCheck": 684
  },
  {
    "Day": "2025-10-14T00:00:00",
    "TotalPass": 15836,
    "TotalDefect": 949,
    "TotalDefectiveGarments": 919,
    "TotalReject": 0,
    "TotalAlterCheck": 949
  },
  {
    "Day": "2025-10-15T00:00:00",
    "TotalPass": 20580,
    "TotalDefect": 1320,
    "TotalDefectiveGarments": 1281,
    "TotalReject": 0,
    "TotalAlterCheck": 1253
  },
  {
    "Day": "2025-10-16T00:00:00",
    "TotalPass": 139893,
    "TotalDefect": 8719,
    "TotalDefectiveGarments": 7657,
    "TotalReject": 0,
    "TotalAlterCheck": 11835
  },
  {
    "Day": "2025-10-18T00:00:00",
    "TotalPass": 155386,
    "TotalDefect": 9119,
    "TotalDefectiveGarments": 8029,
    "TotalReject": 0,
    "TotalAlterCheck": 8318
  },
  {
    "Day": "2025-10-19T00:00:00",
    "TotalPass": 159615,
    "TotalDefect": 9226,
    "TotalDefectiveGarments": 8002,
    "TotalReject": 9,
    "TotalAlterCheck": 8343
  },
  {
    "Day": "2025-10-20T00:00:00",
    "TotalPass": 157505,
    "TotalDefect": 8788,
    "TotalDefectiveGarments": 7648,
    "TotalReject": 0,
    "TotalAlterCheck": 7803
  },
  {
    "Day": "2025-10-21T00:00:00",
    "TotalPass": 163296,
    "TotalDefect": 9190,
    "TotalDefectiveGarments": 8078,
    "TotalReject": 0,
    "TotalAlterCheck": 8296
  },
  {
    "Day": "2025-10-22T00:00:00",
    "TotalPass": 174333,
    "TotalDefect": 10251,
    "TotalDefectiveGarments": 8889,
    "TotalReject": 0,
    "TotalAlterCheck": 9475
  },
  {
    "Day": "2025-10-23T00:00:00",
    "TotalPass": 162531,
    "TotalDefect": 9598,
    "TotalDefectiveGarments": 8578,
    "TotalReject": 0,
    "TotalAlterCheck": 9908
  },
  {
    "Day": "2025-10-25T00:00:00",
    "TotalPass": 116850,
    "TotalDefect": 7285,
    "TotalDefectiveGarments": 6167,
    "TotalReject": 0,
    "TotalAlterCheck": 6302
  },
  {
    "Day": "2025-10-26T00:00:00",
    "TotalPass": 177325,
    "TotalDefect": 9966,
    "TotalDefectiveGarments": 8822,
    "TotalReject": 0,
    "TotalAlterCheck": 9433
  },
  {
    "Day": "2025-10-27T00:00:00",
    "TotalPass": 169981,
    "TotalDefect": 9494,
    "TotalDefectiveGarments": 8410,
    "TotalReject": 0,
    "TotalAlterCheck": 8955
  },
  {
    "Day": "2025-10-28T00:00:00",
    "TotalPass": 159811,
    "TotalDefect": 9541,
    "TotalDefectiveGarments": 8384,
    "TotalReject": 0,
    "TotalAlterCheck": 8254
  },
  {
    "Day": "2025-10-29T00:00:00",
    "TotalPass": 170179,
    "TotalDefect": 9886,
    "TotalDefectiveGarments": 8784,
    "TotalReject": 0,
    "TotalAlterCheck": 10400
  },
  {
    "Day": "2025-10-30T00:00:00",
    "TotalPass": 169841,
    "TotalDefect": 9948,
    "TotalDefectiveGarments": 8759,
    "TotalReject": 0,
    "TotalAlterCheck": 8568
  }
];
