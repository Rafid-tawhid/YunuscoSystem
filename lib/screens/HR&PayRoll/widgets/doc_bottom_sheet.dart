import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/doc_appoinment_list_model.dart';
import '../doc_appointment_requisation.dart';

void showAppointmentBottomSheet({
  required BuildContext context,
  required DocAppoinmentListModel appointment,
  String? medicineName,
  String? doctorAdvice,
  String? medicineTime,
  String? leaveNotes,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Center(
                child: Container(
                  width: 60,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Appointment Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  _buildStatusBadge(appointment.status),
                ],
              ),

              const SizedBox(height: 20),

              // Basic Information
              _buildInfoSection(
                title: 'Basic Information',
                children: [
                  _buildInfoRow('Name:', appointment.fullName ?? 'N/A'),
                  _buildInfoRow('ID Card No:', appointment.idCardNo ?? 'N/A'),
                  _buildInfoRow('Serial No:', appointment.serialNo ?? 'N/A'),
                  _buildInfoRow('Name:', medicineName ?? ''),
                  _buildInfoRow('Request Date:',
                      _formatDate(appointment.requestDate) ?? 'N/A'),
                  _buildInfoRow(
                      'Urgency:', _getUrgencyText(appointment.urgencyType)),
                  _buildInfoRow(
                    'Gate Pass:',
                    appointment.gatePassStatus == 1
                        ? 'Approved'
                        : 'Not Approved',
                    valueColor: appointment.gatePassStatus == 1
                        ? Colors.green
                        : Colors.orange,
                  ),
                ],
              ),

              // const SizedBox(height: 20),
              //
              // // Medical Information
              // if (medicineName != null || doctorAdvice != null || medicineTime != null)
              //   _buildInfoSection(
              //     title: 'Medical Information',
              //     children: [
              //       if (medicineName != null) _buildInfoRow('Medicine:', medicineName),
              //       if (medicineTime != null) _buildInfoRow('Dosage Time:', medicineTime),
              //       if (doctorAdvice != null)
              //         _buildInfoRow(
              //           'Doctor Advice:',
              //           doctorAdvice,
              //           valueStyle: const TextStyle(fontStyle: FontStyle.italic),
              //         ),
              //     ],
              //   ),

              const SizedBox(height: 20),

              // Notes & Remarks
              _buildInfoSection(
                title: 'Notes & Remarks',
                children: [
                  if (appointment.remarks != null &&
                      appointment.remarks!.isNotEmpty)
                    _buildInfoRow('Remarks:', appointment.remarks!),
                  if (leaveNotes != null && leaveNotes.isNotEmpty)
                    _buildInfoRow(
                      'Leave Notes:',
                      leaveNotes,
                      valueStyle: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // Metadata
              _buildInfoSection(
                title: 'Metadata',
                children: [
                  _buildInfoRow('Created:',
                      _formatDate(appointment.createdDate) ?? 'N/A'),
                  if (appointment.createdBy != null)
                    _buildInfoRow('Created By:', '${appointment.createdBy}'),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildInfoSection(
    {required String title, required List<Widget> children}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.blueGrey,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    ],
  );
}

Widget _buildInfoRow(
  String label,
  String value, {
  TextStyle? valueStyle,
  Color? valueColor,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: valueStyle ??
                TextStyle(
                  fontSize: 14,
                  color: valueColor ?? Colors.black87,
                ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildStatusBadge(num? status) {
  final statusInfo = _getStatusInfo(status);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: statusInfo.color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: statusInfo.color.withOpacity(0.3)),
    ),
    child: Text(
      statusInfo.text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: statusInfo.color,
      ),
    ),
  );
}

String _getUrgencyText(num? urgencyType) {
  switch (urgencyType) {
    case 1:
      return 'Normal';
    case 2:
      return 'Urgent';
    case 3:
      return 'Emergency';
    default:
      return 'Not Specified';
  }
}

String? _formatDate(String? dateString) {
  if (dateString == null) return null;
  try {
    final date = DateTime.parse(dateString);
    return DateFormat('d MMM yyyy, hh:mm a').format(date);
  } catch (e) {
    return dateString;
  }
}

StatusInfo _getStatusInfo(num? status) {
  switch (status) {
    case 1:
      return StatusInfo('Pending', Colors.orange);
    case 2:
      return StatusInfo('Approved', Colors.green);
    case 3:
      return StatusInfo('Rejected', Colors.red);
    case 4:
      return StatusInfo('Completed', Colors.blue);
    default:
      return StatusInfo('Unknown', Colors.grey);
  }
}
