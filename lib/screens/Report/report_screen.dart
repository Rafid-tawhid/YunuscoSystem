import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/inventory_provider.dart';

class ProductionStrengthScreen extends StatefulWidget {
  const ProductionStrengthScreen({Key? key}) : super(key: key);

  @override
  _ProductionStrengthScreenState createState() => _ProductionStrengthScreenState();
}

class _ProductionStrengthScreenState extends State<ProductionStrengthScreen> {
  String? _selectedSection;
  List<String> _sections = [];
  DateTime _selectedDate = DateTime.now();
  int _currentSectionIndex = 0;
  Timer? _sectionTimer;

  @override
  void initState() {
    super.initState();
    getProductionStrength();
    _setupSectionTimer();
  }

  @override
  void dispose() {
    _sectionTimer?.cancel();
    super.dispose();
  }

  void _setupSectionTimer() {
    _sectionTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted && _sections.isNotEmpty) {
        setState(() {
          _currentSectionIndex = (_currentSectionIndex + 1) % _sections.length;
          _selectedSection = _sections[_currentSectionIndex];
        });
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      await getProductionStrength();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Production Strength'),
        backgroundColor: Colors.blue[700],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: Consumer<InventoryPorvider>(
        builder: (context, pro, _) {
          if (pro.productionStrengthList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Filter data based on selected section
          final sectionData = pro.productionStrengthList
              .where((item) => item.sectionName == _selectedSection)
              .toList();

          // Calculate totals
          final totalPresent = sectionData.fold(0, (sum, item) => sum + (int.parse(item.present.toString())));
          final totalAbsent = sectionData.fold(0, (sum, item) => sum + (int.parse(item.absent.toString())));
          final totalStrength = sectionData.fold(0, (sum, item) => sum + (int.parse(item.strength.toString())));
          final overallAbsentPercent = totalStrength > 0 ? (totalAbsent / totalStrength * 100) : 0;

          return Column(
            children: [
              // Date display
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Data for ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),

              // Section slider
              Container(
                height: 60,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: PageView.builder(
                  itemCount: _sections.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentSectionIndex = index;
                      _selectedSection = _sections[index];
                    });
                    // Reset timer when user manually changes section
                    _sectionTimer?.cancel();
                    _setupSectionTimer();
                  },
                  itemBuilder: (context, index) {
                    return Center(
                      child: Text(
                        _sections[index],
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Section indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _sections.map((section) {
                  int index = _sections.indexOf(section);
                  return Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentSectionIndex == index
                          ? Colors.blue[700]
                          : Colors.grey[300],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Summary cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _SummaryCard(
                      title: 'Present',
                      value: totalPresent.toString(),
                      color: Colors.green,
                    ),
                    _SummaryCard(
                      title: 'Absent',
                      value: totalAbsent.toString(),
                      color: Colors.red,
                    ),
                    _SummaryCard(
                      title: 'Strength',
                      value: totalStrength.toString(),
                      color: Colors.blue,
                    ),
                    _SummaryCard(
                      title: 'Absent %',
                      value: '${overallAbsentPercent.toStringAsFixed(1)}%',
                      color: overallAbsentPercent > 10 ? Colors.orange : Colors.green,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Section title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      'Designations in $_selectedSection',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${sectionData.length} roles',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Data table
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView(
                    children: [
                      DataTable(
                        headingRowHeight: 50,
                        dataRowHeight: 40,
                        columnSpacing: 16,
                        columns: const [
                          DataColumn(
                            label: Text(
                              'Designation',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Present',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Text(
                              'Absent',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Text(
                              'Strength',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Text(
                              'Absent %',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            numeric: true,
                          ),
                        ],
                        rows: sectionData.map((item) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  item.designation ?? 'N/A',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                    '${item.present ?? 0}',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                    '${item.absent ?? 0}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: (item.absent ?? 0) > 0
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text('${item.strength ?? 0}'),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                    '${item.absentPercent?.toStringAsFixed(1) ?? '0.0'}%',
                                    style: TextStyle(
                                      color: (item.absentPercent ?? 0) > 10
                                          ? Colors.orange
                                          : Colors.green,
                                      fontWeight: (item.absentPercent ?? 0) > 10
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Future<void> getProductionStrength() async {
    var ip = context.read<InventoryPorvider>();
    await ip.getProductionStrengthInfo(_selectedDate);

    if (mounted) {
      setState(() {
        _sections = ip.productionStrengthList.map((e) => e.sectionName ?? '').toSet().toList();
        _sections.sort();
        if (_sections.isNotEmpty) {
          _selectedSection = _sections.first;
          _currentSectionIndex = 0;
        }
      });
    }
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _SummaryCard({
    Key? key,
    required this.title,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}