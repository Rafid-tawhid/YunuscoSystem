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

class MachineMultipleProblemRequestScreen extends ConsumerStatefulWidget {

  const MachineMultipleProblemRequestScreen({
    super.key
  });

  @override
  ConsumerState<MachineMultipleProblemRequestScreen> createState() =>
      _MachineMultipleProblemRequestScreenState();
}

class _MachineMultipleProblemRequestScreenState
    extends ConsumerState<MachineMultipleProblemRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  MaintananceTypeModel? _maintenanceType;
  ProcessNameModel? _process;
  String? _problemTask;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

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
                    //_machineInfoCard(),
                    const SizedBox(height: 16),

                    _maintenanceDropdown(types),

                    // _maintenanceTypeText(types.first),
                    const SizedBox(height: 16),

                    //  _processDropdown(processList),

                    ProcessDropdown(
                      processes: processList,
                      selectedProcess: _process,
                      onChanged: (ProcessNameModel? p1) {
                        setState(() {
                          _process=p1;
                        });

                      },),
                    const SizedBox(height: 16),

                    _problemDropdown(),
                    const SizedBox(height: 16),

                    _timePicker(
                      label: 'Work Start Time',
                      time: _startTime,
                      onPicked: (t) => setState(() => _startTime = t),
                    ),
                    const SizedBox(height: 12),

                    _timePicker(
                      label: 'Work End Time',
                      time: _endTime,
                      onPicked: (t) => setState(() => _endTime = t),
                    ),
                    const SizedBox(height: 24),

                    _submitButton(),
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
            // _infoRow('Machine', widget.breakdownModel.machineName ?? 'N/A'),
            // _infoRow('Section', widget.breakdownModel.sectionName ?? 'N/A'),
            // _infoRow('Line', widget.breakdownModel.lineName ?? 'N/A'),
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
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      title: Text(label),
      subtitle: Text(time?.format(context) ?? 'Select time'),
      trailing: const Icon(Icons.access_time),
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked != null) onPicked(picked);
      },
    );
  }

  // ---------------- SUBMIT ----------------

  Widget _submitButton() {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: myColors.primaryColor,
        ),
        child: _isSubmitting
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Submit Request'),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startTime == null || _endTime == null) {
      _showError('Please select start & end time');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final payload = {
        "date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "operationId": _maintenanceType!.maintenanceTypeId,
        "taskId": _process!.taskId,
        "problemTask": _problemTask,
        "workStartTime": _toApiTime(_startTime!),
        "workEndTime": _toApiTime(_endTime!),
        "employeeId": DashboardHelpers.currentUser?.employeeId ?? 0,
        "machineNumber": '',
      };

      await apiService.postData(
        'api/Manufacturing/UpdateRequisition',
        payload,
      );

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}
