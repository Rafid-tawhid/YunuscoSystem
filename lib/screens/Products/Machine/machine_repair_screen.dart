import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yunusco_group/common_widgets/process_dropdown.dart';
import 'package:yunusco_group/models/machine_breakdown_model.dart';
import 'package:yunusco_group/models/maintanance_type_model.dart';
import 'package:yunusco_group/models/process_name_model.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../../models/machine_repair_task_model.dart';
import '../../../providers/riverpods/management_provider.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  ProcessNameModel? _selectedProcess;
  MachineRepairTaskModel? _selectedTask;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _workDuration = '00:00';
  bool _isSubmitting = false;

  // Validation flags
  bool _processError = false;
  bool _taskError = false;
  bool _startTimeError = false;
  bool _endTimeError = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToError() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        // Scroll to top to ensure errors are visible
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final maintenanceTypes = ref.watch(maintenanceTypeProvider);
    final processNames = ref.watch(processNameProvider);
    final taskList = ref.watch(maintenanceTaskList);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Repair Request'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: maintenanceTypes.when(
          loading: () => _buildLoading(),
          error: (error, _) => _buildError(error.toString()),
          data: (types) {
            return processNames.when(
              loading: () => _buildLoading(),
              error: (error, _) => _buildError(error.toString()),
              data: (processList) {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Machine Info Header
                            _buildMachineHeader(),
                            const SizedBox(height: 8),

                            // Maintenance Type (Read-only)
                            _buildMaintenanceTypeCard(types.first),
                            const SizedBox(height: 12),

                            // Process Selection
                            _buildSectionTitle('Select Process'),
                            const SizedBox(height: 8),
                            _buildProcessDropdown(processList),
                            if (_processError) _buildErrorText('Please select a process'),
                            const SizedBox(height: 8),

                            // Task Selection
                            _buildSectionTitle('Select Task'),
                            const SizedBox(height: 8),
                            _buildTaskDropdown(taskList),
                            if (_taskError) _buildErrorText('Please select a task'),
                            const SizedBox(height: 24),

                            // Time Selection
                            _buildSectionTitle('Work Time'),

                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTimePicker(
                                    label: 'Start Time',
                                    time: _startTime,
                                    isError: _startTimeError,
                                    onPicked: (time) {
                                      setState(() {
                                        _startTime = time;
                                        _startTimeError = false;
                                        _calculateWorkDuration();
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTimePicker(
                                    label: 'End Time',
                                    time: _endTime,
                                    isError: _endTimeError,
                                    onPicked: (time) {
                                      setState(() {
                                        _endTime = time;
                                        _endTimeError = false;
                                        _calculateWorkDuration();
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Work Duration Display
                            if (_startTime != null && _endTime != null)
                              _buildWorkDurationCard(),
                          ],
                        ),
                      ),
                    ),

                    // Submit Button
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(top: BorderSide(color: Colors.grey.shade300)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: _buildSubmitButton(types.first),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  // ==================== WIDGET BUILDERS ====================

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading data...',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => setState(() {}),
              style: ElevatedButton.styleFrom(
                backgroundColor: myColors.primaryColor,
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMachineHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: myColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: myColors.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.build_circle_outlined,
            color: myColors.primaryColor,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.breakdownModel.machineName ?? 'Unknown Machine',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.breakdownModel.lineName ?? 'No line specified',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceTypeCard(MaintananceTypeModel type) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: myColors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.category_outlined,
              color: myColors.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Maintenance Type',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  type.maintenanceName ?? 'General Maintenance',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget  _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildProcessDropdown(List<ProcessNameModel> processes) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _processError ? Colors.red.shade400 : Colors.transparent,
          width: _processError ? 1.5 : 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Material(
          color: Colors.white,
          child: ProcessDropdown(
            processes: processes,
            selectedProcess: _selectedProcess,
            onChanged: (ProcessNameModel? process) {
              setState(() {
                _selectedProcess = process;
                _processError = false;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTaskDropdown(AsyncValue<List<MachineRepairTaskModel>> taskList) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _taskError ? Colors.red.shade400 : Colors.grey.shade300,
          width: _taskError ? 1.5 : 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: taskList.when(
          data: (tasks) => ProblemTaskDropdown(
            tasks: tasks,
            selectedTask: _selectedTask,
            onChanged: (MachineRepairTaskModel? task) {
              setState(() {
                _selectedTask = task;
                _taskError = false;
              });
            },
          ),
          loading: () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: myColors.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Loading tasks...',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          error: (error, _) => Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red.shade400,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Failed to load tasks. Tap to retry.',
                    style: TextStyle(
                      color: Colors.red.shade600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => ref.invalidate(maintenanceTaskList),
                  icon: const Icon(Icons.refresh),
                  color: Colors.grey.shade600,
                  iconSize: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimePicker({
    required String label,
    required TimeOfDay? time,
    required bool isError,
    required Function(TimeOfDay) onPicked,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isError ? Colors.red.shade600 : Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                child: child!,
              ),
            );
            if (picked != null) onPicked(picked);
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isError ? Colors.red.shade400 : Colors.grey.shade300,
                width: isError ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: isError ? Colors.red.shade400 : Colors.grey.shade600,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    time == null ? 'Select time' : _formatTime(time),
                    style: TextStyle(
                      fontSize: 16,
                      color: time == null ? Colors.grey.shade500 : Colors.black87,
                    ),
                  ),
                ),
                if (time != null)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (label.contains('Start')) {
                          _startTime = null;
                          _startTimeError = false;
                        } else {
                          _endTime = null;
                          _endTimeError = false;
                        }
                        _calculateWorkDuration();
                      });
                    },
                    icon: Icon(
                      Icons.clear,
                      size: 20,
                      color: Colors.grey.shade500,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkDurationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: myColors.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: myColors.primaryColor.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.timer_outlined,
                color: myColors.primaryColor,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Work Duration',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '$_workDuration hours',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: myColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_startTime != null && _endTime != null ? _calculateTotalMinutes() : 0} min',
              style: TextStyle(
                color: myColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorText(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 14,
            color: Colors.red.shade600,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.red.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(MaintananceTypeModel type) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : () => _validateAndSubmit(type),
        style: ElevatedButton.styleFrom(
          backgroundColor: myColors.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
        ),
        child: _isSubmitting
            ? SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send_outlined, size: 20),
            SizedBox(width: 8),
            Text(
              'SUBMIT REQUEST',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== HELPER METHODS ====================

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
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
      _workDuration = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    });
  }

  int _calculateTotalMinutes() {
    final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    final endMinutes = _endTime!.hour * 60 + _endTime!.minute;

    int diffMinutes = endMinutes - startMinutes;
    if (diffMinutes < 0) diffMinutes += 24 * 60;

    return diffMinutes;
  }

  void _validateAndSubmit(MaintananceTypeModel type) {
    bool isValid = true;

    // Reset errors
    setState(() {
      _processError = _selectedProcess == null;
      _taskError = _selectedTask == null;
      _startTimeError = _startTime == null;
      _endTimeError = _endTime == null;
    });

    // Check all validations
    if (_processError || _taskError || _startTimeError || _endTimeError) {
      isValid = false;
      _scrollToError();
    }

    // Check if end time is after start time
    if (_startTime != null && _endTime != null) {
      final totalMinutes = _calculateTotalMinutes();
      if (totalMinutes <= 0) {
        isValid = false;
        _showError('End time must be after start time');
        return;
      }
    }

    if (isValid) {
      _submitRequest(type);
    }
  }

  Future<void> _submitRequest(MaintananceTypeModel type) async {
    setState(() => _isSubmitting = true);

    try {
      // final payload = {
      //   "date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      //   "operationId": 3,
      //   "taskId": _selectedTask?.taskId ?? 0,
      //   "workStartTime": _toApiTime(_startTime!),
      //   "workEndTime": _toApiTime(_endTime!),
      //   "employeeId": DashboardHelpers.currentUser?.employeeId ?? 0,
      //   "machineNumber": widget.breakdownModel.machineName,
      //   "maintenanceTypeId": type.maintenanceTypeId,
      //   "processId": _selectedProcess?.taskId ?? 0,
      // };

      final payload={
        "Id":widget.breakdownModel.repairId,
        "OperationId": 1,
        "TaskId": _selectedTask!.taskId,
        "WorkStartTime": _toApiTime(_startTime!),
        "WorkEndTime": _toApiTime(_endTime!),
        "MechanicWorkTime": _workDuration
      };

      // TODO: Replace with your actual API call
      debugPrint('Submitting: $payload');
      await apiService.postData('api/Manufacturing/UpdateRequisition', payload);

      // Show success
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Repair request submitted successfully!'),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );

        // Wait a moment before navigating back
        await Future.delayed(const Duration(milliseconds: 1500));
        Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint('Submission error: $e');
      if (mounted) {
        _showError('Failed to submit request: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }


  String formatDuration(Duration duration) {
    // Handle negative durations if needed
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    return '${twoDigits(hours)}:${twoDigits(minutes)}';
  }

  String getTimeDifference(TimeOfDay start, TimeOfDay end) {
    // Convert TimeOfDay to minutes
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    // Calculate difference
    int diffMinutes;
    if (endMinutes >= startMinutes) {
      diffMinutes = endMinutes - startMinutes;
    } else {
      // Handle overnight duration (crossing midnight)
      diffMinutes = (24 * 60 - startMinutes) + endMinutes;
    }

    final duration = Duration(minutes: diffMinutes);
    return formatDuration(duration);
  }

  String _toApiTime(TimeOfDay t) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, t.hour, t.minute);
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dt);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class AsyncProblemTaskDropdown extends StatelessWidget {
  final AsyncValue<List<MachineRepairTaskModel>> taskList;
  final MachineRepairTaskModel? selectedTask;
  final ValueChanged<MachineRepairTaskModel?> onChanged;

  const AsyncProblemTaskDropdown({
    super.key,
    required this.taskList,
    required this.selectedTask,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return taskList.when(
      data: (tasks) => ProblemTaskDropdown(
        tasks: tasks,
        selectedTask: selectedTask,
        onChanged: onChanged,
      ),
      loading: () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            CircularProgressIndicator(strokeWidth: 1),
            SizedBox(width: 8),
            Text('Loading tasks...'),
          ],
        ),
      ),
      error: (error, stackTrace) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Failed to load tasks',
                style: TextStyle(color: Colors.red[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}