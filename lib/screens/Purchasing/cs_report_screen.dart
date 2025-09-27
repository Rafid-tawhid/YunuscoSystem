import 'package:flutter/material.dart';
import 'package:yunusco_group/utils/colors.dart';

class ComparativeStatementScreen extends StatefulWidget {
  @override
  _ComparativeStatementScreenState createState() => _ComparativeStatementScreenState();
}

class _ComparativeStatementScreenState extends State<ComparativeStatementScreen> {
  final ComparativeStatementData statementData = ComparativeStatementData(
    csCode: 'CS002374',
    storeType: 'General',
    currency: 'BDT',
    regCode: 'GPR0000000046530',
    csDate: '27 Jul 2025',
    procurer: 'Md. Mahadi Hasa',
    purchaseType: 'Local',
    itemCategory: 'Electric Item',
    items: [
      PurchaseItem(
        sl: 1,
        itemName: 'Cable Tail 1/2 Inch China Heavy',
        unit: 'Packet',
        brand: '',
        stock: 0,
        lastPurchaseQty: 3,
        lastPurchaseRate: 140.00,
        lastPurchaseDate: '28 Jul 2025',
        csQty: 3.00,
        suppliers: [
          SupplierQuote(
            name: 'DEBO TRADING CORPORATION',
            rate: 140.00,
            total: 420.00,
          ),
          SupplierQuote(
            name: 'Rohan Electric',
            rate: 150.00,
            total: 450.00,
          ),
        ],
      ),
      PurchaseItem(
        sl: 2,
        itemName: 'Insulation Tape',
        unit: 'Piece',
        brand: '',
        stock: 0,
        lastPurchaseQty: 10,
        lastPurchaseRate: 30.00,
        lastPurchaseDate: '28 Jul 2025',
        csQty: 10.00,
        suppliers: [
          SupplierQuote(
            name: 'DEBO TRADING CORPORATION',
            rate: 30.00,
            total: 300.00,
          ),
          SupplierQuote(
            name: 'Rohan Electric',
            rate: 30.00,
            total: 300.00,
          ),
        ],
      ),
      PurchaseItem(
        sl: 3,
        itemName: 'U Channel',
        unit: 'Piece',
        brand: '',
        stock: 0,
        lastPurchaseQty: 2,
        lastPurchaseRate: 1400.00,
        lastPurchaseDate: '28 Jul 2025',
        csQty: 1.00,
        suppliers: [
          SupplierQuote(
            name: 'DEBO TRADING CORPORATION',
            rate: 1400.00,
            total: 1400.00,
          ),
          SupplierQuote(
            name: 'Rohan Electric',
            rate: 1800.00,
            total: 1800.00,
          ),
        ],
      ),
    ],
    deliveryAddress: '224-233, Rd no. 3, Shiddhirganj 1431',
    contactPerson: 'Md. Baharu Islam, Store Manager, 01709 678913',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Comparative Statement',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.white,
        backgroundColor: myColors.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Card
            _buildHeaderCard(),
            SizedBox(height: 16),

            // Items List
            _buildItemsList(),
            SizedBox(height: 16),

            // Summary Card
            _buildSummaryCard(),
            SizedBox(height: 16),

            // Terms & Conditions
            _buildTermsCard(),
            SizedBox(height: 16),

            // Comments Section
            _buildCommentsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'YUNUSCO (BD) LIMITED',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
            _buildInfoRow('CS Code', statementData.csCode),
            _buildInfoRow('Store Type', statementData.storeType),
            _buildInfoRow('Currency', statementData.currency),
            _buildInfoRow('Reg Code', statementData.regCode),
            _buildInfoRow('CS Date', statementData.csDate),
            _buildInfoRow('Procurer', statementData.procurer),
            _buildInfoRow('Purchase Type', statementData.purchaseType),
            _buildInfoRow('Item Category', statementData.itemCategory),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700]),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: TextStyle(color: Colors.blue[800])),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    return Column(
      children: statementData.items.map((item) => _buildItemCard(item)).toList(),
    );
  }

  Widget _buildItemCard(PurchaseItem item) {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${item.sl}. ${item.itemName}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('Qty: ${item.csQty} ${item.unit}'),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Last Purchase Info
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMiniInfo('Stock', item.stock.toString()),
                  _buildMiniInfo('Last Rate', '${item.lastPurchaseRate} BDT'),
                  _buildMiniInfo('Last Date', item.lastPurchaseDate),
                ],
              ),
            ),
            SizedBox(height: 12),

            // Suppliers Comparison
            Text('Supplier Quotes:', style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            ...item.suppliers.map((supplier) => _buildSupplierRow(supplier)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniInfo(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
  //
  Widget _buildSupplierRow(SupplierQuote supplier) {
    bool isBestPrice = _isBestPrice(supplier.rate, supplier.total);

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isBestPrice ? Colors.green[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isBestPrice ? Colors.green : Colors.grey.shade300,
          width: isBestPrice ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  supplier.name.isEmpty ? 'Supplier' : supplier.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isBestPrice ? Colors.green[800] : Colors.grey[800],
                  ),
                ),
                if (supplier.name.isNotEmpty)
                  Text(
                    'Rate: ${supplier.rate.toStringAsFixed(2)} BDT',
                    style: TextStyle(fontSize: 12),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Total:',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                '${supplier.total.toStringAsFixed(2)} BDT',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isBestPrice ? Colors.green[800] : Colors.blue[800],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _isBestPrice(double rate, double total) {
    // Simple logic to highlight best price (lowest total)
    // You can enhance this based on your business logic
    return total > 0 && rate == statementData.items.expand((item) => item.suppliers.map((s) => s.rate))
        .where((rate) => rate > 0)
        .reduce((min, current) => current < min ? current : min);
  }

  Widget _buildSummaryCard() {
    Map<String, double> supplierTotals = {};

    for (var item in statementData.items) {
      for (var supplier in item.suppliers) {
        if (supplier.name.isNotEmpty) {
          supplierTotals.update(
              supplier.name,
                  (value) => value + supplier.total,
              ifAbsent: () => supplier.total
          );
        }
      }
    }

    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Supplier Comparison Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            ...supplierTotals.entries.map((entry) => _buildSummaryRow(entry.key, entry.value)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String supplierName, double total) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(supplierName, style: TextStyle(fontWeight: FontWeight.w600)),
          Text(
            '${total.toStringAsFixed(2)} BDT',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCard() {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms and Conditions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            _buildTermItem('Tax Type:', 'Exclude'),
            _buildTermItem('VAT Type:', 'Exclude'),
            _buildTermItem('Delivery Place:', statementData.deliveryAddress),
            _buildTermItem('Contact Person:', statementData.contactPerson),
          ],
        ),
      ),
    );
  }

  Widget _buildTermItem(String term, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(term, style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsCard() {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comments on Supplier (Supply Chain)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter your comments here...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data Models (same as before)
class ComparativeStatementData {
  final String csCode;
  final String storeType;
  final String currency;
  final String regCode;
  final String csDate;
  final String procurer;
  final String purchaseType;
  final String itemCategory;
  final List<PurchaseItem> items;
  final String deliveryAddress;
  final String contactPerson;

  ComparativeStatementData({
    required this.csCode,
    required this.storeType,
    required this.currency,
    required this.regCode,
    required this.csDate,
    required this.procurer,
    required this.purchaseType,
    required this.itemCategory,
    required this.items,
    required this.deliveryAddress,
    required this.contactPerson,
  });
}

class PurchaseItem {
  final int sl;
  final String itemName;
  final String unit;
  final String brand;
  final int stock;
  final int lastPurchaseQty;
  final double lastPurchaseRate;
  final String lastPurchaseDate;
  final double csQty;
  final List<SupplierQuote> suppliers;

  PurchaseItem({
    required this.sl,
    required this.itemName,
    required this.unit,
    required this.brand,
    required this.stock,
    required this.lastPurchaseQty,
    required this.lastPurchaseRate,
    required this.lastPurchaseDate,
    required this.csQty,
    required this.suppliers,
  });
}

class SupplierQuote {
  final String name;
  final double rate;
  final double total;

  SupplierQuote({
    required this.name,
    required this.rate,
    required this.total,
  });
}