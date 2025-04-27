import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/hr_provider.dart';

import '../../../models/employee_attendance_model.dart';

class EmployeeCards extends StatelessWidget {
  final List<EmployeeAttendanceModel> attendanceList;

  const EmployeeCards({super.key, required this.attendanceList});

  //
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<HrProvider>(
          builder: (context, pro, _) => pro.employeeAttendanceList.isNotEmpty ? _AttendanceSummaryCard() : SizedBox.shrink(),
        ),
        // Remove Expanded and use Column directly
        Consumer<HrProvider>(
          builder: (context, pro, _) => pro.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : pro.employeeAttendanceList.isEmpty
                  ? Center(
                      child: Text('No records found.'),
                    )
                  : Column(
                      children: attendanceList.map((record) => _AttendanceListItem(record: record)).toList(),
                    ),
        ),
      ],
    );
  }
}

class _AttendanceSummaryCard extends StatelessWidget {
  const _AttendanceSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _SummaryItem(Icons.check_circle, 'Present', Colors.green),
            _SummaryItem(Icons.cancel, 'Absent', Colors.red),
            _SummaryItem(Icons.access_time, 'Late', Colors.orange),
            _SummaryItem(Icons.beach_access, 'Leave', Colors.blue),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SummaryItem(this.icon, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}

class _AttendanceListItem extends StatelessWidget {
  final EmployeeAttendanceModel record;

  const _AttendanceListItem({required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        leading: _buildStatusIndicator(),
        title: Text(
          record.idCardNo ?? 'N/A',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          record.dayDate ?? 'Date not available',
          style: const TextStyle(color: Colors.grey),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailRow('Employee ID', record.employeeId?.toString() ?? 'N/A'),
                _buildDetailRow('In Time', record.inTime ?? 'Not recorded'),
                _buildDetailRow('Out Time', record.outTime ?? 'Not recorded'),
                _buildDetailRow('Status', _getStatusText()),
                if (record.inFlag != null) _buildDetailRow('Flag', record.inFlag!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //
  Widget _buildStatusIndicator() {
     if (record.absent == 1) {
      return const CircleAvatar(
        backgroundColor: Colors.red,
        child: Icon(Icons.close, color: Colors.white),
      );
    } else if (record.late == 1) {
      return const CircleAvatar(
        backgroundColor: Colors.orange,
        child: Icon(Icons.access_time, color: Colors.white),
      );
    } else if (record.leave == 1) {
      return const CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(Icons.beach_access, color: Colors.white),
      );
    }
     if (record.present == 1) {
       return const CircleAvatar(
         backgroundColor: Colors.green,
         child: Icon(Icons.check, color: Colors.white),
       );
     }
     return const CircleAvatar(
      backgroundColor: Colors.grey,
      child: Icon(Icons.stop_outlined, color: Colors.white),
    );
  }

  String _getStatusText() {
    if (record.present == 1) return 'Present';
    if (record.absent == 1) return 'Absent';
    if (record.late == 1) return 'Late';
    if (record.leave == 1) return 'On Leave';
    return 'Unknown';
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Text(': '),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
