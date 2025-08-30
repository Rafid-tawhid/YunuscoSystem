import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../models/buyer_wise_value_model.dart';

class BarChartExample extends StatefulWidget {
  final List<BuyerWiseQty> items;

  const BarChartExample({super.key, required this.items});

  @override
  State<BarChartExample> createState() => _BarChartExampleState();
}

class _BarChartExampleState extends State<BarChartExample> {
  @override
  Widget build(BuildContext context) {
    // Each bar is 40 wide including spacing
    final double chartWidth = widget.items.length * 40;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: chartWidth,
          height: 350, // You can adjust height based on your design
          child: BarChart(
            BarChartData(
              barGroups: widget.items.asMap().entries.map((entry) {
                final index = entry.key;
                final e = entry.value;
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: e.value?.toDouble() ?? 0,
                      color: Colors.blue,
                      width: 20,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ],
                );
              }).toList(),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 60,
                    getTitlesWidget: (value, meta) {
                      final int index = value.toInt();
                      if (index < widget.items.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: RotatedBox(
                            quarterTurns: 1,
                            child: Text(
                              widget.items[index].label ?? '',
                              style: const TextStyle(fontSize: 10),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ),
    );
  }
}
