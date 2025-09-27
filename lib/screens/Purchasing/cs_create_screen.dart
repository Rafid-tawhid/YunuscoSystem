// supply_chain_form_screen.dart
import 'package:flutter/material.dart';

import '../../models/approval_Supply_model.dart';
import '../../models/puchaseMasterModelFirebase.dart';
import 'package:provider/provider.dart';

import '../../providers/purchase_provider.dart';

class SupplyChainFormScreen extends StatefulWidget {
  final ApprovedRequisition requisition;
  final RequisitionDetail productDetail;

  const SupplyChainFormScreen({
    Key? key,
    required this.requisition,
    required this.productDetail,
  }) : super(key: key);

  @override
  _SupplyChainFormScreenState createState() => _SupplyChainFormScreenState();
}

class _SupplyChainFormScreenState extends State<SupplyChainFormScreen> {
  final List<SupplierQuote> _supplierQuotes = [];
  final _formKey = GlobalKey<FormState>();

  // Current supplier form fields
  String _currentSupplierName = '';
  double _currentUnitRate = 0.0;
  String _currentWarranty = '';
  String _currentTaxType = 'Local';
  String _currentVatType = 'Local';
  double _currentTaxRate = 0.0;
  double _currentVatRate = 0.0;
  String _currentCurrency = 'BDT';
  int _currentCreditPeriod = 0;
  String _currentPayMode = 'Cash';
  bool _currentTaxPayee = false;
  bool _currentVatPayee = false;
  double _currentCarryingCost = 0.0;
  double _currentOtherCost = 0.0;
  double _currentDiscount = 0.0;
  String _currentComments = '';

  void _addSupplierQuote() {
    if (_currentSupplierName.isEmpty || _currentUnitRate <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Supplier Name and Unit Rate are required')),
      );
      return;
    }

    setState(() {
      _supplierQuotes.add(SupplierQuote(
        supplierId: DateTime.now().millisecondsSinceEpoch.toString(),
        supplierName: _currentSupplierName,
        unitRate: _currentUnitRate,
        warranty: _currentWarranty,
        taxType: _currentTaxType,
        vatType: _currentVatType,
        taxRate: _currentTaxRate,
        vatRate: _currentVatRate,
        currency: _currentCurrency,
        creditPeriodDays: _currentCreditPeriod,
        payMode: _currentPayMode,
        taxPayee: _currentTaxPayee,
        vatPayee: _currentVatPayee,
        carryingCost: _currentCarryingCost,
        otherCost: _currentOtherCost,
        discount: _currentDiscount,
        comments: _currentComments,
      ));

      // Clear form
      _clearForm();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Supplier added successfully')),
    );
  }

  void _clearForm() {
    setState(() {
      _currentSupplierName = '';
      _currentUnitRate = 0.0;
      _currentWarranty = '';
      _currentTaxType = 'Local';
      _currentVatType = 'Local';
      _currentTaxRate = 0.0;
      _currentVatRate = 0.0;
      _currentCurrency = 'BDT';
      _currentCreditPeriod = 0;
      _currentPayMode = 'Cash';
      _currentTaxPayee = false;
      _currentVatPayee = false;
      _currentCarryingCost = 0.0;
      _currentOtherCost = 0.0;
      _currentDiscount = 0.0;
      _currentComments = '';
    });
  }

  void _removeSupplier(int index) {
    setState(() {
      _supplierQuotes.removeAt(index);
    });
  }

  Future<void> _saveSupplyChainRecord() async {
    if (_supplierQuotes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add at least one supplier')),
      );
      return;
    }

    try {
      var pp=context.read<PurchaseProvider>();
      // Check if record already exists



      final record = SupplyChainRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        reqId: widget.requisition.reqId,
        productId: widget.productDetail.productId,
        productName: widget.productDetail.productDescription,
        unitName: 'Unit ${widget.productDetail.unitId}', // You might want to fetch actual unit name
        requiredQty: widget.productDetail.totalReqQty,
        supplierQuotes: _supplierQuotes,
        createdAt: DateTime.now(),
      );

