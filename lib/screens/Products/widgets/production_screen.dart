import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_month_year_picker/simple_month_year_picker.dart';
import 'package:yunusco_group/providers/product_provider.dart';
import 'package:yunusco_group/screens/Products/widgets/production_widget.dart';

import 'dept_chip.dart';

class ProductionSummaryScreen extends StatefulWidget {
  const ProductionSummaryScreen({super.key});

  @override
  _ProductionSummaryScreenState createState() => _ProductionSummaryScreenState();
}

class _ProductionSummaryScreenState extends State<ProductionSummaryScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedDepartment;

  final List<String> _departments = ['Printing', 'Molding', 'Sewing', 'Finishing'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Production Summary'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Date Selection Card
            Card(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Select Month & Year',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () async {
                        final selectedDate = await SimpleMonthYearPicker.showMonthYearPickerDialog(
                            context: context,
                            titleTextStyle: TextStyle(),
                            monthTextStyle: TextStyle(),
                            yearTextStyle: TextStyle(),
                            disableFuture: true // This will disable future years. It is false by default.
                            );
                        // Use the selected date as needed.
                        debugPrint("month :${selectedDate.month}");
                        debugPrint("year :" + selectedDate.year.toString());
                        debugPrint('Selected date: $selectedDate');
                        setState(() {
                          _selectedDate=selectedDate;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('MMMM yyyy').format(_selectedDate),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Department Selection
            const Text(
              'Select Department',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _departments.map((dept) {
                return DepartmentChip(
                  label: dept,
                  selected: _selectedDepartment == dept,
                  onSelected: (selected) {
                    setState(() {
                      _selectedDepartment = selected ? dept : null;
                    });
                    var pp = context.read<ProductProvider>();
                    debugPrint('_selectedDepartment ${_selectedDepartment}');
                    debugPrint('year ${_selectedDate.year}');
                    debugPrint('month ${_selectedDate.month}');
                    if (_selectedDepartment != null) {
                      pp.getProductionSummary(_selectedDate.month.toString(), _selectedDate.year.toString(), _selectedDepartment.toString());
                    }
                  },
                  color: Colors.purple.shade500,
                );
              }).toList(),
            ),

            // Display Data
            if (_selectedDepartment != null) ...[
              Consumer<ProductProvider>(
                  builder: (context, pro, _) => Expanded(
                      child: pro.isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : pro.productionSummaryList.isEmpty
                              ? Center(
                                  child: Text('No Data Found'),
                                )
                              : WeeklyProductionScreen()))
            ] else ...[
              const Center(
                child: Text(
                  'Please select a department to view data',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
