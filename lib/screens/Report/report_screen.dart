import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/inventory_provider.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../models/production_strength_model.dart';

class ProductionStrengthScreen extends StatefulWidget {
  const ProductionStrengthScreen({Key? key}) : super(key: key);

  @override
  _ProductionStrengthScreenState createState() => _ProductionStrengthScreenState();
}

class _ProductionStrengthScreenState extends State<ProductionStrengthScreen> {
  DateTime _selectedDate = DateTime.now();
  int _currentSectionIndex = 0;
  Timer? _sectionTimer;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    getProductionStrength();
    // _setupSectionTimer();
  }

  @override
  void dispose() {
    _sectionTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _setupSectionTimer() {
    _sectionTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted && context.read<InventoryPorvider>().productionStrengthList.isNotEmpty) {
        final sections = _getSections();
        if (sections.isNotEmpty) {
          final nextIndex = (_currentSectionIndex + 1) % sections.length;
          _pageController.animateToPage(
            nextIndex,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
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

  List<String> _getSections() {
    final ip = context.read<InventoryPorvider>();
    return ip.productionStrengthList.map((e) => e.sectionName ?? '').toSet().toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Production Strength Dashboard',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: myColors.primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
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

          final sections = _getSections();

          return Column(
            children: [
              // Date display
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Data for ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),

              // Section slides with navigation
              Expanded(
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: sections.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentSectionIndex = index;
                        });
                        // Reset timer when user manually changes section
                        _sectionTimer?.cancel();
                        //_setupSectionTimer();
                      },
                      itemBuilder: (context, index) {
                        return _SectionSlide(
                          sectionName: sections[index],
                          data: pro.productionStrengthList.where((item) => item.sectionName == sections[index]).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Section indicators
              if (sections.length > 1)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: Row(children: [
                    // Left navigation arrow
                    IconButton(
                      iconSize: 22,
                      padding: EdgeInsets.all(12),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        shape: CircleBorder(),
                      ),
                      icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                      onPressed: _currentSectionIndex > 0
                          ? () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            }
                          : null,
                    ),

                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: sections.map((section) {
                        int index = sections.indexOf(section);
                        return Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentSectionIndex == index ? Colors.blue[700] : Colors.grey[300],
                          ),
                        );
                      }).toList(),
                    )),

                    // Right navigation arrow
                    IconButton(
                      iconSize: 22,
                      padding: EdgeInsets.all(12),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        shape: CircleBorder(),
                      ),
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: _currentSectionIndex < sections.length - 1
                          ? () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            }
                          : null,
                    )
                  ]),
                ),

              SizedBox(
                height: 12,
              )
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
        _currentSectionIndex = 0;
        _pageController.jumpToPage(0);
      });
    }
  }
}

class _SectionSlide extends StatelessWidget {
  final String sectionName;
  final List<ProductionStrengthModel> data;

  const _SectionSlide({
    Key? key,
    required this.sectionName,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate totals
    final totalPresent = data.fold(0, (sum, item) => sum + (int.parse(item.present.toString())));
    final totalAbsent = data.fold(0, (sum, item) => sum + (int.parse(item.absent.toString())));
    final totalStrength = data.fold(0, (sum, item) => sum + (int.parse(item.present.toString())));
    final overallAbsentPercent = totalStrength > 0 ? (totalAbsent / totalStrength * 100) : 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: myColors.primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Center(
              child: Text(
                sectionName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Summary cards
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    title: 'Present',
                    value: totalPresent.toString(),
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _SummaryCard(
                    title: 'Absent',
                    value: totalAbsent.toString(),
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _SummaryCard(
                    title: 'Strength',
                    value: totalStrength.toString(),
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _SummaryCard(
                    title: 'Absent %',
                    value: '${overallAbsentPercent.toStringAsFixed(1)}%',
                    color: overallAbsentPercent > 10 ? Colors.orange : Colors.green,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Data table title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                const Text(
                  'Designations',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${data.length} roles',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Data table
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  DataTable(columns: [
                    DataColumn(
                      label: Text(
                        'Role',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Pre',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Abs',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Str',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'A%',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      numeric: true,
                    ),
                  ], rows: []),
                  Expanded(
                    child: Scrollbar(
                      child: ListView(
                        children: [
                          DataTable(
                            dataRowHeight: 36,
                            columnSpacing: 12,
                            columns: const [
                              DataColumn(label: SizedBox.shrink()),
                              DataColumn(label: SizedBox.shrink(), numeric: true),
                              DataColumn(label: SizedBox.shrink(), numeric: true),
                              DataColumn(label: SizedBox.shrink(), numeric: true),
                              DataColumn(label: SizedBox.shrink(), numeric: true),
                            ],
                            rows: data.map((item) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      item.designation ?? 'N/A',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        '${item.present ?? 0}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        '${item.absent ?? 0}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: (item.absent ?? 0) > 0 ? Colors.red : Colors.black,
                                          fontWeight: (item.absent ?? 0) > 0 ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        '${item.strength ?? 0}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        '${item.absentPercent?.toStringAsFixed(1) ?? '0.0'}%',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: (item.absentPercent ?? 0) > 10 ? Colors.orange : Colors.green,
                                          fontWeight: (item.absentPercent ?? 0) > 10 ? FontWeight.bold : FontWeight.normal,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
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
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
