import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/models/JobCardDropdownModel.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import 'package:yunusco_group/providers/riverpods/meeting_provider.dart';
import 'package:yunusco_group/screens/HR&PayRoll/widgets/selected_peoples.dart';
import 'package:yunusco_group/screens/notification_screen.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../providers/riverpods/purchase_order_riverpod.dart';
import 'members_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CreateMeetingScreen extends ConsumerStatefulWidget {
  const CreateMeetingScreen({super.key});

  @override
  ConsumerState<CreateMeetingScreen> createState() => _CreateMeetingScreenState();
}

class _CreateMeetingScreenState extends ConsumerState<CreateMeetingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _attendeesController = TextEditingController();
  final TextEditingController _agendaController = TextEditingController();
  final TextEditingController _actionItemsController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime _startTime = DateTime.now().add(const Duration(hours: 1));
  DateTime _endTime = DateTime.now().add(const Duration(hours: 2));
  bool _isSubmitting=false;

  @override
  void dispose() {
    _titleController.dispose();
    _attendeesController.dispose();
    _agendaController.dispose();
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
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final dept=ref.read(selectedDeptProvider);

    final meeting = {
      "MeetingTitle": _titleController.text.trim(),
      "OrganizerName": DashboardHelpers.currentUser!.userName,
      "OrganizerUserId": DashboardHelpers.currentUser!.iDnum,
      "OrganizerEmail": "hello@gmail.com",
      "Department": dept!.name,
      "StartTime": convertDateTime(_startTime.toString()),
      "EndTime": convertDateTime(_endTime.toString()),
      "Attendees": _attendeesController.text.trim(),
      "Agenda": _agendaController.text.trim(),
      "Decisions": "N/A",
      "ActionItems": _actionItemsController.text.trim().isEmpty ? null : _actionItemsController.text.trim(),
      "Notes": _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      "Status": "Confirmed",
      "CreatedDate": convertDateTime(DateTime.now().toString())
    };

    try {
      debugPrint('1. Calling API directly...');

      // Call the API service directly instead of using FutureProvider
      final apiService = ref.read(apiServiceProvider);
      final response = await apiService.postDataWithReturn('api/support/CreateBoardBooking', meeting);

      debugPrint('2. Got response: $response');

      if (response['success'] == true) {
        debugPrint('3. Success - showing snackbar');

        var pp=context.read<HrProvider>();
        final selectedMembers = pp.member_list.where((m) => m.isSelected).toList();
        for (var e in selectedMembers) {
          pp.sendNotification(
              sendTo: e.idCardNo.toString(),
              title:_titleController.text,
              body:"Invitation for a meeting at ${formatDateTime(_startTime)} from ${DashboardHelpers.currentUser!.userName}",
              type:"BoardMeeting"
          );
        }


        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Meeting created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        throw Exception(response['message'] ?? 'Failed to create meeting');
      }
    } catch (error) {
      debugPrint('4. Error: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      debugPrint('5. Finally block - resetting loading state');
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final deptAsync = ref.watch(allDeptList);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create New Meeting',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[50],
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Header Card
                Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFF2C5530).withOpacity(0.1),
                          child: const Icon(Icons.person, color: Color(0xFF2C5530)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Created by ${DashboardHelpers.currentUser!.userName}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2C5530),
                                ),
                              ),
                              Text(
                                departments.firstWhere((e)=>e['id']==int.parse(DashboardHelpers.currentUser!.department??'0'))['name'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Meeting Title
                _buildTextField(
                  controller: _titleController,
                  label: 'Meeting Title *',
                  hintText: 'Enter meeting title',
                  icon: Icons.title,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter meeting title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Department
                // _buildTextField(
                //   controller: _departmentController,
                //   label: 'Department *',
                //   hintText: 'Enter department',
                //   icon: Icons.business,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter department';
                //     }
                //     return null;
                //   },
                // ),

                _buildDepartmentDropdown(deptAsync, ref),
                const SizedBox(height: 16),

                // Date & Time Section
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.blue[700], size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Meeting Time *',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildTimeSelector(
                          label: 'Start Time',
                          time: _startTime,
                          onTap: _selectStartTime,
                        ),
                        const SizedBox(height: 12),
                        _buildTimeSelector(
                          label: 'End Time',
                          time: _endTime,
                          onTap: _selectEndTime,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                PersonSelectionScreen())).then((persons) {
                      if (persons != null) {
                        debugPrint('person $persons');
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      children: [
                        Icon(Icons.person_add),
                        SizedBox(width: 12,),
                        Text('Invite People for the Meeting')
                      ],
                    ),
                  ),
                ),

                SelectedPeopleWidget(),

                // Attendees
                _buildTextField(
                  controller: _attendeesController,
                  label: 'Attendees *',
                  hintText: 'Enter attendee names (comma separated)',
                  icon: Icons.people,
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
                  icon: Icons.description,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter agenda';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Notes (Optional)
                _buildTextField(
                  controller: _notesController,
                  label: 'Notes (Optional)',
                  hintText: 'Enter additional notes',
                  icon: Icons.note,
                  maxLines: 3,
                ),
                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed:_submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C5530),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      shadowColor: const Color(0xFF2C5530).withOpacity(0.3),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Create Meeting',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
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
            prefixIcon: Icon(icon, color: const Color(0xFF2C5530)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Color(0xFF2C5530), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(10),
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
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C5530),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.grey, size: 24),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String convertDateTime(String input) {
    try {
      final DateTime dt = DateTime.parse(input);
      return dt.toIso8601String().split('.').first;
    } catch (e) {
      final DateTime now = DateTime.now();
      return now.toIso8601String().split('.').first;
    }
  }


  String formatDateTime(DateTime dateTime) {
    // Format date part (Jan 15, 2024)
    final datePart = DateFormat('MMM dd, yyyy').format(dateTime);

    // Format time part with AM/PM (02:30 PM)
    final timePart = DateFormat('hh:mm a').format(dateTime);

    return '$datePart at $timePart';
  }

  static String _formatTimeAMPM(DateTime dateTime) {
    final String period = dateTime.hour < 12 ? 'AM' : 'PM';
    final int hour = dateTime.hour == 0 ? 12 : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);

    return '${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $period';
  }


    Widget _buildDepartmentDropdown(AsyncValue<List<Departments>> deptAsync, WidgetRef ref) {
      return deptAsync.when(
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => Text('Error: $error'),
        data: (departments) {
          return DropdownButtonFormField<Departments>(
            value: ref.read(selectedDeptProvider),
            decoration: const InputDecoration(
              labelText: 'Select Department',
              border: OutlineInputBorder(),
            ),
            items: departments.map((dept) {
              return DropdownMenuItem<Departments>(
                value: dept,
                child: Text(dept.name ?? 'Unknown'),
              );
            }).toList(),
            onChanged: (Departments? newValue) {
              ref.read(selectedDeptProvider.notifier).state = newValue;
            },
          );
        },
      );
    }

}