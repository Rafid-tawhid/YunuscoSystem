import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/management_dashboard_model.dart';

class SewingProductionSection extends StatelessWidget {
  final List<SewingProduction>? sewingProduction;

  const SewingProductionSection({Key? key, this.sewingProduction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: sewingProduction?.map((data) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Header
                Row(
                  children: [
                    const Icon(Icons.construction, size: 20, color: Colors.blueGrey),
                    const SizedBox(width: 8),
                    Text(
                      'Section ${data.sections}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24, color: Colors.grey),

                // Metrics Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 8,
                  children: [
                    _buildMetricItem(Icons.timeline, 'Line Running', data.lineRunning),
                    _buildMetricItem(Icons.flag, 'Total Target', data.totalTarget),
                    _buildMetricItem(Icons.timer, 'SMV', data.smv),
                    _buildMetricItem(Icons.check_circle, 'Achieved Qty', data.achieveQty),
                    _buildMetricItem(Icons.percent, 'Achieved %', '${data.achievePercent}%'),
                  ],
                ),

                // Progress Bar
                if (data.achievePercent != null) ...[
                  LinearProgressIndicator(
                    value: (data.achievePercent ?? 0) / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getProgressColor(data.achievePercent!.toDouble()),
                    ),
                    minHeight: 2,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList() ?? [const SizedBox()],
    );
  }

  Widget _buildMetricItem(IconData icon, String label, dynamic value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.blueGrey),
        const SizedBox(width: 8),
        Column(
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
              value.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 70) return Colors.lightGreen;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }
}