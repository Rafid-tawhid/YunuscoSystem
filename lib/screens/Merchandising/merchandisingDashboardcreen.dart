import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yunusco_group/screens/Merchandising/merchandisingSummaryScreen.dart';
import 'package:yunusco_group/screens/Merchandising/purchase_approval_screen.dart';
import 'package:yunusco_group/screens/Merchandising/bom_screen.dart';
import 'package:yunusco_group/screens/Merchandising/work_order_screen.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../Report/report_screen.dart';
import 'buyer_order_Screen.dart';
import 'costing_approval_screen.dart';

class MerchandisingScreen extends StatefulWidget {
  const MerchandisingScreen({super.key});

  @override
  State<MerchandisingScreen> createState() => _MerchandisingScreenState();
}

class _MerchandisingScreenState extends State<MerchandisingScreen> {
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Merchandising',
          style: customTextStyle(18, Colors.white, FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: myColors.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildDashboardCard(
            context,
            title: "Summary\nChart",
            icon: Icons.analytics_outlined,
            color: const Color(0xFF6A5ACD), // Slate blue
            destination: MerchandisingSummaryScreen(),
          ),

          _buildDashboardCard(
            context,
            title: "Buyer\nOrders",
            icon: Icons.list_alt_outlined,
            color: const Color(0xFF20B2AA), // Light sea green
            destination: BuyerOrderScreen(),
          ),
          _buildDashboardCard(
            context,
            title: "Costing\nApproval",
            icon: Icons.list,
            color: const Color(0xFFD97FF1), // Light sea green
            destination: CostingApprovalListScreen(),
          ),
          _buildDashboardCard(
            context,
            title: "Purchase\nApproval",
            icon: Icons.list,
            color: const Color(0xFFEA978A), // Light sea green
            destination: PurchaseApprovalScreen(),
          ),
          _buildDashboardCard(
            context,
            title: "BOM",
            icon: Icons.calendar_today,
            color: Colors.green[300]!,
            destination: BomListScreen(), // Replace with your actual screen
          ),

          _buildDashboardCard(
            context,
            title: "WO",
            icon: Icons.work,
            color: Colors.purple[300]!,
            destination: WorkOrderScreen(), // Replace with your actual screen
          ),

          _buildDashboardCard(
            context,
            title: "Report",
            icon: Icons.analytics,
            color: Colors.indigo[300]!,
            destination: FactoryReportSlider(), // Replace with your actual screen
          ),


        ],
      ),
    );
  }
  //

  Widget _buildDashboardCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required Widget destination,
      }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => destination),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.15),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.2),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap to view',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


