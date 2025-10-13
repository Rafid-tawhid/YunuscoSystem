// comparative_statement_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:path_provider/path_provider.dart';
import '../../helper_class/pdf_service.dart';
import '../../models/comperative_statement_model.dart';

class ComparativeStatementScreen extends StatefulWidget {
  final List<dynamic> jsonData;

  const ComparativeStatementScreen({Key? key, required this.jsonData}) : super(key: key);

  @override
  _ComparativeStatementScreenState createState() => _ComparativeStatementScreenState();
}

class _ComparativeStatementScreenState extends State<ComparativeStatementScreen> {
  List<ComparativeStatementNew> _statements = [];
  bool _isLoading = true;
  String _selectedCode = '';

  @override
  void initState() {
    super.initState();
    Future.microtask((){
      _loadData();
    });
  }

  void _loadData() {
    try {
      final statements = widget.jsonData
          .map((item) => ComparativeStatementNew.fromJson(item))
          .toList();

      // Group by product name and create product groups
      final productGroups = _groupByProduct(statements);

      setState(() {
        _statements = productGroups;
        _selectedCode = statements.isNotEmpty ? statements.first.code : '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error loading data: $e');
    }
  }

  List<ComparativeStatementNew> _groupByProduct(List<ComparativeStatementNew> statements) {
    final Map<String, List<ComparativeStatementNew>> grouped = {};

    for (var statement in statements) {
      if (!grouped.containsKey(statement.productName)) {
        grouped[statement.productName] = [];
      }
      grouped[statement.productName]!.add(statement);
    }

    return grouped.entries.map((entry) {
      // Use the first item as base and add all suppliers
      final base = entry.value.first;
      return ComparativeStatementNew(
        code: base.code,
        productName: base.productName,
        currencyName: base.currencyName,
        creditPeriod: base.creditPeriod,
        payMode: base.payMode,
        purchaseRequisitionCode: base.purchaseRequisitionCode,
        csDate: base.csDate,
        userName: base.userName,
        purchaseType: base.purchaseType,
        productCategoryName: base.productCategoryName,
        uomName: base.uomName,
        brandName: base.brandName,
        storeType: base.storeType,
        lastPurQty: base.lastPurQty,
        lastPurRate: base.lastPurRate,
        lastPurDate: base.lastPurDate,
        csQty: base.csQty,
        suppliers: entry.value.map((stmt) => SupplierData(
          name: stmt.suppliers.first.name, // Access the supplier name from the first supplier
          rate: stmt.suppliers.first.rate,
          csg: stmt.suppliers.first.csg,
          discount: stmt.suppliers.first.discount,
          tax: stmt.suppliers.first.tax,
          vat: stmt.suppliers.first.vat,
          caringCost: stmt.suppliers.first.caringCost,
          inTax: stmt.suppliers.first.inTax,
          inVat: stmt.suppliers.first.inVat,
          oldRate: stmt.suppliers.first.oldRate,
          adiRate: stmt.suppliers.first.adiRate,
          fcRate: stmt.suppliers.first.fcRate,
          mgRate: stmt.suppliers.first.mgRate,
          comment: stmt.suppliers.first.comment,
          adComment: stmt.suppliers.first.adComment,
          fcComment: stmt.suppliers.first.fcComment,
          mgComment: stmt.suppliers.first.mgComment,
          mtf: stmt.suppliers.first.mtf,
          mgt: stmt.suppliers.first.mgt,
          v: stmt.suppliers.first.v,
          t: stmt.suppliers.first.t,
          gateCost: stmt.suppliers.first.gateCost,
          warranty: stmt.suppliers.first.warranty,
          taxP: stmt.suppliers.first.taxP,
          vatP: stmt.suppliers.first.vatP,
        )).toList(),
      );
    }).toList();
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

  void _onSupplierSelected(String productName, String supplierName) {
    setState(() {
      final statement = _statements.firstWhere((stmt) => stmt.productName == productName);
      statement.selectedSupplierName = supplierName;
    });
  }

  List<ComparativeStatementNew> get _filteredStatements {
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
                    _buildSummaryCard('Total', '${grandTotal.toStringAsFixed(2)} ${_statements.first.currencyName}', Icons.attach_money),
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
                        'Grand Total: ${grandTotal.toStringAsFixed(2)} ${_statements.first.currencyName}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        _showRequisitionConfirmationDialog(context, selectedData);
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

  void _showRequisitionConfirmationDialog(BuildContext context, List<Map<String,dynamic>> selectedData) {
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PdfPreviewScreen(
                    selectedData: selectedData,
                    code: 'CS: $_selectedCode',
                    grandTotal: selectedData.fold(0.0, (sum, item) => sum + (item['SelectedTotal'] ?? 0)),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: myColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
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
                      _buildDetailRow('Warranty', data['Warranty'] ?? 'N/A'),
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
          // Summary Card
          _buildSummaryCard2(),

          // Products List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredStatements.length,
              itemBuilder: (context, index) {
                final statement = _filteredStatements[index];
                return ComparativeStatementCardNew(
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
    final selectedSuppliers = statements.map((stmt) => stmt.selectedSupplierName ?? '').where((name) => name.isNotEmpty).toSet();

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
                'Suppliers: ${selectedSuppliers.join(', ')}',
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

class ComparativeStatementCardNew extends StatefulWidget {
  final ComparativeStatementNew statement;
  final Function(String, String) onSupplierSelected;

  const ComparativeStatementCardNew({
    Key? key,
    required this.statement,
    required this.onSupplierSelected,
  }) : super(key: key);

  @override
  _ComparativeStatementCardNewState createState() => _ComparativeStatementCardNewState();
}

class _ComparativeStatementCardNewState extends State<ComparativeStatementCardNew> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final availableSuppliers = widget.statement.suppliers;
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
              Text('Selected: ${selectedSupplier.name} - ${widget.statement.currencyName} ${selectedSupplier.rate}'),
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
                _buildInfoRow('Current Stock', widget.statement.lastPurQty),
                _buildInfoRow('Last Purchase Rate', '${widget.statement.currencyName} ${widget.statement.lastPurRate}'),
                _buildInfoRow('Last Purchase Date', widget.statement.lastPurDate),
                _buildInfoRow('VAT Type', 'None'),
                _buildInfoRow('Tax Type', 'None'),

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

  Widget _buildSupplierOption(SupplierData supplier, ComparativeStatementNew statement) {
    final isSelected = statement.selectedSupplierName == supplier.name;
    final total = (double.tryParse(supplier.rate) ?? 0) * (double.tryParse(statement.csQty) ?? 0);

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
          value: supplier.name,
          groupValue: statement.selectedSupplierName,
          onChanged: (value) {
            widget.onSupplierSelected(statement.productName, value!);
          },
        ),
        title: Text(
          supplier.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.blue : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rate: ${statement.currencyName} ${supplier.rate}'),
            Text('Total: ${statement.currencyName} ${total.toStringAsFixed(2)}'),
            Text('Warranty: ${supplier.warranty}'),
            Text('VAT: ${supplier.vat} | Tax: ${supplier.tax}'),
          ],
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: Colors.green)
            : null,
        onTap: () {
          widget.onSupplierSelected(statement.productName, supplier.name);
        },
      ),
    );
  }
}