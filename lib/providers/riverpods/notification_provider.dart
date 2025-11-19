// providers/tna_notification_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/tna_notification_model.dart';

// Dummy data provider
final tnaNotificationsProvider = Provider<List<TnaNotificationModel>>((ref) {
  return [
    TnaNotificationModel(
      id: 1,
      notificationType: 'Reminder',
      buyer: 'Nike',
      po: 'PO-12345',
      style: 'Style-A',
      notificationDate: '2024-01-15',
      daysOffset: 2,
      recipientRole: 'Merchandiser',
      isSent: true,
      sentDate: '2024-01-13',
      message: 'Sample deadline approaching for PO-12345',
      createdDate: '2024-01-10',
    ),
    TnaNotificationModel(
      id: 2,
      notificationType: 'Alert',
      buyer: 'Adidas',
      po: 'PO-67890',
      style: 'Style-B',
      notificationDate: '2024-01-20',
      daysOffset: -1,
      recipientRole: 'Manager',
      isSent: false,
      message: 'Urgent: Production delay detected',
      createdDate: '2024-01-12',
    ),
    TnaNotificationModel(
      id: 3,
      notificationType: 'Update',
      buyer: 'Puma',
      po: 'PO-54321',
      style: 'Style-C',
      notificationDate: '2024-01-18',
      daysOffset: 5,
      recipientRole: 'Quality Controller',
      isSent: true,
      sentDate: '2024-01-13',
      message: 'Quality check completed successfully',
      createdDate: '2024-01-11',
    ),
    // Add more dummy data as needed
  ];
});