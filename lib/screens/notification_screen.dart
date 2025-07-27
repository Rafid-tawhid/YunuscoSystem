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
      body: Column(
        children: [
          // Consumer<NotificationProvider>(
          //   builder: (context, pro, _) => Align(alignment: Alignment.bottomRight, child: Padding(
          //     padding: const EdgeInsets.only(right: 12.0),
          //     child: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       crossAxisAlignment: CrossAxisAlignment.end,
          //       children: [
          //         Text('Total: ${pro.allNotification.length.toString()}'),
          //         SizedBox(
          //             width: 140,
          //             child: DepartmentDropdown())
          //       ],
          //     ),
          //   )),
          // ),
          Expanded(
            child: Consumer<NotificationProvider>(
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
          ),
        ],
      ),
    );
  }

  void _showNotificationDetails(BuildContext context, NotificationModel notification) {
    final remarksController = TextEditingController();
    final detailsSheet = NotificationDetailsSheet(
        notification: notification,
        controller: remarksController,
        onAccept: () {
          _handleLeaveAction(context, notification, true, remarksController.text);
        },
        onReject: () {
          _handleLeaveAction(context, notification, false, remarksController.text);
        });

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true, // This is important
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
        ),
        child: SingleChildScrollView(
          child: detailsSheet,
        ),
      ),
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
      debugPrint('MAM ID 381');
      var data = [
        {
          "leaveId": notification.leaveId,
          "approvalLevel": DashboardHelpers.currentUser!.userId == 381 ? 2 : 1,
          "note": isApproved
              ? "N/A"
              : remarks.isNotEmpty
                  ? remarks
                  : "N/A",
          "isApprove": isApproved
        }
      ];
      debugPrint('APPROVED STATUS :${DashboardHelpers.currentUser!.userId}');
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
    debugPrint('CHIP STATUS ${status}');
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
      case 'dpt. head':
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

  NotificationDetailsSheet({required this.notification, this.onAccept, this.onReject, this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: 16, // Add keyboard height + some padding
        left: 16,
        right: 16,
        top: 16,
      ),
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
          _DetailRow(
            label: 'Balance',
            value: 'SL: ${notification.sl}, EL: ${notification.el}, CL :${notification.cl},',
          ),
          if (notification.reasons?.isNotEmpty ?? false) _DetailRow(label: 'Reason', value: notification.reasons!),
          const SizedBox(height: 24),
          isShowAcceptRejectButton(notification)
              ? Column(
                  children: [
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: 'Remarks (Optional)',
                          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400, width: .5)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        ),
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: onReject,
                            child: const Text('Reject'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            onPressed: onAccept,
                            child: const Text('Approve', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : SizedBox.shrink(),
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

  bool isShowAcceptRejectButton(NotificationModel notification) {
    if (notification.employeeIdCardNo == DashboardHelpers.currentUser!.iDnum) {
      return false;
    } else if (notification.finalStatus == 1 || notification.finalStatus == 2 || notification.finalStatus == 4) {
      return true;
    } else {
      return false;
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

final List<Map<String, dynamic>> departments = [
  {'id': 0, 'name': 'All'},
  {'id': 1, 'name': 'Accessories'},
  {'id': 2, 'name': 'Accounts & Finance'},
  {'id': 3, 'name': 'Audit & Internal Control'},
  {'id': 4, 'name': 'Business Assessment'},
  {'id': 5, 'name': 'Commercial'},
  {'id': 6, 'name': 'Production & Quality'},
  {'id': 7, 'name': 'Customer Service'},
  {'id': 8, 'name': 'Data Entry'},
  {'id': 9, 'name': 'Design'},
  {'id': 10, 'name': 'HR Admin & Compliance'},
  {'id': 11, 'name': 'IE'},
  {'id': 12, 'name': 'LAB'},
  {'id': 13, 'name': 'Logistic'},
  {'id': 14, 'name': 'Maintenance old'},
  {'id': 15, 'name': 'Management'},
  {'id': 16, 'name': 'Merchandising'},
  {'id': 17, 'name': 'MIS'},
  {'id': 18, 'name': 'Planning'},
  {'id': 19, 'name': 'Product Development'},
  {'id': 20, 'name': 'Production'},
  {'id': 21, 'name': 'Quality Control'},
  {'id': 22, 'name': 'Sales & Marketing'},
  {'id': 23, 'name': 'Sample & CAD'},
  {'id': 24, 'name': 'Store'},
  {'id': 25, 'name': 'Supply Chain'},
  {'id': 26, 'name': 'Technical'},
  {'id': 27, 'name': 'Quality Assurance'},
  {'id': 28, 'name': 'Operations'},
  {'id': 29, 'name': 'Tag'},
  {'id': 30, 'name': 'Design & Product Development'},
  {'id': 31, 'name': 'Extra'},
  {'id': 32, 'name': 'Flexo'},
  {'id': 33, 'name': 'Heat Transfer'},
  {'id': 34, 'name': 'Medical'},
  {'id': 35, 'name': 'PFL'},
  {'id': 36, 'name': 'Pre-Press'},
  {'id': 37, 'name': 'Printing'},
  {'id': 38, 'name': 'Purchase'},
  {'id': 39, 'name': 'Sample & Technical'},
  {'id': 40, 'name': 'Sourcing'},
  {'id': 41, 'name': 'Thermal'},
  {'id': 42, 'name': 'Maintenance'},
  {'id': 43, 'name': 'Woven'},
  {'id': 44, 'name': 'Knitting'},
  {'id': 45, 'name': 'Technical & Planning'},
  {'id': 46, 'name': 'HR & GA'},
  {'id': 47, 'name': 'Facility Maintenance'},
  {'id': 48, 'name': 'Digital Marketing'},
  {'id': 49, 'name': 'Admin & Accounts'},
  {'id': 50, 'name': 'Administration'},
  {'id': 51, 'name': 'Administration'}, // Duplicate ID?
  {'id': 52, 'name': 'Design Studio'},
  {'id': 53, 'name': 'Business Development'},
  {'id': 54, 'name': 'Creative Product Development'},
];



class DepartmentDropdown extends StatefulWidget {
  const DepartmentDropdown({super.key});

  @override
  State<DepartmentDropdown> createState() => _DepartmentDropdownState();
}

class _DepartmentDropdownState extends State<DepartmentDropdown> {
  Map<String, dynamic>? selectedDepartment;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(  // Removes default underline
      child: DropdownButton<Map<String, dynamic>>(
        isDense: true,  // Reduces overall padding
        value: selectedDepartment,
        items: departments.map((department) {
          return DropdownMenuItem<Map<String, dynamic>>(
            value: department,
            child: Padding(
              padding: EdgeInsets.zero,  // Explicit zero padding
              child: Text(
                DashboardHelpers.truncateString(department['name'], 12),
                style: Theme.of(context).textTheme.bodyMedium,  // Inherits text style
              ),
            ),
          );
        }).toList(),
        onChanged: (Map<String, dynamic>? newValue) {
          setState(() {
            selectedDepartment = newValue;
          });
          if (newValue != null) {
            print('Selected Department ID: ${newValue['id']}');
            print('Selected Department Name: ${newValue['name']}');
            var np=context.read<NotificationProvider>();
            np.getFilterNotification(newValue['id']);
          }
        },
        hint: const Padding(  // Hint with zero padding
          padding: EdgeInsets.zero,
          child: Text('Select'),
        ),
      ),
    );
  }
}