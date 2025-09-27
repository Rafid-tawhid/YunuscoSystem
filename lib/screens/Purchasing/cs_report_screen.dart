// comparative_statement_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../models/comperative_statement_model.dart';

class ComparativeStatementScreen extends StatefulWidget {
  final List<dynamic> jsonData;

  const ComparativeStatementScreen({Key? key, required this.jsonData}) : super(key: key);

  @override
  _ComparativeStatementScreenState createState() => _ComparativeStatementScreenState();
}

class _ComparativeStatementScreenState extends State<ComparativeStatementScreen> {
  List<ComparativeStatement> _statements = [];
  bool _isLoading = true;
  String _selectedCode = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    try {
      final statements = widget.jsonData
          .map((item) => ComparativeStatement.fromJson(item))
          .toList();

      // Get unique codes
      final codes = statements.map((e) => e.code).toSet().toList();

      setState(() {
        _statements = statements;
        _selectedCode = codes.isNotEmpty ? codes.first : '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error loading data: $e');
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

  void _onSupplierSelected(int productId, String supplierPosition) {
    setState(() {
      final statement = _statements.firstWhere((stmt) => stmt.productId == productId);
      statement.selectedSupplierPosition = supplierPosition;
    });
  }

  List<ComparativeStatement> get _filteredStatements {
    if (_selectedCode.isEmpty) return _statements;
    return _statements.where((stmt) => stmt.code == _selectedCode).toList();
  }

  Set<String> get _availableCodes {
    return _statements.map((e) => e.code).toSet();
  }

  void _exportSelectedData() {
    final selectedData = _filteredStatements.map((stmt) => stmt.toSelectedJson()).toList();

    // Show selected data summary
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Selected Suppliers Summary'),
        content: Container(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Comparative Statement: $_selectedCode',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 10),
                Text('Total Products: ${selectedData.length}'),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),

                // Show selected suppliers for each product
                ...selectedData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${index + 1}. ${data['ProductName']}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Qty: ${data['CsQty']} ${data['UomName']}'),
                        Text('Selected Supplier: ${data['SelectedSupplierName']}'),
                        Text('Rate: ${data['CurrencyName']} ${data['SelectedRate']}'),
                        Text('Total: ${data['CurrencyName']} ${data['SelectedTotal']}'),
                        Text('Warranty: ${data['WarrantyFirst']}'),
                      ],
                    ),
                  );
                }).toList(),

                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),

                // Total summary
                Text(
                  'Grand Total: ${selectedData.first['CurrencyName']} ${_filteredStatements.fold(0.0, (sum, stmt) => sum + stmt.selectedTotal).toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatJson(List<Map<String, dynamic>> data) {
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  void _copyToClipboard(List<Map<String, dynamic>> data) {
    final jsonString = _formatJson(data);
    // You can use clipboard package here
    // Clipboard.setData(ClipboardData(text: jsonString));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('JSON copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comparative Statement'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: _exportSelectedData,
            tooltip: 'Export Selected Data',
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _statements.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No comparative statement data found', style: TextStyle(fontSize: 18)),
          ],
        ),
      )
          : Column(
        children: [
          // Filter by Code
          if (_availableCodes.length > 1)
            Padding(
              padding: EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Text('Filter by Code: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 10),
                      DropdownButton<String>(
                        value: _selectedCode,
                        items: _availableCodes.map((String code) {
                          return DropdownMenuItem<String>(
                            value: code,
                            child: Text(code),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCode = newValue!;
                          });
                        },
                      ),
                      Spacer(),
                      ElevatedButton.icon(
                        onPressed: _exportSelectedData,
                        icon: Icon(Icons.file_download),
                        label: Text('Export Selected'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Summary Card
          _buildSummaryCard(),

          // Products List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredStatements.length,
              itemBuilder: (context, index) {
                final statement = _filteredStatements[index];
                return ComparativeStatementCard(
                  statement: statement,
                  onSupplierSelected: _onSupplierSelected,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final statements = _filteredStatements;
    final totalProducts = statements.length;
    final totalValue = statements.fold(0.0, (sum, stmt) => sum + stmt.selectedTotal);
    final selectedSuppliers = statements.map((stmt) => stmt.selectedSupplier?['name'] ?? '').toSet();

    return Card(
      margin: EdgeInsets.all(8),
      color: Colors.blue[50],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Products', totalProducts.toString()),
                _buildSummaryItem('Selected Suppliers', selectedSuppliers.length.toString()),
                _buildSummaryItem('Total Value', '${totalValue.toStringAsFixed(2)} ${statements.first.currencyName}'),
              ],
            ),
            SizedBox(height: 8),
            if (selectedSuppliers.length > 0)
              Text(
                'Suppliers: ${selectedSuppliers.where((s) => s.isNotEmpty).join(', ')}',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class ComparativeStatementCard extends StatelessWidget {
  final ComparativeStatement statement;
  final Function(int, String) onSupplierSelected;

  const ComparativeStatementCard({
    Key? key,
    required this.statement,
    required this.onSupplierSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final availableSuppliers = statement.availableSuppliers;
    final selectedSupplier = statement.selectedSupplier;

    return Card(
      margin: EdgeInsets.all(8),
      elevation: 4,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          child: Text(
            statement.productId.toString().substring(statement.productId.toString().length - 2),
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
        ),
        title: Text(
          statement.productName,
          style: TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${statement.productCategoryName}'),
            Text('Qty: ${statement.csQty} ${statement.uomName}'),
            if (selectedSupplier != null)
              Text('Selected: ${selectedSupplier['name']} - ${statement.currencyName} ${selectedSupplier['rate']}'),
          ],
        ),
        trailing: Chip(
          label: Text('${availableSuppliers.length} Options', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue,
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Information
                _buildInfoRow('Product ID', statement.productId.toString()),
                _buildInfoRow('Category', statement.productCategoryName),
                _buildInfoRow('Type', statement.typeName),
                _buildInfoRow('UOM', statement.uomName),
                _buildInfoRow('Required Qty', '${statement.csQty} ${statement.uomName}'),
                _buildInfoRow('Current Stock', statement.cStock.toString()),
                if (statement.lastPurDate.isNotEmpty)
                  _buildInfoRow('Last Purchase', '${statement.lastPurQty} @ ${statement.lastPurRate} on ${statement.lastPurDate}'),

                SizedBox(height: 16),
                Divider(),
                SizedBox(height: 8),

                // Supplier Selection
                Text(
                  'Select Supplier:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                SizedBox(height: 8),

                ...availableSuppliers.map((supplier) => _buildSupplierOption(supplier, statement)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          Expanded(child: Text(value, style: TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildSupplierOption(Map<String, dynamic> supplier, ComparativeStatement statement) {
    final isSelected = statement.selectedSupplierPosition == supplier['position'];

    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      color: isSelected ? Colors.blue[50] : Colors.grey[50],
      borderOnForeground: true,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Radio<String>(
          value: supplier['position'],
          groupValue: statement.selectedSupplierPosition,
          onChanged: (value) {
            onSupplierSelected(statement.productId, value!);
          },
        ),
        title: Text(
          supplier['name'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.blue : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rate: ${statement.currencyName} ${supplier['rate']}'),
            Text('Total: ${statement.currencyName} ${supplier['total']}'),
            Text('Warranty: ${supplier['warranty']}'),
            Text('VAT: ${supplier['vat']} | Tax: ${supplier['tax']}'),
          ],
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: Colors.green)
            : null,
        onTap: () {
          onSupplierSelected(statement.productId, supplier['position']);
        },
      ),
    );
  }
}