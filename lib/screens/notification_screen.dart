import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatelessWidget {
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: "Quality Check Approved",
      description: "Your batch #GAR-2023-456 passed all quality tests",
      time: DateTime.now().subtract(Duration(minutes: 5)),
      icon: Icons.verified,
      color: Colors.green,
      isRead: false,
    ),
    NotificationItem(
      title: "New Defect Reported",
      description: "Stitching issue detected in Batch #GAR-2023-123",
      time: DateTime.now().subtract(Duration(hours: 2)),
      icon: Icons.warning_rounded,
      color: Colors.orange,
      isRead: true,
    ),
    NotificationItem(
      title: "Daily Summary Ready",
      description: "View your quality report for May 15, 2023",
      time: DateTime.now().subtract(Duration(days: 1)),
      icon: Icons.summarize,
      color: Colors.blue,
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Notifications",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          TextButton(
            child: Text("Mark all read",
                style: TextStyle(color: Theme.of(context).primaryColor)),
            onPressed: () {},
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final notification = notifications[index];
                  return _NotificationCard(notification: notification);
                },
                childCount: notifications.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  const _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: notification.isRead
          ? Colors.white
          : Theme.of(context).cardColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: notification.color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(notification.icon,
                    color: notification.color, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(notification.title,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: notification.isRead
                                  ? Colors.grey[800]
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        Text('2 min ago',
                            style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(notification.description,
                        style: GoogleFonts.poppins(color: Colors.grey[600])),
                  ],
                ),
              ),
              if (!notification.isRead) ...[
                SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String description;
  final DateTime time;
  final IconData icon;
  final Color color;
  final bool isRead;

  NotificationItem({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
    this.isRead = false,
  });
}