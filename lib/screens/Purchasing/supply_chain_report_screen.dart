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
  List<RequisitionSupplierSummary> _requisitionSummaries = [];
  bool _isLoading = true;
  String _selectedFilter = 'all';

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
      var pp = context.read<PurchaseProvider>();
      List<SupplyChainRecord> records = await pp.getAllSupplyChainRecords();


      // Group records by requisition ID
      final Map<String, List<SupplyChainRecord>> groupedRecords = {};

      for (var record in records) {
        if (!groupedRecords.containsKey(record.reqId)) {
          groupedRecords[record.reqId] = [];
        }
        groupedRecords[record.reqId]!.add(record);
      }

      // Convert to RequisitionSupplierSummary
      List<RequisitionSupplierSummary> summaries = [];

      groupedRecords.forEach((reqId, records) {
        List<ProductSupplierSelection> productSelections = [];

        for (var record in records) {
          productSelections.add(ProductSupplierSelection(
            productId: record.productId.toString(),
            productName: record.productName,
            requiredQty: int.parse(record.requiredQty.toString()),
            unitName: record.unitName,
            suppliers: record.supplierQuotes,
          ));
        }

        summaries.add(RequisitionSupplierSummary(
          reqId: reqId,
          createdAt: records.first.createdAt,
          productSelections: productSelections,
          status: records.first.status,
        ));
      });

      // Sort by date
      summaries.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      setState(() {
        _requisitionSummaries = summaries;
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

  void _onSupplierSelected(String reqId, String productId, String supplierId) {
    setState(() {
      final requisition = _requisitionSummaries.firstWhere((r) => r.reqId == reqId);
      final product = requisition.productSelections.firstWhere((p) => p.productId == productId);
      product.selectedSupplierId = supplierId;
    });
  }

  void _generatePurchaseOrder(RequisitionSupplierSummary summary) {
    // Show summary of selected suppliers
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Purchase Order Summary - Req #${summary.reqId.substring(summary.reqId.length - 6)}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Selected Suppliers:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              ...summary.productSelections.map((product) => Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('📦 ${product.productName}', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('   Supplier: ${product.selectedSupplier?.supplierName ?? "No supplier"}'),
                    Text('   Rate: ${product.selectedSupplier?.currency} ${product.selectedSupplier?.unitRate}'),
                    Text('   Qty: ${product.requiredQty} ${product.unitName}'),
                    Divider(),
                  ],
                ),
              )),
              SizedBox(height: 10),
              Text('Total Estimated Cost: ${summary.totalCost.toStringAsFixed(2)} BDT',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Save purchase order logic here
              _savePurchaseOrder(summary);
              Navigator.pop(context);
            },
            child: Text('Confirm Purchase Order'),
          ),
        ],
      ),
    );
  }

  void _savePurchaseOrder(RequisitionSupplierSummary summary) {
    // Implement your purchase order saving logic here
    print('Saving purchase order for requisition: ${summary.reqId}');
    // You can save to Firebase or navigate to another screen

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Purchase order generated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supply Chain Records'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _requisitionSummaries.isEmpty
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
          itemCount: _requisitionSummaries.length,
          itemBuilder: (context, index) {
            final summary = _requisitionSummaries[index];
            return RequisitionSummaryCard(
              summary: summary,
              onSupplierSelected: _onSupplierSelected,
              onGeneratePO: _generatePurchaseOrder,
            );
          },
        ),
      ),
    );
  }
}

class RequisitionSummaryCard extends StatelessWidget {
  final RequisitionSupplierSummary summary;
  final Function(String, String, String) onSupplierSelected;
  final Function(RequisitionSupplierSummary) onGeneratePO;

  const RequisitionSummaryCard({
    Key? key,
    required this.summary,
    required this.onSupplierSelected,
    required this.onGeneratePO,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      elevation: 4,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(summary.status),
          child: Icon(Icons.inventory, color: Colors.white, size: 20),
        ),
        title: Text(
          'Requisition #${summary.reqId.substring(summary.reqId.length - 6)}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Products: ${summary.productSelections.length}'),
            Text('Suppliers: ${_getTotalSuppliers(summary)}'),
            Text('Total Cost: BDT ${summary.totalCost.toStringAsFixed(2)}'),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => onGeneratePO(summary),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: Text('Generate PO'),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: summary.productSelections.map((product) =>
                  ProductSupplierCard(
                    product: product,
                    reqId: summary.reqId,
                    onSupplierSelected: onSupplierSelected,
                  )
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  int _getTotalSuppliers(RequisitionSupplierSummary summary) {
    return summary.productSelections.fold(0, (sum, product) => sum + product.suppliers.length);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed': return Colors.green;
      case 'pending': return Colors.orange;
      default: return Colors.grey;
    }
  }
}

class ProductSupplierCard extends StatelessWidget {
  final ProductSupplierSelection product;
  final String reqId;
  final Function(String, String, String) onSupplierSelected;

  const ProductSupplierCard({
    Key? key,
    required this.product,
    required this.reqId,
    required this.onSupplierSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      color: Colors.grey[50],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Header
            Row(
              children: [
                Icon(Icons.shopping_cart, color: Colors.blue),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    product.productName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  'Qty: ${product.requiredQty} ${product.unitName}',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Supplier Selection
            Text('Select Supplier:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),

            ...product.suppliers.map((supplier) => SupplierSelectionTile(
              supplier: supplier,
              isSelected: product.selectedSupplierId == supplier.supplierId,
              onTap: () => onSupplierSelected(reqId, product.productId, supplier.supplierId),
              requiredQty: product.requiredQty,
            )).toList(),
          ],
        ),
      ),
    );
  }
}

class SupplierSelectionTile extends StatelessWidget {
  final SupplierQuote supplier;
  final bool isSelected;
  final VoidCallback onTap;
  final int requiredQty;

  const SupplierSelectionTile({
    Key? key,
    required this.supplier,
    required this.isSelected,
    required this.onTap,
    required this.requiredQty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subtotal = supplier.unitRate * requiredQty;
    final totalCost = subtotal +
        (subtotal * (supplier.taxRate / 100)) +
        (subtotal * (supplier.vatRate / 100)) +
        supplier.carryingCost +
        supplier.otherCost -
        (subtotal * (supplier.discount / 100));

    return Card(
      margin: EdgeInsets.only(bottom: 8),
      color: isSelected ? Colors.blue[50] : Colors.white,
      elevation: isSelected ? 2 : 1,
      child: ListTile(
        leading: Radio(
          value: true,
          groupValue: isSelected,
          onChanged: (value) => onTap(),
        ),
        title: Text(
          supplier.supplierName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.blue : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Unit Rate: ${supplier.currency} ${supplier.unitRate}'),
            Text('Total: ${supplier.currency} ${totalCost.toStringAsFixed(2)}'),
            if (supplier.warranty.isNotEmpty) Text('Warranty: ${supplier.warranty}'),
            Wrap(
              spacing: 6,
              children: [
                if (supplier.taxRate > 0) Chip(label: Text('Tax: ${supplier.taxRate}%', style: TextStyle(fontSize: 10))),
                if (supplier.vatRate > 0) Chip(label: Text('VAT: ${supplier.vatRate}%', style: TextStyle(fontSize: 10))),
                if (supplier.discount > 0) Chip(label: Text('Discount: ${supplier.discount}%', style: TextStyle(fontSize: 10))),
              ],
            ),
          ],
        ),
        trailing: isSelected ? Icon(Icons.check_circle, color: Colors.green) : null,
        onTap: onTap,
      ),
    );
  }
}