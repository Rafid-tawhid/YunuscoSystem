import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yunusco_group/common_widgets/process_dropdown.dart';
import 'package:yunusco_group/models/maintanance_type_model.dart';
import 'package:yunusco_group/models/process_name_model.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../../models/machine_repair_task_model.dart';
import '../../../providers/riverpods/employee_provider.dart';
import '../../../providers/riverpods/production_provider.dart';
import 'machine_qr_scanner.dart';

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
  MachineRepairTaskModel? _selectedTask;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _selectedMachineModel;
  String? _selectedMachineType;
  bool _isSubmitting = false;
  List<String> _scannedMachineInfo = [];

  @override
  Widget build(BuildContext context) {
    final maintenanceTypes = ref.watch(maintenanceTypeProvider);
    final processNames = ref.watch(processNameProvider);
    final taskList = ref.watch(maintenanceTaskList);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Machine Repair'),
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
                return taskList.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => _errorWidget(e.toString()),
                  data: (tasks) {
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        const SizedBox(height: 16),

                        _maintenanceDropdown(types),
                        const SizedBox(height: 16),

                        // Show process dropdown only if maintenance type is not "Breakdown" (id=4)
                        if(_maintenanceType != null && _maintenanceType!.maintenanceTypeId != 4)
                          Column(
                            children: [
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
                            ],
                          ),

                        // Show problem dropdown only if maintenance type is not "Preventive" (id=3)
                        if(_maintenanceType != null && _maintenanceType!.maintenanceTypeId != 3)
                          Column(
                            children: [
                              ProblemTaskDropdown(
                                tasks: tasks,
                                selectedTask: _selectedTask,
                                onChanged: (MachineRepairTaskModel? task) {
                                  setState(() {
                                    _selectedTask = task;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),

                        // Show machine QR scanner only if maintenance type is not "Predictive" (id=2)
                        if(_maintenanceType != null && _maintenanceType!.maintenanceTypeId != 2)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // QR Scanner Button
                              Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: Colors.grey.shade300, width: 1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Row(
                                    children: [
                                      Icon(Icons.qr_code_scanner, color: myColors.primaryColor, size: 28),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Scan Machine QR Code',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              _scannedMachineInfo.isNotEmpty
                                                  ? 'Tap to scan another'
                                                  : 'Required for this maintenance type',
                                              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          _scannedMachineInfo.isNotEmpty
                                              ? Icons.refresh
                                              : Icons.arrow_forward_ios,
                                          color: myColors.primaryColor,
                                        ),
                                        onPressed: () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => BeautifulQRScannerScreen(fromMultipleScreen: true)
                                              )
                                          ).then((value) {
                                            if(value != null && value is List<String>) {
                                              debugPrint('Scanned Value: $value');
                                              setState(() {
                                                _scannedMachineInfo = value;
                                                if(value.length > 2) _selectedMachineModel = value[2];
                                                if(value.length > 3) _selectedMachineType = value[3];
                                              });
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Scanned Machine Info Card
                              if(_scannedMachineInfo.isNotEmpty)
                                Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(color: myColors.primaryColor.withOpacity(0.3), width: 1.5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.check_circle, color: Colors.green.shade600, size: 24),
                                            const SizedBox(width: 8),
                                            const Text(
                                              'Machine Scanned Successfully',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),

                                        if(_selectedMachineModel != null && _selectedMachineModel!.isNotEmpty)
                                          Column(
                                            children: [
                                              _machineDetailRow(
                                                icon: Icons.precision_manufacturing,
                                                label: 'Machine Model',
                                                value: _selectedMachineModel!,
                                              ),
                                              const SizedBox(height: 8),
                                            ],
                                          ),

                                        if(_selectedMachineType != null && _selectedMachineType!.isNotEmpty)
                                          _machineDetailRow(
                                            icon: Icons.category,
                                            label: 'Machine Type',
                                            value: _selectedMachineType!,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 16),
                            ],
                          ),

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
            );
          },
        ),
      ),
    );
  }

  // ---------------- DROPDOWNS ----------------

  Widget _maintenanceDropdown(List<MaintananceTypeModel> types) {
    types.removeWhere((e) => e.maintenanceTypeId == 1);

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
          child: Text(e.maintenanceName ?? 'Unknown'),
        ),
      )
          .toList(),
      validator: (v) => v == null ? 'Required' : null,
      onChanged: (v) => setState(() {
        _maintenanceType = v;
        // Reset dependent fields when maintenance type changes
        if(v?.maintenanceTypeId == 4) _process = null;
        if(v?.maintenanceTypeId == 3) _selectedTask = null;
        if(v?.maintenanceTypeId == 2) {
          _scannedMachineInfo = [];
          _selectedMachineModel = null;
          _selectedMachineType = null;
        }
      }),
    );
  }

  Widget _machineDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: myColors.primaryColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- TIME PICKER ----------------

  Widget _timePicker({
    required String label,
    required TimeOfDay? time,
    required Function(TimeOfDay) onPicked,
  }) {
    String _format12Hour(TimeOfDay? timeOfDay) {
      if (timeOfDay == null) return 'Select time';

      final hour = timeOfDay.hourOfPeriod == 0 ? 12 : timeOfDay.hourOfPeriod;
      final minute = timeOfDay.minute.toString().padLeft(2, '0');
      final period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
      return '$hour:$minute $period';
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: const Icon(Icons.access_time, color: Colors.grey),
        title: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          _format12Hour(time),
          style: TextStyle(
            fontSize: 15,
            color: time == null ? Colors.grey.shade500 : Colors.black,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.grey),
          onPressed: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              builder: (BuildContext context, Widget? child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    alwaysUse24HourFormat: false,
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              setState(() => onPicked(picked));
            }
          },
        ),
      ),
    );
  }

  // ---------------- SUBMIT ----------------

  Widget _submitButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: myColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _isSubmitting
            ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send, size: 20, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Submit Request',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate based on maintenance type
    if (_maintenanceType == null) {
      _showError('Please select maintenance type');
      return;
    }

    if (_maintenanceType!.maintenanceTypeId != 4 && _process == null) {
      _showError('Please select process');
      return;
    }

    // The ProblemTaskDropdown handles its own validation through the Form
    // No need to manually check for _selectedTask

    if (_maintenanceType!.maintenanceTypeId != 2 && _scannedMachineInfo.isEmpty) {
      _showError('Please scan machine QR code');
      return;
    }

    if (_startTime == null || _endTime == null) {
      _showError('Please select start & end time');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final apiService = ref.read(apiServiceProvider);

      final payload = {
        "date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "maintenanceTypeId": _maintenanceType!.maintenanceTypeId,
        "operationId": _process?.taskId ?? 0,
        "taskId": _selectedTask?.taskId ?? 0,
        "problemTask": _selectedTask?.taskName ?? '',
        "workStartTime": _formatApiDateTime(_toApiDateTime(_startTime!)),
        "workEndTime": _formatApiDateTime(_toApiDateTime(_endTime!)),
        "employeeId": DashboardHelpers.currentUser?.employeeId ?? 0,
        "machineNumber": _selectedMachineModel,
        "machineCode": _scannedMachineInfo.isNotEmpty ? _scannedMachineInfo[1] : '',
        "machineType": _selectedMachineType,
      };
      //
      debugPrint('Payload: $payload');

      await apiService.postData(
        'api/Manufacturing/UpdateRequisition',
        payload,
      );

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showError('Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  String _toApiTime(TimeOfDay t) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, t.hour, t.minute);
    return DateFormat("HH:mm:ss").format(dt);
  }
  DateTime _toApiDateTime(TimeOfDay t) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, t.hour, t.minute);
  }

  String _formatApiDateTime(DateTime dt) {
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(dt);
  }



  // ---------------- HELPERS ----------------

  Widget _errorWidget(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Error loading data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setState(() {}),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(msg)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}