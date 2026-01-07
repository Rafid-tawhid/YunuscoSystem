import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../../models/shipment_breakdown_model.dart';
import '../../providers/riverpods/management_provider.dart';

class ShipmentBreakdownDashboard extends ConsumerStatefulWidget {
  const ShipmentBreakdownDashboard({Key? key}) : super(key: key);

  @override
  ConsumerState<ShipmentBreakdownDashboard> createState() =>
      _ShipmentBreakdownDashboardState();
}

class _ShipmentBreakdownDashboardState
    extends ConsumerState<ShipmentBreakdownDashboard> {
  String _selectedBuyer = 'All';
  String _selectedMonth = 'All';
  List<String> _buyerList = [];
  List<String> _monthList = [];

  @override
  Widget build(BuildContext context) {
    final shipmentAsyncValue = ref.watch(shipmentBreakdownInfo);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Shipment Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue[800],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              _showFilterDialog(context);
            },
            tooltip: 'Filter',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              _exportData();
            },
            tooltip: 'Export',
          ),
        ],
      ),
      body: shipmentAsyncValue.when(
        data: (shipments) {
          if (shipments.isEmpty) {
            return _buildEmptyState();
          }

          // Process data for filters and charts
          _processData(shipments);
          final filteredShipments = _filterShipments(shipments);

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(shipmentBreakdownInfo);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Summary Cards
                  _buildSummaryCards(filteredShipments),

                  // Charts Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _buildMonthlyChart(shipments),
                        const SizedBox(height: 20),
                        _buildBuyerWiseChart(shipments),
                        const SizedBox(height: 20),
                        _buildStyleWiseChart(shipments),
                      ],
                    ),
                  ),

                  // Shipment List
                  _buildShipmentList(filteredShipments),
                ],
              ),
            ),
          );
        },
        loading: () => _buildLoadingState(),
        error: (error, stackTrace) => _buildErrorState(error),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.invalidate(shipmentBreakdownInfo);
        },
        backgroundColor: Colors.blue[800],
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  void _processData(List<ShipmentBreakdownModel> shipments) {
    if (_buyerList.isEmpty) {
      final buyers = shipments.map((s) => s.buyerName ?? 'Unknown').toSet().toList();
      _buyerList = ['All', ...buyers];
    }

    if (_monthList.isEmpty) {
      final months = shipments.map((s) {
        if (s.shipmentDate != null) {
          final date = DateTime.tryParse(s.shipmentDate!);
          if (date != null) {
            return DateFormat('MMM yyyy').format(date);
          }
        }
        return 'Unknown';
      }).toSet().toList();
      _monthList = ['All', ...months];
    }
  }

  List<ShipmentBreakdownModel> _filterShipments(List<ShipmentBreakdownModel> shipments) {
    return shipments.where((shipment) {
      final buyerMatch = _selectedBuyer == 'All' ||
          shipment.buyerName == _selectedBuyer;

      final monthMatch = _selectedMonth == 'All' ||
          (shipment.shipmentDate != null &&
              _getMonthYear(shipment.shipmentDate!) == _selectedMonth);

      return buyerMatch && monthMatch;
    }).toList();
  }

  String _getMonthYear(String dateString) {
    final date = DateTime.tryParse(dateString);
    if (date != null) {
      return DateFormat('MMM yyyy').format(date);
    }
    return 'Unknown';
  }

  Widget _buildSummaryCards(List<ShipmentBreakdownModel> shipments) {
    final totalQuantity = shipments.fold<int>(
      0,
          (sum, shipment) => sum + (shipment.shipmentQuantity?.toInt() ?? 0),
    );

    final totalValue = shipments.fold<double>(
      0,
          (sum, shipment) => sum + (shipment.shipmentQuantity?.toDouble() ?? 0) * 100,
    ); // Assuming 100 per unit for demo

    final uniqueStyles = shipments.map((s) => s.style).toSet().length;
    final uniqueBuyers = shipments.map((s) => s.buyerName).toSet().length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shipment Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              if (_selectedBuyer != 'All' || _selectedMonth != 'All')
                Chip(
                  label: Text('${shipments.length} items'),
                  backgroundColor: Colors.blue[50],
                ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildSummaryCard(
                'Total Quantity',
                '$totalQuantity',
                Icons.inventory,
                Colors.blue,
              ),
              _buildSummaryCard(
                'Total Value',
                '\$${totalValue.toStringAsFixed(0)}',
                Icons.attach_money,
                Colors.green,
              ),
              _buildSummaryCard(
                'Unique Styles',
                '$uniqueStyles',
                Icons.style,
                Colors.purple,
              ),
              _buildSummaryCard(
                'Buyers',
                '$uniqueBuyers',
                Icons.group,
                Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 24),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyChart(List<ShipmentBreakdownModel> shipments) {
    // Group by month
    final monthlyData = <String, double>{};
    for (final shipment in shipments) {
      if (shipment.shipmentDate != null && shipment.shipmentQuantity != null) {
        final monthYear = _getMonthYear(shipment.shipmentDate!);
        monthlyData[monthYear] =
            (monthlyData[monthYear] ?? 0) + shipment.shipmentQuantity!.toDouble();
      }
    }

    final chartData = monthlyData.entries
        .map((e) => ChartData(e.key, e.value))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly Shipment Quantity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                labelRotation: -45,
                labelStyle: const TextStyle(fontSize: 10),
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(text: 'Quantity'),
                numberFormat: NumberFormat.compact(),
              ),
              series: <CartesianSeries>[
                ColumnSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  color: Colors.blue,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.top,
                  ),
                ),
              ],
              tooltipBehavior: TooltipBehavior(enable: true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyerWiseChart(List<ShipmentBreakdownModel> shipments) {
    final buyerData = <String, double>{};
    for (final shipment in shipments) {
      if (shipment.buyerName != null && shipment.shipmentQuantity != null) {
        buyerData[shipment.buyerName!] =
            (buyerData[shipment.buyerName!] ?? 0) + shipment.shipmentQuantity!.toDouble();
      }
    }

    final chartData = buyerData.entries
        .map((e) => ChartData(e.key, e.value))
        .toList()
      ..sort((b, a) => a.y.compareTo(b.y))
      ..take(10); // Top 10 buyers

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Buyers',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: SfCircularChart(
              legend: Legend(
                isVisible: true,
                overflowMode: LegendItemOverflowMode.wrap,
              ),
              series: <CircularSeries>[
                PieSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                  ),
                  explode: true,
                  explodeIndex: 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyleWiseChart(List<ShipmentBreakdownModel> shipments) {
    final styleData = <String, double>{};
    for (final shipment in shipments) {
      if (shipment.style != null && shipment.shipmentQuantity != null) {
        styleData[shipment.style!] =
            (styleData[shipment.style!] ?? 0) + shipment.shipmentQuantity!.toDouble();
      }
    }

    final chartData = styleData.entries
        .map((e) => ChartData(e.key, e.value))
        .toList()
      ..sort((b, a) => a.y.compareTo(b.y))
      ..take(8); // Top 8 styles

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Styles',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                labelRotation: -45,
                labelStyle: const TextStyle(fontSize: 10),
              ),
              series: <CartesianSeries>[
                BarSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  color: Colors.purple,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShipmentList(List<ShipmentBreakdownModel> shipments) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shipment Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                Chip(
                  label: Text('${shipments.length} shipments'),
                  backgroundColor: Colors.blue[50],
                ),
              ],
            ),
          ),
          ...shipments.map((shipment) => _buildShipmentCard(shipment)),
        ],
      ),
    );
  }

  Widget _buildShipmentCard(ShipmentBreakdownModel shipment) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Color indicator
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: _getColorFromString(shipment.style ?? ''),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      shipment.masterOrderCode ?? 'N/A',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Qty: ${shipment.shipmentQuantity ?? 0}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  shipment.buyerName ?? 'Unknown Buyer',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _buildInfoChip('Style: ${shipment.style ?? 'N/A'}'),
                    _buildInfoChip('Color: ${shipment.colorName ?? 'N/A'}'),
                    _buildInfoChip('Size: ${shipment.sizeName ?? 'N/A'}'),
                    if (shipment.shipmentDate != null)
                      _buildInfoChip(
                        'Date: ${DateFormat('dd MMM yyyy').format(DateTime.parse(shipment.shipmentDate!))}',
                      ),
                    if (shipment.buyerPoNumber != null)
                      _buildInfoChip('PO: ${shipment.buyerPoNumber}'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Color _getColorFromString(String input) {
    int hash = 0;
    for (int i = 0; i < input.length; i++) {
      hash = input.codeUnitAt(i) + ((hash << 5) - hash);
    }
    return HSLColor.fromAHSL(
      1,
      hash % 360,
      0.7,
      0.6,
    ).toColor();
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Filter Shipments'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedBuyer,
                    decoration: const InputDecoration(
                      labelText: 'Buyer',
                      border: OutlineInputBorder(),
                    ),
                    items: _buyerList.map((buyer) {
                      return DropdownMenuItem(
                        value: buyer,
                        child: Text(buyer),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBuyer = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedMonth,
                    decoration: const InputDecoration(
                      labelText: 'Month',
                      border: OutlineInputBorder(),
                    ),
                    items: _monthList.map((month) {
                      return DropdownMenuItem(
                        value: month,
                        child: Text(month),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMonth = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedBuyer = 'All';
                      _selectedMonth = 'All';
                    });
                  },
                  child: const Text('Clear All'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _exportData() {
    // Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export functionality to be implemented'),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[800]!),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading shipment data...',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to load data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(shipmentBreakdownInfo);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No shipment data available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add shipments to see data here',
            style: TextStyle(color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ref.invalidate(shipmentBreakdownInfo);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}