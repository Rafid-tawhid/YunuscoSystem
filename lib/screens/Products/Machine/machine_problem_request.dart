// lib/screens/machine_repair_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../../models/machine_breakdown_dropdown.dart';
import '../../../models/machine_scan_model.dart';
import '../../../providers/riverpods/production_provider.dart';
import '../widgets/machine_line_dropdown.dart';
import 'machine_problem_list.dart';

class MachineRepairScreen extends ConsumerStatefulWidget {
  MachineScanModel? machineInfo;


  MachineRepairScreen({this.machineInfo});

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
  ProductionLines? _productionLines;


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
          if(widget.machineInfo==null)Column(
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
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.blue.shade100)
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        widget.machineInfo!.machineName??'',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.blue.shade100)
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        widget.machineInfo!.machineTypeId.toString()??'',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 8),

          ProductionLineDropdown(
            label: 'Production Line',
            selectedLine: _productionLines, // Your state variable
            onChanged: (newLine) {
              setState(() {
                _productionLines = newLine;
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
      "machineId": widget.machineInfo!.machineId,
      "machineTypeId": widget.machineInfo!.machineTypeId,
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