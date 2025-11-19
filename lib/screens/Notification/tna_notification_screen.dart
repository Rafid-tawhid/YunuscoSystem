// screens/tna_notification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../models/tna_notification_model.dart';
import '../../providers/riverpods/notification_provider.dart';

class TnaNotificationScreen extends ConsumerWidget {
  const TnaNotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(tnaNotificationsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'TNA Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [

        ],
      ),
      body: Column(
        children: [
          // Summary Cards
          _buildSummaryCards(notifications),

          // Notifications List
          Expanded(
            child: notifications.isEmpty
                ? _buildEmptyState()
                : _buildNotificationsList(notifications),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(List<TnaNotificationModel> notifications) {
    final sentCount = notifications.where((n) => n.isSent == true).length;
    final pendingCount = notifications.where((n) => n.isSent != true).length;
    final urgentCount = notifications.where((n) => (n.daysOffset ?? 0) <= 0).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          _buildSummaryItem('Total', notifications.length.toString(), Colors.blue),
          _buildSummaryItem('Sent', sentCount.toString(), Colors.green),
          _buildSummaryItem('Pending', pendingCount.toString(), Colors.orange),
          _buildSummaryItem('Urgent', urgentCount.toString(), Colors.red),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(List<TnaNotificationModel> notifications) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationCard(notification, index,context);
      },
    );
  }

  Widget _buildNotificationCard(TnaNotificationModel notification, int index,BuildContext ctx) {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: _getNotificationColor(notification),
              width: 4,
            ),
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getNotificationColor(notification).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getNotificationIcon(notification),
              color: _getNotificationColor(notification),
              size: 20,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  notification.notificationType ?? 'Notification',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              _buildStatusBadge(notification),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                notification.message ?? 'No message',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              _buildNotificationDetails(notification),
            ],
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Colors.grey.shade400,
          ),
          onTap: () {
            _showNotificationDetails(ctx, notification);
          },
        ),
      ),
    );
  }

  Widget _buildStatusBadge(TnaNotificationModel notification) {
    final isSent = notification.isSent == true;
    final daysOffset = notification.daysOffset ?? 0;

    if (daysOffset <= 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Text(
          'URGENT',
          style: TextStyle(
            color: Colors.red.shade700,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSent ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSent ? Colors.green.shade200 : Colors.orange.shade200,
        ),
      ),
      child: Text(
        isSent ? 'SENT' : 'PENDING',
        style: TextStyle(
          color: isSent ? Colors.green.shade700 : Colors.orange.shade700,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNotificationDetails(TnaNotificationModel notification) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.business, size: 12, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              'Buyer: ${notification.buyer ?? 'N/A'}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(width: 12),
            Icon(Icons.shopping_bag, size: 12, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              'PO: ${notification.po ?? 'N/A'}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.calendar_today, size: 12, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              'Date: ${_formatDate(notification.notificationDate)}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(width: 12),
            Icon(Icons.person, size: 12, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              'Role: ${notification.recipientRole ?? 'N/A'}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ],
    );
  }

  Color _getNotificationColor(TnaNotificationModel notification) {
    final daysOffset = notification.daysOffset ?? 0;

    if (daysOffset <= 0) return Colors.red;
    if (daysOffset <= 2) return Colors.orange;
    if (notification.isSent == true) return Colors.green;
    return Colors.blue;
  }

  IconData _getNotificationIcon(TnaNotificationModel notification) {
    switch (notification.notificationType?.toLowerCase()) {
      case 'reminder':
        return Icons.alarm;
      case 'alert':
        return Icons.warning;
      case 'update':
        return Icons.update;
      default:
        return Icons.notifications;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _showNotificationDetails(BuildContext context, TnaNotificationModel notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.notificationType ?? 'Notification Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Buyer', notification.buyer),
              _buildDetailRow('PO Number', notification.po),
              _buildDetailRow('Style', notification.style),
              _buildDetailRow('Notification Date', _formatDate(notification.notificationDate)),
              _buildDetailRow('Days Offset', notification.daysOffset?.toString()),
              _buildDetailRow('Recipient Role', notification.recipientRole),
              _buildDetailRow('Status', notification.isSent == true ? 'Sent' : 'Pending'),
              if (notification.sentDate != null)
                _buildDetailRow('Sent Date', _formatDate(notification.sentDate)),
              const SizedBox(height: 16),
              Text(
                'Message:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(notification.message ?? 'No message'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(value ?? 'N/A'),
          ),
        ],
      ),
    );
  }


}