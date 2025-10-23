// lib/screens/meetings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/common_widgets/custom_button.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/models/board_room_booking_model.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../providers/riverpods/meeting_provider.dart';
import '../../providers/riverpods/purchase_order_riverpod.dart';
import 'create_a_meeting.dart';

class MeetingsScreen extends ConsumerStatefulWidget {
  const MeetingsScreen({super.key});

  @override
  ConsumerState<MeetingsScreen> createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends ConsumerState<MeetingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Meetings'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blueGrey[50], // Background color for the whole tab bar
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: myColors.primaryColor, // Background color of selected tab
                borderRadius: BorderRadius.circular(1), // Rounded corners
              ),
              indicatorSize: TabBarIndicatorSize.tab, // Make indicator cover the full tab
              labelColor: Colors.white, // Text color when selected
              unselectedLabelColor: Colors.black, // Text color when not selected
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
              tabs: const [
                Tab(text: "Today's Bookings"),
                Tab(text: 'All Bookings'),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: Colors.green.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateMeetingScreen()));
                },
                child: const Text(
                  'Create +',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Today's Bookings Tab
                Consumer(
                  builder: (context, ref, child) {
                    final todaysBookings = ref.watch(todaysBookingsProvider);
                    return todaysBookings.when(
                      data: (bookings) => _buildBody(bookings, isToday: true),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Error: $error', style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => ref.refresh(todaysBookingsProvider),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // All Bookings Tab
                Consumer(
                  builder: (context, ref, child) {
                    final allBookings = ref.watch(allBookingsProvider);
                    return allBookings.when(
                      data: (bookings) => _buildBody(bookings, isToday: false),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Error: $error', style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => ref.refresh(allBookingsProvider),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Rest of your _buildBody, _buildMeetingCard methods remain the same...


  Widget _buildBody(List<BoardRoomBookingModel> data, {required bool isToday}) {
    if (data.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              isToday ? 'No meetings for today' : 'No meetings found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isToday ? 'All clear for today!' : 'Create your first meeting',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final meeting = data[index];
        return _buildMeetingCard(meeting);
      },
    );
  }

  Widget _buildMeetingCard(BoardRoomBookingModel meeting) {
    return InkWell(
      onLongPress: (){
        showDeleteBookingBottomSheet(
          context: context,
          meetingTitle: meeting.meetingTitle ?? 'Untitled Meeting',
          onDeleteConfirmed: () {
            _deleteBooking(meeting); // Your delete function
          },
        );
      },
      child: Card(
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

  void _deleteBooking(BoardRoomBookingModel meeting) async {

    final apiService = ref.read(apiServiceProvider);
    final response = await apiService.deleteData('api/support/CancelBoardBooking/${meeting.id}');
    debugPrint('Response ${response}');
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
}