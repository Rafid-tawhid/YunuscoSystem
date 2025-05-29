import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/management_provider.dart';
import 'package:yunusco_group/providers/merchandising_provider.dart';
import 'package:yunusco_group/screens/Merchandising/merchandisingSummaryScreen.dart';
import 'package:yunusco_group/screens/Merchandising/widgets/buyer_wise_order_quantity.dart';
import 'package:yunusco_group/screens/Merchandising/widgets/buyer_wise_order_value.dart';
import 'package:yunusco_group/screens/Merchandising/widgets/item_wise_sales_value.dart';
import 'package:yunusco_group/screens/Merchandising/widgets/order_shipment_chart.dart';

import '../../models/buyer_wise_value_model.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import 'buyer_order_Screen.dart';
import 'costing_approval.dart';

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
            destination: Text(''),
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


