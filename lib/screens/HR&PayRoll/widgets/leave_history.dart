import 'package:flutter/material.dart';

class LeaveSummaryWidget extends StatelessWidget {
  const LeaveSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final leaveData = [
      {'type': 'Sick Leave', 'total': 14, 'used': 1, 'remaining': 13},
      {'type': 'Earn Leave', 'total': 6.28, 'used': 0, 'remaining': 6.28},
      {'type': 'Casual Leave', 'total': 10, 'used': 0, 'remaining': 10},
      {'type': 'Leave Without Pay', 'total': 120, 'used': 0, 'remaining': 120},
      {'type': 'Maternity Leave', 'total': 112, 'used': 0, 'remaining': 106},
      {'type': 'Special Leave', 'total': 28, 'used': 0, 'remaining': 28},
    ];

    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Leave Balance Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...leaveData.map((leave) => _buildLeaveRow(
              leave['type'] as String,
              leave['total'] as dynamic,
              leave['used'] as int,
              leave['remaining'] as dynamic,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveRow(String type, dynamic total, int used, dynamic remaining) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              type,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              total.toString(),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              used.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: used > 0 ? Colors.red : Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              remaining.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}