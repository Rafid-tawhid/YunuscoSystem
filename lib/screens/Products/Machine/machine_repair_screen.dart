import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/models/machine_breakdown_model.dart';
import 'package:yunusco_group/models/maintanance_type_model.dart';
import 'package:yunusco_group/models/process_name_model.dart';
import 'package:yunusco_group/providers/riverpods/management_provider.dart';
import '../../../providers/riverpods/production_provider.dart';


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
  MaintananceTypeModel? _selectedMaintenanceType;
  ProcessNameModel? _selectedProcessName;
  String? _selectedWaitingTime;

  TimeOfDay? _workStartTime;
  TimeOfDay? _workEndTime;
  String _mechanicWorkTime = '00:00';

  final TextEditingController _problemDescriptionController = TextEditingController();
  final TextEditingController _solutionController = TextEditingController();

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // Waiting time options (15 min intervals up to 8 hours)
  final List<String> _waitingTimeOptions = [
    '00:00',
    '00:15',
    '00:30',
    '00:45',
    '01:00',
    '01:15',
    '01:30',
    '01:45',
    '02:00',
    '02:15',
    '02:30',
    '02:45',
    '03:00',
    '03:15',
    '03:30',
    '03:45',
    '04:00',
    '04:15',
    '04:30',
    '04:45',
    '05:00',
    '05:15',
    '05:30',
    '05:45',
    '06:00',
    '06:15',
    '06:30',
    '06:45',
    '07:00',
    '07:15',
    '07:30',
    '07:45',
    '08:00',
  ];

  @override
  void initState() {
    super.initState();
    _problemDescriptionController.text = widget.breakdownModel.machineName ?? '';
    _selectedWaitingTime = '00:30'; // Default waiting time
    _loadDropdownData();
  }

  @override
  void dispose() {
    _problemDescriptionController.dispose();
    _solutionController.dispose();
    super.dispose();
  }

  Future<void> _loadDropdownData() async {
    try {
      setState(() => _isLoading = true);
      ref.invalidate(maintenanceTypeProvider);
      ref.invalidate(processNameProvider);
      await ref.read(maintenanceTypeProvider.future);
      await ref.read(processNameProvider.future);
    } catch (e) {
      if (mounted) {
        debugPrint('Error loading dropdown data: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _selectWorkStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _workStartTime ?? TimeOfDay.now(),
      helpText: 'Select Work Start Time',
    );

    if (picked != null) {
      setState(() {
        _workStartTime = picked;
        _calculateWorkDuration();
      });
    }
  }

  Future<void> _selectWorkEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _workEndTime ?? TimeOfDay.now(),
      helpText: 'Select Work End Time',
    );

    if (picked != null) {
      setState(() {
        _workEndTime = picked;
        _calculateWorkDuration();
      });
    }
  }

  void _calculateWorkDuration() {
    if (_workStartTime != null && _workEndTime != null) {
      // Convert TimeOfDay to minutes since midnight
      int startMinutes = _workStartTime!.hour * 60 + _workStartTime!.minute;
      int endMinutes = _workEndTime!.hour * 60 + _workEndTime!.minute;

      // Calculate difference
      int diffMinutes = endMinutes - startMinutes;

      // Handle case where end time is on next day
      if (diffMinutes < 0) {
        diffMinutes += 24 * 60;
      }

      // Format as HH:mm
      int hours = diffMinutes ~/ 60;
      int minutes = diffMinutes % 60;

      setState(() {
        _mechanicWorkTime = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return 'Not selected';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatDateTimeForAPI(TimeOfDay? time) {
    if (time == null) return '';
    // Get current date
    final now = DateTime.now();
    // Create DateTime with current date and selected time
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dateTime);
  }

  String _getCurrentDateTimeISO() {
    final now = DateTime.now();
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(now);
  }

  bool _validateForm() {
    return _selectedMaintenanceType != null &&
        _selectedProcessName != null &&
        _workStartTime != null &&
        _workEndTime != null &&
        _selectedWaitingTime != null &&
        _problemDescriptionController.text.isNotEmpty &&
        _solutionController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final maintenanceTypesAsync = ref.watch(maintenanceTypeProvider);
    final processNameList = ref.watch(processNameProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Machine Repair Request'),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadDropdownData,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Machine Info Card
                Card(
                  color: Colors.white,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Machine Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow('Machine:', widget.breakdownModel.machineName ?? 'N/A'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Maintenance Type Dropdown
                _buildSectionTitle('Maintenance Information'),
                const SizedBox(height: 8),
                maintenanceTypesAsync.when(
                  data: (maintenanceTypes) {
                    if (_selectedMaintenanceType == null && maintenanceTypes.isNotEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _selectedMaintenanceType = maintenanceTypes.first;
                        });
                      });
                    }
                    return _buildMaintenanceTypeDropdown(maintenanceTypes);
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => _buildErrorWidget(error.toString()),
                ),
                const SizedBox(height: 16),

                // Process Name Dropdown
                processNameList.when(
                  data: (processNames) {
                    if (_selectedProcessName == null && processNames.isNotEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _selectedProcessName = processNames.first;
                        });
                      });
                    }
                    return _buildProcessNameDropdown(processNames);
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => _buildErrorWidget(error.toString()),
                ),
                const SizedBox(height: 16),

                // Time Selection Section
                _buildSectionTitle('Time Information'),
                const SizedBox(height: 8),

                // Current Date Display
                Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.blue),
                        const SizedBox(width: 12),
                        Text(
                          'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Work Start Time
                _buildTimeField(
                  label: 'Work Start Time *',
                  value: _formatTimeOfDay(_workStartTime),
                  hint: 'Select work start time',
                  onTap: () => _selectWorkStartTime(context),
                  icon: Icons.access_time,
                ),
                const SizedBox(height: 12),

                // Work End Time
                _buildTimeField(
                  label: 'Work End Time *',
                  value: _formatTimeOfDay(_workEndTime),
                  hint: 'Select work end time',
                  onTap: () => _selectWorkEndTime(context),
                  icon: Icons.access_time,
                ),
                const SizedBox(height: 12),

                // Mechanic Work Time (Auto-calculated)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[50],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.timer, color: Colors.green, size: 20),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Mechanic Work Duration:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Text(
                        _mechanicWorkTime,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (_workStartTime != null && _workEndTime != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      'Automatically calculated from start and end times',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),

                // Waiting Time Dropdown
                _buildWaitingTimeDropdown(),
                const SizedBox(height: 24),

                // Solution
                _buildSectionTitle('Solution'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _solutionController,
                  decoration: InputDecoration(
                    labelText: 'Solution Applied *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.build),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter solution applied';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _validateForm()
                        ? () {
                      if (_formKey.currentState!.validate()) {
                        _submitRequest();
                      }
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Submit Repair Request',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMaintenanceTypeDropdown(List<MaintananceTypeModel> maintenanceTypes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Maintenance Type *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: _selectedMaintenanceType == null ? Colors.red : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<MaintananceTypeModel>(
              value: _selectedMaintenanceType,
              isExpanded: true,
              hint: const Text('Select maintenance type'),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
              items: maintenanceTypes.map((type) {
                return DropdownMenuItem<MaintananceTypeModel>(
                  value: type,
                  child: Text(type.maintenanceName ?? 'Unnamed'),
                );
              }).toList(),
              onChanged: (MaintananceTypeModel? newValue) {
                setState(() {
                  _selectedMaintenanceType = newValue;
                });
              },
              menuMaxHeight: 300, // Set max height for dropdown menu
            ),
          ),
        ),
        if (_selectedMaintenanceType == null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0),
            child: Text(
              'Required',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildProcessNameDropdown(List<ProcessNameModel> processNames) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Process Name *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: _selectedProcessName == null ? Colors.red : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<ProcessNameModel>(
              value: _selectedProcessName,
              isExpanded: true,
              hint: const Text('Select process name'),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
              items: processNames.map((process) {
                return DropdownMenuItem<ProcessNameModel>(
                  value: process,
                  child: Text(process.taskName ?? 'Unnamed'),
                );
              }).toList(),
              onChanged: (ProcessNameModel? newValue) {
                setState(() {
                  _selectedProcessName = newValue;
                });
              },
              menuMaxHeight: 300, // Set max height for dropdown menu
            ),
          ),
        ),
        if (_selectedProcessName == null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0),
            child: Text(
              'Required',
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildWaitingTimeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Waiting Time *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedWaitingTime,
              isExpanded: true,
              hint: const Text('Select waiting time'),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
              items: _waitingTimeOptions.map((time) {
                return DropdownMenuItem<String>(
                  value: time,
                  child: Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 16, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(time),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedWaitingTime = newValue;
                });
              },
              menuMaxHeight: 300, // Set max height for dropdown menu
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Select waiting time in 15-minute intervals (up to 8 hours)',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
      ),
    );
  }

  Widget _buildTimeField({
    required String label,
    required String value,
    required String hint,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.blue, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value == 'Not selected' ? hint : value,
                    style: TextStyle(
                      color: value == 'Not selected' ? Colors.grey : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Error: $error',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _submitRequest() {
    if (!_validateForm()) return;

    final data = {
      "date": DashboardHelpers.convertDateTime(DateTime.now().toString(), pattern: 'yyyy-MM-dd'),
      "operationId": 3,
      "taskId": _selectedProcessName!.taskId,
      "mechanicInfoTime": _getCurrentDateTimeISO(),
      "workStartTime": _formatDateTimeForAPI(_workStartTime),
      "workEndTime": _formatDateTimeForAPI(_workEndTime),
      "mechanicWorkTime": _mechanicWorkTime,
      "employeeId": DashboardHelpers.currentUser!.employeeId,
      "machineNumber": widget.breakdownModel.machineName,
      "maintenanceTypeId": _selectedMaintenanceType!.maintenanceTypeId,
      "waitingTime": _selectedWaitingTime,
      "solution": _solutionController.text,
    };

    // Call your API service
    apiService.postData('api/Manufacturing/UpdateRequisition', data);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '✅ Repair Request Submitted Successfully!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Maintenance: ${_selectedMaintenanceType!.maintenanceName}'),
            Text('Process: ${_selectedProcessName!.taskName}'),
            Text('Work Duration: $_mechanicWorkTime hours'),
            Text('Waiting Time: $_selectedWaitingTime'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 4),
      ),
    );

    // Navigate back after submission
    Navigator.pop(context, data);
  }
}