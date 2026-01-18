import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yunusco_group/common_widgets/process_dropdown.dart';
import 'package:yunusco_group/models/machine_scan_model.dart';
import 'package:yunusco_group/models/maintanance_type_model.dart';
import 'package:yunusco_group/models/process_name_model.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../../models/machine_breakdown_dropdown.dart';
import '../../../models/machine_repair_task_model.dart';
import '../../../providers/riverpods/employee_provider.dart';
import '../../../providers/riverpods/production_provider.dart';
import '../widgets/machine_line_dropdown.dart';
import 'machine_qr_scanner.dart';

class MachineMultipleProblemRequestScreen extends ConsumerStatefulWidget {
  const MachineMultipleProblemRequestScreen({super.key});

  @override
  ConsumerState<MachineMultipleProblemRequestScreen> createState() =>
      _MachineMultipleProblemRequestScreenState();
}

class _MachineMultipleProblemRequestScreenState
    extends ConsumerState<MachineMultipleProblemRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form state
  MaintananceTypeModel? _maintenanceType;
  ProcessNameModel? _process;
  MachineRepairTaskModel? _selectedTask;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _isSubmitting = false;
  MachineScanModel? _scannedMachineInfo;
  String _workDuration = '00:00';
  ProductionLines? _selectedLine;

  // Computed properties
  bool get _shouldShowProcess =>
      _maintenanceType != null && _maintenanceType!.maintenanceTypeId != 4;

  bool get _shouldShowProblemTask =>
      _maintenanceType != null && _maintenanceType!.maintenanceTypeId != 3;

  bool get _shouldShowQrScanner =>
      _maintenanceType != null && _maintenanceType!.maintenanceTypeId != 2;

  bool get _shouldRequireMachineScan =>
      _maintenanceType != null &&
          _maintenanceType!.maintenanceTypeId != 4 &&
          _maintenanceType!.maintenanceTypeId != 2;

  bool get _shouldRequireProcess =>
      _maintenanceType != null && _maintenanceType!.maintenanceTypeId != 4;
  bool get _shouldShowLine =>
      _maintenanceType != null && _maintenanceType!.maintenanceTypeId == 4;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Machine Repair'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: _buildFormContent(),
            ),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return ref.watch(maintenanceTypeProvider).when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _buildErrorWidget(e.toString()),
      data: (types) => ref.watch(processNameProvider).when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildErrorWidget(e.toString()),
        data: (processList) => ref.watch(maintenanceTaskList).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _buildErrorWidget(e.toString()),
          data: (tasks) => _buildFormFields(types, processList, tasks),
        ),
      ),
    );
  }

  Widget _buildFormFields(
      List<MaintananceTypeModel> maintenanceTypes,
      List<ProcessNameModel> processList,
      List<MachineRepairTaskModel> tasks,
      ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildMaintenanceDropdown(maintenanceTypes),
          const SizedBox(height: 16),
          if (_shouldShowProcess) ...[
            ProcessDropdown(
              processes: processList,
              selectedProcess: _process,
              onChanged: (ProcessNameModel? p1) {
                setState(() => _process = p1);
              },
            ),
            const SizedBox(height: 16),
          ],
          if (_shouldShowProblemTask) ...[
            ProblemTaskDropdown(
              tasks: tasks,
              selectedTask: _selectedTask,
              onChanged: (MachineRepairTaskModel? task) {
                setState(() => _selectedTask = task);
                debugPrint('Selected Process: ${task!.taskId}');
                debugPrint('Selected Process: ${task.taskName}');
              },
            ),
            const SizedBox(height: 16),
          ],
          if (_shouldShowQrScanner) ...[
            _buildQrScannerSection(),
            const SizedBox(height: 8),
          ],
         if(_shouldShowLine) ProductionLineDropdown(
            label: 'Production Line',
            selectedLine: _selectedLine, // Your state variable
            onChanged: (newLine) {
              setState(() {
                _selectedLine = newLine;
              });
            },
          ),
          const SizedBox(height: 12),
          _buildTimeSelectionRow(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMaintenanceDropdown(List<MaintananceTypeModel> types) {
    // Filter out type with ID 1
    final filteredTypes = types.where((e) => e.maintenanceTypeId != 1).toList();

    return DropdownButtonFormField<MaintananceTypeModel>(
      value: _maintenanceType,
      decoration: const InputDecoration(
        labelText: 'Maintenance Type *',
        border: OutlineInputBorder(),
      ),
      items: filteredTypes.map(_buildDropdownItem).toList(),
      validator: (v) => v == null ? 'Required' : null,
      onChanged: _onMaintenanceTypeChanged,
    );
  }

  DropdownMenuItem<MaintananceTypeModel> _buildDropdownItem(
      MaintananceTypeModel type) {
    return DropdownMenuItem(
      value: type,
      child: Text(type.maintenanceName ?? 'Unknown'),
    );
  }

  void _onMaintenanceTypeChanged(MaintananceTypeModel? newType) {
    setState(() {
      _maintenanceType = newType;
      _resetDependentFields(newType);
    });
  }

  void _resetDependentFields(MaintananceTypeModel? type) {
    if (type == null) return;

    if (type.maintenanceTypeId == 4) {
      // Breakdown - no process needed
      _process = null;
    }
    if (type.maintenanceTypeId == 3) {
      // Preventive - no task needed
      _selectedTask = null;
    }
    if (type.maintenanceTypeId == 2) {
      // Predictive - no machine scan needed
      _scannedMachineInfo = null;
    }
    if (type.maintenanceTypeId == 4) {
      // Breakdown - no machine scan needed
      _scannedMachineInfo = null;
    }
  }

  Widget _buildQrScannerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQrScannerButton(),
        const SizedBox(height: 12),
        if (_scannedMachineInfo != null) _buildScannedMachineInfo(),
      ],
    );
  }

  Widget _buildQrScannerButton() {
    return InkWell(
      onTap: _scanQrCode,
      child: Card(
        elevation: 2,
        color: Colors.white,
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
                      _scannedMachineInfo == null
                          ? 'Tap to scan machine QR'
                          : 'Scanned successfully',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  _scannedMachineInfo != null
                      ? Icons.refresh
                      : Icons.arrow_forward_ios,
                  color: myColors.primaryColor,
                ),
                onPressed: _scanQrCode,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _scanQrCode() async {
    final result = await Navigator.push<MachineScanModel?>(
      context,
      MaterialPageRoute(
        builder: (context) =>
        const BeautifulQRScannerScreen(fromMultipleScreen: true),
      ),
    );

    if (result != null && mounted) {
      setState(() => _scannedMachineInfo = result);
      _logScannedMachineInfo(result);
    }
  }

  void _logScannedMachineInfo(MachineScanModel info) {
    debugPrint('Scanned Machine Code: ${info.machineCode}');
    debugPrint('Scanned MachineModelId: ${info.machineTypeId}');
    debugPrint('Scanned Machine Id: ${info.machineId}');
    debugPrint('Scanned Machine Name: ${info.machineName}');
  }

  Widget _buildScannedMachineInfo() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: myColors.primaryColor.withAlpha(77), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle,
                    color: Colors.green.shade600, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Machine Scanned Successfully',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildMachineDetailRow(
              icon: Icons.precision_manufacturing,
              label: 'Machine Code',
              value: _scannedMachineInfo!.machineCode.toString(),
            ),
            const SizedBox(height: 8),
            _buildMachineDetailRow(
              icon: Icons.category,
              label: 'Machine Type',
              value: _scannedMachineInfo!.machineName.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMachineDetailRow({
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

  Widget _buildTimeSelectionRow() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey, size: 20),
                SizedBox(width: 8),
                Text(
                  'Work Time Selection',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTimePickerCard(
                    label: 'Start Time',
                    time: _startTime,
                    onTap: () => _showTimePicker(context, (time) {
                      setState(() => _startTime = time);
                      _calculateWorkDuration();
                    }),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTimePickerCard(
                    label: 'End Time',
                    time: _endTime,
                    onTap: () => _showTimePicker(context, (time) {
                      setState(() => _endTime = time);
                      _calculateWorkDuration();
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_startTime != null || _endTime != null)
              _buildDurationDisplay(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePickerCard({
    required String label,
    required TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time == null ? '--:--' : _formatTimeForDisplay(time),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: time == null ? Colors.grey.shade400 : myColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: myColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: myColors.primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.timer_outlined,
              size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          const Text(
            'Work Duration: ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          Text(
            _workDuration,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: myColors.primaryColor,
            ),
          ),
          const Text(
            ' (HH:MM)',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeForDisplay(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hourOfPeriod == 0 ? 12 : timeOfDay.hourOfPeriod;
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    final period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _showTimePicker(
      BuildContext context, Function(TimeOfDay) onPicked) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      onPicked(picked);
    }
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitForm,
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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate maintenance type selection
    if (_maintenanceType == null) {
      _showError('Please select maintenance type');
      return;
    }

    // Validate process (not required for Breakdown - type 4)
    if (_shouldRequireProcess && _process == null) {
      _showError('Please select process');
      return;
    }

    // Validate machine scan (not required for Predictive - type 2 or Breakdown - type 4)
    if (_shouldRequireMachineScan && _scannedMachineInfo == null) {
      _showError('Please scan machine QR code');
      return;
    }

    // Validate time selection
    if (_startTime == null || _endTime == null) {
      _showError('Please select start & end time');
      return;
    }

    if (_maintenanceType!.maintenanceTypeId!=2 && _scannedMachineInfo == null) {
      _showError('Please scan machine QR code');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final payload = _buildPayload();
      debugPrint('Payload: $payload');

      // Uncomment when ready to send
      final apiService = ref.read(apiServiceProvider);
      await apiService.postData(
        'api/Manufacturing/savebreakdown',
        payload,
      );

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint('ERROR $e');
      _showError('Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Map<String, dynamic> _buildPayload() {
    final now = DateTime.now();
    final payload = <String, dynamic>{};

    // Always include these fields
    payload["MaintenanceTypeId"] = _maintenanceType!.maintenanceTypeId;
    payload["WorkStartTime"] = _formatDateTime(_startTime!, now);
    payload["WorkEndTime"] = _formatDateTime(_endTime!, now);
    payload["MechanicWorkTime"] = _workDuration;

    // Conditionally include OperationId
    if (_process != null && _process!.taskId != null) {
      payload["OperationId"] = _process!.taskId;
    }

    // Conditionally include TaskId (only if task is selected)
    if (_selectedTask != null && _selectedTask!.taskId != null) {
      payload["TaskId"] = _selectedTask!.taskId;
    }

    // Conditionally include MachineId
    if (_scannedMachineInfo != null && _scannedMachineInfo!.machineId != null) {
      payload["MachineId"] = _scannedMachineInfo!.machineId;
    }

    // Conditionally include MachineTypeId
    if (_scannedMachineInfo != null && _scannedMachineInfo!.machineTypeId != null) {
      payload["MachineTypeId"] = _scannedMachineInfo!.machineTypeId;
    }
    if(_maintenanceType!.maintenanceTypeId==4&& _selectedLine != null && _selectedLine!.lineId != null){
      payload["LineId"] = _selectedLine!.lineId;
    }

    return payload;
  }

  String _formatDateTime(TimeOfDay time, DateTime baseDate) {
    final dateTime = DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      time.hour,
      time.minute,
    );
    // Format: 2026-01-14T09:00:00
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dateTime);
  }

  Widget _buildErrorWidget(String message) {
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

  void _calculateWorkDuration() {
    if (_startTime == null || _endTime == null) {
      setState(() => _workDuration = '00:00');
      return;
    }

    final totalMinutes = _calculateTotalMinutes();
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    setState(() {
      _workDuration =
      '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    });
  }

  int _calculateTotalMinutes() {
    final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    final endMinutes = _endTime!.hour * 60 + _endTime!.minute;

    int diffMinutes = endMinutes - startMinutes;
    if (diffMinutes < 0) diffMinutes += 24 * 60;

    return diffMinutes;
  }



  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
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