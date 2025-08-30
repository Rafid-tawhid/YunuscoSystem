import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../models/buyer_wise_value_model.dart';

class ItemWiseSalesChart extends StatelessWidget {
  final List<ItemWiseWise> items;

  const ItemWiseSalesChart({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text("No data available"));
    }

    // Sort by percentage to find top
    final sortedItems = [...items]
      ..sort((a, b) => (b.quantity ?? 0).compareTo(a.quantity ?? 0));
    final total = items.fold<double>(0, (sum, e) => sum + (e.quantity ?? 0));
    final topBuyer = sortedItems.first;
    final topPercent =
        ((topBuyer.quantity ?? 0) / total * 100).toStringAsFixed(2);

    // Generate colors
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
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 360,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: items.asMap().entries.map((entry) {
                    int i = entry.key;
                    var item = entry.value;
                    final percent = (item.quantity ?? 0) / total * 100;
                    return PieChartSectionData(
                        value: item.quantity?.toDouble() ?? 0,
                        color: colors[i % colors.length],
                        title: "${percent.toStringAsFixed(1)}%",
                        radius: 120,
                        titleStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold));
                  }).toList(),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(topBuyer.item ?? '',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text("$topPercent%",
                    style: const TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        ...items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          final percent =
              ((item.quantity ?? 0) / total * 100).toStringAsFixed(2);
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
                  child: Text(item.item ?? '-',
                      style: const TextStyle(fontSize: 14)),
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
