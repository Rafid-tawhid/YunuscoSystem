import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/models/machine_breakdown_model.dart';
import 'package:yunusco_group/models/maintanance_type_model.dart';
import 'package:yunusco_group/models/process_name_model.dart';
import 'package:yunusco_group/providers/riverpods/management_provider.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../../providers/riverpods/production_provider.dart';

// Problem tasks list (moved to top for better visibility)
const List<String> problemTasks = [
  'Machine Overheating',
  'Unusual Noises/Vibration',
  'Power Supply Issue',
  'Motor Failure',
  'Bearing Wear/Failure',
  'Belt/Pulley Damage',
  'Gearbox Malfunction',
  'Hydraulic System Leak',
  'Pneumatic System Failure',
  'Electrical Short Circuit',
  'Control Panel Malfunction',
  'Sensor Failure',
  'Lubrication System Issue',
  'Cooling System Failure',
  'Alignment Problem',
  'Calibration Required',
  'Software/Firmware Error',
  'Network Connectivity Issue',
  'Mechanical Jam/Obstruction',
  'Wear & Tear Replacement',
  'Preventive Maintenance',
  'Scheduled Service',
  'Emergency Repair',
  'Performance Optimization',
  'Safety System Check',
  'Emergency Stop Malfunction',
  'Spindle/Bearing Noise',
  'Tool Changer Issue',
  'CNC Controller Error',
  'Axis Movement Problem',
  'Surface Finish Issue',
  'Dimensional Inaccuracy',
  'Production Quality Issue',
  'Cycle Time Extended',
  'Material Feeding Problem',
  'Product Ejection Issue',
  'Fixture/Clamping Problem',
  'Coolant System Failure',
  'Chip Removal Issue',
  'Dust Collection Problem',
];

// ==================== WIDGET CLASSES ====================

class MachineProblemRequestScreen extends ConsumerStatefulWidget {
  final MachineBreakdownModel? breakdownModel;
  const MachineProblemRequestScreen({
    super.key,
    this.breakdownModel,
  });

  @override
  ConsumerState<MachineProblemRequestScreen> createState() =>
      _MachineProblemRequestScreenState();
}

