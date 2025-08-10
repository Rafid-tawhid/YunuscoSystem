import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/product_provider.dart';
import 'package:yunusco_group/purchasing/widgets/purchase_product_list.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../models/requisation_products_model.dart';

class CreatePurchaseRequisitionScreen extends StatefulWidget {
  @override
  _CreatePurchaseRequisitionScreenState createState() => _CreatePurchaseRequisitionScreenState();
}

class _CreatePurchaseRequisitionScreenState extends State<CreatePurchaseRequisitionScreen> {
  final _formKey = GlobalKey<FormState>();
  List<RequisationProductsModel> items = [];

  // Dropdown values
  Map<String, dynamic>? _selectedDivision;
  final List<Map<String, dynamic>> _divisions = [
    {"id": 'G', "name": "Garments"},
    {"id": 'A', "name": "Accessories"}
  ];

  // Form controllers
  final TextEditingController _requiredDateController = TextEditingController();
  final TextEditingController _materialNameController = TextEditingController();
  final TextEditingController _materialDescController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _consumeDaysController = TextEditingController();
  RequisationProductsModel? _selectedProduct;

  @override
  void initState() {
    super.initState();
    _requiredDateController.text = _formatDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Purchase Requisition",style: TextStyle(color: Colors.white),),
        backgroundColor: myColors.primaryColor,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 24),
              // Division Dropdown
              _buildDropdown(
                value: _selectedDivision,
                items: _divisions,
                label: "Division*",
                hint: 'Select Division',
                validator: (value) => value == null ? 'Required field' : null,
                onChanged: (value) => setState(() => _selectedDivision = value),
              ),
              const SizedBox(height: 16),

              // Required Date
              TextFormField(
                controller: _requiredDateController,
                decoration: InputDecoration(
                  labelText: "Required Date*",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                validator: (value) => value?.isEmpty ?? true ? 'Required field' : null,
              ),
              const SizedBox(height: 16),

              // Product Selection
              InkWell(
                onTap: () async {
                  final product = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductSelectionScreen()),
                  );
                  if (product != null) {
                    setState(() {
                      _selectedProduct = product;
                      _materialNameController.text = product.productName ?? '';
                    });

                    debugPrint('_selectedProduct ${_selectedProduct!.toJson()}');
                  }
                },
                child: TextFormField(
                  controller: _materialNameController,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: "Product*",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'Please select a product' : null,
                ),
              ),
              const SizedBox(height: 16),

              // Product Details
              TextFormField(
                controller: _materialDescController,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              // Quantity and Consume Days
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _qtyController,
                      decoration: InputDecoration(
                        labelText: "Quantity*",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Required field';
                        if (double.tryParse(value!) == null) return 'Invalid number';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _consumeDaysController,
                      decoration: InputDecoration(
                        labelText: "Consume Days*",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Required field';
                        if (int.tryParse(value!) == null) return 'Invalid number';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Brand and Notes
              TextFormField(
                controller: _brandController,
                decoration: InputDecoration(
                  labelText: "Brand",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: "Notes",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              // Add Item Button
              ElevatedButton(
                onPressed: _addItem,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: myColors.green
                ),
                child: Text("Add Item",style: TextStyle(color: Colors.white),),
              ),
              const SizedBox(height: 24),

              // Added Items List
              if (items.isNotEmpty) ...[
                Text('Added Items (${items.length})', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...items.map((item) => _buildItemCard(item)),
                const SizedBox(height: 16),
              ],



              SizedBox(height: 16,),
              if (items.isNotEmpty) TextFormField(
                controller: _remarksController,
                decoration: InputDecoration(
                  labelText: "Remarks",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24,),
              // Submit Button
              if (items.isNotEmpty)
                ElevatedButton(
                  onPressed: _submitRequisition,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor:myColors.primaryColor
                  ),

                  child: Text("Submit Requisition",style: TextStyle(color: Colors.white),),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required Map<String, dynamic>? value,
    required List<Map<String, dynamic>> items,
    required String label,
    required String hint,
    required String? Function(Map<String, dynamic>?) validator,
    required Function(Map<String, dynamic>?) onChanged,
  }) {
    return DropdownButtonFormField<Map<String, dynamic>>(
      value: value,
      items: items.map((item) => DropdownMenuItem(
        value: item,
        child: Text(item['name']),
      )).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      hint: Text(hint),
      validator: validator,
    );
  }

  Widget _buildItemCard(RequisationProductsModel item) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(item.productName ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.productName != null) Text(item.productName??''),
            Text("Qty: ${item.actualReqQty}"),
            if (item.uomName != null) Text("UOM: ${item.uomName!}"),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _removeItem(item),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      _requiredDateController.text = DashboardHelpers.convertDateTime2(picked);
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  void _addItem() {
    if (_formKey.currentState!.validate() && _selectedProduct != null) {
      setState(() {
        items.add(RequisationProductsModel.fromJson2({
          "productId": _selectedProduct!.productId,
          "productName": _selectedProduct!.productName,
          "productDescription": _materialDescController.text,
          "unitId": _selectedProduct!.uomId,
          "actualReqQty": int.parse(_qtyController.text.toString()),
          "excessForStock": null,
          "totalReqQty": int.parse(_qtyController.text.toString()),
          "consumeDays": int.parse(_consumeDaysController.text.toString()),
          "note": _noteController.text,
          "brand": _brandController.text,
          "approvedQty": null,
          "requiredDate": _requiredDateController.text
        }));
        _clearFields();
      });
      DashboardHelpers.showAlert(msg: 'Item Added Successfully!!');
    }
  }

  void _removeItem(RequisationProductsModel item) {
    setState(() => items.remove(item));
  }

  void _clearFields() {
    _materialNameController.clear();
    _materialDescController.clear();
    _qtyController.clear();
    _brandController.clear();
    _noteController.clear();
    _consumeDaysController.clear();
    _selectedProduct = null;
  }

  Future<void> _submitRequisition() async {
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please add at least one item")),
      );
      return;
    }

    final data = {
      "requisitionMaster": {
        "productType": _selectedDivision!['id'],
        "remarks": _remarksController.text,
        "division": _selectedDivision!['id']=='G'?1:2
      },
      "requisitionDetails": items.map((item) => {
        "productId": item.productId,
        "productDescription": item.productDescription,
        "unitId": item.uomId,
        "actualReqQty": item.actualReqQty,
        "totalReqQty": item.totalReqQty,
        "consumeDays": item.consumeDays,
        "note": item.note,
        "brand": item.brand,
        "requiredDate": item.requiredDate
      }).toList()
    };

    var pp=context.read<ProductProvider>();
    var result=await pp.submitGeneralRequisation(data);
    if(result){
      DashboardHelpers.showAlert(msg: 'Requisition submitted successfully!');
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _requiredDateController.dispose();
    _materialNameController.dispose();
    _materialDescController.dispose();
    _qtyController.dispose();
    _remarksController.dispose();
    _brandController.dispose();
    _noteController.dispose();
    _consumeDaysController.dispose();
    super.dispose();
  }
}