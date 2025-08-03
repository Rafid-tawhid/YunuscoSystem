import 'package:flutter/material.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/purchasing/widgets/purchase_product_list.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../utils/constants.dart';

class PurchaseRequisitionScreen extends StatefulWidget {
  @override
  _PurchaseRequisitionScreenState createState() => _PurchaseRequisitionScreenState();
}

class _PurchaseRequisitionScreenState extends State<PurchaseRequisitionScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> items = [];
  final ScrollController _scrollController = ScrollController();

  // Dropdown values
  Map<String, dynamic>? _selectedDepartment;
  Map<String, dynamic>? _selectedDivision;
  final List<Map<String, dynamic>> _divisions = [
    {"id": 1, "name": "Garments"},
    {"id": 2, "name": "Accessories"}
  ];

  // Form controllers
  final TextEditingController _employeeController = TextEditingController(text: DashboardHelpers. currentUser!.userName);
  final TextEditingController _requiredDateController = TextEditingController(text: "02-Aug-2025");
  final TextEditingController _materialNameController = TextEditingController();
  final TextEditingController _materialDescController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              Text('Requisition Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),

              // Division Dropdown
              _buildCompactDropdown(
                value: _selectedDivision,
                items: _divisions,
                hint: 'Select Division',
                label: "Division*",
                validator: (value) => value == null ? 'Please select division' : null,
                onChanged: (Map<String, dynamic>? newValue) {
                  setState(() {
                    _selectedDivision = newValue;
                  });
                },
              ),
              SizedBox(height: 12),
              _buildCompactDropdown(
                value: _selectedDepartment,
                items: allDepartmentList,
                hint: 'Select Department',
                label: "Department*",
                validator: (value) => value == null ? 'Please select department' : null,
                onChanged: (Map<String, dynamic>? newValue) {
                  setState(() {
                    _selectedDepartment = newValue;
                  });
                },
              ),
              SizedBox(height: 12),

              // Employee Name
              TextFormField(
                controller: _employeeController,
                decoration: InputDecoration(
                  labelText: "Employee Name*",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Employee name is required' : null,
              ),
              SizedBox(height: 12),

              // Required Date
              TextFormField(
                controller: _requiredDateController,
                decoration: InputDecoration(
                  labelText: "Required Date*",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today, size: 20),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Required date is needed' : null,
                readOnly: true,
              ),
              SizedBox(height: 24),

              Divider(),
              SizedBox(height: 8),

              Text('Add Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),

              // Material Name
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductSelectionScreen())).then((value) {
                    if (value != null) {
                      setState(() {
                        _materialNameController.text = value;
                      });
                    }
                  });
                },
                child: TextFormField(
                  controller: _materialNameController,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: "Product Name*",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'Please select a product' : null,
                ),
              ),
              SizedBox(height: 12),

              // Description
              TextFormField(
                controller: _materialDescController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),
              SizedBox(height: 12),

              // Quantity
              TextFormField(
                controller: _qtyController,
                decoration: InputDecoration(
                  labelText: "Quantity*",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Quantity is required';
                  if (double.tryParse(value!) == null) return 'Enter valid number';
                  return null;
                },
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
                  labelText: "Remarks",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),
              SizedBox(height: 16),

              ElevatedButton(
                onPressed: _addItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: myColors.green,
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Text("Add Item", style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 24),

              if (items.isNotEmpty) ...[
                Divider(),
                SizedBox(height: 8),
                Text('Added Items (${items.length})', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                ...items.map((item) => _buildItemCard(item)),
                SizedBox(height: 16),
              ],

              ElevatedButton(
                onPressed: _saveRequisition,
                style: ElevatedButton.styleFrom(
                  backgroundColor: myColors.primaryColor,
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Text("Submit Requisition", style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactDropdown({
    required Map<String, dynamic>? value,
    required List<Map<String, dynamic>> items,
    required String label,
    required String hint,
    required String? Function(Map<String, dynamic>?) validator,
    required Function(Map<String, dynamic>?) onChanged,
  }) {
    return FormField<Map<String, dynamic>>(
      validator: validator,
      builder: (formFieldState) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            errorText: formFieldState.errorText,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Map<String, dynamic>>(
              value: value,
              isExpanded: true,
              isDense: true,
              hint: Text(hint),
              alignment: Alignment.bottomLeft,
              items: items.map((item) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: item,
                  child: Text(item['name'].toString(), style: TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (value) {
                onChanged(value);
                formFieldState.didChange(value);
              },
            ),
          ),
        );
      },
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
                Text(item['materialName'], style: TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () => _removeItem(item),
                ),
              ],
            ),
            if (item['materialDesc']?.isNotEmpty ?? false)
              Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(item['materialDesc']),
              ),
            Text("Qty: ${item['qty']}"),
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
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _requiredDateController.text = "${picked.day}-${_getMonthName(picked.month)}-${picked.year}";
      });
    }
  }

  String _getMonthName(int month) {
    return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][month - 1];
  }

  void _addItem() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        items.add({
          'materialName': _materialNameController.text,
          'materialDesc': _materialDescController.text,
          'qty': _qtyController.text,
          'brand': _brandController.text,
          'note': _noteController.text,
        });

        // Clear fields after adding
        _materialNameController.clear();
        _materialDescController.clear();
        _qtyController.clear();
        _brandController.clear();
        _noteController.clear();
      });
    }
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
      'division': _selectedDivision,
      'department': _selectedDepartment,
      'employeeName': _employeeController.text,
      'requiredDate': _requiredDateController.text,
      'items': items,
    };

    // Here you would typically send the data to your backend
    debugPrint('Requisition Data: $requisitionData');

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
    _requiredDateController.dispose();
    _materialNameController.dispose();
    _materialDescController.dispose();
    _qtyController.dispose();
    _brandController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}
