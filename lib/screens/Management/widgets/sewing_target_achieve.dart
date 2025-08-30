import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/management_dashboard_model.dart';

class MorrisLineSection extends StatelessWidget {
  final List<MorrisLine>? morrisLine;

  const MorrisLineSection({super.key, this.morrisLine});

  @override
  Widget build(BuildContext context) {
    if (morrisLine == null || morrisLine!.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'No Morris Line data available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    // Calculate max value rounded up to nearest 50k
    final maxValue = morrisLine!
        .map((e) => max(e.targetQty ?? 0, e.acheiveQty ?? 0))
        .reduce((a, b) => max(a, b))
        .toDouble();
    final roundedMax = ((maxValue / 50000).ceil() * 50000).toDouble();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sewing Target vs Achieve (Last 15 days)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Scroll horizontally to view all lines',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              //
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: morrisLine!.length * 80.0,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceBetween,
                        groupsSpace: 16,
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final data = morrisLine![groupIndex];
                              final percentage = ((data.acheiveQty ?? 0) /
                                      (data.targetQty ?? 1)) *
                                  100;
                              return BarTooltipItem(
                                '${data.name}\n'
                                'Target: ${NumberFormat.decimalPattern().format(data.targetQty)}\n'
                                'Achieved: ${NumberFormat.decimalPattern().format(data.acheiveQty)}\n'
                                'Progress: ${percentage.toStringAsFixed(1)}%',
                                const TextStyle(color: Colors.white),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 50000, // Force 50k difference
                              reservedSize: 50, // More space for labels
                              getTitlesWidget: (value, meta) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    NumberFormat.compact().format(value),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                if (value < 0 || value >= morrisLine!.length) {
                                  return const SizedBox();
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    morrisLine![value.toInt()].name ?? '',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          drawHorizontalLine: true,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey.withOpacity(0.2),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1,
                            ),
                            left: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                        ),
                        barGroups: morrisLine!.asMap().entries.map((entry) {
                          final data = entry.value;
                          final percentage =
                              ((data.acheiveQty ?? 0) / (data.targetQty ?? 1)) *
                                  100;

                          return BarChartGroupData(
                            x: entry.key,
                            barsSpace: 4,
                            barRods: [
                              BarChartRodData(
                                toY: data.targetQty?.toDouble() ?? 0,
                                color: Colors.grey.withOpacity(0.2),
                                width: 20,
                                borderRadius: BorderRadius.zero,
                              ),
                              BarChartRodData(
                                toY: data.acheiveQty?.toDouble() ?? 0,
                                gradient: _getBarGradient(percentage),
                                width: 20,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                        minY: 0,
                        maxY: roundedMax,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.swipe, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Swipe to view more',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  LinearGradient _getBarGradient(double percentage) {
    return LinearGradient(
      colors: [
        if (percentage >= 100) Colors.green.shade400,
        if (percentage >= 100) Colors.green.shade600,
        if (percentage >= 75) Colors.lightGreen.shade400,
        if (percentage >= 75) Colors.lightGreen.shade600,
        if (percentage >= 50) Colors.orange.shade400,
        if (percentage >= 50) Colors.orange.shade600,
        if (percentage < 50) Colors.red.shade400,
        if (percentage < 50) Colors.red.shade600,
      ],
      stops: const [0.0, 1.0],
    );
  }
}
