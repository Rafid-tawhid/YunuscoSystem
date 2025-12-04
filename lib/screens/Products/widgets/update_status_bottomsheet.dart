// lib/widgets/update_status_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/utils/constants.dart';
import '../../../models/machine_breakdown_model.dart';

// lib/utils/status_utils.dart
class StatusFlow {
  static List<String> flow = [
    MachineBreakdownStatus.reported,
    MachineBreakdownStatus.awaiting,
    MachineBreakdownStatus.in_progress,
    MachineBreakdownStatus.resolved,
    MachineBreakdownStatus.completed,
  ];

  static String getNextStatus(String currentStatus) {
    final index = flow.indexOf(currentStatus);
    if (index == -1 || index >= flow.length - 1) {
      return currentStatus; // Already at last status
    }
    return flow[index + 1];
  }

  static String getPreviousStatus(String currentStatus) {
    final index = flow.indexOf(currentStatus);
    if (index <= 0) {
      return currentStatus; // Already at first status
    }
    return flow[index - 1];
  }

  static bool canUserUpdate(String currentStatus) {
    return currentStatus == MachineBreakdownStatus.reported; // Only when reported
  }

  static bool isFinalStatus(String status) {
    return status == 'Completed';
  }

  static Color getStatusColor(String? status) {
    switch (status) {
      case MachineBreakdownStatus.reported:
        return Colors.red;
      case MachineBreakdownStatus.awaiting:
        return Colors.orange;
      case MachineBreakdownStatus.in_progress:
        return Colors.blue;
      case MachineBreakdownStatus.resolved:
        return Colors.green;
      case MachineBreakdownStatus.completed:
        return Colors.green.shade700;
      default:
        return Colors.grey;
    }
  }
}


class UpdateStatusBottomSheet extends ConsumerStatefulWidget {
  final MachineBreakdownModel breakdown;

  const UpdateStatusBottomSheet({
    super.key,
    required this.breakdown,
  });

  @override
  ConsumerState<UpdateStatusBottomSheet> createState() => _UpdateStatusBottomSheetState();
}

class _UpdateStatusBottomSheetState extends ConsumerState<UpdateStatusBottomSheet> {
  final _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedDate;
  TimeOfDay? _selectedAttendTime;

  late String _nextStatus;
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Calculate next status based on current status
    _nextStatus = StatusFlow.getNextStatus(widget.breakdown.status ?? 'Reported');