      await pp.saveSupplyChainRecord(record);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Supply chain record saved successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving record: $e')),
      );
    }
  }

  @override
  void initState() {
    getSupplierQuotesByReqIdAndProduct(
      productId: widget.productDetail.productId,
      reqId: widget.productDetail.reqId
    );
    super.initState();
  }

  // Add this method to your purchase_provider.dart
   getSupplierQuotesByReqIdAndProduct({
    required String reqId,
    required String productId
  }) async {
    var pp=context.read<PurchaseProvider>();
    pp.getSupplierQuotesByReqIdAndProduct(reqId, productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CS Status - Supply Chain'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveSupplyChainRecord,
            tooltip: 'Save All Suppliers',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Information Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Product Information',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text('Item Name: ${widget.productDetail.productDescription}'),
                      Text('Required Qty: ${widget.productDetail.totalReqQty}'),
                      Text('Brand: ${widget.productDetail.brand}'),
                      Text('Required Date: ${widget.productDetail.requiredDate}'),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Supplier Form
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Supplier Quote',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),

                      // Basic Information
                      _buildSectionHeader('Supplier Information'),
                      _buildTextFormField('Supplier Name *', (value) => _currentSupplierName = value),
                      _buildNumberField('Unit Rate *', (value) => _currentUnitRate = value),
                      _buildTextFormField('Warranty', (value) => _currentWarranty = value),

                      SizedBox(height: 16),
                      _buildSectionHeader('Tax & VAT Information'),
                      Row(
                        children: [
                          Expanded(child: _buildDropdown('Tax Type', ['Local', 'Import'], (value) => _currentTaxType = value!)),
                          SizedBox(width: 10),
                          Expanded(child: _buildDropdown('VAT Type', ['Local', 'Import'], (value) => _currentVatType = value!)),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: _buildNumberField('Tax Rate (%)', (value) => _currentTaxRate = value)),
                          SizedBox(width: 10),
                          Expanded(child: _buildNumberField('VAT Rate (%)', (value) => _currentVatRate = value)),
                        ],
                      ),

                      SizedBox(height: 16),
                      _buildSectionHeader('Purchase Information'),
                      Row(
                        children: [
                          Expanded(child: _buildDropdown('Currency', ['BDT', 'USD', 'EUR'], (value) => _currentCurrency = value!)),
                          SizedBox(width: 10),
                          Expanded(child: _buildNumberField('Credit Period (Days)', (value) => _currentCreditPeriod = value.toInt())),
                        ],
                      ),
                      _buildDropdown('Pay Mode', ['Cash', 'Credit', 'Cheque'], (value) => _currentPayMode = value!),
                      Row(
                        children: [
                          Expanded(child: _buildCheckbox('Tax Payee', _currentTaxPayee, (value) => setState(() => _currentTaxPayee = value!))),
                          Expanded(child: _buildCheckbox('VAT Payee', _currentVatPayee, (value) => setState(() => _currentVatPayee = value!))),
                        ],
                      ),

                      SizedBox(height: 16),
                      _buildSectionHeader('Cost Information'),
                      Row(
                        children: [
                          Expanded(child: _buildNumberField('Carrying Cost', (value) => _currentCarryingCost = value)),
                          SizedBox(width: 10),
                          Expanded(child: _buildNumberField('Other Cost', (value) => _currentOtherCost = value)),
                        ],
                      ),
                      _buildNumberField('Discount (%)', (value) => _currentDiscount = value),
                      _buildTextFormField('Comments', (value) => _currentComments = value, maxLines: 3),

                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _addSupplierQuote,
                        icon: Icon(Icons.add),
                        label: Text('Add Supplier Quote'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Added Suppliers List
              if (_supplierQuotes.isNotEmpty) ...[
                Text(
                  'Added Suppliers (${_supplierQuotes.length})',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ..._supplierQuotes.asMap().entries.map((entry) {
                  final index = entry.key;
                  final quote = entry.value;
                  return Card(
                    margin: EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(Icons.business, color: Colors.blue),
                      title: Text(quote.supplierName),
                      subtitle: Text('Unit Rate: ${quote.currency} ${quote.unitRate}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeSupplier(index),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    );
  }

  Widget _buildTextFormField(String label, Function(String) onChanged, {int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        maxLines: maxLines,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildNumberField(String label, Function(double) onChanged) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        onChanged: (value) => onChanged(double.tryParse(value) ?? 0.0),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        value: items.first,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }
}