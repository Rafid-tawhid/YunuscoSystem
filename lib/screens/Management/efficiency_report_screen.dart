import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../models/item_efficiency_model.dart';
import '../../providers/riverpods/management_provider.dart';

class EfficiencyScreen extends ConsumerWidget {
  const EfficiencyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(selectedDateProvider);
    final efficiencyAsync = ref.watch(efficiencyDataProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          '📊 Item Efficiency',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue.shade700,
        shadowColor: Colors.black12,
      ),
      body: efficiencyAsync.when(
        data: (items) => _buildContent(context, ref, date, items),
        loading: () => _buildLoading(),
        error: (error, stack) => _buildError(context, ref, error),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, String date, List<ItemEfficiencyModel> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Enhanced Date Picker Field
            _buildDatePicker(context, ref, date),

            const SizedBox(height: 20),

            if (items.isEmpty)
              _buildEmptyState()
            else
              _buildDataContent(items),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, WidgetRef ref, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Date',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async => _selectDate(context, ref),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade50, Colors.lightBlue.shade50],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade100, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade100.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date.isEmpty ? 'Choose a date' : DateFormat('MMM dd, yyyy').format(DateTime.parse(date)),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: date.isEmpty ? Colors.grey : Colors.blue.shade800,
                    ),
                  ),
                  Icon(Icons.calendar_month_rounded,
                      color: Colors.blue.shade600, size: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart_rounded, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No Data Available',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Text(
              'Select another date to view efficiency data',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataContent(List<ItemEfficiencyModel> items) {
    final totalQuantity = items.fold(0, (sum, item) => sum + (item.quantity!.toInt() ?? 0));
    final avgEfficiency = items.isEmpty ? 0 : items.fold(0, (sum, item) => sum + (item.averageEfficiency!.toInt() ?? 0)) / items.length;
    final valMap = <String, double>{};
    for (final e in items) {
      valMap[e.itemName ?? 'Unknown'] = e.averageEfficiency?.toDouble() ?? 0.0;
    }

    return Column(
      children: [
        // Stats Cards
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Items',
                items.length.toString(),
                Icons.inventory_2_rounded,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Avg Efficiency',
                '${avgEfficiency.toStringAsFixed(1)}%',
                Icons.trending_up_rounded,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          'Total Quantity',
          totalQuantity.toString(),
          Icons.shopping_cart_rounded,
          Colors.orange,
          fullWidth: true,
        ),

        const SizedBox(height: 20),

        // Enhanced Pie Chart
        BeautifulPieChart(
          title: "Efficiency Distribution",
          valueMap: valMap,
          titleColor: Colors.blue.shade700,
        ),

        const SizedBox(height: 20),

        // Enhanced List Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Item Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              Text(
                '${items.length} items',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Enhanced Items List
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey.shade100,
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                final efficiency = item.averageEfficiency ?? 0;
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      left: BorderSide(
                        color: _getEfficiencyColor(efficiency.toDouble()),
                        width: 4,
                      ),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade100,
                            Colors.lightBlue.shade100,
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.blue.shade700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      item.itemName ?? 'Unknown Item',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.trending_up_rounded,
                              size: 14,
                              color: _getEfficiencyColor(efficiency.toDouble()),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${efficiency.toDouble().toStringAsFixed(2)}%',
                              style: TextStyle(
                                color: _getEfficiencyColor(efficiency.toDouble()),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Qty: ${item.quantity}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getEfficiencyColor(efficiency.toDouble()).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getEfficiencyStatus(efficiency.toDouble()),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _getEfficiencyColor(efficiency.toDouble()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          SizedBox(height: 16),
          Text(
            'Loading Efficiency Data...',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded,
              size: 64, color: Colors.red.shade300),
          const SizedBox(height: 16),
          const Text(
            'Failed to Load Data',
            style: TextStyle(fontSize: 18, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            'Error: $error',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => ref.refresh(efficiencyDataProvider),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, WidgetRef ref) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      final formatted = DateFormat('yyyy-MM-dd').format(pickedDate);
      ref.read(selectedDateProvider.notifier).state = formatted;
    }
  }

  // Keep your existing _buildStatCard, _getEfficiencyColor, _getEfficiencyStatus methods
  Widget _buildStatCard(String title, String value, IconData icon, Color color,
      {bool fullWidth = false}) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getEfficiencyColor(double efficiency) {
    if (efficiency >= 80) return Colors.green;
    if (efficiency >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getEfficiencyStatus(double efficiency) {
    if (efficiency >= 80) return 'EXCELLENT';
    if (efficiency >= 60) return 'GOOD';
    return 'NEEDS IMPROVEMENT';
  }
}

class BeautifulPieChart extends StatelessWidget {
  final String title;
  final Map<String, double> valueMap;
  final Color? titleColor;

  const BeautifulPieChart({super.key, required this.title, required this.valueMap, this.titleColor});

  @override
  Widget build(BuildContext context) {
    // Add safety check for empty data
    if (valueMap.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            'No data for chart',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      );
    }

    final colors = [
      Color(0xFF4285F4), // Blue
      Color(0xFFEA4335), // Red
      // ... keep your existing colors
    ];

    // Rest of your existing BeautifulPieChart code...
    return Container(
      // Your existing pie chart implementation
    );
  }
}