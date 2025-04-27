import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/product_provider.dart';

class WeeklyProductionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        final weeklyData = provider.productionSummaryList;
        final totalQty = weeklyData.fold(0.0, (sum, item) => sum + (double.parse(item['sumQty'].toString())));
        final totalTarget = weeklyData.fold(0.0, (sum, item) => sum + (double.parse(item['sumTarget'].toString())));
        final overallPercentage = totalTarget > 0.0 ? (totalQty / totalTarget) * 100 : 0;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Overall Summary Card
              Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Monthly Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatItem('Total Production', totalQty),
                          _buildStatItem('Total Target', totalTarget),
                          _buildStatItem('Achievement', overallPercentage, isPercent: true),
                        ],
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: overallPercentage / 100,
                        minHeight: 12,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getProgressColor(overallPercentage.toDouble()),
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Weekly Breakdown
              const Text(
                'Weekly Breakdown',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...weeklyData.map((weekData) => _buildWeekCard(weekData)).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeekCard(Map<String, dynamic> weekData) {
    final sumQty = (weekData['sumQty'] as num).toDouble();
    final sumTarget = (weekData['sumTarget'] as num).toDouble();
    final percentage = sumTarget > 0 ? (sumQty / sumTarget) * 100 : 0.0;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              weekData['dataLabel'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildWeekStat('Production', weekData['sumQty']),
                _buildWeekStat('Target', weekData['sumTarget']),
                _buildWeekStat('Achievement', percentage, isPercent: true),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getProgressColor(percentage),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            if (percentage > 0) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: 12,
                    color: _getProgressColor(percentage),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, dynamic value, {bool isPercent = false}) {
    final formatter = NumberFormat('#,##0');
    final displayValue = isPercent ? '${NumberFormat('#,##0.0').format(value)}%' : formatter.format(value);

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
          displayValue,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isPercent ? _getProgressColor(value) : Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildWeekStat(String label, dynamic value, {bool isPercent = false}) {
    final formatter = NumberFormat('#,##0');
    final displayValue = isPercent ? '${NumberFormat('#,##0.0').format(value)}%' : formatter.format(value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          displayValue,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isPercent ? _getProgressColor(value) : Colors.black87,
          ),
        ),
      ],
    );
  }

  Color _getProgressColor(dynamic percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 70) return Colors.lightGreen;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }
}