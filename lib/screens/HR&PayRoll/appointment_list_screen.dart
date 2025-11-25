import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../models/appointment_model.dart';
import '../../providers/riverpods/management_provider.dart';
import 'appointment_create_screen.dart';

class AppointmentListScreen extends ConsumerWidget {
  const AppointmentListScreen({super.key});

  // Helper method to get status color
  Color getStatusColor(String status) {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(allAppointmentListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Appointments'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateAppointmentScreen()));
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              ref.invalidate(allAppointmentListProvider);
            },
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: appointmentsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
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
                onPressed: () {
                  ref.invalidate(allAppointmentListProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (appointments) {
          if (appointments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_today,
                      size: 64, color: Colors.grey),
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CreateAppointmentScreen()));
                    },
                    child: const Text('Create Appointment'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(allAppointmentListProvider);
            },
            child: ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return Card(
                  color: Colors.white,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with Appointment Number and Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '#${appointment.appointmentNumber ?? 'N/A'}',
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
                            GestureDetector(
                              onTap: (){
                                if(appointment.status=='Waiting') {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(24.0),
                                        ),
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
                                              // Animated Icon
                                              Container(
                                                padding: const EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [Colors.orange[100]!, Colors.orange[50]!],
                                                  ),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: Colors.orange[200]!, width: 2),
                                                ),
                                                child: Icon(
                                                  Icons.timer_off_rounded,
                                                  size: 40,
                                                  color: Colors.orange[700],
                                                ),
                                              ),

                                              const SizedBox(height: 20),

                                              // Title
                                              Text(
                                                'Meeting Status',
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[800],
                                                  letterSpacing: -0.5,
                                                ),
                                              ),

                                              const SizedBox(height: 16),

