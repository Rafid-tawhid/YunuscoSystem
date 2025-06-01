import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/models/notification_model.dart';
import 'package:yunusco_group/providers/notofication_provider.dart';

import '../helper_class/dashboard_helpers.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNotifications();
    });
  }

  @override
  void dispose() {

    super.dispose();
  }

  void _loadNotifications() {
    final provider = context.read<NotificationProvider>();
    provider.getAllNotification(DashboardHelpers.currentUser!.iDnum.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.allNotification.isEmpty) {
            return const Center(child: Text('No notifications found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: provider.allNotification.length,
            itemBuilder: (context, index) {
              final notification = provider.allNotification[index];
              return _NotificationListItem(
                notification: notification,
                onTap: () => _showNotificationDetails(context, notification),
              );
            },
          );
        },
      ),
    );
  }

  void _showNotificationDetails(BuildContext context, NotificationModel notification) {
    final remarksController = TextEditingController();
    final detailsSheet = NotificationDetailsSheet(
      notification: notification,
      controller: remarksController,
      onAccept: notification.leaveStatus?.toLowerCase() == 'pending'
          ? () => _handleLeaveAction(context, notification, true, remarksController.text)
          : null,
      onReject: notification.leaveStatus?.toLowerCase() == 'pending'
          ? () => _handleLeaveAction(context, notification, false, remarksController.text)
          : null,
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (context) => detailsSheet,
    );
  }

  Future<void> _handleLeaveAction(
      BuildContext context,
      NotificationModel notification,
      bool isApproved,
      String remarks,
      ) async {
    final provider = context.read<NotificationProvider>();

    try {
      var data = [
        {
          "leaveId": notification.leaveId,
          "approvalLevel": DashboardHelpers.currentUser!.userId == 11 ? 2 : 1,
          "note": isApproved ? "N/A" : remarks.isNotEmpty ? remarks : "N/A",
          "isApprove": isApproved
        }
      ];

      provider.acceptLeaveApproval(data);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isApproved ? 'Leave approved' : 'Leave rejected')),
        );
        Navigator.pop(context);
        _loadNotifications();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update status: ${e.toString()}')),
        );
      }
    }
  }


}

class _NotificationListItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationListItem({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
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
                  _StatusChip(status: notification.leaveStatus),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${notification.leaveType} • ${notification.dayCount} days',
                style: const TextStyle(color: Colors.blueGrey),
              ),
              const SizedBox(height: 4),
              Text(
                '${_formatDate(notification.leaveFromDate)} - ${_formatDate(notification.leaveToDate)}',
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}

class _StatusChip extends StatelessWidget {
  final String? status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status ?? 'Pending',
        style: const TextStyle(color: Colors.white, fontSize: 12),
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

class NotificationDetailsSheet extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final TextEditingController? controller;

  NotificationDetailsSheet({
    required this.notification,
    this.onAccept,
    this.onReject,
    this.controller
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                notification.applaiedForEmployee ?? 'Unknown Employee',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _StatusChip(status: notification.leaveStatus),
            ],
          ),
          const SizedBox(height: 16),
          _DetailRow(label: 'Applied By', value: notification.appliedByName),
          _DetailRow(label: 'Applied On', value: _formatDate(notification.leaveCreationDate)),
          _DetailRow(label: 'Leave Type', value: notification.leaveType),
          _DetailRow(
            label: 'Period',
            value: '${_formatDate(notification.leaveFromDate)} - ${_formatDate(notification.leaveToDate)}',
          ),
          _DetailRow(label: 'Duration', value: '${notification.dayCount} days'),
          _DetailRow(label: 'Balance', value: 'SL: ${notification.sl}, EL: ${notification.el}, CL :${notification.cl},', ),

          if (notification.reasons?.isNotEmpty ?? false)
            _DetailRow(label: 'Reason', value: notification.reasons!),

          if (onAccept != null || onReject != null) ...[
            const SizedBox(height: 24),
            (DashboardHelpers.currentUser!.isDepartmentHead==true||DashboardHelpers.currentUser!.loginName=='00004') ? Column(
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: 'Remarks (Optional)',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: .5
                          )
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    ),
                    maxLines: 2,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (onReject != null)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onReject,
                          child: const Text('Reject'),
                        ),
                      ),
                    if (onAccept != null) ...[
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green
                          ),
                          onPressed: onAccept,
                          child: const Text('Approve', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ) : SizedBox.shrink(),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String? value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value ?? 'N/A')),
        ],
      ),
    );
  }
}