import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/inventory_provider.dart';
import 'package:yunusco_group/utils/colors.dart';

class InventoryStockScreen extends StatefulWidget {
  const InventoryStockScreen({super.key});

  @override
  State<InventoryStockScreen> createState() => _InventoryStockScreenState();
}

class _InventoryStockScreenState extends State<InventoryStockScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  String _selectedStoreType='4';

  @override
  void initState() {
    _loadData(_selectedDate,_selectedStoreType??'4');
    super.initState();
  }

  Future<void> _loadData(DateTime date,String storeType) async {
    setState(() => _isLoading = true);
    try {
      await context.read<InventoryPorvider>().getInventoryStockSummery(date,storeType);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading data: ${e.toString()}")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Inventory', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.indigo[800]!, myColors.primaryColor],
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            color: Colors.white,
            onSelected: (String value) {
              // Call your function with the selected store type
              handleStoreTypeSelection(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: '1', // StoreType value
                  child: Text('General Store'),
                ),
                PopupMenuItem<String>(
                  value: '2',
                  child: Text('Accessories Store'),
                ),
                PopupMenuItem<String>(
                  value: '3',
                  child: Text('Garments Store'),
                ),
                PopupMenuItem<String>(
                  value: '4',
                  child: Text('All'),
                ),
              ];
            },
            icon: Icon(Icons.filter_alt_outlined, color: Colors.white), // Using store icon
          ),
        ],
        //
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Consumer<InventoryPorvider>(
          builder: (context, provider, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Selected date display
              Center(
                  child: InkWell(
                    onTap: (){
                      _selectDate(context);
                    },
                  child: Text(
                    DashboardHelpers.convertDateTime(
                        _selectedDate.toString(),
                        pattern: 'dd-MMM-yyyy'
                    ),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[800],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              _buildStockMovementChart(provider),
              SizedBox(height: 24),
              _buildInventoryTable(provider),
            ],
          ),
        ),
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
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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
          SizedBox(height: 12),
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
                Text(DashboardHelpers.convertDateTime(
                    _selectedDate.toString(),
                    pattern: 'dd-MMM-yyyy'
                ))
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
                              (item.balanceValue ?? 0).toStringAsFixed(2),
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


  void _exportData(BuildContext context) {
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.indigo[800]!,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.indigo[800],
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
      _loadData(picked,_selectedStoreType??'');
    }
  }

  // Function to handle selection
  void handleStoreTypeSelection(String storeType) {
    // Here you can call your API or perform any action
    print('Selected store type: $storeType');
    setState(() {
      _selectedStoreType=storeType;
    });
    _loadData(_selectedDate,storeType);
  }

// Helper function to get store name
  String getStoreName(String type) {
    switch (type) {
      case '1': return 'General Store';
      case '2': return 'Accessories Store';
      case '3': return 'Garments Store';
      default: return '4';
    }
  }
}