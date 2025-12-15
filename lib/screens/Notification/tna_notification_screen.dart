// screens/tna_notification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../models/tna_notification_model.dart';
import '../../providers/riverpods/notification_provider.dart';

class TnaNotificationScreen extends ConsumerStatefulWidget {
  const TnaNotificationScreen({super.key});

  @override
  ConsumerState<TnaNotificationScreen> createState() => _TnaNotificationScreenState();
}

class _TnaNotificationScreenState extends ConsumerState<TnaNotificationScreen> {
  String _selectedFilter = 'all'; // 'all', 'sent', 'pending', 'urgent'

  @override
  void initState() {
    super.initState();
    // Load notifications when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    try {
      await ref.read(tnaNotificationsProvider.notifier).loadNotificationData();
    } catch (e) {
      // Handle error if needed
      debugPrint('Error loading initial data: $e');
    }
  }

  List<TnaNotificationModel> _getFilteredNotifications(List<TnaNotificationModel> allNotifications) {
    switch (_selectedFilter) {
      case 'sent':
        return allNotifications.where((n) => n.isSent == true).toList();
      case 'pending':
        return allNotifications.where((n) => n.isSent !=true).toList();
      case 'all':
      default:
        return allNotifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    final allNotifications = ref.watch(tnaNotificationsProvider);
    final filteredNotifications = _getFilteredNotifications(allNotifications);

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
          IconButton(
              onPressed: () {
                ref.read(tnaNotificationsProvider.notifier).loadNotificationData();
              },
              icon: const Icon(Icons.refresh)
          ),
          IconButton(
            onPressed: () async {
              // Show loading dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const AlertDialog(
                  content: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 16),
                      Text("Sending notification..."),
                    ],
                  ),
                ),
              );
              sendEmailNotification(context);
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Cards
          _buildSummaryCards(allNotifications),

          // Filter indicator
          if (_selectedFilter != 'all')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.orange.shade50,
              child: Row(
                children: [
                  Icon(Icons.filter_alt, size: 16, color: Colors.orange.shade700),
                  const SizedBox(width: 8),
                  Text(
                    'Showing ${_getFilterLabel(_selectedFilter)}',
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedFilter = 'all';
                      });
                    },
                    child: Text(
                      'Clear',
                      style: TextStyle(
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Notifications List
          Expanded(
            child: filteredNotifications.isEmpty
                ? _buildEmptyState(_selectedFilter)
                : _buildNotificationsList(filteredNotifications),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(List<TnaNotificationModel> notifications) {
    final sentCount = notifications.where((n) => n.isSent == true).length;
    final pendingCount = notifications.where((n) => n.isSent != true).length;

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
          _buildSummaryItem(
            'Total',
            notifications.length.toString(),
            Colors.blue,
            'all',
            isSelected: _selectedFilter == 'all',
          ),
          _buildSummaryItem(
            'Sent',
            sentCount.toString(),
            Colors.green,
            'sent',
            isSelected: _selectedFilter == 'sent',
          ),
          _buildSummaryItem(
            'Pending',
            pendingCount.toString(),
            Colors.orange,
            'pending',
            isSelected: _selectedFilter == 'pending',
          ),
          // _buildSummaryItem(
          //   'Urgent',
          //   urgentCount.toString(),
          //   Colors.red,
          //   'urgent',
          //   isSelected: _selectedFilter == 'urgent',
          // ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, Color color, String filterType, {bool isSelected = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedFilter = filterType;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.3) : color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: isSelected ? Border.all(color: color, width: 2) : null,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected ? color : color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : color,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? color : Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String filter) {
    String message;
    String subtitle;

    switch (filter) {
      case 'sent':
        message = 'No Sent Notifications';
        subtitle = 'No notifications have been sent yet';
        break;
      case 'pending':
        message = 'No Pending Notifications';
        subtitle = 'All notifications have been sent';
        break;
      case 'urgent':
        message = 'No Urgent Notifications';
        subtitle = 'Great! No urgent notifications';
        break;
      case 'all':
      default:
        message = 'No Notifications';
        subtitle = 'You\'re all caught up!';
    }

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
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
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
        return _buildNotificationCard(notification, index, context);
      },
    );
  }

  Widget _buildNotificationCard(TnaNotificationModel notification, int index, BuildContext ctx) {
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

          ],
        ),
        Row(
          children: [
            Icon(Icons.shopping_bag, size: 12, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              'PO: ${DashboardHelpers.truncateString(notification.po.toString(), 10) ?? 'N/A'}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.style, size: 12, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              'Style: ${DashboardHelpers.truncateString(notification.style.toString(), 20) ?? 'N/A'}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.calendar_today, size: 12, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              'Date: ${_formatDate(notification.notificationDate)}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ],
    );
  }

  Color _getNotificationColor(TnaNotificationModel notification) {
    final sent = notification.isSent ?? false;
    if (sent == true) return Colors.green;
    if (sent !=true) return Colors.orange;
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

  String _getFilterLabel(String filter) {
    switch (filter) {
      case 'sent': return 'Sent Notifications';
      case 'pending': return 'Pending Notifications';
      case 'urgent': return 'Urgent Notifications';
      default: return 'All Notifications';
    }
  }


  void _showNotificationDetails(BuildContext context, TnaNotificationModel notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.notificationType ?? 'Notification Details'),
        backgroundColor: Colors.white,
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
  //

  void sendEmailNotification(BuildContext context) async{
    try {
      // Call your API
      await ref.read(tnaNotificationsProvider.notifier).sendNotification();

      // Close loading dialog
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification sent successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      // Close loading dialog
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send notification: $error'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}