import 'package:flutter/material.dart';

import '../../../models/employee_attendance_model.dart';

class AttendanceSummary extends StatelessWidget {
  final List<EmployeeAttendanceModel> attendanceData;

  const AttendanceSummary({Key? key, required this.attendanceData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate summary data
    int totalWorkingDays = attendanceData.where((day)=>day.inFlag!='WH').length;
    int presentDays = attendanceData.where((day) => day.present == 1).length;
    int absentDays = attendanceData.where((day) => day.absent == 1).length;
    int leaveDays = attendanceData.where((day) => day.leave == 1).length;
    int lateDays = attendanceData.where((day) => day.late == 1).length;

    // Calculate total working hours
    Duration totalWorkingHours = Duration();
    for (var day in attendanceData) {
      if (day.totalWorkingHours != null && day.totalWorkingHours.toString().isNotEmpty) {
        List<String> parts = day.totalWorkingHours!.split(':');
        if (parts.length == 2) {
          totalWorkingHours += Duration(hours: int.parse(parts[0]), minutes: int.parse(parts[1]));
        }
      }
    }

    // Format total working hours
    String formattedTotalHours = "${totalWorkingHours.inHours}:${(totalWorkingHours.inMinutes % 60).toString().padLeft(2, '0')}";

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attendance Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem('Total Days', totalWorkingDays.toString()),
              _buildSummaryItem('Present', presentDays.toString(), Colors.green),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem('Absent', absentDays.toString(), Colors.red),
              _buildSummaryItem('Leave', leaveDays.toString(), Colors.orange),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem('Late Days', lateDays.toString(), Colors.amber),
              _buildSummaryItem('Total Hours', formattedTotalHours),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, [Color? color]) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.blue[800],
          ),
        ),
      ],
    );
  }
}