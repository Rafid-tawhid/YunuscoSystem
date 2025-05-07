import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/notification_model.dart';

class NotificationsScreen extends StatelessWidget {
  final List<NotificationModel> notifications = [
    NotificationModel(
      employeeIdCardNo: "EMP-001",
      applaiedForEmployee: "John Doe",
      departmentName: "Engineering",
      leaveFromDate: "2023-06-15",
      leaveToDate: "2023-06-18",
      leaveCreationDate: "2023-06-10",
      leaveType: "Annual Leave",
      reasons: "Family vacation",
      dayCount: 3,
      leaveStatus: "Pending",
      appliedByName: "John Doe",
    ),
    NotificationModel(
      employeeIdCardNo: "EMP-002",
      applaiedForEmployee: "Jane Smith",
      departmentName: "Marketing",
      leaveFromDate: "2023-06-20",
      leaveToDate: "2023-06-22",
      leaveCreationDate: "2023-06-12",
      leaveType: "Sick Leave",
      reasons: "Medical appointment",
      dayCount: 2,
      leaveStatus: "Approved",
      appliedByName: "Jane Smith",
    ),
    NotificationModel(
      employeeIdCardNo: "EMP-003",
      applaiedForEmployee: "Robert Johnson",
      departmentName: "HR",
      leaveFromDate: "2023-06-25",
      leaveToDate: "2023-06-30",
      leaveCreationDate: "2023-06-18",
      leaveType: "Emergency Leave",
      reasons: "Family emergency",
      dayCount: 5,
      leaveStatus: "Rejected",
      appliedByName: "Robert Johnson",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: notifications.isEmpty
          ? const Center(child: Text('No notification found'))
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _buildNotificationCard(notification);
        },
      ),
    );
  }


  Widget _buildNotificationCard(NotificationModel notification) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  notification.applaiedForEmployee ?? 'Unknown Employee',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(notification.leaveStatus),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    notification.leaveStatus ?? 'Pending',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${notification.leaveType} (${notification.dayCount} days)',
              style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'From: ${_formatDate(notification.leaveFromDate)} '
                  'To: ${_formatDate(notification.leaveToDate)}',
            ),
            const SizedBox(height: 8),
            if (notification.reasons != null && notification.reasons!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reason:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(notification.reasons!),
                ],
              ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Applied by: ${notification.appliedByName ?? 'Unknown'}',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  _formatDate(notification.leaveCreationDate),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
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

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';

    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString; // Return original if parsing fails
    }
  }

}