import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/merchandising_provider.dart';

class ApprovalTopCards extends StatelessWidget {
  const ApprovalTopCards({super.key});

  @override
  Widget build(BuildContext context) {
    var mp=Provider.of<MerchandisingProvider>(context,listen: true);
    final totalItems = mp.costingApprovalFilterList.length;
    final pendingCount = mp.costingApprovalFilterList.where((a) => a.finalStatus == 'Pending').length;
    final approvedCount = mp.costingApprovalFilterList.where((a) => a.finalStatus == 'Approved').length;
    final rejectedCount = mp.costingApprovalFilterList.where((a) => a.finalStatus == 'Rejected').length;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          _buildSummaryCard('Total', totalItems.toString(), Colors.blue),
          const SizedBox(width: 10),
          _buildSummaryCard('Pending', pendingCount.toString(), Colors.orange),
          const SizedBox(width: 10),
          _buildSummaryCard('Approved', approvedCount.toString(), Colors.green),
          const SizedBox(width: 10),
          _buildSummaryCard('Rejected', rejectedCount.toString(), Colors.red),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Consumer<MerchandisingProvider>(
            builder: (context,pro,_)=>pro.isLoading?Center(child: CircularProgressIndicator(),):Column(
              children: [
                FittedBox(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
