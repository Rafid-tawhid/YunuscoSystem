import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final Map<String,dynamic> lcData={
  "MasterLCId": 277,
  "Version": 1,
  "MasterLCNo": "P02L25196I000010",
  "IssueDate": null,
  "ShipDate": null,
  "ExpiryDate": null,
  "IssueDateStr": "7/22/2025",
  "ShipDateStr": "10/27/2025",
  "ExpiryDateStr": "11/11/2025",
  "TenorId": 0,
  "TenorStr": null,
  "ShipmentModeId": 5,
  "ShipmentModeStr": "Air/Sea",
  "SalesTerms": "FOB/FCA",
  "BuyerId": 33,
  "LienRefNo": "P02L25196I000010",
  "BankNameId": 0,
  "BankName": null,
  "PoScLcNo": "P02L25196I000010",
  "EXIMStatusId": 158,
  "EXIMStatus": "LC No",
  "SCAmount": 440964.67,
  "MasterLCAmount": 440964.67,
  "BtBPercent": 70.00,
  "Roam": 308675.27,
  "OrderQty": 128564,
  "UnitPrice": 3.43,
  "MasterLCCode": "YBL-MLC-277-2025",
  "BuyerName": "WOLF LINGERIE LTD",
  "AmendAmount": 0,
  "AmendQty": 0,
  "AmendAmountIncDec": 0,
  "AmendQtyIncDec": 0,
  "AmndDate": "0001-01-01T00:00:00",
  "BLAmendNo": null,
  "RepAmendNo": null,
  "Remark": null,
  "RemainingAmount": 308675.27,
  "TotalAmountUsedFor_BTB_FTT_FDD": 0.00,
  "UsedForBTB_Amount": 0.00,
  "UsedForBTB_Percentage": 0.00,
  "UsedForFDD_Amount": 0.00,
  "UsedForFDD_Percentage": 0.00,
  "UsedForFTT_Amount": 0.00,
  "UsedForFTT_Percentage": 0.00,
  "created_date_str": null
};

class LCDetailScreen extends StatelessWidget {

  const LCDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('LC Details: ${lcData['MasterLCNo']}'),
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
        _buildInfoRow('Issue Date', _parseDate(lcData['IssueDateStr'], dateFormat)),
        _buildInfoRow('Ship Date', _parseDate(lcData['ShipDateStr'], dateFormat)),
        _buildInfoRow('Expiry Date', _parseDate(lcData['ExpiryDateStr'], dateFormat)),

        const SizedBox(height: 24),
        _buildSectionHeader('Financials'),
        _buildInfoRow('Total Amount', currencyFormat.format(lcData['MasterLCAmount'])),
        _buildInfoRow('Unit Price', currencyFormat.format(lcData['UnitPrice'])),
        _buildInfoRow('Order Qty', '${lcData['OrderQty']}'),
        _buildInfoRow('Remaining Amount', currencyFormat.format(lcData['RemainingAmount'])),
        _buildInfoRow('BTB Percentage', '${lcData['BtBPercent']}%'),

        const SizedBox(height: 24),
        _buildSectionHeader('Utilization'),
        _buildInfoRow('Used for BTB', '${currencyFormat.format(lcData['UsedForBTB_Amount'])} (${lcData['UsedForBTB_Percentage']}%)'),
          _buildInfoRow('Used for FDD', '${currencyFormat.format(lcData['UsedForFDD_Amount'])} (${lcData['UsedForFDD_Percentage']}%)'),
              _buildInfoRow('Used for FTT', '${currencyFormat.format(lcData['UsedForFTT_Amount'])} (${lcData['UsedForFTT_Percentage']}%)'),

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