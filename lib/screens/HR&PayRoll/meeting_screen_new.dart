// lib/screens/meetings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/common_widgets/custom_button.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/models/board_room_booking_model.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../providers/riverpods/meeting_provider.dart';
import 'create_a_meeting.dart';

class MeetingsScreen extends ConsumerStatefulWidget {
  const MeetingsScreen({super.key});

  @override
  ConsumerState<MeetingsScreen> createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends ConsumerState<MeetingsScreen> {
  @override
  void initState() {
    super.initState();
    // Load meetings when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(meetingProvider.notifier).getMeetings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final meetingState = ref.watch(meetingProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Meetings'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(meetingProvider.notifier).getMeetings(),
          ),
        ],
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.zero, // Set minimum size to zero
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: Colors.green.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6), // ← Adjust this value
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateMeetingScreen()));
                  },
                  child: Text(
                    'Create +',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ),
          Expanded(child: _buildBody(meetingState)),
        ],
      ),
    );
  }

  Widget _buildBody(MeetingListState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${state.error}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(meetingProvider.notifier).getMeetings(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.data.isEmpty) {
      return const Center(child: Text('No meetings found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.data.length,
      itemBuilder: (context, index) {
        final meeting = state.data[index];
        return _buildMeetingCard(meeting);
      },
    );
  }

  Widget _buildMeetingCard(BoardRoomBookingModel meeting) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    meeting.meetingTitle ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(meeting.status ?? ''),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    meeting.status ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Organizer and Department
            Text(
              'Organizer: ${meeting.organizerName} • ${meeting.department}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),

            // Highlighted Date and Time Section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 18, color: Colors.blue[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatDate(DashboardHelpers.parseDateOrNow(meeting.startTime)),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 14, color: Colors.blue[700]),
                            const SizedBox(width: 4),
                            Text(
                              '${_formatTime(DashboardHelpers.parseDateOrNow(meeting.startTime))} - ${_formatTime(DashboardHelpers.parseDateOrNow(meeting.endTime))}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Attendees
            _buildInfoRow('Attendees:', meeting.attendees ?? ''),
            const SizedBox(height: 8),

            // Agenda
            _buildInfoRow('Agenda:', meeting.agenda ?? ''),
            const SizedBox(height: 8),

            // Decisions (if available)
            if (meeting.decisions != null && meeting.decisions!.isNotEmpty) ...[
              _buildInfoRow('Decisions:', meeting.decisions ?? ''),
              const SizedBox(height: 8),
            ],

            // Action Items (if available)
            if (meeting.actionItems != null && meeting.actionItems!.isNotEmpty) ...[
              _buildInfoRow('Action Items:', meeting.actionItems ?? ''),
              const SizedBox(height: 8),
            ],

            // Notes (if available)
            if (meeting.notes != null && meeting.notes!.isNotEmpty) ...[
              _buildInfoRow('Notes:', meeting.notes ?? ''),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
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

  String _formatDate(DateTime dateTime) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return '${days[dateTime.weekday - 1]}, ${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
