import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yunusco_group/utils/colors.dart';

class LCDetailScreen extends StatelessWidget {
  final Map<String, dynamic> lcData;

  const LCDetailScreen({super.key, required this.lcData});

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('LC Details: ${lcData['MasterLCNo']}'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Basic Information'),
            _buildInfoRow('LC Number', lcData['MasterLCNo']),
            _buildInfoRow('Buyer', lcData['BuyerName']),
            _buildInfoRow('Status', lcData['EXIMStatus']),
            _buildInfoRow('Sales Terms', lcData['SalesTerms']),
            _buildInfoRow('Shipment Mode', lcData['ShipmentModeStr']),
            const SizedBox(height: 24),
            _buildSectionHeader('Dates'),
            _buildInfoRow(
                'Issue Date', _parseDate(lcData['IssueDateStr'], dateFormat)),
            _buildInfoRow(
                'Ship Date', _parseDate(lcData['ShipDateStr'], dateFormat)),
            _buildInfoRow(
                'Expiry Date', _parseDate(lcData['ExpiryDateStr'], dateFormat)),
            const SizedBox(height: 24),
            _buildSectionHeader('Financials'),
            _buildInfoRow('Total Amount',
                currencyFormat.format(lcData['MasterLCAmount'])),
            _buildInfoRow(
                'Unit Price', currencyFormat.format(lcData['UnitPrice'])),
            _buildInfoRow('Order Qty', '${lcData['OrderQty']}'),
            _buildInfoRow('Remaining Amount',
                currencyFormat.format(lcData['RemainingAmount'])),
            _buildInfoRow('BTB Percentage', '${lcData['BtBPercent']}%'),
            const SizedBox(height: 24),
            _buildSectionHeader('Utilization'),
            _buildInfoRow('Used for BTB',
                '${currencyFormat.format(lcData['UsedForBTB_Amount'])} (${lcData['UsedForBTB_Percentage']}%)'),
            _buildInfoRow('Used for FDD',
                '${currencyFormat.format(lcData['UsedForFDD_Amount'])} (${lcData['UsedForFDD_Percentage']}%)'),
            _buildInfoRow('Used for FTT',
                '${currencyFormat.format(lcData['UsedForFTT_Amount'])} (${lcData['UsedForFTT_Percentage']}%)'),
            if (lcData['Remark'] != null) ...[
              const SizedBox(height: 24),
              _buildSectionHeader('Remarks'),
              _buildInfoRow('Notes', lcData['Remark']),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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
              value ?? 'N/A',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  String _parseDate(String? dateStr, DateFormat formatter) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return formatter.format(date);
    } catch (e) {
      return dateStr; // Return original string if parsing fails
    }
  }
}