    // Set default date/time to now
    _selectedDate = DateTime.now();
    _selectedAttendTime = TimeOfDay.now();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedAttendTime=picked;
      });
    }
  }

  void _submitUpdate() {
    if (StatusFlow.canUserUpdate(widget.breakdown.status ?? '')) {
      // For "Reported" status, validate form
      if (_formKey.currentState?.validate() ?? false) {
        _processUpdate();
      }
    } else {
      // For other statuses, just auto-advance
      _processUpdate();
    }
  }

  void _processUpdate() {
    // Prepare update data
//        "MaintenanceId": 6,
//         "MaintenanceName": "Electrical Panel Cooling Fan",
//         "MaintenanceDate": "2024-01-24",
//         "IdCardNo": "EMP05623",
//         "FullName": "Chen Wei",
//         "OperationName": "Assembly Line",
//         "LineName": "Line 5",
//         "MachineType": "Robotic Arm",
//         "MachineNo": "ROB-118",
//         "TaskCode": null,
//         "ReportedTime": null,
//         "MechanicInfoTime": null,
//         "WorkStartTime": "Jan 24 2024  1:00PM",
//         "DelayTime": null,
//         "WorkEndTime": "Jan 24 2024  2:30PM",
//         "MechanicWorkTime": "90",
//         "BreakdownDescription": "Cooling fan in main electrical panel stopped working. Panel temperature reached 65°C. Replaced fan with spare unit.",
//         "BreakdownDateTime": "Jan 24 2024 12:15PM",
//         "Status": "Resolved",
//         "CreatedDate": "2025-12-03T11:31:59.167",
//         "UpdatedDate": "2025-12-03T11:31:59.167"


  if(widget.breakdown.status==MachineBreakdownStatus.reported){
        // Show error
        var data={
          "MaintenanceId": widget.breakdown.maintenanceId,
          "Updates": {
            "Status": _nextStatus,
            "MechanicInfoTime":_selectedAttendTime,
            "TaskCode":_notesController.text,
            "MaintenanceDate":_selectedDate,
          }
        };
        debugPrint('Update Data: $data');

    }
  if(widget.breakdown.status==MachineBreakdownStatus.awaiting){
        // Show error
        var data={
          "MaintenanceId": widget.breakdown.maintenanceId,
          "Updates": {
            "Status": _nextStatus,
            "WorkStartTime":_selectedAttendTime
          }
        };
        debugPrint('Update Data: $data');

    }
  if(widget.breakdown.status==MachineBreakdownStatus.in_progress){
        // Show error
        var data={
          "MaintenanceId": widget.breakdown.maintenanceId,
          "Updates": {
            "Status": _nextStatus,
            "WorkEndTime":_selectedAttendTime
          }
        };
        debugPrint('Update Data: $data');

    }

  if(widget.breakdown.status==MachineBreakdownStatus.resolved){
        // Show error
        var data={
          "MaintenanceId": widget.breakdown.maintenanceId,
          "Updates": {
            "Status": _nextStatus,
            "WorkEndTime":_selectedAttendTime
          }
        };
        debugPrint('Update Data: $data');

    }

    // Close bottom sheet with data
    Navigator.pop(context);
  }

  Widget _buildStatusInfo() {
    final currentStatus = widget.breakdown.status ?? 'Reported';
    final currentColor = StatusFlow.getStatusColor(currentStatus);
    final nextColor = StatusFlow.getStatusColor(_nextStatus);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Status
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: currentColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Status',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    currentStatus,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: currentColor,
                    ),
                  ),
                ],
              ),
              Spacer(),
              // Arrow
              Icon(
                Icons.arrow_right_alt,
                color: Colors.grey[400],
                size: 40,
              ),
              Spacer(),
              // Next Status
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: nextColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Next Status',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        _nextStatus,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: nextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),



        ],
      ),
    );
  }

  Widget _buildStatusFlowIndicator() {
    final currentStatus = widget.breakdown.status ?? 'Reported';
    final currentIndex = StatusFlow.flow.indexOf(currentStatus);

    return Column(
      children: [
        // Status labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: StatusFlow.flow.map((status) {
            final isActive = StatusFlow.flow.indexOf(status) <= currentIndex;
            final isCurrent = status == currentStatus;

            return Column(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: isActive
                        ? StatusFlow.getStatusColor(status)
                        : Colors.grey[300],
                    shape: BoxShape.circle,
                    border: isCurrent
                        ? Border.all(color: Colors.white, width: 2)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '${StatusFlow.flow.indexOf(status) + 1}',
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isCurrent
                        ? StatusFlow.getStatusColor(status)
                        : Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: 8),

        // Progress line
        Stack(
          children: [
            Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              height: 3,
              width: (MediaQuery.of(context).size.width - 60) * ((currentIndex + 1) / StatusFlow.flow.length),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: StatusFlow.getStatusColor(currentStatus),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final canUserUpdate = StatusFlow.canUserUpdate(widget.breakdown.status ?? '');

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: StatusFlow.getStatusColor(widget.breakdown.status).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.update,
                    color: StatusFlow.getStatusColor(widget.breakdown.status),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Update Breakdown Status',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      Text(
                        'ID: ${widget.breakdown.maintenanceId}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Status Flow Indicator
            _buildStatusFlowIndicator(),
            const SizedBox(height: 20),

            // Status Transition Info
            _buildStatusInfo(),
            const SizedBox(height: 20),

            // Only show time/notes input when status is "Reported"
            if (canUserUpdate) ...[
              // Date Picker (required for Reported status)
              _buildDateField(
                label: 'Work Date',
                date: _selectedDate,
                onDateSelected: () => _selectDate(),
                isRequired: true,
              ),
              const SizedBox(height: 16),

              // Time Picker Row (required for Reported status)
              Row(
                children: [
                  Expanded(
                    child: _buildTimeField(
                      label: 'Attend Time',
                      time: _selectedAttendTime,
                      onTimeSelected: () => _selectTime(),
                      isRequired: true,
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 16),

              // Notes Text Field (required for Reported status)
              _buildNotesField(isRequired: false),
              const SizedBox(height: 20),
            ] else ...[
              // Show message for other statuses
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue[700],
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status will auto-update',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Status will automatically change from "${widget.breakdown.status}" to "$_nextStatus"',
                            style: TextStyle(
                              color: Colors.blue[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Action Buttons
            _buildActionButtons(canUserUpdate),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onDateSelected,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onDateSelected,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(
                color: isRequired && date == null
                    ? Colors.red.withOpacity(0.5)
                    : Colors.grey[300]!,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: isRequired && date == null
                      ? Colors.red
                      : Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    date != null
                        ? "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}"
                        : 'Select Date',
                    style: TextStyle(
                      color: date != null ? Colors.black87 : Colors.grey[500],
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isRequired && date == null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0),
            child: Text(
              'Please select a date',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTimeField({
    required String label,
    required TimeOfDay? time,
    required VoidCallback onTimeSelected,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTimeSelected,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(
                color: isRequired && time == null
                    ? Colors.red.withOpacity(0.5)
                    : Colors.grey[300]!,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: isRequired && time == null
                      ? Colors.red
                      : Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    time != null
                        ? time.format(context)
                        : 'Select Time',
                    style: TextStyle(
                      color: time != null ? Colors.black87 : Colors.grey[500],
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isRequired && time == null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0),
            child: Text(
              'Please select time',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNotesField({bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Notes',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _notesController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Enter notes or additional information...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isRequired && _notesController.text.isEmpty
                    ? Colors.red.withOpacity(0.5)
                    : Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            errorText: isRequired && _notesController.text.isEmpty
                ? 'Please enter notes'
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool canUserUpdate) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: BorderSide(color: Colors.grey[300]!),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitUpdate,
            style: ElevatedButton.styleFrom(
              backgroundColor: StatusFlow.getStatusColor(_nextStatus),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.arrow_forward, size: 20),
                const SizedBox(width: 8),
                Text(_nextStatus,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}