class _MachineProblemRequestScreenState
    extends ConsumerState<MachineProblemRequestScreen> {
  // State variables
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Form data
  MaintananceTypeModel? _selectedMaintenanceType;
  ProcessNameModel? _selectedProcessName;
  String? _selectedProblemTask;
  String? _selectedMachineCode;
  String? _selectedMachineType;

  // Time data
  TimeOfDay? _workStartTime;
  TimeOfDay? _workEndTime;
  String _mechanicWorkTime = '';

  // Text controllers
  final TextEditingController _solutionController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  // Loading states
  bool _isLoading = false;
  bool _isSubmitting = false;

  // Dropdown options
  final List<String> _machineCodes = [
    'MC-001', 'MC-002', 'MC-003',
    'MC-004', 'MC-005', 'MC-006',
  ];

  final List<String> _machineTypes = [
    'CNC Machine', 'Lathe Machine', 'Milling Machine',
    'Drilling Machine', 'Grinding Machine', 'Welding Machine',
    'Cutting Machine', 'Press Machine',
  ];

  @override
  void initState() {
    super.initState();
    _loadDropdownData();
  }

  @override
  void dispose() {
    _solutionController.dispose();
    _remarksController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ==================== DATA LOADING ====================

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
        _showErrorSnackBar('Failed to load dropdown data');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ==================== TIME HANDLING ====================

  Future<void> _selectWorkStartTime(BuildContext context) async {
    final TimeOfDay? picked = await _showTimePickerDialog(
      context: context,
      initialTime: _workStartTime ?? TimeOfDay.now(),
      helpText: 'SELECT WORK START TIME',
      primaryColor: Colors.blue,
    );

    if (picked != null) {
      setState(() {
        _workStartTime = picked;
        _calculateWorkDuration();
      });
    }
  }

  Future<void> _selectWorkEndTime(BuildContext context) async {
    final TimeOfDay? picked = await _showTimePickerDialog(
      context: context,
      initialTime: _workEndTime ?? (_workStartTime ?? TimeOfDay.now()),
      helpText: 'SELECT WORK END TIME',
      primaryColor: Colors.green,
    );

    if (picked != null) {
      setState(() {
        _workEndTime = picked;
        _calculateWorkDuration();
      });
    }
  }

  Future<TimeOfDay?> _showTimePickerDialog({
    required BuildContext context,
    required TimeOfDay initialTime,
    required String helpText,
    required Color primaryColor,
  }) async {
    return await showTimePicker(
      context: context,
      initialTime: initialTime,
      initialEntryMode: TimePickerEntryMode.dial,
      helpText: helpText,
      cancelText: 'CANCEL',
      confirmText: 'CONFIRM',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteTextColor: Colors.black,
              hourMinuteColor: primaryColor,
              dayPeriodTextColor: Colors.black,
              dayPeriodColor: primaryColor,
              dialBackgroundColor: Colors.white,
              dialHandColor: primaryColor,
              dialTextColor: Colors.black,
              entryModeIconColor: primaryColor,
              helpTextStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  void _calculateWorkDuration() {
    if (_workStartTime == null || _workEndTime == null) return;

    final startMinutes = _workStartTime!.hour * 60 + _workStartTime!.minute;
    final endMinutes = _workEndTime!.hour * 60 + _workEndTime!.minute;
    int diffMinutes = endMinutes - startMinutes;

    if (diffMinutes < 0) diffMinutes += 24 * 60;

    final hours = diffMinutes ~/ 60;
    final minutes = diffMinutes % 60;

    setState(() {
      _mechanicWorkTime =
      '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    });
  }

  String _formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return 'Not selected';
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
  }

  String _formatDateTimeForAPI(TimeOfDay? time) {
    if (time == null) return '';
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(dateTime);
  }

  // ==================== FORM VALIDATION ====================

  bool _validateForm() {
    return _selectedMaintenanceType != null &&
        _workStartTime != null &&
        _workEndTime != null;
  }

  List<MaintananceTypeModel> _getFilteredMaintenanceTypes(
      List<MaintananceTypeModel> allTypes) {
    if (widget.breakdownModel == null) {
      return allTypes.length > 1 ? allTypes.sublist(1) : allTypes;
    } else {
      return [allTypes.first];
    }
  }

  // ==================== SNACKBAR HELPERS ====================

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            const Expanded(child: Text('Repair request submitted successfully!')),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ==================== API SUBMISSION ====================

  Future<void> _submitRequest() async {
    if (!_validateForm()) {
      _showErrorSnackBar('Please fill all required fields');
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final data = _prepareSubmissionData();
      debugPrint('Submitting data: $data');

      // Call API service
      await apiService.postData('api/Manufacturing/UpdateRequisition', data);

      _showSuccessSnackBar();

      if (mounted) {
        Navigator.pop(context, data);
      }
    } catch (e) {
      debugPrint('Error submitting request: $e');
      _showErrorSnackBar('Failed to submit request: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Map<String, dynamic> _prepareSubmissionData() {
    final data = <String, dynamic>{
      "date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      "operationId": _selectedMaintenanceType!.maintenanceTypeId,
      "taskId": _selectedProcessName?.taskId ?? 0,
      "mechanicInfoTime": _getCurrentDateTimeISO(),
      "workStartTime": _formatDateTimeForAPI(_workStartTime),
      "workEndTime": _formatDateTimeForAPI(_workEndTime),
      "mechanicWorkTime": _mechanicWorkTime,
      "employeeId": DashboardHelpers.currentUser?.employeeId ?? 0,
      "problemTask": _selectedProblemTask,
      "machineCode": _selectedMachineCode,
      "machineType": _selectedMachineType,
      "solution": _solutionController.text,
    };

    // Add conditional fields
    if (widget.breakdownModel != null) {
      data["id"] = _selectedProcessName?.taskId;
      data["machineNumber"] = widget.breakdownModel?.machineName ?? '';
      data["maintenanceTypeId"] = _selectedMaintenanceType!.maintenanceTypeId;
    }

    return data;
  }

  String _getCurrentDateTimeISO() {
    final now = DateTime.now();
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(now);
  }

  // ==================== BUILD METHOD ====================

  @override
  Widget build(BuildContext context) {
    final maintenanceTypesAsync = ref.watch(maintenanceTypeProvider);
    final processNameList = ref.watch(processNameProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.breakdownModel != null ? 'Repair Request' : 'New Maintenance Request',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Progress indicator
            if (_isSubmitting) _buildProgressIndicator(),

            Expanded(
              child: _buildMainContent(
                maintenanceTypesAsync: maintenanceTypesAsync,
                processNameList: processNameList,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== UI COMPONENTS ====================

  Widget _buildProgressIndicator() {
    return LinearProgressIndicator(
      backgroundColor: Colors.grey[200],
      valueColor: AlwaysStoppedAnimation<Color>(myColors.primaryColor),
      minHeight: 2,
    );
  }

  Widget _buildMainContent({
    required AsyncValue<List<MaintananceTypeModel>> maintenanceTypesAsync,
    required AsyncValue<List<ProcessNameModel>> processNameList,
  }) {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Machine Details (only for existing breakdowns)
            if (widget.breakdownModel != null) _buildMachineDetailsCard(),

            // Current Date Card
            _buildDateCard(),

            const SizedBox(height: 20),

            // Maintenance Type Section
            _buildMaintenanceTypeSection(maintenanceTypesAsync),

            const SizedBox(height: 20),

            // Process Name (only for existing breakdowns)
            if (widget.breakdownModel != null)
              _buildProcessNameSection(processNameList),

            // Time Selection Section
            _buildTimeSelectionSection(),

            const SizedBox(height: 20),

            // Dynamic Fields based on Maintenance Type
            if (_selectedMaintenanceType != null) _buildDynamicFieldsSection(),

            // Solution Field (only for new requests)
            if (widget.breakdownModel == null) _buildSolutionSection(),

            const SizedBox(height: 32),

            // Submit Button
            _buildSubmitButton(),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ==================== SECTION BUILDERS ====================

  Widget _buildMachineDetailsCard() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.build_circle_outlined,
                  color: myColors.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Machine Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.memory,
              label: 'Machine Name',
              value: widget.breakdownModel!.machineName ?? 'N/A',
            ),
            if (widget.breakdownModel!.sectionName != null)
              _buildDetailRow(
                icon: Icons.location_on_outlined,
                label: 'Section',
                value: widget.breakdownModel!.sectionName!,
              ),
            if (widget.breakdownModel!.lineName != null)
              _buildDetailRow(
                icon: Icons.line_style,
                label: 'Line',
                value: widget.breakdownModel!.lineName!,
              ),
            if (widget.breakdownModel!.requisitionCode != null)
              _buildDetailRow(
                icon: Icons.qr_code,
                label: 'Requisition Code',
                value: widget.breakdownModel!.requisitionCode!,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: myColors.primaryColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Request Date',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('EEEE, MMMM dd, yyyy').format(DateTime.now()),
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
      ),
    );
  }

  Widget _buildMaintenanceTypeSection(
      AsyncValue<List<MaintananceTypeModel>> maintenanceTypesAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Maintenance Details'),
        const SizedBox(height: 12),
        maintenanceTypesAsync.when(
          data: (allTypes) => _buildMaintenanceTypeDropdown(allTypes),
          loading: () => _buildLoadingIndicator(),
          error: (error, _) => _buildErrorWidget(error.toString()),
        ),
      ],
    );
  }

  Widget _buildProcessNameSection(
      AsyncValue<List<ProcessNameModel>> processNameList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        processNameList.when(
          data: (processNames) => _buildProcessNameDropdown(processNames),
          loading: () => _buildLoadingIndicator(),
          error: (error, _) => _buildErrorWidget(error.toString()),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTimeSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Time Information'),
        const SizedBox(height: 12),
        // Work Start Time
        _buildTimeFieldCard(
          label: 'Work Start Time *',
          value: _formatTimeOfDay(_workStartTime),
          hint: 'Select start time',
          icon: Icons.play_circle_fill_outlined,
          color: Colors.blue,
          onTap: () => _selectWorkStartTime(context),
        ),
        const SizedBox(height: 12),

        // Work End Time
        _buildTimeFieldCard(
          label: 'Work End Time *',
          value: _formatTimeOfDay(_workEndTime),
          hint: 'Select end time',
          icon: Icons.stop_circle_outlined,
          color: Colors.green,
          onTap: () => _selectWorkEndTime(context),
        ),
        const SizedBox(height: 12),

        // Duration Display
        _buildDurationCard(),
      ],
    );
  }

  Widget _buildDynamicFieldsSection() {
    if (_selectedMaintenanceType!.maintenanceTypeId == 3) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Machine Information'),
          const SizedBox(height: 12),
          _buildMachineCodeDropdown(),
          const SizedBox(height: 12),
          _buildMachineTypeDropdown(),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Problem Details'),
          const SizedBox(height: 12),
          _buildProblemTaskDropdown(),
        ],
      );
    }
  }

  Widget _buildSolutionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _buildSectionTitle('Repair Details'),
        const SizedBox(height: 12),
        _buildSolutionField(),
      ],
    );
  }

  // ==================== FORM FIELD WIDGETS ====================

  Widget _buildMaintenanceTypeDropdown(List<MaintananceTypeModel> allTypes) {
    final filteredTypes = _getFilteredMaintenanceTypes(allTypes);

    // Auto-select first item
    if (_selectedMaintenanceType == null && filteredTypes.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedMaintenanceType = filteredTypes.first;
        });
      });
    }

    return _buildDropdown<MaintananceTypeModel>(
      label: 'Maintenance Type *',
      value: _selectedMaintenanceType,
      items: filteredTypes,
      hint: 'Select maintenance type',
      isRequired: _selectedMaintenanceType == null,
      itemBuilder: (type) => Text(type.maintenanceName ?? 'Unnamed'),
      onChanged: (newValue) {
        setState(() {
          _selectedMaintenanceType = newValue;
          _selectedProblemTask = null;
          _selectedMachineCode = null;
          _selectedMachineType = null;
        });
      },
    );
  }

  Widget _buildProcessNameDropdown(List<ProcessNameModel> processNames) {
    // Auto-select first item
    if (_selectedProcessName == null && processNames.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedProcessName = processNames.first;
        });
      });
    }

    return _buildDropdown<ProcessNameModel>(
      label: 'Process Name *',
      value: _selectedProcessName,
      items: processNames,
      hint: 'Select process name',
      itemBuilder: (process) => Text(process.taskName ?? 'Unnamed'),
      onChanged: (newValue) {
        setState(() => _selectedProcessName = newValue);
      },
    );
  }

  Widget _buildMachineCodeDropdown() {
    return _buildDropdown<String>(
      label: 'Machine Code *',
      value: _selectedMachineCode,
      items: _machineCodes,
      hint: 'Select machine code',
      icon: Icons.qr_code_2_outlined,
      iconColor: Colors.blue.shade600,
      itemBuilder: (code) => Row(
        children: [
          Icon(Icons.qr_code_2_outlined, color: Colors.blue.shade600, size: 18),
          const SizedBox(width: 10),
          Text(code),
        ],
      ),
      onChanged: (newValue) {
        setState(() => _selectedMachineCode = newValue);
      },
    );
  }

  Widget _buildMachineTypeDropdown() {
    return _buildDropdown<String>(
      label: 'Machine Type *',
      value: _selectedMachineType,
      items: _machineTypes,
      hint: 'Select machine type',
      icon: Icons.category_outlined,
      iconColor: Colors.green.shade600,
      itemBuilder: (type) => Row(
        children: [
          Icon(Icons.category_outlined, color: Colors.green.shade600, size: 18),
          const SizedBox(width: 10),
          Text(type),
        ],
      ),
      onChanged: (newValue) {
        setState(() => _selectedMachineType = newValue);
      },
    );
  }

  Widget _buildProblemTaskDropdown() {
    return _buildDropdown<String>(
      label: 'Problem Task *',
      value: _selectedProblemTask,
      items: problemTasks,
      hint: 'Select problem task',
      icon: Icons.warning_outlined,
      iconColor: Colors.red.shade600,
      itemBuilder: (task) => Row(
        children: [
          Icon(Icons.warning_outlined, color: Colors.red.shade600, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              task,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      onChanged: (newValue) {
        setState(() => _selectedProblemTask = newValue);
      },
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required String hint,
    required Widget Function(T) itemBuilder,
    required void Function(T?) onChanged,
    bool isRequired = false,
    IconData? icon,
    Color? iconColor,
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
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isRequired ? Colors.red.shade300 : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T>(
                  value: value,
                  isExpanded: true,
                  hint: Text(
                    hint,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  iconSize: 28,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                  items: items.map((item) {
                    return DropdownMenuItem<T>(
                      value: item,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: itemBuilder(item),
                      ),
                    );
                  }).toList(),
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
        ),
        if (isRequired)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0),
            child: Text(
              'Required field',
              style: TextStyle(
                color: Colors.red.shade600,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTimeFieldCard({
    required String label,
    required String value,
    required String hint,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isSelected = value != 'Not selected';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color.withOpacity(0.3) : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isSelected ? value : hint,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? color : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.access_time,
              color: isSelected ? color : Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(
            Icons.timer_outlined,
            color: _mechanicWorkTime.isEmpty ? Colors.grey : Colors.orange,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Work Duration',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  _mechanicWorkTime.isEmpty ? '--:--' : _mechanicWorkTime,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _mechanicWorkTime.isEmpty
                        ? Colors.grey
                        : Colors.orange.shade800,
                  ),
                ),
              ],
            ),
          ),
          if (_workStartTime != null && _workEndTime != null)
            Chip(
              label: const Text('Auto-calculated'),
              backgroundColor: Colors.orange.shade50,
              labelStyle: const TextStyle(
                fontSize: 11,
                color: Colors.orange,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            ),
        ],
      ),
    );
  }

  Widget _buildSolutionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Solution Applied *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _solutionController,
          decoration: InputDecoration(
            hintText: 'Describe the solution applied...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: myColors.primaryColor, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: const Icon(Icons.build, color: Colors.blue),
            contentPadding: const EdgeInsets.all(16),
          ),
          maxLines: 4,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the solution applied';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isSubmitting || !_validateForm() ? null : _submitRequest,
        style: ElevatedButton.styleFrom(
          backgroundColor: myColors.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isSubmitting
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Submitting...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.send, size: 20),
            const SizedBox(width: 8),
            Text(
              widget.breakdownModel != null
                  ? 'Submit Repair Request'
                  : 'Submit Maintenance Request',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== UTILITY WIDGETS ====================

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: myColors.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: myColors.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade200, width: 1),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Error: ${error.length > 100 ? '${error.substring(0, 100)}...' : error}',
              style: TextStyle(
                color: Colors.red.shade800,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          TextButton(
            onPressed: _loadDropdownData,
            child: Text(
              'Retry',
              style: TextStyle(
                color: myColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}