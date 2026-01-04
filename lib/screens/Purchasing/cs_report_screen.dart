// comparative_statement_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yunusco_group/common_widgets/text_fields.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/riverpods/management_provider.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:path_provider/path_provider.dart';
import '../../helper_class/pdf_service.dart';
import '../../models/comperative_statement_model.dart';

import 'package:flutter/material.dart';

import '../../models/cs_requisation_model.dart';

import 'package:flutter/material.dart';

import '../Inventory/comperative_statement_list.dart';


class SupplierSelectionScreen extends StatefulWidget {
  final List<CsRequisationModel> requisitions;

  const SupplierSelectionScreen({super.key, required this.requisitions});

  @override
  State<SupplierSelectionScreen> createState() =>
      _SupplierSelectionScreenState();
}

class _SupplierSelectionScreenState extends State<SupplierSelectionScreen> {
  List<ProductGroup> _productGroups = [];
  final Map<String, String> _selectedSuppliers =
      {}; // productName -> supplierName

  @override
  void initState() {
    super.initState();
    _groupProducts();
  }

  void _groupProducts() {
    final Map<String, List<CsRequisationModel>> grouped = {};

    // Group by product name
    for (var req in widget.requisitions) {
      if (!grouped.containsKey(req.productName)) {
        grouped[req.productName ?? ''] = [];
      }
      grouped[req.productName]!.add(req);
    }

    // Convert to ProductGroup list
    _productGroups = grouped.entries.map((entry) {
      return ProductGroup(
        productName: entry.key ?? 'Unknown Product',
        suppliers: entry.value,
        commonData: entry.value.first, // Use first item for common data
      );
    }).toList();
  }

  void _onSupplierSelected(String productName, String supplierName) {
    setState(() {
      _selectedSuppliers[productName] = supplierName;
    });
  }

  void _exportSelectedData() {
    final selectedItems = _getSelectedItems();


    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select at least one supplier')));
      return;
    }

