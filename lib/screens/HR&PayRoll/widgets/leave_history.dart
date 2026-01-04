import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/hr_provider.dart';

import '../../../models/self_leave_info.dart';

class LeaveSummaryWidget extends StatelessWidget {
  const LeaveSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // final leaveData = [
    //   {'type': 'Sick Leave', 'total': 14, 'used': 1, 'remaining': 13},
    //   {'type': 'Earn Leave', 'total': 6.28, 'used': 0, 'remaining': 6.28},
    //   {'type': 'Casual Leave', 'total': 10, 'used': 0, 'remaining': 10},
    //   {'type': 'Leave Without Pay', 'total': 120, 'used': 0, 'remaining': 120},
    //   {'type': 'Maternity Leave', 'total': 112, 'used': 0, 'remaining': 106},
    //   {'type': 'Special Leave', 'total': 28, 'used': 0, 'remaining': 28},
    // ];

    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<HrProvider>(
          builder: (context, pro, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Leave Balance Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              // In your parent widget:
              if (pro.selfLeaveInfo != null)
                CompactLeaveInfo(leaveInfo: pro.selfLeaveInfo!),
              // ...leaveData.map((leave) => _buildLeaveRow(
              //   leave['type'] as String,
              //   leave['total'] as dynamic,
              //   leave['used'] as int,
              //   leave['remaining'] as dynamic,
              // )),
            ],
          ),
        ),
      ),
    );
  }
}

class CompactLeaveInfo extends StatelessWidget {
  final SelfLeaveInfo leaveInfo;
  final double rowHeight = 30.0;

  const CompactLeaveInfo({super.key, required this.leaveInfo});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          _buildRow(
              'Sick Leave', leaveInfo.sickLeave, leaveInfo.sickLeavePolicyDays),
          _buildRow('Casual Leave', leaveInfo.casualLeave,
              leaveInfo.casualLeavePolicyDays),
          _buildRow('Maternity Leave', leaveInfo.maternityLeave,
              leaveInfo.maternityLeavePolicyDays),
          _buildRow(
              'Earn Leave', leaveInfo.earnLeave, leaveInfo.earnLeavePolicyDays),
          _buildRow('Leave Without Pay', leaveInfo.leaveWithoutPay,
              leaveInfo.leaveWithoutPayPolicyDays),
        ],
      ),
    );
  }

  //
  Widget _buildRow(String title, num? used, num? total) {
    final remaining = (total ?? 0) - (used ?? 0);

    return SizedBox(
      height: rowHeight,
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(title, overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            child: Text('${remaining.toStringAsFixed(2)}/$total (Rem: $used)'),
          ),
        ],
      ),
    );
  }
}
