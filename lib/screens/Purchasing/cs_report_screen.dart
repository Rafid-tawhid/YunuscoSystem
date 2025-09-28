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
    final grandTotal = _filteredStatements.fold(0.0, (sum, stmt) => sum + stmt.selectedTotal);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.checklist, color: myColors.primaryColor, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Selected Suppliers Summary',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              Divider(height: 1),

              // Summary cards
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    _buildSummaryCard('Products', selectedData.length.toString(), Icons.inventory),
                    SizedBox(width: 10),
                    _buildSummaryCard('Total', '${grandTotal.toStringAsFixed(2)} BDT', Icons.attach_money),
                  ],
                ),
              ),

              // List title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      'Selected Items',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                    ),
                    Spacer(),
                    Text(
                      'CS: $_selectedCode',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8),

              // Products list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: selectedData.length,
                  itemBuilder: (context, index) {
                    final data = selectedData[index];
                    return _buildProductItem(data, index);
                  },
                ),
              ),

              // Footer with action buttons
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(top: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Grand Total: ${grandTotal.toStringAsFixed(2)} BDT',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Add your action here (save, submit, etc.)
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text('Selected data processed successfully!')),
                        // );
                        //Navigator.pop(context);
                        _showRequisitionConfirmationDialog(context);

                      },
                      icon: Icon(Icons.check_circle),
                      label: Text('Authorization'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _showRequisitionConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          children: [
            Icon(
              Icons.task_alt,
              color: myColors.primaryColor,
              size: 48,
            ),
            SizedBox(height: 8),
            Text(
              'Confirm Requisition',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to confirm this requisition?',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processRequisition();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: myColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Confirm',style: TextStyle(color: Colors.white
            ),),
          ),
        ],
      ),
    );
  }

  void _processRequisition() {
    // Your confirmation logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Requisition confirmed successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }


  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Expanded(
      child: Card(
        color: Colors.blue[50],
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, size: 20, color: myColors.primaryColor),
              SizedBox(height: 4),
              Text(title, style: TextStyle(fontSize: 10, color: Colors.grey)),
              SizedBox(height: 2),
              Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],

          ),
        ),
      ),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> data, int index) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with product info
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: myColors.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: myColors.primaryColor),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    data['ProductName'] ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            SizedBox(height: 8),

            // Details in two columns
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column - Basic info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Qty', '${data['CsQty']} ${data['UomName']}'),
                      _buildDetailRow('Category', data['ProductCategoryName'] ?? ''),
                      _buildDetailRow('Supplier', data['SelectedSupplierName'] ?? ''),
                    ],
                  ),
                ),

                // Right column - Financial info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildDetailRow('Rate', '${data['CurrencyName']} ${(data['SelectedRate'] ?? 0).toStringAsFixed(2)}'),
                      _buildDetailRow('Total', '${data['CurrencyName']} ${(data['SelectedTotal'] ?? 0).toStringAsFixed(2)}'),
                      _buildDetailRow('Warranty', data['WarrantyFirst'] ?? 'N/A'),
                    ],
                  ),
                ),
              ],
            ),

            // Additional info if available
            if ((data['CreditPeriod'] ?? '').isNotEmpty || (data['PayMode'] ?? '').isNotEmpty)
              Container(
                margin: EdgeInsets.only(top: 8),
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    if ((data['CreditPeriod'] ?? '').isNotEmpty)
                      Expanded(
                        child: Text(
                          'Credit: ${data['CreditPeriod']}',
                          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                        ),
                      ),
                    if ((data['PayMode'] ?? '').isNotEmpty)
                      Expanded(
                        child: Text(
                          'Payment: ${data['PayMode']}',
                          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                          textAlign: TextAlign.end,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 10),
              overflow: TextOverflow.ellipsis,
            ),
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
            icon: Icon(Icons.save),
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
          // if (_availableCodes.length > 1)
          //   Padding(
          //     padding: EdgeInsets.all(16),
          //     child: Card(
          //       color: Colors.white,
          //       child: Padding(
          //         padding: EdgeInsets.all(12),
          //         child: Row(
          //           children: [
          //             Text('Filter by Code: ', style: TextStyle(fontWeight: FontWeight.bold)),
          //             SizedBox(width: 10),
          //             DropdownButton<String>(
          //               value: _selectedCode,
          //               items: _availableCodes.map((String code) {
          //                 return DropdownMenuItem<String>(
          //                   value: code,
          //                   child: Text(code),
          //                 );
          //               }).toList(),
          //               onChanged: (String? newValue) {
          //                 setState(() {
          //                   _selectedCode = newValue!;
          //                 });
          //               },
          //             ),
          //             Spacer(),
          //             ElevatedButton.icon(
          //               onPressed: _exportSelectedData,
          //               icon: Icon(Icons.file_download),
          //               label: Text('Export Selected'),
          //               style: ElevatedButton.styleFrom(
          //                 backgroundColor: Colors.green,
          //                 foregroundColor: Colors.white,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),

          // Summary Card
          _buildSummaryCard2(),

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

  Widget _buildSummaryCard2() {
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
            if (selectedSuppliers.isNotEmpty)
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

class ComparativeStatementCard extends StatefulWidget {
  final ComparativeStatement statement;
  final Function(int, String) onSupplierSelected;

  const ComparativeStatementCard({
    Key? key,
    required this.statement,
    required this.onSupplierSelected,
  }) : super(key: key);

  @override
  _ComparativeStatementCardState createState() => _ComparativeStatementCardState();
}

class _ComparativeStatementCardState extends State<ComparativeStatementCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final availableSuppliers = widget.statement.availableSuppliers;
    final selectedSupplier = widget.statement.selectedSupplier;

    return Card(
      margin: EdgeInsets.all(8),
      elevation: 4,
      color: Colors.white,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          child: Text(
            'Y',
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
        ),
        title: Text(
          widget.statement.productName,
          style: TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${widget.statement.productCategoryName}'),
            Text('Qty: ${widget.statement.csQty} ${widget.statement.uomName}'),
            if (selectedSupplier != null)
              Text('Selected: ${selectedSupplier['name']} - ${widget.statement.currencyName} ${selectedSupplier['rate']}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text('${availableSuppliers.length} Options', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.blue,
            ),
            SizedBox(width: 8),
            AnimatedRotation(
              duration: Duration(milliseconds: 300),
              turns: _isExpanded ? 0.5 : 0,
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey[600],
                size: 24,
              ),
            ),
          ],
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Information
                // _buildInfoRow('Product ID', widget.statement.productId.toString()),
                // _buildInfoRow('Category', widget.statement.productCategoryName),
                // _buildInfoRow('Type', widget.statement.typeName),
                // _buildInfoRow('UOM', widget.statement.uomName),
                // Text(widget.statement.toSelectedJson().toString()),

                _buildInfoRow('Current Stock', widget.statement.cStock.toString()),
                _buildInfoRow('Vat',getVat(widget.statement.selectedSupplierPosition,widget.statement)??''),
                if (widget.statement.lastPurDate.isNotEmpty)
                  _buildInfoRow('Last Purchase', '${widget.statement.lastPurQty} @ ${widget.statement.lastPurRate} on ${widget.statement.lastPurDate}'),

                SizedBox(height: 16),
                Divider(),
                SizedBox(height: 8),

                // Supplier Selection
                Text(
                  'Select Supplier:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                SizedBox(height: 8),

                ...availableSuppliers.map((supplier) => _buildSupplierOption(supplier, widget.statement)),
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
            widget.onSupplierSelected(statement.productId, value!);
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
          widget.onSupplierSelected(statement.productId, supplier['position']);
        },
      ),
    );
  }

  String? getVat(String selectedSupplierPosition, ComparativeStatement statement) {
    if(selectedSupplierPosition=='First'){
      return statement.vatPFirst.toString();
    }
    if(selectedSupplierPosition=='Second'){
      return statement.vatPSecond.toString();
    }
    if(selectedSupplierPosition=='Third'){
      return statement.vatPSecond.toString();
    }
    if(selectedSupplierPosition=='Four'){
      return statement.vatPFour.toString();
    }
  }
}