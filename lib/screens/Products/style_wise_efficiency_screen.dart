import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/stylewise_efficiency_model.dart';

class StylewiseEfficiencyScreen extends StatelessWidget {
  final List<StylewiseEfficiencyModel> efficiencies;

  const StylewiseEfficiencyScreen({super.key, required this.efficiencies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Stylewise Efficiency Report'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Summary Card
          _buildSummaryCard(),
          const SizedBox(height: 8),
          // Data List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: efficiencies.length,
              itemBuilder: (context, index) {
                final item = efficiencies[index];
                return _buildEfficiencyCard(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem('Total Styles', efficiencies.length.toString()),
                _buildSummaryItem(
                  'Avg Efficiency',
                  _calculateAverageEfficiency().toStringAsFixed(1) + '%',
                ),
                _buildSummaryItem(
                  'Active Lines',
                  _countUniqueLines().toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEfficiencyCard(StylewiseEfficiencyModel item) {
    final latestEfficiency = _getLatestEfficiency(item);
    final efficiencyColor = _getEfficiencyColor(latestEfficiency ?? 0);

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
                Flexible(
                  child: Text(
                    item.styleNo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Chip(
                  backgroundColor: efficiencyColor,
                  label: Text(
                    latestEfficiency != null
                        ? '${latestEfficiency.toStringAsFixed(1)}%'
                        : 'N/A',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Buyer: ${item.buyerName}'),
            Text('Section: ${item.sectionName} | Line: ${item.lineName}'),
            Text('PO: ${item.po} | Item: ${item.item}'),
            const SizedBox(height: 8),
            if (latestEfficiency != null)
              LinearProgressIndicator(
                value: latestEfficiency / 100,
                backgroundColor: Colors.grey[200],
                color: efficiencyColor,
                minHeight: 6,
              ),
            const SizedBox(height: 8),
            _buildEfficiencyHistory(item),
          ],
        ),
      ),
    );
  }

  Widget _buildEfficiencyHistory(StylewiseEfficiencyModel item) {
    final sortedDates = item.dateEfficiencies.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Efficiency:',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: sortedDates.take(5).map((date) {
            final efficiency = item.dateEfficiencies[date];
            if (efficiency == null) return const SizedBox.shrink();

            return Chip(
              backgroundColor: Colors.grey[200],
              label: Text(
                '${DateFormat('MMM dd').format(date)}: ${efficiency.toStringAsFixed(1)}%',
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getEfficiencyColor(double efficiency) {
    if (efficiency >= 90) return Colors.green;
    if (efficiency >= 80) return Colors.lightGreen;
    if (efficiency >= 70) return Colors.orange;
    return Colors.red;
  }

  // Helper methods
  double _calculateAverageEfficiency() {
    double total = 0;
    int count = 0;

    for (final item in efficiencies) {
      for (final efficiency in item.dateEfficiencies.values) {
        if (efficiency != null) {
          total += efficiency;
          count++;
        }
      }
    }

    return count > 0 ? total / count : 0;
  }

  int _countUniqueLines() {
    return efficiencies.map((e) => e.lineName).toSet().length;
  }

  double? _getLatestEfficiency(StylewiseEfficiencyModel item) {
    final sortedDates = item.dateEfficiencies.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    for (final date in sortedDates) {
      final efficiency = item.dateEfficiencies[date];
      if (efficiency != null) return efficiency;
    }
    return null;
  }
}