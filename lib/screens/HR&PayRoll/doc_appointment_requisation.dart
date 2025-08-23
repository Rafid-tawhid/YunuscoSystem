import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import 'package:yunusco_group/screens/HR&PayRoll/widgets/doctor_appointment_list_screen.dart';
import '../../common_widgets/custom_button.dart';
import '../../models/doc_appoinment_list_model.dart';
import '../../utils/colors.dart';

class DocAppoinmentReq extends StatefulWidget {
  const DocAppoinmentReq({super.key});

  @override
  _DocAppoinmentReqState createState() => _DocAppoinmentReqState();
}

class _DocAppoinmentReqState extends State<DocAppoinmentReq> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _idCardController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  int? _urgencyType;
  final Map<String, int> _urgencyOptions = {
    'Regular': 1,
    'Emergency': 2,
  };

  @override
  void dispose() {
    _idCardController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_urgencyType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select urgency type')),
        );
        return;
      }

      final requestData = {
        "idCardNo": _idCardController.text,
        "remarks": _remarksController.text,
        "urgencyType": _urgencyType,
        "requestDate": DashboardHelpers.convertDateTime2(DateTime.now()),
        "status": 1,
      };

      var hp = context.read<HrProvider>();
      if (await hp.saveDocAppoinment(requestData)) {
        //clear field
        _idCardController.clear();
        _remarksController.clear();
        if (mounted) DashboardHelpers.showSnakBar(context: context, message: 'Doctor Appointment Success!', bgColor: myColors.green);
        if (mounted) Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Doc-Appointment'),
        centerTitle: true,
        elevation: 0,
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 8,
              ),
              Consumer<HrProvider>(
                  builder: (context, pro, _) => ElevatedButton(
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
                        pro.showHideDocForm();
                      },
                      child: Text(
                        pro.showForm ? 'Applications' : 'Create +',
                        style: TextStyle(color: Colors.white),
                      ))),
              SizedBox(
                height: 8,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Consumer<HrProvider>(
                        builder: (context, pro, _) => pro.showForm ? DocReqForm() : SizedBox.shrink(),
                      ),
                      // ID Card Number Field
                      Consumer<HrProvider>(
                        builder: (context, pro, _) {
                          return pro.showForm
                              ? SizedBox.shrink()
                              : ListView.builder(
                                  padding: const EdgeInsets.all(8),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: pro.docAppointmentList.length,
                                  itemBuilder: (context, index) {
                                    final appointment = pro.docAppointmentList[index];
                                    return Card(
                                      margin: const EdgeInsets.symmetric(vertical: 4),
                                      color: Colors.white,
                                      child: ListTile(
                                        title: Text(
                                          'Serial: ${appointment.serialNo ?? 'N/A'}',
                                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('ID: ${appointment.idCardNo ?? 'N/A'}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                                            Text('Date: ${DashboardHelpers.convertDateTime(appointment.createdDate ?? '')}'),
                                            if (appointment.remarks?.isNotEmpty ?? false) Text('Remarks: ${appointment.remarks}'),
                                          ],
                                        ),
                                        trailing: _buildUrgencyChip(appointment.urgencyType!.toInt(), appointment.gatePassStatus),
                                        onTap: () {
                                          showAppointmentBottomSheet(
                                            context: context,
                                            appointment: appointment, // Your DocAppoinmentListModel instance
                                            medicineName: "Napa Extra",
                                            doctorAdvice: "Take rest for 3 days and avoid strenuous activities",
                                            medicineTime: "1+0+1 (After meals)",
                                            leaveNotes: "Medical leave approved for 3 days",
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


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
                    _buildInfoRow('ID Card No:', appointment.idCardNo ?? 'N/A'),
                    _buildInfoRow('Serial No:', appointment.serialNo ?? 'N/A'),
                    _buildInfoRow('Gate ID:', appointment.gateId?.toString() ?? 'N/A'),
                    _buildInfoRow(
                        'Request Date:',
                        _formatDate(appointment.requestDate) ?? 'N/A'
                    ),
                    _buildInfoRow(
                        'Urgency:',
                        _getUrgencyText(appointment.urgencyType)
                    ),
                    _buildInfoRow(
                      'Gate Pass:',
                      appointment.gatePassStatus == true ? 'Approved' : 'Not Approved',
                      valueColor: appointment.gatePassStatus == true
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Medical Information
                if (medicineName != null || doctorAdvice != null || medicineTime != null)
                  _buildInfoSection(
                    title: 'Medical Information',
                    children: [
                      if (medicineName != null)
                        _buildInfoRow('Medicine:', medicineName),
                      if (medicineTime != null)
                        _buildInfoRow('Dosage Time:', medicineTime),
                      if (doctorAdvice != null)
                        _buildInfoRow('Doctor Advice:', doctorAdvice,
                          valueStyle: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                    ],
                  ),

                const SizedBox(height: 20),

                // Notes & Remarks
                _buildInfoSection(
                  title: 'Notes & Remarks',
                  children: [
                    if (appointment.remarks != null && appointment.remarks!.isNotEmpty)
                      _buildInfoRow('Remarks:', appointment.remarks!),

                    if (leaveNotes != null && leaveNotes.isNotEmpty)
                      _buildInfoRow('Leave Notes:', leaveNotes,
                        valueStyle: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                  ],
                ),

                const SizedBox(height: 20),

                // Metadata
                _buildInfoSection(
                  title: 'Metadata',
                  children: [
                    _buildInfoRow(
                        'Created:',
                        _formatDate(appointment.createdDate) ?? 'N/A'
                    ),
                    if (appointment.updatedDate != null)
                      _buildInfoRow(
                          'Last Updated:',
                          _formatDate(appointment.updatedDate) ?? 'N/A'
                      ),
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

  Widget _buildInfoSection({required String title, required List<Widget> children}) {
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

  Widget _buildInfoRow(String label, String value, {
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
              style: valueStyle ?? TextStyle(
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

  Widget DocReqForm() {
    return Column(
      children: [
        TextFormField(
          controller: _idCardController,
          decoration: const InputDecoration(
            labelText: "ID Card No",
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) => value == null || value.isEmpty ? 'ID is required' : null,
        ),
        const SizedBox(height: 16),

        // Remarks Field
        TextFormField(
          controller: _remarksController,
          decoration: const InputDecoration(
            labelText: "Remarks",
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
          validator: (value) => value == null || value.isEmpty ? 'Remarks required' : null,
        ),
        const SizedBox(height: 16),

        // Urgency Dropdown
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(
            labelText: 'Urgency Type',
            border: OutlineInputBorder(),
          ),
          items: _urgencyOptions.entries
              .map(
                (entry) => DropdownMenuItem<int>(
                  value: entry.value,
                  child: Text(entry.key),
                ),
              )
              .toList(),
          value: _urgencyType,
          onChanged: (value) => setState(() => _urgencyType = value),
          validator: (_) => _urgencyType == null ? 'Urgency type is required' : null,
        ),
        const SizedBox(height: 24),

        // Submit Button
        Consumer<HrProvider>(
          builder: (context, pro, _) => CustomElevatedButton(
            isLoading: pro.isLoading,
            text: 'Submit Request',
            onPressed: _submitForm,
          ),
        ),
      ],
    );
  }

  Widget _buildUrgencyChip(int? urgency, bool? gatePass) {
    if (urgency == null) return const SizedBox();

    return Chip(
        label: gatePass == true
            ? Text('Gate Pass', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
            : Text(
                urgency == 1 ? 'Regular' : 'Emergency',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
        backgroundColor: gatePass == true
            ? Colors.green
            : urgency == 1
                ? Colors.orange
                : Colors.red);
  }
}


class StatusInfo {
  final String text;
  final Color color;

  StatusInfo(this.text, this.color);
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