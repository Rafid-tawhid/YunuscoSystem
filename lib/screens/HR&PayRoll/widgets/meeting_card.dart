import 'package:flutter/material.dart';

import '../../../helper_class/dashboard_helpers.dart';
import '../../../models/board_room_booking_model.dart';
import 'meeting_details.dart';

class MeetingCard extends StatefulWidget {
  final BoardRoomBookingModel meeting;
  final Function(BoardRoomBookingModel) onDelete;

  const MeetingCard({
    super.key,
    required this.meeting,
    required this.onDelete,
  });

  @override
  State<MeetingCard> createState() => _MeetingCardState();
}

class _MeetingCardState extends State<MeetingCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        onLongPress: () {
          showDeleteBookingBottomSheet(
            context: context,
            meetingTitle: widget.meeting.meetingTitle ?? 'Untitled Meeting',
            onDeleteConfirmed: () {
              widget.onDelete(widget.meeting);
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Collapsed view - Time, Title, Organizer
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time section
                  Container(
                    width: 70,
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _formatTimeWithAmPm(DashboardHelpers.parseDateOrNow(widget.meeting.startTime)),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                        Text(
                          _getAmPm(DashboardHelpers.parseDateOrNow(widget.meeting.startTime)),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Title and organizer
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.meeting.meetingTitle ?? 'Untitled Meeting',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'By ${widget.meeting.organizerName}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Expand icon and status
                  Column(
                    children: [
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getStatusColor(widget.meeting.status ?? ''),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          widget.meeting.status ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Expanded details
              if (_isExpanded) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),

                // Date and full time
                _buildDetailRow(
                  icon: Icons.calendar_today,
                  title: 'Date & Time',
                  value: '${_formatDate(DashboardHelpers.parseDateOrNow(widget.meeting.startTime))} • ${_formatTimeWithAmPm(DashboardHelpers.parseDateOrNow(widget.meeting.startTime))} ${_getAmPm(DashboardHelpers.parseDateOrNow(widget.meeting.startTime))} - ${_formatTimeWithAmPm(DashboardHelpers.parseDateOrNow(widget.meeting.endTime))} ${_getAmPm(DashboardHelpers.parseDateOrNow(widget.meeting.endTime))}',
                ),

                const SizedBox(height: 8),

                // Department
                _buildDetailRow(
                  icon: Icons.business,
                  title: 'Department',
                  value: widget.meeting.department ?? 'Not specified',
                ),

                const SizedBox(height: 8),

                // Attendees
                if (widget.meeting.attendees != null && widget.meeting.attendees!.isNotEmpty)
                  _buildDetailRow(
                    icon: Icons.people,
                    title: 'Attendees',
                    value: widget.meeting.attendees!,
                  ),

                // Agenda
                if (widget.meeting.agenda != null && widget.meeting.agenda!.isNotEmpty)
                  _buildDetailRow(
                    icon: Icons.list,
                    title: 'Agenda',
                    value: widget.meeting.agenda!,
                  ),

                // Decisions
                if (widget.meeting.decisions != null && widget.meeting.decisions!.isNotEmpty)
                  _buildDetailRow(
                    icon: Icons.check_circle,
                    title: 'Decisions',
                    value: widget.meeting.decisions!,
                  ),

                // Action Items
                if (widget.meeting.actionItems != null && widget.meeting.actionItems!.isNotEmpty)
                  _buildDetailRow(
                    icon: Icons.playlist_add_check,
                    title: 'Action Items',
                    value: widget.meeting.actionItems!,
                  ),

                // Notes
                if (widget.meeting.notes != null && widget.meeting.notes!.isNotEmpty)
                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailRow(
                          icon: Icons.note,
                          title: 'Notes',
                          value: widget.meeting.notes!,
                        ),
                      ),
                      IconButton(onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MeetingDetailsScreen(meeting: widget.meeting),
                          ),
                        );

                      }, icon: Icon(Icons.info_outline))
                    ],
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showDeleteBookingBottomSheet({
    required BuildContext context,
    required String meetingTitle,
    required VoidCallback onDeleteConfirmed,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.red.shade600,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Delete Meeting',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          meetingTitle,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Warning message
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'This action cannot be undone. The meeting will be permanently deleted.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.orange.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Action buttons
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey.shade400),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Delete button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close bottom sheet
                        onDeleteConfirmed(); // Call delete function
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTimeWithAmPm(DateTime dateTime) {
    final hour = dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '${hour == 0 ? 12 : hour}:$minute';
  }

  String _getAmPm(DateTime dateTime) {
    return dateTime.hour < 12 ? 'AM' : 'PM';
  }

  String _formatDate(DateTime dateTime) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}