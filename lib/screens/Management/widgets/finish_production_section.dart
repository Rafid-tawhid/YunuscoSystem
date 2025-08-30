import 'package:flutter/material.dart';

import '../../../models/management_dashboard_model.dart';

class FinishProductionSection extends StatelessWidget {
  final List<FinishProduction>? finishProduction;

  const FinishProductionSection({super.key, this.finishProduction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: finishProduction?.map((data) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200, width: 1),
                      borderRadius: BorderRadius.circular(4)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.factory, // Use an appropriate icon
                          color: Colors.blueAccent,
                          size: 40,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Section: ${data.sections}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Table Running: ${data.tableRunning}',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700]),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Total Target: ${data.totalTarget}',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700]),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'SMV: ${data.smv}',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700]),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Achieve Qty: ${data.achieveQty}',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700]),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Achieve Percent: ${data.achievePercent}%',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList() ??
            [],
      ),
    );
  }
}
