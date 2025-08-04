import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/requisition_details_model.dart';

class RequisitionDetailsScreen extends StatelessWidget {
  final List<RequisitionDetailsModel> requisitions;

  const RequisitionDetailsScreen({super.key, required this.requisitions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Requisition Details'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: requisitions.length,
        itemBuilder: (context, index) {
          final req = requisitions[index];
          return _buildRequisitionCard(req);
        },
      ),
    );
  }

  Widget _buildRequisitionCard(RequisitionDetailsModel req) {
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          req.product ?? 'No Product Name',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          'Req #${req.requisitionCode ?? 'N/A'} • ${_formatDate(req.requisitionDate)}',
          style: const TextStyle(color: Colors.grey),
        ),
        leading: req.imagePathString != null
            ? CircleAvatar(
          backgroundImage: NetworkImage(req.imagePathString!),
          radius: 24,
        )
            : const CircleAvatar(
          child: Icon(Icons.inventory),
          radius: 24,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Employee', req.employeeName),
                _buildDetailRow('Department', req.department),
                _buildDetailRow('Section', req.section),
                _buildDetailRow('Product Description', req.productDescription?.toString()),
                _buildDetailRow('Unit', '${req.unit} (${req.unitId})'),
                const Divider(),
                _buildQuantityRow('Requested', req.actualReqQty),
                _buildQuantityRow('Approved', req.approvedQty),
                _buildQuantityRow('In Stock', req.iNHandQty),
                const Divider(),
                _buildDetailRow('Required By', _formatDate(req.requiredDate)),
                _buildDetailRow('Approved By', req.approvedBy),
                _buildDetailRow('Approval Type', req.approvalType),
                if (req.note?.isNotEmpty == true) ...[
                  const Divider(),
                  _buildDetailRow('Notes', req.note, isImportant: true),
                ],
                const SizedBox(height: 8),
                _buildLastPurchaseInfo(req),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value, {bool isImportant = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: isImportant ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: TextStyle(
                fontWeight: isImportant ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityRow(String label, num? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _getQuantityColor(label, value),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value?.toString() ?? '0',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getQuantityColor(String label, num? value) {
    if (value == null || value == 0) return Colors.grey;

    switch (label) {
      case 'Requested':
        return Colors.orange;
      case 'Approved':
        return Colors.green;
      case 'In Stock':
        return value < 10 ? Colors.red : Colors.blue;
      default:
        return Colors.blue;
    }
  }

  Widget _buildLastPurchaseInfo(RequisitionDetailsModel req) {
    return Card(
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Last Purchase Info',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            _buildDetailRow('Date', _formatDate(req.lastPurchaseDate)),
            _buildDetailRow('Supplier', req.supplierName),
            _buildDetailRow('Rate', req.lastPurchaseRate?.toStringAsFixed(2)),
            _buildDetailRow('Total', '\$${req.totalPurchaseAmount?.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}