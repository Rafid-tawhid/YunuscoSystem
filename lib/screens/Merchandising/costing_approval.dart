import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/merchandising_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/costing_approval_list_model.dart';

class CostingApprovalListScreen extends StatefulWidget {

  @override
  State<CostingApprovalListScreen> createState() => _CostingApprovalListScreenState();
}

class _CostingApprovalListScreenState extends State<CostingApprovalListScreen> {
  final NumberFormat currencyFormat = NumberFormat.currency(symbol: '\$');
  final NumberFormat percentFormat = NumberFormat.decimalPercentPattern(decimalDigits: 2);

  @override
  void initState() {
    var mp=context.read<MerchandisingProvider>();
    mp.getCostingApprovalList('1212');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Costing Approvals'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade800, Colors.blue.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              // Add filter functionality
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey.shade50, Colors.grey.shade100],
          ),
        ),
        child: Column(
          children: [
            _buildSummaryCards(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Consumer<MerchandisingProvider>(builder: (context,pro,_)=>ListView.separated(
                    itemCount: pro.costingApprovalList.length,
                    separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade200),
                    itemBuilder: (context, index) {
                      final approval = pro.costingApprovalList[index];
                      return _buildApprovalItem(approval);
                    },
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    // Calculate summary statistics
    var mp=context.read<MerchandisingProvider>();
    final totalItems = mp.costingApprovalList.length;
    final pendingCount = mp.costingApprovalList.where((a) => a.finalStatus == 'Pending').length;
    final approvedCount = mp.costingApprovalList.where((a) => a.finalStatus == 'Approved').length;
    final rejectedCount = mp.costingApprovalList.where((a) => a.finalStatus == 'Rejected').length;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
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
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalItem(CostingApprovalListModel approval) {
    return ExpansionTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _getStatusColor(approval.finalStatus).withOpacity(0.2),
        ),
        child: Center(
          child: Icon(
            _getStatusIcon(approval.finalStatus),
            color: _getStatusColor(approval.finalStatus),
            size: 20,
          ),
        ),
      ),
      title: Text(
        'Costing Code: ${approval.costingCode ?? 'N/A'}',
        style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 13),
      ),

      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text('Buyer: ${approval.buyerName ?? 'N/A'}',style: TextStyle(fontSize: 12),),
          Text('${approval.styleName} (${approval.materialMaxBudget}\$ max)',style: TextStyle(fontSize: 12),)
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${double.parse(approval.profitCostInPercent.toString()).toStringAsFixed(2)}%',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            approval.finalStatus ?? 'Status N/A',
            style: TextStyle(
              color: _getStatusColor(approval.finalStatus),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            children: [
              _buildDetailRow('Category', approval.catagoryName),
              _buildDetailRow('Style Ref', approval.styleRef),
              _buildDetailRow('Created By', approval.createdBy),
              _buildDetailRow('Created Date', approval.createdDate),
              _buildDetailRow('Submit To', approval.submitToPerson),
              _buildDetailRow('Version', approval.version?.toString()),
              _buildDetailRow('Material Budget', currencyFormat.format(approval.materialMaxBudget)),
              _buildDetailRow('Material Cost', currencyFormat.format(approval.materialCost)),
              _buildDetailRow('Buying Cost', currencyFormat.format(approval.buyingCost)),
              _buildDetailRow('CM', currencyFormat.format(approval.cm)),
              _buildDetailRow('SMV', approval.smv?.toString()),
              _buildDetailRow('Profit %', percentFormat.format((approval.profitCostInPercent ?? 0) / 100)),
              _buildDetailRow('Total Qty', approval.totalOrderQty?.toString()),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // View details action
                },
                child: const Text('Reject',style: TextStyle(color: Colors.red),),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // Take action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: approval.finalStatus=='Pending'?Colors.green:Colors.orange,
                ),
                child: Text(
                  approval.finalStatus == 'Pending' ? 'Accept' : 'View',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      case 'Pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status) {
      case 'Approved':
        return Icons.check_circle;
      case 'Rejected':
        return Icons.cancel;
      case 'Pending':
        return Icons.access_time;
      default:
        return Icons.help_outline;
    }
  }
}