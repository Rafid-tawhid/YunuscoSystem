// lib/screens/machine_repair_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../../models/machine_breakdown_dropdown.dart';
import '../../../providers/riverpods/production_provider.dart';
import 'machine_problem_list.dart';

class MachineRepairScreen extends ConsumerStatefulWidget {
  List<String> machineInfo;
  MachineRepairScreen({super.key, this.machineInfo = const []});

  @override
  ConsumerState<MachineRepairScreen> createState() => _MachineRepairScreenState();
}

class _MachineRepairScreenState extends ConsumerState<MachineRepairScreen> {
  // Local form state
  //final MachineRepairForm _formData = MachineRepairForm();

  // Text controllers
  final _machineCodesController = TextEditingController();
  final _problemTaskCodesController = TextEditingController();
  final _machineTypeController = TextEditingController();
  Operations? _selectedOperation;
  ProductionLines? _productionLines;
  Employees? _employees;
  Tasks? _tasks;

  @override
  void dispose() {
    _machineCodesController.dispose();
    _problemTaskCodesController.dispose();
    _machineTypeController.dispose();
    super.dispose();
  }

  void _retryLoading() {
    ref.invalidate(machineDropdownDataProvider);
  }

  @override
  Widget build(BuildContext context) {
    final dropdownDataAsync = ref.watch(machineDropdownDataProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Machine Breakdown'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>MachineBreakdownListScreen()));
          }, icon: Icon(Icons.list)),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _retryLoading,
            tooltip: 'Refresh data',
          ),
        ],
      ),
      body: dropdownDataAsync.when(
        data: (dropdownData) {
          return _buildForm(dropdownData);
        },
        loading: () => _buildLoadingState(),
        error: (error, stackTrace) => _buildErrorState(error, stackTrace),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          Text(
            'Loading Maintenance Data...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error, StackTrace stackTrace) {
    String errorMessage = 'An error occurred';

    if (error is Exception) {
      errorMessage = error.toString().replaceAll('Exception: ', '');
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red[400],
              size: 70,
            ),
            const SizedBox(height: 20),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Text(
                errorMessage,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: _retryLoading,
              style: ElevatedButton.styleFrom(
                backgroundColor: myColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text(
                'Retry Loading Data',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(MachineBreakdownDropdown dropdownData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Parsed names
          if(widget.machineInfo.isNotEmpty)Column(
            children: [
              Text(
                'Machine Info:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade700,
                ),
              ),
              SizedBox(height: 8),

              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: widget.machineInfo
                      .asMap()
                      .entries
                      .map((entry) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: entry.key < 1 // only first element gets bottom border
                              ? BorderSide(color: Colors.blue.shade100)
                              : BorderSide.none,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${entry.key + 1}', // numbers will be 1,2 for the last 2 elements
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          SizedBox(height: 8),
          _buildProductionLineDropdown(
            label: 'Line # :',
            lines: dropdownData.productionLines ?? [],
            selectedLine: _productionLines,
            onChanged: (line) {
              setState(() {
                _productionLines = line;
              });
            },
          ),

          const SizedBox(height: 16),

          // Action Buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildTaskDropdown({
    required String label,
    required List<Tasks> tasks,
    required Tasks? selectedTask,
    required Function(Tasks?) onChanged,
  }) {
    return _buildGenericDropdown<Tasks>(
      label: label,
      value: selectedTask,
      items: tasks,
      displayText: (task) => '${task.taskName} (${task.taskCode})',
      hintText: 'Select Task',
      onChanged: onChanged,
    );
  }


  Widget _buildOperationDropdown({
    required String label,
    required List<Operations> operations,
    required Operations? selectedOperation,
    required Function(Operations?) onChanged,
  }) {
    return _buildGenericDropdown<Operations>(
      label: label,
      value: selectedOperation,
      items: operations,
      displayText: (operation) => operation.operationName ?? 'Unknown',
      hintText: 'Select Operation',
      onChanged: onChanged,
    );
  }

  Widget _buildProductionLineDropdown({
    required String label,
    required List<ProductionLines> lines,
    required ProductionLines? selectedLine,
    required Function(ProductionLines?) onChanged,
  }) {
    return _buildGenericDropdown<ProductionLines>(
      label: label,
      value: selectedLine,
      items: lines,
      displayText: (line) => line.name ?? line.shortName ?? 'Unknown',
      hintText: 'Select Production Line',
      onChanged: onChanged,
    );
  }

  Widget _buildEmployeeDropdown({
    required String label,
    required List<Employees> employees,
    required Employees? selectedEmployee,
    required Function(Employees?) onChanged,
  }) {
    return _buildGenericDropdown<Employees>(
      label: label,
      value: selectedEmployee,
      items: employees,
      displayText: (employee) => '${employee.employeeName} (${employee.employeeCode})',
      hintText: 'Select Employee',
      onChanged: onChanged,
    );
  }

  Widget _buildGenericDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required String Function(T) displayText,
    required String hintText,
    required Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              hint: Text(
                hintText,
                style: TextStyle(color: Colors.grey[500]),
              ),
              items: items.map((T item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    displayText(item),
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 0,
            ),
          ),
          maxLines: maxLines,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: myColors.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
            icon: const Icon(Icons.save, size: 20),
            label: const Text(
              'Submit Repair',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submitForm() async {


    var data={
      "machineId": widget.machineInfo[0],
      "machineTypeId": widget.machineInfo[1],
      "lineId": _productionLines!.lineId
    };

    final submitFunction = ref.read(submitMachineRepair);

    // Call the function with your data
    final response = await submitFunction(data);
    if(response['Success']){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Repair information submitted successfully!'),
          backgroundColor: Colors.green[600],
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.pop(context);
      Navigator.pop(context);
    }



  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}