import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/inventory_provider.dart';
import 'package:flutter/material.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../models/inventory_stock_model.dart';

class InventoryStockScreen extends StatefulWidget {


  const InventoryStockScreen({
    Key? key,}) : super(key: key);

  @override
  State<InventoryStockScreen> createState() => _InventoryStockScreenState();
}

class _InventoryStockScreenState extends State<InventoryStockScreen> {

  @override
  void initState() {
    var ip=context.read<InventoryPorvider>();
    ip.getInventoryStockSummery();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Inventory', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.indigo[800]!,myColors.primaryColor],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt, color: Colors.white),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Consumer<InventoryPorvider>(builder: (context,provider,_)=>Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStockMovementChart(provider),
            SizedBox(height: 24),
            _buildInventoryTable(provider),
          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: Icon(Icons.download, color: Colors.white),
        onPressed: () => _exportData(context),
      ),
    );
  }

  Widget _buildSummaryCards(InventoryPorvider pro) {
    final totalIn = pro.inventoryStockList.fold<double>(
        0, (sum, item) => sum + (item.goodsINQty ?? 0));
    final totalOut = pro.inventoryStockList.fold<double>(
        0, (sum, item) => sum + (item.goodsOutQty ?? 0));
    final totalBalance = pro.inventoryStockList.fold<double>(
        0, (sum, item) => sum + (item.balanceQty ?? 0));

    return Row(
      children: [
        _buildSummaryCard(
          title: "Total In",
          value: totalIn.toStringAsFixed(0),
          icon: Icons.input,
          color: Colors.green,
        ),
        SizedBox(width: 12),
        _buildSummaryCard(
          title: "Total Out",
          value: totalOut.toStringAsFixed(0),
          icon: Icons.output,
          color: Colors.red,
        ),
        SizedBox(width: 12),
        _buildSummaryCard(
          title: "Current",
          value: totalBalance.toStringAsFixed(0),
          icon: Icons.inventory,
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        elevation: 3,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockMovementChart(InventoryPorvider pro) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Stock Movement",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 12,),
          _buildSummaryCards(pro),
        ],
      ),
    );
  }

  Widget _buildInventoryTable(InventoryPorvider pro) {
    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Inventory Details",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Text(DashboardHelpers.convertDateTime(DateTime.now().toString(),pattern: 'dd-MMM-yyyy'))
              ],
            ),
            SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey[200]!),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 16,
                      horizontalMargin: 8,
                      headingRowHeight: 36,
                      dataRowHeight: 40,
                      headingTextStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[800],
                      ),
                      dataTextStyle: TextStyle(
                        fontSize: 12,
                      ),
                      columns: [
                        DataColumn(label: _buildHeader("Store")),
                        DataColumn(label: _buildHeader("Currency"), numeric: true),
                        DataColumn(label: _buildHeader("In"), numeric: true),
                        DataColumn(label: _buildHeader("Out"), numeric: true),
                        DataColumn(label: _buildHeader("Balance"), numeric: true),
                        DataColumn(label: _buildHeader("Value"), numeric: true),
                      ],
                      rows: pro.inventoryStockList.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(Text(
                              item.storeType?.replaceAll("Store", "").trim() ?? '--',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )),
                            DataCell(Text(item.currency ?? '-')),
                            DataCell(Text(
                              (item.goodsINQty ?? 0).toStringAsFixed(0),
                              style: TextStyle(
                                color: Colors.green[700],
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                            DataCell(Text(
                              (item.goodsOutQty ?? 0).toStringAsFixed(0),
                              style: TextStyle(
                                color: Colors.red[700],
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                            DataCell(Text(
                              (item.balanceQty ?? 0).toStringAsFixed(0),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            )),
                            DataCell(Text(
                              '${(item.balanceValue ?? 0).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            )),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Filter Inventory"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add your filter options here
            Text("Filter options coming soon!"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("CANCEL"),
          ),
          ElevatedButton(
            onPressed: () {
              // Apply filters
              Navigator.pop(context);
            },
            child: Text("APPLY"),
          ),
        ],
      ),
    );
  }

  void _exportData(BuildContext context) {
    // Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Exporting inventory data...")),
    );
  }

  Widget _buildHeader(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}