                                              // Content
                                              Text(
                                                'Has this meeting been completed?',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[600],
                                                  height: 1.5,
                                                ),
                                              ),

                                              const SizedBox(height: 8),

                                              // Additional info
                                              Text(
                                                'This will update the meeting status in your records',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[500],
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),

                                              const SizedBox(height: 28),

                                              // Progress indicator (optional visual element)
                                              Container(
                                                height: 4,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius: BorderRadius.circular(2),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      width: 60,
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                          colors: [Colors.blue[400]!, Colors.blue[600]!],
                                                        ),
                                                        borderRadius: BorderRadius.circular(2),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              const SizedBox(height: 28),

                                              // Buttons
                                              Row(
                                                children: [
                                                  // No - Meeting not finished
                                                  Expanded(
                                                    child: Container(
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(14),
                                                        border: Border.all(color: Colors.grey[300]!),
                                                      ),
                                                      child: TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();

                                                        },
                                                        style: TextButton.styleFrom(
                                                          foregroundColor: Colors.grey[700],
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(14),
                                                          ),
                                                        ),
                                                        child: const Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Icon(Icons.close, size: 18),
                                                            SizedBox(width: 6),
                                                            Text(
                                                              'Still Going',
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  const SizedBox(width: 12),

                                                  // Yes - Meeting finished
                                                  Expanded(
                                                    child: Container(
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                          colors: [Colors.green[500]!, Colors.green[600]!],
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomRight,
                                                        ),
                                                        borderRadius: BorderRadius.circular(14),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.green.withOpacity(0.3),
                                                            blurRadius: 8,
                                                            offset: const Offset(0, 4),
                                                          ),
                                                        ],
                                                      ),
                                                      child: ElevatedButton(
                                                        onPressed: () async {

                                                          var data = {
                                                            "appointmentId": appointment.appointmentId,
                                                            "status": "Completed",
                                                            "managerScheduledDate": appointment.managerScheduledDate,
                                                            "managerScheduledTime": appointment.managerScheduledTime,
                                                            "updatedBy": DashboardHelpers.currentUser!.iDnum
                                                          };
                                                          // Example API call structure:
                                                          var res = await apiService.postData('api/Support/schedule', data);
                                                          appointment.copyWith(status: 'Completed');
                                                          if (res != null) {
                                                            // Show success message
                                                            DashboardHelpers.showAlert(
                                                                msg: 'Appointment Completed Successfully',);

                                                            Navigator.of(context).pop();
                                                            ref.watch(allAppointmentListProvider);
                                                          }
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.transparent,
                                                          foregroundColor: Colors.white,
                                                          shadowColor: Colors.transparent,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(14),
                                                          ),
                                                        ),
                                                        child: const Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Icon(Icons.check, size: 18),
                                                            SizedBox(width: 6),
                                                            Text(
                                                              'Completed',
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              const SizedBox(height: 8),

                                              // Cancel option
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.grey[500],
                                                ),
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    decoration: TextDecoration.underline,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  color: getStatusColor(appointment.status ?? '')
                                      .withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color:
                                        getStatusColor(appointment.status ?? ''),
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  appointment.status=='' ? 'Pending': appointment.status ?? 'N/A',
                                  style: TextStyle(
                                    color:
                                        getStatusColor(appointment.status ?? ''),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        const Divider(height: 1, color: Colors.grey),
                        const SizedBox(height: 16),

                        // Employee Information in a compact grid
                        Row(
                          children: [
                            _buildInfoChip(Icons.person,
                                appointment.employeeName ?? 'N/A'),
                            const SizedBox(width: 8),
                            _buildInfoChip(
                                Icons.badge, appointment.designation ?? 'N/A'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildInfoChip(
                                Icons.work, appointment.department ?? 'N/A'),
                            const SizedBox(width: 8),
                            _buildInfoChip(Icons.fingerprint,
                                appointment.employeeId ?? 'N/A'),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Purpose Section
                        Container(
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
                                  Icon(Icons.description,
                                      size: 16, color: Colors.blue.shade600),
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
                        ),

                        const SizedBox(height: 16),

                        // Date and Time Section
                        // In the Date and Time Section, wrap the Time part with GestureDetector

                        // Also add the same for Manager Scheduled Time if available
                        (appointment.managerScheduledDate != null)
                            ? Column(
                                children: [
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.green.shade100),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.check_circle,
                                            size: 16,
                                            color: Colors.green.shade700),
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
                                            _formatDate(appointment
                                                .managerScheduledDate
                                                .toString()),
                                            Colors.green.shade700,
                                          ),
                                        ),
                                        Container(
                                          width: 1,
                                          height: 40,
                                          color: Colors.green.shade200,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                        ),
                                        Expanded(
                                          child: _buildDateTimeItem(
                                            Icons.access_time,
                                            'Scheduled Time',
                                            _formatTime(appointment
                                                .managerScheduledTime
                                                ?.toString()),
                                            Colors.green.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : GestureDetector(
                              onTap: ()=>_onTimeTap(context, appointment),
                              child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: Colors.blue.shade100),
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
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                      ),
                                      Expanded(
                                        child: _buildDateTimeItem(
                                          Icons.access_time,
                                          'Requested Time',
                                          _formatTime(
                                              appointment.preferredTime),
                                          Colors.blue.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ),

                        const SizedBox(height: 16),

                        // Footer with creation info
                        Container(
                          padding: const EdgeInsets.only(top: 12),
                          decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(color: Colors.grey.shade300)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.calendar_month,
                                      size: 14, color: Colors.grey.shade600),
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
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to format date
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';

    try {
      // Handle both "2024-03-20T10:00:00" and "2024-03-20" formats
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    } catch (e) {
      return dateString; // Return original if parsing fails
    }
  }

  // Helper method to format time
  String _formatTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return 'N/A';

    try {
      // Handle both "10:00:00" and "10:00 AM" formats
      if (timeString.contains('T')) {
        // If it's part of a datetime string
        final date = DateTime.parse('2024-01-01$timeString');
        return DashboardHelpers.convertDateTime(date.toString(),
            pattern: 'hh:mm a');
      } else if (timeString.length == 8 && timeString.contains(':')) {
        // If it's in "HH:mm:ss" format
        final timeParts = timeString.split(':');
        final hour = int.parse(timeParts[0]);
        final minute = timeParts[1];
        // final period = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour > 12 ? hour - 12 : hour;
        return '$displayHour:$minute';
      } else {
        return timeString; // Return original if format is unknown
      }
    } catch (e) {
      return timeString; // Return original if parsing fails
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

  Widget _buildDateTimeItem(
      IconData icon, String label, String value, Color color) {
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

  void _onTimeTap(BuildContext context, AppointmentModel appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
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
                // Icon Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    size: 32,
                    color: Colors.blue[700],
                  ),
                ),

                const SizedBox(height: 16),

                // Title
                Text(
                  'Appointment Options',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),

                const SizedBox(height: 16),

                // Content
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

                // Buttons
                Column(
                  children: [
                    // Accept Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _acceptAppointment(appointment);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Accept Appointment',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Reschedule Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _selectNewTime(context, appointment);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.blue.shade300),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.schedule, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Reschedule',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Cancel Button
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                         // _cancelAppointment(appointment);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[600],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectNewTime(
      BuildContext context, AppointmentModel appointment) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      // Call your API here with the new time
      _callRescheduleApi(appointment, selectedTime, context);
    }
  }

  Future<void> _callRescheduleApi(AppointmentModel appointment,
      TimeOfDay newTime, BuildContext context) async {
    // Implement your API call here
    final newTimeString =
        "${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}:00";

    debugPrint('Calling API to reschedule appointment ${appointment.appointmentId} to $newTimeString');

    var data = {
      "appointmentId": appointment.appointmentId,
      "status": "Waiting",
      "managerScheduledDate": appointment.preferredDate,
      "managerScheduledTime": newTimeString,
      "updatedBy": DashboardHelpers.currentUser!.iDnum
    };
    // Example API call structure:
    var res = await apiService.postData('api/Support/schedule', data);
    appointment.copyWith(managerScheduledTime: newTimeString);
    if (res != null) {
      // Show success message
      DashboardHelpers.showAlert(
          msg: 'Appointment time updated to $newTimeString');
    }
  }

  Future<void> _acceptAppointment(AppointmentModel appointment) async {



    debugPrint('Calling API to accept appointment ${appointment.preferredTime}');

    var data = {
      "appointmentId": appointment.appointmentId,
      "status": "Waiting",
      "managerScheduledDate": appointment.preferredDate,
      "managerScheduledTime": appointment.preferredTime,
      "updatedBy": DashboardHelpers.currentUser!.iDnum
    };
    // Example API call structure:
    var res = await apiService.postData('api/Support/schedule', data);

    if (res != null) {
      // Show success message
      DashboardHelpers.showAlert(
          msg: 'Appointment time accepted to ${appointment.preferredTime}');
    }
  }
}
