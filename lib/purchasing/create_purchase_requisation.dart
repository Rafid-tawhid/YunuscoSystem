import 'package:flutter/material.dart';

class PurchaseRequisitionScreen extends StatefulWidget {
  @override
  _PurchaseRequisitionScreenState createState() => _PurchaseRequisitionScreenState();
}

class _PurchaseRequisitionScreenState extends State<PurchaseRequisitionScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> items = [];
  final ScrollController _scrollController = ScrollController();

  // Dropdown values
  String? _selectedDepartment = 'MIS';
  String? _selectedDivision = 'Garment';
  final List<String> _departments = ['MIS', 'HR', 'Finance', 'Production'];
  final List<String> _divisions = ['Garment', 'Knitting', 'Dyeing', 'Printing'];

  // Form controllers
  TextEditingController _employeeController = TextEditingController(text: "A.F.M Sadegul Amin");
  TextEditingController _productController = TextEditingController(text: "620");
  TextEditingController _requiredDateController = TextEditingController(text: "02-Aug-2025");

  // Item controllers
  TextEditingController _materialNameController = TextEditingController();
  TextEditingController _materialDescController = TextEditingController();
  TextEditingController _unitController = TextEditingController();
  TextEditingController _qtyController = TextEditingController();
  TextEditingController _brandController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("General & Accessories Requisition"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
              controller: _scrollController,
              children: [
              Text('Requisition Details', style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: 16),

          // Department Dropdown
          _buildCompactDropdown(
            value: _selectedDepartment,
            items: _departments,
            label: "Department",
            onChanged: (value) => setState(() => _selectedDepartment = value),
          ),
          SizedBox(height: 12),

          // Employee Name
          TextFormField(
            controller: _employeeController,
            decoration: InputDecoration(
              labelText: "Employee Name",
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
          SizedBox(height: 12),

          // Division Dropdown
          _buildCompactDropdown(
            value: _selectedDivision,
            items: _divisions,
            label: "Division",
            onChanged: (value) => setState(() => _selectedDivision = value),
          ),
          SizedBox(height: 12),

          // Product Name
          TextFormField(
            controller: _productController,
            decoration: InputDecoration(
              labelText: "Product Name",
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
          SizedBox(height: 12),

          // Required Date
          TextFormField(
            controller: _requiredDateController,
            decoration: InputDecoration(
              labelText: "Required Date",
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today, size: 20),
                onPressed: () => _selectDate(context),
              ),
            ),
          ),
          SizedBox(height: 24),

          Divider(),
          SizedBox(height: 8),

          Text('Add Items', style: Theme.of(context).textTheme.headlineMedium),
          SizedBox(height: 16),

          // Material Name
          TextFormField(
            controller: _materialNameController,
            decoration: InputDecoration(
              labelText: "Material Name*",
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
          SizedBox(height: 12),

          // Description
          TextFormField(
            controller: _materialDescController,
            decoration: InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
          SizedBox(height: 12),

          Row(
            children: [
              // Unit
              Expanded(
                child: TextFormField(
                  controller: _unitController,
                  decoration: InputDecoration(
                    labelText: "Unit",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                ),),
                SizedBox(width: 12),

                // Quantity
                Expanded(
                  child: TextFormField(
                    controller: _qtyController,
                    decoration: InputDecoration(
                      labelText: "Quantity*",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                ],
              ),
              SizedBox(height: 12),

              // Brand
              TextFormField(
                controller: _brandController,
                decoration: InputDecoration(
                  labelText: "Brand",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),
              SizedBox(height: 12),

              // Note
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: "Note",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),
              SizedBox(height: 16),

              ElevatedButton(
                onPressed: _addItem,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Text("Add Item"),
              ),
              SizedBox(height: 24),

              if (items.isNotEmpty) ...[
                Divider(),
                SizedBox(height: 8),
                Text('Added Items (${items.length})', style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: 12),
                ...items.map((item) => _buildItemCard(item)).toList(),
                SizedBox(height: 16),
              ],

              ElevatedButton(
                onPressed: _saveRequisition,
                child: Text("Submit Requisition"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 48),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactDropdown({
    required String? value,
    required List<String> items,
    required String label,
    required Function(String?) onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          isDense: true,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item['materialName'],
                    style: TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () => _removeItem(item),
                ),
              ],
            ),
            SizedBox(height: 6),
            if (item['materialDesc']?.isNotEmpty ?? false)
              Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(item['materialDesc']),
              ),
            Row(
              children: [
                Text("Qty: ${item['qty']}"),
                SizedBox(width: 16),
                if (item['unit']?.isNotEmpty ?? false)
                  Text("Unit: ${item['unit']}"),
              ],
            ),
            if (item['brand']?.isNotEmpty ?? false)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text("Brand: ${item['brand']}"),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _requiredDateController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  void _addItem() {
    if (_materialNameController.text.isEmpty || _qtyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill required fields (marked with *)")),
      );
      return;
    }

    setState(() {
      items.add({
        'materialName': _materialNameController.text,
        'materialDesc': _materialDescController.text,
        'unit': _unitController.text,
        'qty': _qtyController.text,
        'brand': _brandController.text,
        'note': _noteController.text,
      });

      // Clear fields after adding
      _materialNameController.clear();
      _materialDescController.clear();
      _unitController.clear();
      _qtyController.clear();
      _brandController.clear();
      _noteController.clear();
    });
  }

  void _removeItem(Map<String, dynamic> item) {
    setState(() {
      items.remove(item);
    });
  }

  void _saveRequisition() {
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please add at least one item")),
      );
      return;
    }

    final requisitionData = {
      'department': _selectedDepartment,
      'employeeName': _employeeController.text,
      'division': _selectedDivision,
      'productName': _productController.text,
      'requiredDate': _requiredDateController.text,
      'items': items,
    };

    print(requisitionData); // For debugging

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Requisition submitted successfully!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _employeeController.dispose();
    _productController.dispose();
    _requiredDateController.dispose();
    _materialNameController.dispose();
    _materialDescController.dispose();
    _unitController.dispose();
    _qtyController.dispose();
    _brandController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}