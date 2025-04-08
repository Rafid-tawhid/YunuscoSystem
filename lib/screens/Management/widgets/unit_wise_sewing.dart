import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/management_dashboard_model.dart';

class UnitWiseSewingSection extends StatelessWidget {
  final List<UnitWiseSewing>? unitWiseSewing;

  UnitWiseSewingSection({this.unitWiseSewing});

  @override
  Widget build(BuildContext context) {
    return unitWiseSewing != null && unitWiseSewing!.isNotEmpty
        ? Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Unit-wise Sewing Data',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1.5,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barGroups: unitWiseSewing!
                    .asMap()
                    .entries
                    .map((entry) => BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.quantity!.toDouble(),
                      color: Colors.blue,
                      width: 16,
                    ),
                  ],
                ))
                    .toList(),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value < 0 || value >= unitWiseSewing!.length) {
                          return Container();
                        }
                        return Text(
                          unitWiseSewing![value.toInt()].unitName ?? '',
                          style: TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                ),
                // Show grid lines
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  drawHorizontalLine: true,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.3),
                    strokeWidth: 1,
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.3),
                    strokeWidth: 1,
                  ),
                ),
                // Show border
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    )
        : Center(
      child: Text('No data available'),
    );
  }
}