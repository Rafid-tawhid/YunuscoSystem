import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/hr_provider.dart';

import '../../models/single_emp_leave_history_model.dart';

class EmployeeLeaveHistoryScreen extends StatelessWidget {
  const EmployeeLeaveHistoryScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var hp = context.read<HrProvider>();
    hp.getSingleEmployeeLeaveHistory();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Reports'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<HrProvider>(
        builder: (context, pro, _) => Container(
          decoration: BoxDecoration(color: Colors.white),
          child: pro.singleEmpLeaveList.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: pro.singleEmpLeaveList.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final leave = pro.singleEmpLeaveList[index];
                    return _buildLeaveCard(leave, context);
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildLeaveCard(
      SingleEmpLeaveHistoryModel leave, BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final fromDate = leave.leaveFromDate != null
        ? DateTime.parse(leave.leaveFromDate!)
        : null;
    final toDate =
        leave.leaveToDate != null ? DateTime.parse(leave.leaveToDate!) : null;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  leave.leavePolicyType ?? 'Leave',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(leave.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    leave.status ?? 'Pending',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '${fromDate != null ? dateFormat.format(fromDate) : 'N/A'} '
                  '- ${toDate != null ? dateFormat.format(toDate) : 'N/A'}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.timelapse, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Days: ${leave.remainingLeaveDay ?? 0}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                const Icon(Icons.help_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  leave.leaveType == 1 ? 'Paid Leave' : 'Unpaid Leave',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            if (leave.reasons != null && leave.reasons!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.note, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      leave.reasons!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.beach_access, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No Leave History Found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You haven\'t applied for any leaves yet',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
