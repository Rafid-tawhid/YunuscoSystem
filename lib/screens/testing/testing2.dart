import 'dart:convert';

import 'package:flutter/material.dart';
import '../../models/cs_requisation_model.dart';


class SupplierSelectionScreen2 extends StatefulWidget {
  final List<CsRequisationModel> requisitions;

  const SupplierSelectionScreen2({super.key, required this.requisitions});

  @override
  State<SupplierSelectionScreen2> createState() => _SupplierSelectionScreen2State();
}

class _SupplierSelectionScreen2State extends State<SupplierSelectionScreen2> {
  final Map<String, ProductSelection> _selectedProducts = {};
  List<ProductGroup> _productGroups = [];
  final TextEditingController _globalNotesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _groupProducts();
    _initializeSelections();
  }

  void _groupProducts() {
    final Map<String, List<CsRequisationModel>> grouped = {};

    for (var req in widget.requisitions) {
      final key = req.productName ?? 'Unknown';
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(req);
    }

    _productGroups = grouped.entries.map((entry) {
      return ProductGroup(
        productName: entry.key,
        suppliers: entry.value,
        commonData: entry.value.first,
      );
    }).toList();
  }

  void _initializeSelections() {
    for (var group in _productGroups) {
      if (group.suppliers.isNotEmpty) {
        final defaultSupplier = group.suppliers.first;
        _selectedProducts[group.productName] = ProductSelection(
          supplier: defaultSupplier,
          quantity: defaultSupplier.csQty!.toInt() ?? 0,
          notes: '',
        );
      }
    }
  }

  // Main Screen UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Supplier Selection', style: TextStyle(fontSize: 18)),
          Text(
            '${_productGroups.length} products, ${_selectedProducts.length} selected',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 2,
      actions: [
        _buildProgressIndicator(),
        IconButton(
          icon: Icon(Icons.auto_awesome, color: Colors.blue),
          onPressed: _autoSelectBestSuppliers,
          tooltip: 'Auto-select best suppliers',
        ),
        IconButton(
          icon: Icon(Icons.restart_alt, color: Colors.orange),
          onPressed: _resetSelections,
          tooltip: 'Reset all selections',
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    final selectedCount = _selectedProducts.length;
    final totalCount = _productGroups.length;
    final percentage = totalCount > 0 ? (selectedCount / totalCount * 100) : 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${percentage.round()}%', style: TextStyle(fontSize: 12)),
          SizedBox(height: 4),
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: selectedCount / totalCount,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_productGroups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No products available', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _productGroups.length,
      padding: EdgeInsets.all(12),
      itemBuilder: (context, index) {
        return _buildProductCard(_productGroups[index], index);
      },
    );
  }

  Widget _buildProductCard(ProductGroup group, int index) {
    final selection = _selectedProducts[group.productName];
    final isSelected = selection != null;
    final totalCost = (selection?.quantity ?? 0) * (selection?.supplier.rate ?? 0);

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: isSelected ? Colors.blue : Colors.grey,
          child: Text(
            '${index + 1}',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                group.productName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            if (isSelected) ...[
              Icon(Icons.check_circle, color: Colors.green, size: 18),
              SizedBox(width: 4),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Row(
              children: [
                _buildInfoChip('Qty: ${selection?.quantity ?? 0}', Colors.blue),
                SizedBox(width: 6),
                _buildInfoChip(group.commonData.uomName ?? 'N/A', Colors.green),
                if (isSelected) ...[
                  SizedBox(width: 6),
                  _buildInfoChip('Selected', Colors.orange),
                ],
              ],
            ),
            SizedBox(height: 4),
            Text(
              isSelected ? '${selection?.supplier.supplierName}' : 'No supplier selected',
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.green[700] : Colors.grey,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${group.commonData.currencyName} ${totalCost.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            Text(
              '${group.suppliers.length} options',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        initiallyExpanded: !isSelected, // Expand if not selected
        childrenPadding: EdgeInsets.all(16),
        children: [
          // Product Basic Info
          _buildProductOverview(group),
          Divider(height: 32, thickness: 1),

          // Supplier Selection
          _buildSupplierSelection(group),

          // Quantity Adjustment
          _buildQuantityAdjustment(group, selection),

          // Notes Section
          _buildNotesSection(group, selection),

          // Actions
          _buildCardActions(group),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildProductOverview(ProductGroup group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Product Details', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _buildDetailItem(Icons.category, 'Category', group.commonData.productCategoryName),
            _buildDetailItem(Icons.branding_watermark, 'Brand', group.commonData.brandName),
            _buildDetailItem(Icons.attach_money, 'Last Rate', '${group.commonData.currencyName} ${group.commonData.lastPurRate}'),
            _buildDetailItem(Icons.date_range, 'Last Purchase', group.commonData.lastPurDate),
            _buildDetailItem(Icons.security, 'Warranty', group.commonData.warranty),
            _buildDetailItem(Icons.payment, 'Payment', group.commonData.payMode),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String? value) {
    return Container(
      width: 150,
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 10, color: Colors.grey)),
                Text(
                  value ?? 'N/A',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplierSelection(ProductGroup group) {
    final selection = _selectedProducts[group.productName];
    final currentSupplier = selection?.supplier;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Select Supplier', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            Text('${group.suppliers.length} available', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: group.suppliers.map((supplier) {
            final isSelected = currentSupplier?.supplierName == supplier.supplierName;
            final totalCost = (selection?.quantity ?? supplier.csQty ?? 0) * (supplier.rate ?? 0);

            return GestureDetector(
              onTap: () => _selectSupplier(group.productName, supplier),
              child: Container(
                width: 160,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue[50] : Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            supplier.supplierName ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.blue : Colors.grey[800],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isSelected)
                          Icon(Icons.check_circle, color: Colors.green, size: 16),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Rate: ${supplier.currencyName} ${supplier.rate}',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Total: ${supplier.currencyName} ${totalCost.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green[700]),
                    ),
                    SizedBox(height: 4),
                    if (supplier.warranty?.isNotEmpty == true)
                      Row(
                        children: [
                          Icon(Icons.verified_user, size: 12, color: Colors.orange),
                          SizedBox(width: 4),
                          Text('${supplier.warranty}', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuantityAdjustment(ProductGroup group, ProductSelection? selection) {
    final currentQty = selection?.quantity ?? group.commonData.csQty ?? 0;
    final minQty = 1;
    final maxQty = currentQty * 2; // Allow up to double the original

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text('Adjust Quantity', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        Row(
          children: [
            IconButton(
              onPressed: currentQty > minQty ? () => _adjustQuantity(group.productName, -1) : null,
              icon: Icon(Icons.remove_circle_outline),
              color: currentQty > minQty ? Colors.red : Colors.grey,
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    '$currentQty',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  Text(
                    '${group.commonData.uomName}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: currentQty < maxQty ? () => _adjustQuantity(group.productName, 1) : null,
              icon: Icon(Icons.add_circle_outline),
              color: currentQty < maxQty ? Colors.green : Colors.grey,
            ),
            SizedBox(width: 8),
            Column(
              children: [
                Container(
                  width: 100,
                  child: Slider(
                    value: currentQty.toDouble(),
                    min: minQty.toDouble(),
                    max: maxQty.toDouble(),
                    divisions: (maxQty.toInt() - minQty.toInt()),
                    label: '$currentQty',
                    onChanged: (value) => _setQuantity(group.productName, value.toInt()),
                  ),
                ),
                Text(
                  '${minQty} - ${maxQty}',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () => _setQuantity(group.productName, group.commonData.csQty?.toInt() ?? 1),
              icon: Icon(Icons.restore, size: 16),
              label: Text('Reset to ${group.commonData.csQty}'),
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotesSection(ProductGroup group, ProductSelection? selection) {
    final controller = TextEditingController(text: selection?.notes ?? '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text('Notes & Comments', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Add comments about this selection...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
              suffixIcon: IconButton(
                icon: Icon(Icons.save, size: 18),
                onPressed: () => _saveNotes(group.productName, controller.text),
                tooltip: 'Save notes',
              ),
            ),
            onChanged: (value) => _saveNotes(group.productName, value),
          ),
        ),
        SizedBox(height: 8),
        if (selection?.notes?.isNotEmpty == true)
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.yellow[50],
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.yellow[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.note, size: 16, color: Colors.orange),
                SizedBox(width: 8),
                Expanded(child: Text(selection!.notes!, style: TextStyle(fontSize: 12))),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCardActions(ProductGroup group) {
    final isSelected = _selectedProducts.containsKey(group.productName);

    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton.icon(
            onPressed: () => _clearSelection(group.productName),
            icon: Icon(Icons.clear, size: 16),
            label: Text('Clear'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: BorderSide(color: Colors.red),
            ),
          ),
          SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () => _selectSupplier(group.productName, group.suppliers.first),
            icon: Icon(isSelected ? Icons.edit : Icons.check, size: 16),
            label: Text(isSelected ? 'Update' : 'Select'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? Colors.blue : Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final totalItems = _selectedProducts.length;
    final totalCost = _selectedProducts.values.fold<double>(
      0,
          (sum, selection) => sum + (selection.quantity * (selection.supplier.rate ?? 0)),
    );
    final currency = _selectedProducts.values.isNotEmpty
        ? _selectedProducts.values.first.supplier.currencyName
        : '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Global Notes
          Container(
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[100]!),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.note_add, color: Colors.blue, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _globalNotesController,
                    decoration: InputDecoration(
                      hintText: 'Add global notes for all selections...',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),

          // Summary Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$totalItems products selected', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('$currency ${totalCost.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[700])),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: totalItems > 0 ? _showSummary : null,
                icon: Icon(Icons.summarize),
                label: Text('Review & Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper Methods
  void _selectSupplier(String productName, CsRequisationModel supplier) {
    setState(() {
      final current = _selectedProducts[productName];
      _selectedProducts[productName] = ProductSelection(
        supplier: supplier,
        quantity: current?.quantity.toInt() ?? supplier.csQty!.toInt() ?? 0,
        notes: current?.notes ?? '',
      );
    });
  }

  void _adjustQuantity(String productName, int delta) {
    final selection = _selectedProducts[productName];
    if (selection != null) {
      final newQty = selection.quantity + delta;
      if (newQty >= 1) {
        setState(() {
          _selectedProducts[productName] = selection.copyWith(quantity: newQty);
        });
      }
    }
  }

  void _setQuantity(String productName, int quantity) {
    final selection = _selectedProducts[productName];
    if (selection != null && quantity >= 1) {
      setState(() {
        _selectedProducts[productName] = selection.copyWith(quantity: quantity);
      });
    }
  }

  void _saveNotes(String productName, String notes) {
    final selection = _selectedProducts[productName];
    if (selection != null) {
      setState(() {
        _selectedProducts[productName] = selection.copyWith(notes: notes);
      });
    }
  }

  void _clearSelection(String productName) {
    setState(() {
      _selectedProducts.remove(productName);
    });
  }

  void _autoSelectBestSuppliers() {
    setState(() {
      for (var group in _productGroups) {
        if (group.suppliers.isNotEmpty) {
          // Find supplier with lowest rate
          CsRequisationModel? bestSupplier;
          double? bestRate;

          for (var supplier in group.suppliers) {
            final rate = supplier.rate ?? double.infinity;
            if (bestRate == null || rate < bestRate) {
              bestRate = rate.toDouble();
              bestSupplier = supplier;
            }
          }

          if (bestSupplier != null) {
            _selectedProducts[group.productName] = ProductSelection(
              supplier: bestSupplier,
              quantity: bestSupplier.csQty!.toInt() ?? 0,
              notes: 'Auto-selected: Lowest rate',
            );
          }
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Auto-selected best suppliers for all products'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _resetSelections() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset All Selections'),
        content: Text('Are you sure you want to clear all selections and notes?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedProducts.clear();
                _globalNotesController.clear();
                _initializeSelections();
              });
              Navigator.pop(context);
            },
            child: Text('Reset All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSummary() {
    final selectedItems = _getSelectedItems();
    if (selectedItems.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => SummaryScreen(
          selections: selectedItems,
          globalNotes: _globalNotesController.text,
          originalRequisitions: widget.requisitions,
        ),
      ),
    );
  }

  List<ProductSelection> _getSelectedItems() {
    return _selectedProducts.values.toList();
  }





}

// Summary Screen for review
class SummaryScreen extends StatelessWidget {
  final List<ProductSelection> selections;
  final String globalNotes;
  final List<CsRequisationModel> originalRequisitions;

  const SummaryScreen({
    super.key,
    required this.selections,
    required this.globalNotes,
    required this.originalRequisitions,
  });

  @override
  Widget build(BuildContext context) {
    final totalCost = selections.fold<double>(
      0,
          (sum, selection) => sum + (selection.quantity * (selection.supplier.rate ?? 0)),
    );
    final currency = selections.isNotEmpty ? selections.first.supplier.currencyName : '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Review Selections'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveSelections(context,selections,originalRequisitions),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Selections', style: TextStyle(fontWeight: FontWeight.bold)),
                        Chip(
                          label: Text('${selections.length} items'),
                          backgroundColor: Colors.blue,
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Grand Total', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          '$currency ${totalCost.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Global Notes
            if (globalNotes.isNotEmpty)
              Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.note, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Global Notes', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(globalNotes),
                    ],
                  ),
                ),
              ),

            SizedBox(height: 16),

            // Comparison Table
            Text('Changes Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),

            ...selections.map((selection) {
              final original = originalRequisitions.firstWhere(
                    (req) => req.productName == selection.supplier.productName,
                orElse: () => selection.supplier,
              );

              return _buildComparisonCard(selection, original);
            }),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[300]!)),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Go Back'),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _saveSelections(context,selections,originalRequisitions),
                icon: Icon(Icons.save),
                label: Text('Save All'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonCard(ProductSelection selection, CsRequisationModel original) {
    final hasChanges =
        selection.quantity != (original.csQty ?? 0) ||
            selection.supplier.supplierName != original.supplierName ||
            selection.notes?.isNotEmpty == true;

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      color: hasChanges ? Colors.yellow[50] : Colors.white,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(selection.supplier.productName ?? '', style: TextStyle(fontWeight: FontWeight.bold))),
                if (hasChanges)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('CHANGED', style: TextStyle(color: Colors.white, fontSize: 10)),
                  ),
              ],
            ),
            SizedBox(height: 8),

            // Comparison Table
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(3),
              },
              children: [
                _buildComparisonRow('Supplier', original.supplierName, selection.supplier.supplierName),
                _buildComparisonRow('Quantity', '${original.csQty}', '${selection.quantity}'),
                _buildComparisonRow('Rate', '${original.rate}', '${selection.supplier.rate}'),
                _buildComparisonRow('Total',
                    '${(original.rate ?? 0) * (original.csQty ?? 0)}',
                    '${selection.supplier.rate! * selection.quantity}'),
              ],
            ),

            // Notes
            if (selection.notes?.isNotEmpty == true) ...[
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.note, size: 16, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(child: Text('Notes: ${selection.notes!}', style: TextStyle(fontSize: 12))),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  TableRow _buildComparisonRow(String label, String? oldValue, String? newValue) {
    final isChanged = oldValue != newValue;

    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Text(
            oldValue ?? 'N/A',
            style: TextStyle(
              color: isChanged ? Colors.red : Colors.grey[700],
              decoration: isChanged ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Text(
            newValue ?? 'N/A',
            style: TextStyle(
              color: isChanged ? Colors.green : Colors.grey[700],
              fontWeight: isChanged ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  void _saveSelections(BuildContext context,List<ProductSelection> selection,List<CsRequisationModel> requisitions) async {
    _generateAndPrintComparisonData(selections);
    // Implement save logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selections saved successfully'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate back
    // Navigator.pop(context);
    // Navigator.pop(context); // Back to previous screen
  }


  void _generateAndPrintComparisonData(List<ProductSelection> selections) {
    final comparisonData = _generateComparisonJSON(selections);

    // Pretty print the JSON
    final encoder = JsonEncoder.withIndent('  ');
    final prettyJson = encoder.convert(comparisonData);

    print('=' * 80);
    print('COMPLETE COMPARISON DATA');
    print('=' * 80);
    print(prettyJson);
    print('=' * 80);

    // Also log to debug console
    debugPrint(prettyJson);

    // Optional: Show a snackbar with summary
    _showComparisonSummary(comparisonData);
  }

  Map<String, dynamic> _generateComparisonJSON(List<ProductSelection> selections) {
    final timestamp = DateTime.now().toIso8601String();
    final allComparisons = <Map<String, dynamic>>[];

    double grandTotalOriginal = 0;
    double grandTotalSelected = 0;
    int changedProducts = 0;

    for (final selection in selections) {
      // Find original requisition for this product
      final original = originalRequisitions.firstWhere(
            (req) => req.productName == selection.supplier.productName,
        orElse: () => selection.supplier,
      );

      // Generate comparison for this product
      final comparison = _generateProductComparison(original, selection);
      allComparisons.add(comparison);

      // Update totals
      final originalTotal = comparison['originalTotal'] as double;
      final selectedTotal = comparison['selectedTotal'] as double;

      grandTotalOriginal += originalTotal;
      grandTotalSelected += selectedTotal;

      if (comparison['hasChanges'] == true) {
        changedProducts++;
      }
    }

    final netDifference = grandTotalSelected - grandTotalOriginal;

    return {
      'metadata': {
        'timestamp': timestamp,
        'generatedBy': 'SupplierSelectionScreen',
        'totalProducts': selections.length,
        'changedProducts': changedProducts,
        'unchangedProducts': selections.length - changedProducts,
      },
      'financialSummary': {
        'grandTotalOriginal': grandTotalOriginal,
        'grandTotalSelected': grandTotalSelected,
        'netDifference': netDifference,
        'percentageChange': grandTotalOriginal > 0
            ? ((netDifference / grandTotalOriginal) * 100).toStringAsFixed(2)
            : '0.00',
        'totalSavings': netDifference < 0 ? netDifference.abs() : 0,
        'totalIncrease': netDifference > 0 ? netDifference : 0,
      },
      'comparisons': allComparisons,
      'summaryBySupplier': _generateSupplierSummary(allComparisons),
      'summaryByCategory': _generateCategorySummary(allComparisons),
    };
  }


  double _calculateTotal(CsRequisationModel model, int quantity) {
    final baseAmount = quantity * (model.rate ?? 0);
    final discountAmount = baseAmount * ((model.discount ?? 0) / 100);
    final csgAmount = model.csg ?? 0;
    final caringCost = model.caringCost ?? 0;
    final taxAmount = model.taxP ?? 0;
    final vatAmount = model.vatP ?? 0;
    final gateCost = model.gateCost ?? 0;

    return baseAmount - discountAmount + csgAmount + caringCost +
        taxAmount + vatAmount + gateCost;
  }

  void _addChangeIfDifferent(
      Map<String, dynamic> changes,
      String fieldName,
      dynamic originalValue,
      dynamic newValue,
      ) {
    if (originalValue != newValue) {
      changes[fieldName] = {
        'original': originalValue,
        'new': newValue,
        'changedAt': DateTime.now().toIso8601String(),
      };
    }
  }

  Map<String, dynamic> _generateCategorySummary(List<Map<String, dynamic>> comparisons) {
    final summary = <String, Map<String, dynamic>>{};

    for (final comp in comparisons) {
      final category = comp['category'] as String? ?? 'Uncategorized';
      final originalTotal = comp['originalTotal'] as double;
      final selectedTotal = comp['selectedTotal'] as double;

      if (!summary.containsKey(category)) {
        summary[category] = {
          'count': 0,
          'originalTotal': 0.0,
          'selectedTotal': 0.0,
          'difference': 0.0,
          'products': [],
        };
      }

      final data = summary[category]!;
      data['count'] = (data['count'] as int) + 1;
      data['originalTotal'] = (data['originalTotal'] as double) + originalTotal;
      data['selectedTotal'] = (data['selectedTotal'] as double) + selectedTotal;
      data['difference'] = (data['difference'] as double) + (selectedTotal - originalTotal);
      (data['products'] as List).add(comp['productName']);
    }

    return summary;
  }


  Map<String, dynamic> _generateSupplierSummary(List<Map<String, dynamic>> comparisons) {
    final summary = <String, Map<String, dynamic>>{};

    for (final comp in comparisons) {
      final supplier = comp['selectedSupplier']['name'] as String? ?? 'Unknown';
      final amount = comp['selectedTotal'] as double;

      if (!summary.containsKey(supplier)) {
        summary[supplier] = {
          'count': 0,
          'totalAmount': 0.0,
          'products': [],
          'averageAmount': 0.0,
        };
      }

      final data = summary[supplier]!;
      data['count'] = (data['count'] as int) + 1;
      data['totalAmount'] = (data['totalAmount'] as double) + amount;
      (data['products'] as List).add({
        'name': comp['productName'],
        'amount': amount,
        'quantity': comp['quantities']['selected'],
      });
    }

    // Calculate average
    for (final entry in summary.entries) {
      final data = entry.value;
      final count = data['count'] as int;
      final total = data['totalAmount'] as double;
      data['averageAmount'] = count > 0 ? total / count : 0;
    }

    return summary;
  }
  void _showComparisonSummary(Map<String, dynamic> comparisonData) {
    final metadata = comparisonData['metadata'] as Map<String, dynamic>;
    final financial = comparisonData['financialSummary'] as Map<String, dynamic>;

  }

  Map<String, dynamic> _generateProductComparison(
      CsRequisationModel original,
      ProductSelection selection,
      ) {
    // Calculate totals
    final originalTotal = _calculateTotal(original, original.csQty!.toInt() ?? 0);
    final selectedTotal = _calculateTotal(selection.supplier, selection.quantity);

    // Find all changes
    final changes = <String, Map<String, dynamic>>{};

    // Compare all fields
    _addChangeIfDifferent(changes, 'supplierName',
        original.supplierName, selection.supplier.supplierName);
    _addChangeIfDifferent(changes, 'supplierId',
        original.supplierId, selection.supplier.supplierId);
    _addChangeIfDifferent(changes, 'rate',
        original.rate, selection.supplier.rate);
    _addChangeIfDifferent(changes, 'quantity',
        original.csQty, selection.quantity);
    _addChangeIfDifferent(changes, 'discount',
        original.discount, selection.supplier.discount);
    _addChangeIfDifferent(changes, 'csg',
        original.csg, selection.supplier.csg);
    _addChangeIfDifferent(changes, 'tax',
        original.tax, selection.supplier.tax);
    _addChangeIfDifferent(changes, 'vat',
        original.vat, selection.supplier.vat);
    _addChangeIfDifferent(changes, 'taxP',
        original.taxP, selection.supplier.taxP);
    _addChangeIfDifferent(changes, 'vatP',
        original.vatP, selection.supplier.vatP);
    _addChangeIfDifferent(changes, 'caringCost',
        original.caringCost, selection.supplier.caringCost);
    _addChangeIfDifferent(changes, 'gateCost',
        original.gateCost, selection.supplier.gateCost);
    _addChangeIfDifferent(changes, 'warranty',
        original.warranty, selection.supplier.warranty);
    _addChangeIfDifferent(changes, 'creditPeriod',
        original.creditPeriod, selection.supplier.creditPeriod);
    _addChangeIfDifferent(changes, 'payMode',
        original.payMode, selection.supplier.payMode);

    return {
      'productId': original.productId,
      'productName': original.productName,
      'productCode': original.code,
      'category': original.productCategoryName,
      'brand': original.brandName,
      'uom': original.uomName,

      'originalSupplier': {
        'name': original.supplierName,
        'id': original.supplierId,
      },
      'selectedSupplier': {
        'name': selection.supplier.supplierName,
        'id': selection.supplier.supplierId,
      },

      'pricing': {
        'originalRate': original.rate,
        'selectedRate': selection.supplier.rate,
        'currency': original.currencyName,
        'originalDiscount': original.discount,
        'selectedDiscount': selection.supplier.discount,
      },

      'quantities': {
        'original': original.csQty,
        'selected': selection.quantity,
        'uom': original.uomName,
      },

      'totals': {
        'original': originalTotal,
        'selected': selectedTotal,
        'difference': selectedTotal - originalTotal,
        'currency': original.currencyName,
      },

      'changes': changes,
      'hasChanges': changes.isNotEmpty,
      'originalTotal': originalTotal,
      'selectedTotal': selectedTotal,
      'difference': selectedTotal - originalTotal,

      'notes': selection.notes,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }



}

// Helper Classes
class ProductSelection {
  final CsRequisationModel supplier;
  final int quantity;
  final String? notes;

  ProductSelection({
    required this.supplier,
    required this.quantity,
    this.notes,
  });

  ProductSelection copyWith({
    CsRequisationModel? supplier,
    int? quantity,
    String? notes,
  }) {
    return ProductSelection(
      supplier: supplier ?? this.supplier,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }
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

  @override
  String toString() {
    return 'ProductGroup{productName: $productName, suppliers: $suppliers, commonData: $commonData}';
  }





}



///none
///
///

// In _SupplierSelectionScreenState class
