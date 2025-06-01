import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String _selectedReportType = 'Production';
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );
  String _selectedDepartment = 'All';

  final List<String> _reportTypes = [
    'Production',
    'Inventory',
    'Quality',
    'Finance',
    'Attendance',
    'Shipment'
  ];

  final List<String> _departments = [
    'All',
    'Cutting',
    'Sewing',
    'Finishing',
    'Quality Control',
    'Warehouse'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garments Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _exportToPDF,
            tooltip: 'Export to PDF',
          ),
        ],
      ),
      body: Column(
        children: [
          // Report type selector
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: _selectedReportType,
              items: _reportTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedReportType = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Report Type',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // Filter controls
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(
                      '${DateFormat('dd/MM/yyyy').format(_dateRange.start)} - '
                          '${DateFormat('dd/MM/yyyy').format(_dateRange.end)}',
                    ),
                    onPressed: _selectDateRange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedDepartment,
                    items: _departments.map((dept) {
                      return DropdownMenuItem(
                        value: dept,
                        child: Text(dept),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDepartment = value!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Department',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Report content area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildReportContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportContent() {
    switch (_selectedReportType) {
      case 'Production':
        return _buildProductionReport();
      case 'Inventory':
        return _buildInventoryReport();
      case 'Quality':
        return _buildQualityReport();
      case 'Finance':
        return _buildFinanceReport();
      case 'Attendance':
        return _buildAttendanceReport();
      case 'Shipment':
        return _buildShipmentReport();
      default:
        return const Center(child: Text('Select a report type'));
    }
  }


  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: _dateRange,
    );
    if (picked != null) {
      setState(() {
        _dateRange = picked;
      });
    }
  }

  void _exportToPDF() {
    // Implement PDF export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting to PDF...')),
    );
  }

  // Similar methods for other report types (_buildFinanceReport, etc.)
  Widget _buildFinanceReport() {
    return const Center(child: Text('Finance Report Content'));
  }

  Widget _buildAttendanceReport() {
    return const Center(child: Text('Attendance Report Content'));
  }

  Widget _buildShipmentReport() {
    return const Center(child: Text('Shipment Report Content'));
  }

  Widget _buildProductionReport() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Production Report',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          DataTable(
            columns: const [
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Line'), numeric: true),
              DataColumn(label: Text('Style'), numeric: true),
              DataColumn(label: Text('Target'), numeric: true),
              DataColumn(label: Text('Output'), numeric: true),
              DataColumn(label: Text('Efficiency %'), numeric: true),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('01 Jun')),
                DataCell(Text('Line 1')),
                DataCell(Text('S-102')),
                DataCell(Text('1200')),
                DataCell(Text('1150')),
                DataCell(Text('95.8')),
              ]),
              DataRow(cells: [
                DataCell(Text('01 Jun')),
                DataCell(Text('Line 2')),
                DataCell(Text('S-105')),
                DataCell(Text('1200')),
                DataCell(Text('1250')),
                DataCell(Text('104.2')),
              ]),
              DataRow(cells: [
                DataCell(Text('02 Jun')),
                DataCell(Text('Line 1')),
                DataCell(Text('S-102')),
                DataCell(Text('1200')),
                DataCell(Text('1100')),
                DataCell(Text('91.7')),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryReport() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Inventory Report',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          DataTable(
            columns: const [
              DataColumn(label: Text('Item Code')),
              DataColumn(label: Text('Description')),
              DataColumn(label: Text('UOM')),
              DataColumn(label: Text('Current Stock'), numeric: true),
              DataColumn(label: Text('Reorder Level'), numeric: true),
              DataColumn(label: Text('Status')),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('FAB-1001')),
                DataCell(Text('Cotton Fabric')),
                DataCell(Text('Meter')),
                DataCell(Text('4500')),
                DataCell(Text('2000')),
                DataCell(Text('In Stock', style: TextStyle(color: Colors.green))),
              ]),
              DataRow(cells: [
                DataCell(Text('THR-2002')),
                DataCell(Text('Polyester Thread')),
                DataCell(Text('Cones')),
                DataCell(Text('150')),
                DataCell(Text('200')),
                DataCell(Text('Low Stock', style: TextStyle(color: Colors.orange))),
              ]),
              DataRow(cells: [
                DataCell(Text('BTN-3005')),
                DataCell(Text('Plastic Buttons')),
                DataCell(Text('Pcs')),
                DataCell(Text('5000')),
                DataCell(Text('3000')),
                DataCell(Text('In Stock', style: TextStyle(color: Colors.green))),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQualityReport() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Quality Inspection Report',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          DataTable(
            columns: const [
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Batch No')),
              DataColumn(label: Text('Style')),
              DataColumn(label: Text('Inspected'), numeric: true),
              DataColumn(label: Text('Defects'), numeric: true),
              DataColumn(label: Text('Defect %'), numeric: true),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('01 Jun')),
                DataCell(Text('B-2023-06-01')),
                DataCell(Text('S-102')),
                DataCell(Text('500')),
                DataCell(Text('25')),
                DataCell(Text('5.0')),
              ]),
              DataRow(cells: [
                DataCell(Text('02 Jun')),
                DataCell(Text('B-2023-06-02')),
                DataCell(Text('S-105')),
                DataCell(Text('600')),
                DataCell(Text('18')),
                DataCell(Text('3.0')),
              ]),
              DataRow(cells: [
                DataCell(Text('03 Jun')),
                DataCell(Text('B-2023-06-03')),
                DataCell(Text('S-108')),
                DataCell(Text('450')),
                DataCell(Text('30')),
                DataCell(Text('6.7')),
              ]),
            ],
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Defect Breakdown',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          DataTable(
            columns: const [
              DataColumn(label: Text('Defect Type')),
              DataColumn(label: Text('Count'), numeric: true),
              DataColumn(label: Text('Percentage'), numeric: true),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('Stitching Error')),
                DataCell(Text('25')),
                DataCell(Text('45%')),
              ]),
              DataRow(cells: [
                DataCell(Text('Fabric Defect')),
                DataCell(Text('12')),
                DataCell(Text('22%')),
              ]),
              DataRow(cells: [
                DataCell(Text('Measurement Issue')),
                DataCell(Text('8')),
                DataCell(Text('15%')),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}