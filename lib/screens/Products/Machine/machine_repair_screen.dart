import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yunusco_group/common_widgets/process_dropdown.dart';
import 'package:yunusco_group/models/machine_breakdown_model.dart';
import 'package:yunusco_group/models/maintanance_type_model.dart';
import 'package:yunusco_group/models/process_name_model.dart';
import 'package:yunusco_group/providers/riverpods/management_provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../../providers/riverpods/production_provider.dart';

const List<String> problemTasks = [
  'Machine Overheating',
  'Electrical Issue',
  'Bearing Failure',
  'Motor Failure',
  'Mechanical Jam',
  'Preventive Maintenance',
  'Emergency Repair',
];

class MachineProblemRequestScreen extends ConsumerStatefulWidget {
  final MachineBreakdownModel breakdownModel;

  const MachineProblemRequestScreen({
    super.key,
    required this.breakdownModel,
  });

  @override
  ConsumerState<MachineProblemRequestScreen> createState() =>
      _MachineProblemRequestScreenState();
}

class _MachineProblemRequestScreenState
    extends ConsumerState<MachineProblemRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  MaintananceTypeModel? _maintenanceType;
  ProcessNameModel? _process;
  String? _problemTask;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _workDuration = '00:00';

  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final maintenanceTypes = ref.watch(maintenanceTypeProvider);
    final processNames = ref.watch(processNameProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Repair Request'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: maintenanceTypes.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _errorWidget(e.toString()),
          data: (types) {
            return processNames.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => _errorWidget(e.toString()),
              data: (processList) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // _maintenanceDropdown(types),

                    _maintenanceTypeText(types.first),
                    const SizedBox(height: 16),

                    //  _processDropdown(processList),

                    ProcessDropdown(
                      processes: processList,
                      selectedProcess: _process,
                      onChanged: (ProcessNameModel? p1) {
                        setState(() {
                          _process = p1;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    _problemDropdown(),
                    const SizedBox(height: 16),

                    _timePicker(
                      label: 'Work Start Time',
                      time: _startTime,
                      onPicked: (t) => setState(() {
                        _startTime = t;
                        _calculateWorkDuration();
                      }),
                    ),
                    const SizedBox(height: 12),

                    _timePicker(
                      label: 'Work End Time',
                      time: _endTime,
                      onPicked: (t) => setState(() {
                        _endTime = t;
                        _calculateWorkDuration();
                      }),
                    ),
                    const SizedBox(height: 12),

                    // Mechanic Work Time Field
                   if(_startTime!=null&&_endTime!=null) _workTimeDisplay(),
                    const SizedBox(height: 12),

                    _machineInfoCard(),
                    const SizedBox(height: 36),

                    _submitButton(types.first),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  // ---------------- MACHINE INFO ----------------

  Widget _machineInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Machine Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            _infoRow('Machine', widget.breakdownModel.machineName ?? 'N/A'),
            _infoRow('Line', widget.breakdownModel.lineName ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // ---------------- DROPDOWNS ----------------

  Widget _maintenanceDropdown(List<MaintananceTypeModel> types) {
    return DropdownButtonFormField<MaintananceTypeModel>(
      value: _maintenanceType,
      decoration: const InputDecoration(
        labelText: 'Maintenance Type *',
        border: OutlineInputBorder(),
      ),
      items: types
          .map(
            (e) => DropdownMenuItem(
          value: e,
          child: Text(e.maintenanceName ?? ''),
        ),
      )
          .toList(),
      validator: (v) => v == null ? 'Required' : null,
      onChanged: (v) => setState(() => _maintenanceType = v),
    );
  }

  Widget _maintenanceTypeText(MaintananceTypeModel type) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          const Text(
            'Maintenance Type',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          // Type Name
          Text(
            type.maintenanceName ?? '',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _problemDropdown() {
    return DropdownButtonFormField<String>(
      value: _problemTask,
      decoration: const InputDecoration(
        labelText: 'Problem Task *',
        border: OutlineInputBorder(),
      ),
      items: problemTasks
          .map(
            (e) => DropdownMenuItem(
          value: e,
          child: Text(e),
        ),
      )
          .toList(),
      validator: (v) => v == null ? 'Required' : null,
      onChanged: (v) => setState(() => _problemTask = v),
    );
  }

  // ---------------- TIME PICKER ----------------

  Widget _timePicker({
    required String label,
    required TimeOfDay? time,
    required Function(TimeOfDay) onPicked,
  }) {
    // Custom 12-hour format function
    String _format12Hour(TimeOfDay time) {
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      return '$hour:$minute $period';
    }

    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      title: Text(label),
      subtitle: Text(
        time == null ? 'Select time' : _format12Hour(time),
      ),
      trailing: const Icon(Icons.access_time),
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: false, // Force 12-hour format
              ),
              child: child!,
            );
          },
        );
        if (picked != null) onPicked(picked);
      },
    );
  }

  // ---------------- WORK TIME DISPLAY ----------------

  Widget _workTimeDisplay() {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      title: const Text('Mechanic Work Time'),
      subtitle: Text(
        _startTime != null && _endTime != null
            ? '$_workDuration hours'
            : 'Select start and end time',
      ),
      trailing: const Icon(Icons.timer_outlined, color: Colors.blue),
    );
  }

  void _calculateWorkDuration() {
    if (_startTime == null || _endTime == null) {
      setState(() => _workDuration = '00:00');
      return;
    }

    final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    final endMinutes = _endTime!.hour * 60 + _endTime!.minute;

    int diffMinutes = endMinutes - startMinutes;
    if (diffMinutes < 0) diffMinutes += 24 * 60;

    final hours = diffMinutes ~/ 60;
    final minutes = diffMinutes % 60;

    setState(() {
      _workDuration = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    });
  }

  // ---------------- SUBMIT ----------------

  Widget _submitButton(MaintananceTypeModel types) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : (){_submit(types);},
        style: ElevatedButton.styleFrom(
          backgroundColor: myColors.primaryColor,
        ),
        child: _isSubmitting
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
          'Submit Request',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _submit(MaintananceTypeModel types) async {
    if (!_formKey.currentState!.validate()) return;
    if (_startTime == null || _endTime == null) {
      _showError('Please select start & end time');
      return;
    }

    setState(() => _isSubmitting = true);

    //   "mechanicWorkTime": _workDuration,
    // "date": "2025-01-13",
    //  "operationId": 3,
    //  "taskId": 7,
    //  "mechanicInfoTime": "2025-01-13T09:30:00",
    //  "workStartTime": "2025-01-13T10:00:00",
    //  "workEndTime": "2025-01-13T12:15:00",
    //  "mechanicWorkTime": "02:15",
    //  "employeeId": 1025,
    //  "machineNumber": "MC-2204",
    //  "maintenanceTypeId": 1,
    //  "waitingTime": "00:30"
    try {
      final payload = {
        "date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "operationId": 3,
        "taskId": _process!.taskId,
        "workStartTime": _toApiTime(_startTime!),
        "workEndTime": _toApiTime(_endTime!),
        "employeeId": DashboardHelpers.currentUser?.employeeId ?? 0,
        "machineNumber": widget.breakdownModel.machineName,
        "maintenanceTypeId": types.maintenanceTypeId
      };

      debugPrint(types.maintenanceTypeId.toString());

      await apiService.postData(
        'api/Manufacturing/UpdateRequisition',
        payload,
      );

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      debugPrint('Error $e ${_maintenanceType!.maintenanceTypeId}');
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _toApiTime(TimeOfDay t) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, t.hour, t.minute);
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dt);
  }

  // ---------------- HELPERS ----------------

  Widget _errorWidget(String message) {
    return Center(child: Text(message));
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}