    _showSummaryBottomSheet(selectedItems);
  }

  List<CsRequisationModel> _getSelectedItems() {
    return _productGroups
        .where((group) => _selectedSuppliers.containsKey(group.productName))
        .map((group) {
      final selectedSupplierName = _selectedSuppliers[group.productName]!;
      return group.suppliers.firstWhere(
          (supplier) => supplier.supplierName == selectedSupplierName);
    }).toList();
  }

  void _showSummaryBottomSheet(List<CsRequisationModel> selectedItems) {
    final totalValue = selectedItems.fold(
        0.0, (sum, item) => sum + (item.rate ?? 0) * (item.csQty ?? 0));
    final currency =
        selectedItems.isNotEmpty ? selectedItems.first.currencyName : '';
    TextEditingController _notesController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height / 1.5,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Selected Suppliers Summary',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),

                // Selected items list
                ...selectedItems.map((item) => ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text(item.productName ?? ''),
                      subtitle:
                          Text('${item.supplierName} - $currency ${item.rate}'),
                      trailing: Text(
                          '${currency} ${((item.rate ?? 0) * (item.csQty ?? 0)).toStringAsFixed(2)}'),
                    )),

                Divider(),

                // Total
                ListTile(
                  title: Text('Grand Total',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text('$currency ${totalValue.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green)),
                ),

                SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Additional Notes',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: myColors.primaryColor),
                  onPressed: () async {
                    Navigator.pop(context);
                     var response= await _confirmSelection(selectedItems,_notesController.text.trim());
                     DashboardHelpers.showAlert(msg: response['Message']??'Something went wrong',);
                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ComperativeStatementList()));
                  },
                  child: Text(
                    'Confirm Selection',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //
  Future<dynamic>  _confirmSelection(List<CsRequisationModel> selectedItems,String notes) async {
    List<Map<String, dynamic>> items = [];
    // Handle confirmation logic
    for (var e in selectedItems) {
      items.add({
        'productId': e.productId,
        'code': e.code,
        'supplierName': e.supplierName,
        'supplierId': e.supplierId,
      });
    }
    var data={
      'note': notes,
      'supplier': items,
    };
    var response=await apiService.postData('api/Inventory/UpdateSupplierChoice', data);

    return response;

    // Navigate to next screen or save data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Select Suppliers'),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: myColors.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.checklist),
            onPressed: () {
              showConfirmDialog(
                  context: context,
                  title: 'Confirm All Selection',
                  message:
                      'Are you sure you want to select the lowest supplier for all products?',
                  onSubmit: () {
                    setState(() {
                      for (var group in _productGroups) {
                        if (group.suppliers.isNotEmpty) {
                          // Find all suppliers with the lowest rate
                          double? lowestRate;
                          List<CsRequisationModel> lowestRateSuppliers = [];

                          // Find the lowest rate
                          for (var supplier in group.suppliers) {
                            final currentRate =
                                supplier.rate ?? double.infinity;

                            if (lowestRate == null ||
                                currentRate < lowestRate) {
                              lowestRate = currentRate.toDouble();
                            }
                          }

                          // Collect all suppliers with the lowest rate
                          for (var supplier in group.suppliers) {
                            if (supplier.rate == lowestRate) {
                              lowestRateSuppliers.add(supplier);
                            }
                          }

                          // Select first supplier from lowest rate suppliers
                          if (lowestRateSuppliers.isNotEmpty) {
                            // Option 1: Select first one
                            _selectedSuppliers[group.productName] =
                                lowestRateSuppliers.first.supplierName ?? '';

                            // Option 2: If you want to break ties based on other criteria:
                            // For example, select supplier with longer warranty
                            /*
                            lowestRateSuppliers.sort((a, b) {
                              final warrantyA = int.tryParse(a.warranty?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0') ?? 0;
                              final warrantyB = int.tryParse(b.warranty?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0') ?? 0;
                              return warrantyB.compareTo(warrantyA); // Descending (higher warranty first)
                            });
                            _selectedSuppliers[group.productName] = lowestRateSuppliers.first.supplierName ?? '';
                            */
                          }
                        }
                      }
                    });

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Selected suppliers with lowest rates for all products'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  onCancel: () {
                    //Navigator.pop(context);
                  });
            },
            tooltip: 'All Selected',
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _exportSelectedData,
            tooltip: 'View Selected',
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _productGroups.length,
        itemBuilder: (context, index) {
          final productGroup = _productGroups[index];
          return _buildProductCard(productGroup, index);
        },
      ),
    );
  }

  Widget _buildProductCard(ProductGroup productGroup, int index) {
    final isSelected = _selectedSuppliers.containsKey(productGroup.productName);
    final selectedSupplier =
        isSelected ? _selectedSuppliers[productGroup.productName] : null;

    return Card(
      color: Colors.white,
      margin: EdgeInsets.all(8),
      child: ExpansionTile(
        leading: isSelected
            ? Icon(Icons.check_circle, color: Colors.green)
            : Icon(Icons.radio_button_unchecked),
        title: Text(
          '${index + 1}. ${productGroup.productName}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Quantity: ${productGroup.commonData.csQty} ${productGroup.commonData.uomName}'),
            Text('Category: ${productGroup.commonData.productCategoryName}'),
            if (isSelected) Text('Selected: $selectedSupplier'),
          ],
        ),
        trailing: Chip(
          label: Text('${productGroup.suppliers.length} Suppliers'),
          backgroundColor: Colors.blue,
          labelStyle: TextStyle(color: Colors.white),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product common info
                _buildProductInfo(productGroup.commonData),

                SizedBox(height: 16),
                Divider(),
                SizedBox(height: 8),

                // Supplier selection
                Text('Select Supplier:',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
                SizedBox(height: 8),

                ...productGroup.suppliers
                    .map((supplier) => _buildSupplierOption(
                        supplier, productGroup.productName))
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(CsRequisationModel data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Current Stock', data.lastPurQty?.toString() ?? 'N/A'),
        _buildInfoRow(
            'Last Purchase Rate', '${data.currencyName} ${data.lastPurRate}'),
        _buildInfoRow('Last Purchase Date', data.lastPurDate ?? 'N/A'),
        _buildInfoRow('Warranty', data.warranty ?? 'N/A'),
        _buildInfoRow('Payment Mode', data.payMode ?? 'N/A'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$label: ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          Expanded(child: Text(value, style: TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildSupplierOption(CsRequisationModel supplier, String productName) {
    final isSelected = _selectedSuppliers[productName] == supplier.supplierName;
    final total = (supplier.rate ?? 0) * (supplier.csQty ?? 0);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      color: isSelected ? Colors.blue[50] : Colors.grey[50],
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Radio<String>(
          value: supplier.supplierName ?? '',
          groupValue: isSelected ? supplier.supplierName : null,
          onChanged: (value) {
            _onSupplierSelected(productName, value!);
          },
        ),
        title: Text(
          supplier.supplierName ?? 'No Supplier',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.blue : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rate: ${supplier.currencyName} ${supplier.rate}'),
            Text('Total: ${supplier.currencyName} ${total.toStringAsFixed(2)}'),
            Text('Warranty: ${supplier.warranty}'),
            Text('VAT: ${supplier.vat} | Tax: ${supplier.tax}'),
          ],
        ),
        trailing:
            isSelected ? Icon(Icons.check_circle, color: Colors.green) : null,
        onTap: () {
          _onSupplierSelected(productName, supplier.supplierName!);
        },
      ),
    );
  }
}

Future<bool?> showConfirmDialog({
  required BuildContext context,
  String title = 'Please Confirm',
  String message = 'Are you sure you want to proceed?',
  String confirmText = 'CONFIRM',
  String cancelText = 'CANCEL',
  double? height,
  Function? onCancel,
  Function? onSubmit,
  Color? confirmButtonColor,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 400,
            minHeight: height ?? 280,
          ),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon with circular background
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_rounded,
                  size: 34,
                  color: Colors.amber.shade700,
                ),
              ),

              const SizedBox(height: 20),

              // Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),

              const SizedBox(height: 12),

              // Message
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Need to Talk button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Optional: Add functionality
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade50,
                    foregroundColor: Colors.orange.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.orange.shade200),
                    ),
                  ),
                  child: Text(
                    'Need to Talk',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Action buttons row
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                        if (onCancel != null) onCancel();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        cancelText,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Confirm Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        if (onSubmit != null) onSubmit();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: confirmButtonColor ?? Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        confirmText,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class ProductGroup {
  final String productName;
  final List<CsRequisationModel> suppliers;
  final CsRequisationModel commonData;

  ProductGroup({
    required this.productName,
    required this.suppliers,
    required this.commonData,
  });
}
