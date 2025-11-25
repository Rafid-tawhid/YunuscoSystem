import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../models/appointment_model.dart';
import '../../providers/riverpods/management_provider.dart';
import '../notification_screen.dart';
import 'appointment_create_screen.dart';

class AppointmentListScreen extends ConsumerWidget {
  const AppointmentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(allAppointmentListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, ref),
      body: _buildBody(context, ref, appointmentsAsync),
    );
  }

  AppBar _buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const Text('Appointments'),
      backgroundColor: myColors.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () => _navigateToCreateAppointment(context),
          icon: const Icon(Icons.add, color: Colors.white),
        ),
        IconButton(
          onPressed: () => _refreshAppointments(ref),
          icon: const Icon(Icons.refresh, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, AsyncValue<List<AppointmentModel>> appointmentsAsync) {
    return appointmentsAsync.when(
      loading: () => _buildLoadingState(),
      error: (error, stack) => _buildErrorState(error, stack, ref),
      data: (appointments) => _buildAppointmentsList(context, ref, appointments),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState(Object error, StackTrace stack, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error loading appointments',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _refreshAppointments(ref),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(BuildContext context, WidgetRef ref, List<AppointmentModel> appointments) {
    if (appointments.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return _buildAppointmentCard(context, ref, appointment);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.calendar_today, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No Appointments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first appointment',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _navigateToCreateAppointment(context),
            child: const Text('Create Appointment'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(BuildContext context, WidgetRef ref, AppointmentModel appointment) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(appointment, context, ref),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 16),
            _buildEmployeeInfo(appointment),
            const SizedBox(height: 16),
            _buildPurposeSection(appointment),
            const SizedBox(height: 16),
            _buildDateTimeSection(context, ref, appointment),
            const SizedBox(height: 16),
            _buildFooter(appointment),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader(AppointmentModel appointment, BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '#Appointment: ${appointment.appointmentId ?? 'N/A'}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'With: ${appointment.appointmentWith ?? 'N/A'}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        _buildStatusChip(appointment, context, ref),
      ],
    );
  }

  Widget _buildStatusChip(AppointmentModel appointment, BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        if (appointment.status == 'Waiting') {
          _showMeetingCompletionDialog(context, appointment, ref);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: _getStatusColor(appointment.status ?? '').withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _getStatusColor(appointment.status ?? ''),
            width: 1.5,
          ),
        ),
        child: Text(
          appointment.status == '' ? 'Pending' : appointment.status ?? 'N/A',
          style: TextStyle(
            color: _getStatusColor(appointment.status ?? ''),
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeInfo(AppointmentModel appointment) {
    return Column(
      children: [
        Row(
          children: [
            _buildInfoChip(Icons.person, appointment.employeeName ?? 'N/A'),
            const SizedBox(width: 8),
            _buildInfoChip(Icons.badge, appointment.designation ?? 'N/A'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildInfoChip(Icons.badge,departments.firstWhere((e)=>e['id']==int.parse(appointment.department.toString()),orElse: ()=>{'name':'N/A'})['name']??'N/A'),
            const SizedBox(width: 8),
            _buildInfoChip(Icons.fingerprint, appointment.employeeId ?? 'N/A'),
          ],
        ),
      ],
    );
  }

  Widget _buildPurposeSection(AppointmentModel appointment) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description, size: 16, color: Colors.blue.shade600),
              const SizedBox(width: 6),
              Text(
                'Purpose',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            appointment.purpose ?? 'N/A',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeSection(BuildContext context, WidgetRef ref, AppointmentModel appointment) {
    if (appointment.managerScheduledDate != null) {
      return _buildManagerScheduledSection(appointment);
    } else {
      return GestureDetector(
        onTap: () {
          if(DashboardHelpers.currentUser!.department=='15'||DashboardHelpers.currentUser!.iDnum=='38389'){
            _showAppointmentOptionsDialog(context, appointment, ref);
          }
        },
        child: _buildRequestedDateTimeSection(appointment),
      );
    }
  }

  Widget _buildManagerScheduledSection(AppointmentModel appointment) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.shade100),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, size: 16, color: Colors.green.shade700),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Scheduled by Management',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade800,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildDateTimeItem(
                  Icons.calendar_today,
                  'Scheduled Date',
                  _formatDate(appointment.managerScheduledDate.toString()),
                  Colors.green.shade700,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.green.shade200,
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
              Expanded(
                child: _buildDateTimeItem(
                  Icons.access_time,
                  'Scheduled Time',
                  _formatTime(appointment.managerScheduledTime?.toString()),
                  Colors.green.shade700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRequestedDateTimeSection(AppointmentModel appointment) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildDateTimeItem(
              Icons.calendar_today,
              'Requested Date',
              _formatDate(appointment.preferredDate),
              Colors.blue.shade700,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.blue.shade200,
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
          Expanded(
            child: _buildDateTimeItem(
              Icons.access_time,
              'Requested Time',
              _formatTime(appointment.preferredTime),
              Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(AppointmentModel appointment) {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_month, size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(
                'Created: ${_formatDate(appointment.createdDate)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          Text(
            'By: ${appointment.createdBy ?? 'N/A'}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Helper Methods
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'waiting':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.grey.shade600),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeItem(IconData icon, String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';

    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _formatTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return 'N/A';

    try {
      if (timeString.contains('T')) {
        final date = DateTime.parse('2024-01-01$timeString');
        return DashboardHelpers.convertDateTime(date.toString(), pattern: 'hh:mm a');
      } else if (timeString.length == 8 && timeString.contains(':')) {
        final timeParts = timeString.split(':');
        final hour = int.parse(timeParts[0]);
        final minute = timeParts[1];
        final displayHour = hour > 12 ? hour - 12 : hour;
        // final period = hour >= 12 ? 'PM' : 'AM';
        return '$displayHour:$minute';
      } else {
        return timeString;
      }
    } catch (e) {
      return timeString;
    }
  }

  // Navigation and Actions
  void _navigateToCreateAppointment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateAppointmentScreen()),
    );
  }

  Future<void> _refreshAppointments(WidgetRef ref) async {
    ref.invalidate(allAppointmentListProvider);
  }

  // Dialog Methods
  void _showAppointmentOptionsDialog(BuildContext context, AppointmentModel appointment, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) => _buildAppointmentOptionsDialog(context, appointment, ref),
    );
  }

  Widget _buildAppointmentOptionsDialog(BuildContext context, AppointmentModel appointment, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.calendar_today, size: 32, color: Colors.blue[700]),
            ),
            const SizedBox(height: 16),
            Text(
              'Appointment Options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'What would you like to do with this appointment?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                _buildDialogButton(
                  text: 'Accept Appointment',
                  icon: Icons.check_circle,
                  color: Colors.green,
                  onPressed: () => _handleAcceptAppointment(context, appointment, ref),
                ),
                const SizedBox(height: 12),
                _buildDialogButton(
                  text: 'Reschedule',
                  icon: Icons.schedule,
                  color: Colors.blue,
                  isOutlined: true,
                  onPressed: () => _handleReschedule(context, appointment, ref),
                ),
                const SizedBox(height: 12),
                _buildDialogButton(
                  text: 'Cancel',
                  icon: Icons.close,
                  color: Colors.grey,
                  isTextButton: true,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogButton({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    bool isOutlined = false,
    bool isTextButton = false,
  }) {
    if (isTextButton) {
      return SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[600],
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    if (isOutlined) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: BorderSide(color: color.withOpacity(0.7)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  void _showMeetingCompletionDialog(BuildContext context, AppointmentModel appointment, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) => _buildMeetingCompletionDialog(context, appointment, ref),
    );
  }

  Widget _buildMeetingCompletionDialog(BuildContext context, AppointmentModel appointment, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey[50]!],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.orange[100]!, Colors.orange[50]!]),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.orange[200]!, width: 2),
              ),
              child: Icon(Icons.timer_off_rounded, size: 40, color: Colors.orange[700]),
            ),
            const SizedBox(height: 20),
            Text('Meeting Status', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[800])),
            const SizedBox(height: 16),
            Text('Has this meeting been completed?', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            const SizedBox(height: 8),
            Text('This will update the meeting status in your records', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.grey[500])),
            const SizedBox(height: 28),
            Container(
              height: 4,
              width: 100,
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(2)),
              child: Stack(children: [Container(width: 60, decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blue[400]!, Colors.blue[600]!]), borderRadius: BorderRadius.circular(2)))]),
            ),
            const SizedBox(height: 28),
            Row(children: [
              _buildCompletionDialogButton(text: 'Still Going', icon: Icons.close, color: Colors.grey, onPressed: () => Navigator.of(context).pop()),
              const SizedBox(width: 6),
              _buildCompletionDialogButton(text: 'Completed', icon: Icons.check, color: Colors.green, onPressed: () => _handleMarkCompleted(context, appointment, ref)),
            ]),
            const SizedBox(height: 8),
            TextButton(onPressed: () => Navigator.of(context).pop(), style: TextButton.styleFrom(foregroundColor: Colors.grey[500]), child: const Text('Cancel', style: TextStyle(fontSize: 14, decoration: TextDecoration.underline))),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionDialogButton({required String text, required IconData icon, required Color color, required VoidCallback onPressed}) {
    return Expanded(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color == Colors.green ? Colors.transparent : Colors.grey[300]!),
          gradient: color == Colors.green ? LinearGradient(colors: [Colors.green[500]!, Colors.green[600]!]) : null,
          color: color == Colors.green ? null : Colors.transparent,
          boxShadow: color == Colors.green ? [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : null,
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: color == Colors.green ? Colors.white : Colors.grey[700],
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(text, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))]),
        ),
      ),
    );
  }

  // API Handlers
  Future<void> _handleAcceptAppointment(BuildContext context, AppointmentModel appointment, WidgetRef ref) async {
    Navigator.of(context).pop();

    final data = {
      "appointmentId": appointment.appointmentId,
      "status": "Waiting",
      "managerScheduledDate": appointment.preferredDate,
      "managerScheduledTime": appointment.preferredTime,
      "updatedBy": DashboardHelpers.currentUser!.iDnum
    };

    try {
      final res = await apiService.postData('api/Support/schedule', data);
      if (res != null) {
        DashboardHelpers.showAlert(msg: 'Appointment accepted successfully');
        _refreshAppointments(ref); // Refresh the list
      }
    } catch (e) {
      DashboardHelpers.showAlert(msg: 'Error accepting appointment: $e');
    }
  }

  Future<void> _handleReschedule(BuildContext context, AppointmentModel appointment, WidgetRef ref) async {
    Navigator.of(context).pop();

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      await _callRescheduleApi(appointment, selectedTime, context, ref);
    }
  }

  Future<void> _callRescheduleApi(AppointmentModel appointment, TimeOfDay newTime, BuildContext context, WidgetRef ref) async {
    final newTimeString = "${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}:00";

    final data = {
      "appointmentId": appointment.appointmentId,
      "status": "Waiting",
      "managerScheduledDate": appointment.preferredDate,
      "managerScheduledTime": newTimeString,
      "updatedBy": DashboardHelpers.currentUser!.iDnum
    };

    try {
      final res = await apiService.postData('api/Support/schedule', data);
      if (res != null) {
        DashboardHelpers.showAlert(msg: 'Appointment time updated to $newTimeString');
        _refreshAppointments(ref); // Refresh the list
      }
    } catch (e) {
      DashboardHelpers.showAlert(msg: 'Error rescheduling appointment: $e');
    }
  }

  Future<void> _handleMarkCompleted(BuildContext context, AppointmentModel appointment, WidgetRef ref) async {
    Navigator.of(context).pop();

    final data = {
      "appointmentId": appointment.appointmentId,
      "status": "Completed",
      "managerScheduledDate": appointment.managerScheduledDate,
      "managerScheduledTime": appointment.managerScheduledTime,
      "updatedBy": DashboardHelpers.currentUser!.iDnum
    };

    try {
      final res = await apiService.postData('api/Support/schedule', data);
      if (res != null) {
        DashboardHelpers.showAlert(msg: 'Appointment Completed Successfully');
        _refreshAppointments(ref); // Refresh the list
      }
    } catch (e) {
      DashboardHelpers.showAlert(msg: 'Error completing appointment: $e');
    }
  }
}