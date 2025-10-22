// lib/screens/create_meeting_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/models/board_room_booking_model.dart';

import '../../providers/riverpods/meeting_provider.dart';

class CreateMeetingScreen extends ConsumerStatefulWidget {
  const CreateMeetingScreen({super.key});

  @override
  ConsumerState<CreateMeetingScreen> createState() => _CreateMeetingScreenState();
}

class _CreateMeetingScreenState extends ConsumerState<CreateMeetingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _attendeesController = TextEditingController();
  final TextEditingController _agendaController = TextEditingController();
  final TextEditingController _decisionsController = TextEditingController();
  final TextEditingController _actionItemsController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime _startTime = DateTime.now().add(const Duration(hours: 1));
  DateTime _endTime = DateTime.now().add(const Duration(hours: 2));

  @override
  void dispose() {
    _titleController.dispose();
    _emailController.dispose();
    _departmentController.dispose();
    _attendeesController.dispose();
    _agendaController.dispose();
    _decisionsController.dispose();
    _actionItemsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectStartTime() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_startTime),
      );

      if (time != null) {
        setState(() {
          _startTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
          // Auto-set end time to 1 hour after start
          _endTime = _startTime.add(const Duration(hours: 1));
        });
      }
    }
  }

  Future<void> _selectEndTime() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endTime,
      firstDate: _startTime,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_endTime),
      );

      if (time != null) {
        setState(() {
          _endTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {

      final meeting={
        "MeetingTitle": _titleController.text.trim(),
        "OrganizerName": DashboardHelpers.currentUser!.userName,
        "OrganizerUserId": DashboardHelpers.currentUser!.iDnum,
        "OrganizerEmail": "hello@gmail.com",
        "Department": DashboardHelpers.currentUser!.department,
        "StartTime": convertDateTime(_startTime.toString()),
        "EndTime": convertDateTime(_endTime.toString()),
        "Attendees":_attendeesController.text.trim(),
        "Agenda": _agendaController.text.trim(),
        "Decisions": "N/A",
        "ActionItems": _actionItemsController.text.trim().isEmpty ? null : _actionItemsController.text.trim(),
        "Notes": _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        "Status": "Confirmed",
        "CreatedDate": convertDateTime(DateTime.now().toString())
      };
      //{
      //    "MeetingTitle": "Quarterly  Meeting",
      //   "OrganizerName": "Tawhidur Rahman 2 ",
      //   "OrganizerUserId": "usr_1001",
      //   "OrganizerEmail": "tawhidur.rahman@company.com",
      //   "Department": "Product Development",
      //   "StartTime": "2025-10-23T15:00:00Z",
      //   "EndTime": "2025-10-23T15:30:00Z",
      //   "Attendees": "Alice Smith, Bob Rahman, Carol Hossain",
      //   "Agenda": "Discuss Q4 goals, budget planning, and feature roadmap.",
      //   "Decisions": "Finalize release schedule and assign key milestones.",
      //   "ActionItems": "Bob to prepare the updated feature list; Carol to draft the Q4 budget.",
      //   "Notes": "All attendees agreed on the roadmap timeline; follow-up scheduled next week.",
      //   "Status": "Confirmed",
      //   "CreatedDate": "2025-10-20T08:45:00Z"
      // }

      final success = await ref.read(createMeetingProvider.notifier).createMeeting(meeting);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Meeting created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return success
      }
    }



  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(createMeetingProvider.notifier).clearError();
    });
  }

  //
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Clear error when dependencies change (screen becomes active)
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     ref.read(createMeetingProvider.notifier).clearError();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final createMeetingState = ref.watch(createMeetingProvider);


    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create New Meeting',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2C5530),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Organizer Name
              Text('Meeting Created by ${DashboardHelpers.currentUser!.userName}'),
              SizedBox(height: 12,),
              // Meeting Title
              _buildTextField(
                controller: _titleController,
                label: 'Meeting Title *',
                hintText: 'Enter meeting title',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter meeting title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Department
              _buildTextField(
                controller: _departmentController,
                label: 'Department *',
                hintText: 'Enter department',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter department';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Date & Time Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Meeting Time *',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Start Time
                    _buildTimeSelector(
                      label: 'Start Time',
                      time: _startTime,
                      onTap: _selectStartTime,
                    ),
                    const SizedBox(height: 12),

                    // End Time
                    _buildTimeSelector(
                      label: 'End Time',
                      time: _endTime,
                      onTap: _selectEndTime,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Attendees
              _buildTextField(
                controller: _attendeesController,
                label: 'Attendees *',
                hintText: 'Enter attendee names (comma separated)',
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter attendees';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Agenda
              _buildTextField(
                controller: _agendaController,
                label: 'Agenda *',
                hintText: 'Enter meeting agenda',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter agenda';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // // Decisions (Optional)
              // _buildTextField(
              //   controller: _decisionsController,
              //   label: 'Decisions (Optional)',
              //   hintText: 'Enter key decisions',
              //   maxLines: 2,
              // ),
              // const SizedBox(height: 16),
              //
              // // Action Items (Optional)
              // _buildTextField(
              //   controller: _actionItemsController,
              //   label: 'Action Items (Optional)',
              //   hintText: 'Enter action items',
              //   maxLines: 2,
              // ),
              // const SizedBox(height: 16),

              // Notes (Optional)
              _buildTextField(
                controller: _notesController,
                label: 'Notes (Optional)',
                hintText: 'Enter additional notes',
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Error Message
              Visibility(
                visible: createMeetingState.error!=null,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Text(
                    createMeetingState.error ?? 'No error',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: createMeetingState.isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C5530),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: createMeetingState.isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : const Text(
                    'Create Meeting',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF2C5530), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelector({
    required String label,
    required DateTime time,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(
              label.contains('Start') ? Icons.play_arrow : Icons.stop,
              color: const Color(0xFF2C5530),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_formatDate(time)} at ${_formatTime(time)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String convertDateTime(String input) {
    try {
      // Parse the input string to DateTime
      DateTime dt = DateTime.parse(input);

      // Optional: adjust time if needed (e.g., round minutes)
      // dt = DateTime(dt.year, dt.month, dt.day, 19, 0, 0);

      // Format as 2025-10-22T19:30:00 (ISO format without milliseconds)
      final formatted = dt.toIso8601String().split('.').first;
      return formatted;
    } catch (e) {
      // If parsing fails, return current date/time formatted
      final now = DateTime.now();
      return now.toIso8601String().split('.').first;
    }
  }


}