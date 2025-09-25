// supply_chain_records_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../models/approval_Supply_model.dart';
import '../../providers/purchase_provider.dart';

class SupplyChainRecordsScreen extends StatefulWidget {
  @override
  _SupplyChainRecordsScreenState createState() => _SupplyChainRecordsScreenState();
}

class _SupplyChainRecordsScreenState extends State<SupplyChainRecordsScreen> {

  List<SupplyChainRecord> _records = [];
  bool _isLoading = true;
  String _selectedFilter = 'all'; // all, pending, completed

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<SupplyChainRecord> records;
      var pp=context.read<PurchaseProvider>();

      if (_selectedFilter == 'all') {
        records = await pp.getAllSupplyChainRecords();
      } else {
        records = await pp.getSupplyChainRecordsByStatus(_selectedFilter);
      }

      setState(() {
        _records = records;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error loading records: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed': return Colors.green;
      case 'pending': return Colors.orange;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supply Chain Records'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
              _loadRecords();
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'all', child: Text('All Records')),
              PopupMenuItem(value: 'pending', child: Text('Pending')),
              PopupMenuItem(value: 'completed', child: Text('Completed')),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _records.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No supply chain records found', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Records will appear here after adding suppliers',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _loadRecords,
        child: ListView.builder(
          itemCount: _records.length,
          itemBuilder: (context, index) {
            final record = _records[index];
            return SupplyChainRecordCard(record: record);
          },
        ),
      ),
    );
  }
}

class SupplyChainRecordCard extends StatelessWidget {
  final SupplyChainRecord record;

  const SupplyChainRecordCard({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bestQuote = record.bestQuote;

    return Card(
      margin: EdgeInsets.all(8),
      elevation: 4,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(record.status),
          child: Icon(Icons.safety_check_outlined, color: Colors.white, size: 20),
        ),
        title: Text(
          record.productName,
          style: TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Req ID: ${record.reqId.substring(record.reqId.length - 6)}'),
            Text('Suppliers: ${record.supplierQuotes.length}'),
            if (bestQuote != null)
              Text('Best Quote: ${bestQuote.currency} ${record.calculateTotalCost(bestQuote).toStringAsFixed(2)}'),
          ],
        ),
        trailing: Chip(
          label: Text(
            record.status.toUpperCase(),
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
          backgroundColor: _getStatusColor(record.status),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Information
                _buildInfoRow('Product', record.productName),
                _buildInfoRow('Required Qty', '${record.requiredQty} ${record.unitName}'),
                _buildInfoRow('Requisition ID', record.reqId),

                SizedBox(height: 16),

                // Suppliers Section
                Text(
                  'Supplier Quotes (${record.supplierQuotes.length})',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                SizedBox(height: 8),

                ...record.supplierQuotes.map((quote) => _buildSupplierQuoteCard(quote, record)).toList(),

                SizedBox(height: 16),
                _buildInfoRow('Created', _formatDate(record.createdAt)),
                _buildInfoRow('Record ID', record.id.substring(record.id.length - 8)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildSupplierQuoteCard(SupplierQuote quote, SupplyChainRecord record) {
    final totalCost = record.calculateTotalCost(quote);
    final isBestQuote = record.bestQuote?.supplierId == quote.supplierId;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      color: isBestQuote ? Colors.green[50] : Colors.grey[50],
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    quote.supplierName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isBestQuote ? Colors.green : Colors.black,
                    ),
                  ),
                ),
                if (isBestQuote)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'BEST',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8),

            // Basic Info
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _buildInfoChip('Rate: ${quote.currency} ${quote.unitRate}'),
                _buildInfoChip('Tax: ${quote.taxRate}%'),
                _buildInfoChip('VAT: ${quote.vatRate}%'),
                if (quote.warranty.isNotEmpty) _buildInfoChip('Warranty: ${quote.warranty}'),
                _buildInfoChip('Credit: ${quote.creditPeriodDays} days'),
              ],
            ),

            SizedBox(height: 8),

            // Cost Breakdown
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  _buildCostRow('Subtotal', quote.unitRate * double.parse(record.requiredQty), quote.currency),
                  if (quote.taxRate > 0) _buildCostRow('Tax', (quote.unitRate * double.parse(record.requiredQty)) * (quote.taxRate / 100), quote.currency),
                  if (quote.vatRate > 0) _buildCostRow('VAT', (quote.unitRate * double.parse(record.requiredQty)) * (quote.vatRate / 100), quote.currency),
                  if (quote.carryingCost > 0) _buildCostRow('Carrying Cost', quote.carryingCost, quote.currency),
                  if (quote.otherCost > 0) _buildCostRow('Other Cost', quote.otherCost, quote.currency),
                  if (quote.discount > 0) _buildCostRow('Discount', -((quote.unitRate * double.parse(record.requiredQty)) * (quote.discount / 100)), quote.currency),
                  Divider(),
                  _buildCostRow('TOTAL', totalCost, quote.currency, isBold: true),
                ],
              ),
            ),

            if (quote.comments.isNotEmpty) ...[
              SizedBox(height: 8),
              Text('Comments: ${quote.comments}', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
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

  Widget _buildCostRow(String label, double amount, String currency, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(
            '${amount >= 0 ? '+' : ''}$currency ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: amount < 0 ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed': return Colors.green;
      case 'pending': return Colors.orange;
      default: return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}