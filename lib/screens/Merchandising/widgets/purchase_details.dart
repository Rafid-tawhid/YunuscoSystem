import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PurchaseOrderReportScreen extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const PurchaseOrderReportScreen({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Purchase Order Report'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Basic Information'),
            _buildInfoRow('Order Date', _formatDate(orderData['OrderDate'])),
            _buildInfoRow('Buyer',
                '${orderData['BuyerName']} (ID: ${orderData['BuyerId']})'),
            _buildInfoRow('Supplier ID', orderData['SupplierId'].toString()),
            _buildInfoRow('Amount',
                '\$${orderData['AmountAfterDiscount']?.toStringAsFixed(2) ?? '0.00'}'),
            _buildInfoRow('Discount',
                '${orderData['Discount']?.toStringAsFixed(2) ?? '0.00'}%'),
            _buildSectionHeader('Shipping & Delivery'),
            _buildInfoRow('Expected Delivery',
                _formatDate(orderData['ExpectedDeliveryDate'])),
            _buildInfoRow(
                'Is Import', orderData['IsImport'] == true ? 'Yes' : 'No'),
            _buildInfoRow(
                'Partial Shipment', _boolToText(orderData['PartialShipment'])),
            _buildInfoRow(
                'Trans Shipment', _boolToText(orderData['TransShipment'])),
            _buildInfoRow(
                'Shipping Line',
                orderData['ShippingLineIsOpen'] != null &&
                        orderData['ShippingLineIsOpen']
                    ? 'Open'
                    : 'Closed'),
            _buildSectionHeader('Terms & Conditions'),
            _buildInfoRow(
                'Shipping Terms', _handleNull(orderData['ShippingTerms'])),
            _buildInfoRow('Packing Instruction',
                _handleNull(orderData['PackingInstruction'])),
            _buildInfoRow('Remarks', _handleNull(orderData['Remarks'])),
            _buildSectionHeader('Document Requirements'),
            _buildInfoRow('Original Invoice',
                _boolToText(orderData['CRoriginalInvoice'])),
            _buildInfoRow('Organic Certificate',
                _boolToText(orderData['CRorganicCertificate'])),
            _buildInfoRow('Test Certificate',
                _boolToText(orderData['CRtestCertificate'])),
            _buildInfoRow(
                'Packing List', _boolToText(orderData['CRpackingList'])),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Not specified';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _boolToText(bool? value) {
    if (value == null) return 'Not specified';
    return value ? 'Required' : 'Not Required';
  }

  String _handleNull(dynamic value) {
    return value?.toString() ?? 'Not specified';
  }
}
