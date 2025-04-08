import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/buyer_wise_value_model.dart';

class BuyerQtyPieChart extends StatelessWidget {
  final List<BuyerWiseQty> items;

  const BuyerQtyPieChart({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text("No data available"));
    }

    final sortedItems = [...items]..sort((a, b) => (b.value ?? 0).compareTo(a.value ?? 0));
    final total = items.fold<double>(0, (sum, e) => sum + (e.value ?? 0));

    final colors = [
      Colors.deepPurple,
      Colors.purple,
      Colors.blueGrey,
      Colors.red,
      Colors.indigo,
      Colors.cyan,
      Colors.orange,
    ];

    return Column(
      children: [
        SizedBox(
          height: 350,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              // 👇 Removed the center space for full pie chart
              centerSpaceRadius: 0,
              sections: items.asMap().entries.map((entry) {
                int i = entry.key;
                var item = entry.value;

                return PieChartSectionData(
                  value: item.value?.toDouble() ?? 0,
                  color: colors[i % colors.length],
                  title: "${((item.value ?? 0) / total * 100).toStringAsFixed(1)}%",
                  radius: 100,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Legend
        ...items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          final percent = ((item.value ?? 0) / total * 100).toStringAsFixed(2);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colors[i % colors.length],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(item.label ?? '-', style: const TextStyle(fontSize: 14)),
                ),
                Text("$percent%", style: const TextStyle(fontSize: 14)),
              ],
            ),
          );
        }),
      ],
    );
  }
}
