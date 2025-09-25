// requisition_list_screen.dart
import 'package:flutter/material.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/purchase_provider.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/screens/Purchasing/supply_chain_screen.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../models/puchaseMasterModelFirebase.dart';

class NewRequisitionListScreen extends StatefulWidget {
  @override
  _NewRequisitionListScreenState createState() => _NewRequisitionListScreenState();
}

class _NewRequisitionListScreenState extends State<NewRequisitionListScreen> {
  List<Map<String, dynamic>> _requisitions = [];
  bool _isLoading = true;
  String _selectedFilter = 'all'; // all, pending, approved, rejected

  @override
  void initState() {
    super.initState();
    _loadRequisitions();
  }

  Future<void> _loadRequisitions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Map<String, dynamic>> requisitions;
      var pp = context.read<PurchaseProvider>();

      if (_selectedFilter == 'all') {
        requisitions = await pp.getAllRequisitionsWithDetails();
      } else {
        requisitions = await pp.getRequisitionsByStatus(_selectedFilter);
      }

      setState(() {
        _requisitions = requisitions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error loading requisitions: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleApproval(String reqId, bool approve) async {
    final action = approve ? 'approve' : 'reject';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm $action'),
        content: Text('Are you sure you want to $action this requisition?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Confirm', style: TextStyle(color: approve ? Colors.green : Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        var pp = context.read<PurchaseProvider>();
        await pp.updateApprovalStatus(
          reqId: reqId,
          status: approve ? 'approved' : 'rejected',
          approvedBy: DashboardHelpers.currentUser!.userId.toString(), // Replace with actual user ID
        );

        // Reload the list
        _loadRequisitions();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Requisition ${approve ? 'approved' : 'rejected'} successfully'),
            backgroundColor: approve ? Colors.green : Colors.red,
          ),
        );
      } catch (e) {
        _showErrorDialog('Error updating requisition: $e');
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dept Head'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ApprovedRequisitionsScreen()));
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'CS', child: Text('Supply Chain')),

            ],
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _requisitions.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No requisitions found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _loadRequisitions,
        child: ListView.builder(
          itemCount: _requisitions.length,
          itemBuilder: (context, index) {
            final requisition = _requisitions[index];
            final master = requisition['master'] as PuchaseMasterModelFirebase;
            final details = requisition['details'] as List<RequisitionDetail>;

            return RequisitionCard(
              master: master,
              details: details,
              onApprove: () => _handleApproval(master.reqId, true),
              onReject: () => _handleApproval(master.reqId, false),
            );
          },
        ),
      ),
    );
  }
}

// Requisition Card Widget
class RequisitionCard extends StatelessWidget {
  final PuchaseMasterModelFirebase master;
  final List<RequisitionDetail> details;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const RequisitionCard({
    Key? key,
    required this.master,
    required this.details,
    required this.onApprove,
    required this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.all(8),
      elevation: 4,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(master.approval),
          child: Text(
            master.userId,
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
        ),
        title: Text(
          'Req #${master.reqId.substring(master.reqId.length - 6)}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${master.productType} | Division: ${master.division}'),
            Text('Remarks: ${master.remarks}'),
            Chip(
              label: Text(
                _getStatusText(master.approval),
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: _getStatusColor(master.approval),
            ),
          ],
        ),
        trailing: master.approval == 'pending'
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.check, color: Colors.green),
              onPressed: onApprove,
              tooltip: 'Approve',
            ),
            IconButton(
              icon: Icon(Icons.close, color: Colors.red),
              onPressed: onReject,
              tooltip: 'Reject',
            ),
          ],
        )
            : Text(
          'Approved by: ${master.approvedBy ?? 'N/A'}',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Products Details:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                ...details.map((detail) => ProductDetailItem(detail: detail)),
                SizedBox(height: 16),
                Text(
                  'Created: ${_formatDate(master.createdAt)}',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  '${_getStatusText(master.approval)}: ${_formatDate(master.createdAt)}',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved': return Colors.green;
      case 'rejected': return Colors.red;
      default: return Colors.orange;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'approved': return 'Approved';
      case 'rejected': return 'Rejected';
      default: return 'Pending';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

// Product Detail Item Widget
class ProductDetailItem extends StatelessWidget {
  final RequisitionDetail detail;

  const ProductDetailItem({Key? key, required this.detail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      color: Colors.grey[50],
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              detail.productName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                _buildDetailChip('Qty: ${detail.totalReqQty}'),
                _buildDetailChip('Days: ${detail.consumeDays}'),
                _buildDetailChip('Brand: ${detail.brand}'),
              ],
            ),
            SizedBox(height: 4),
            Text('Note: ${detail.note}', style: TextStyle(fontSize: 12)),
            Text('Required: ${detail.requiredDate}', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(String text) {
    return Container(
      margin: EdgeInsets.only(right: 4),
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}