import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../models/production_efficiency_model.dart';
import '../../providers/product_provider.dart';

class ProductionEfficiencyScreen extends StatefulWidget {
  const ProductionEfficiencyScreen({super.key});

  @override
  State<ProductionEfficiencyScreen> createState() => _ProductionEfficiencyScreenState();
}

class _ProductionEfficiencyScreenState extends State<ProductionEfficiencyScreen> {
  DateTime? selectedDate;
  int? selectedBuyerId;
  int? selectedSectionId;
  int? selectedLineId;
  String? selectedStyleNo;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
   // _loadInitialData();
  }

  // Future<void> _loadInitialData() async {
  //   final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
  //   await context.read<ProductProvider>().getProductionEfficiencyReport(formattedDate);
  // }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      Future.microtask((){
        context.read<ProductProvider>().getProductionEfficiencyReport(formattedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final filteredList = provider.getFilteredList(
      buyerId: selectedBuyerId,
      sectionId: selectedSectionId,
      lineId: selectedLineId,
      styleNo: selectedStyleNo,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Production Efficiency Report'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [

          // Date Picker
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text(
              selectedDate == null
                  ? 'Select Date'
                  : DateFormat('dd MMM yyyy').format(selectedDate!),
            ),
            trailing: const Icon(Icons.arrow_drop_down),
            onTap: () => _selectDate(context),
          ),
          const Divider(),
          // Filter Section
          Consumer<ProductProvider>(
            builder: (context,pro,_)=>pro.isLoading?Center(child: CircularProgressIndicator(),):_buildFilterSection(context, provider),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text('Total : ${filteredList.length.toString()}'),
              )),
          // Data Section
          Expanded(
            child: filteredList.isEmpty
                ? const Center(child: Text('No data available'))
                : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final item = filteredList[index];
                return _buildEfficiencyCard(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context, ProductProvider provider) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            // Dropdown Filters
            const SizedBox(height: 8),
            // In your _buildFilterSection widget, replace the dropdown items with:

            // In your _buildFilterSection widget, replace the dropdown items with:
            Row(
              children: [
                Expanded(
                  child: _buildFilterDropdown<int>(
                    value: selectedBuyerId,
                    hint: 'All Buyers',
                    items: provider.buyerDropdownItems,
                    onChanged: (value) {
                      setState(() {
                        selectedBuyerId = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildFilterDropdown<int>(
                    value: selectedSectionId,
                    hint: 'All Sections',
                    items: provider.sectionDropdownItems,
                    onChanged: (value) {
                      setState(() {
                        selectedSectionId = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildFilterDropdown<int>(
                    value: selectedLineId,
                    hint: 'All Lines',
                    items: provider.lineDropdownItems,
                    onChanged: (value) {
                      setState(() {
                        selectedLineId = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildFilterDropdown<String>(
                    value: selectedStyleNo,
                    hint: 'All Styles',
                    items: provider.styleDropdownItems,
                    onChanged: (value) {
                      setState(() {
                        selectedStyleNo = value;
                      });
                    },
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildFilterDropdown<T>({
    required T? value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(hint),
          items: [
            DropdownMenuItem<T>(
              value: null,
              child: Text('All ${hint.substring(4)}'),
            ),
            ...items,
          ],
          onChanged: onChanged,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
        ),
      ),
    );
  }

  Widget _buildEfficiencyCard(ProductionEfficiencyModel item) {
    final efficiencyColor = _getEfficiencyColor(item.achievedEffiency ?? 0);

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.styleNo ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  backgroundColor: efficiencyColor,
                  label: Text(
                    '${item.achievedEffiency?.toStringAsFixed(1)}%',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Buyer: ${item.buyerName ?? 'N/A'}'),
            Text('Section: ${item.sectionName ?? 'N/A'}'),
            Text('Line: ${item.lineName ?? 'N/A'}'),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (item.achievedEffiency ?? 0) / 100,
              backgroundColor: Colors.grey[200],
              color: efficiencyColor,
              minHeight: 6,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetricTile('Target', '${item.dayTarget ?? 0}'),
                _buildMetricTile('Production', '${item.todaysProduction ?? 0}'),
                _buildMetricTile('Variance', '${item.variance ?? 0}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetricTile('SMV', '${item.smv ?? 0}'),
                _buildMetricTile('Capacity', '${item.capacity ?? 0}'),
                _buildMetricTile('Manpower', '${item.manpower ?? 0}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getEfficiencyColor(num efficiency) {
    if (efficiency >= 90) return Colors.green;
    if (efficiency >= 80) return Colors.lightGreen;
    if (efficiency >= 70) return Colors.orange;
    return Colors.red;
  }
}

