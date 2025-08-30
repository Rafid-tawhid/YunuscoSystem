import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import '../../../models/vehicle_model.dart';

class VehicleApprovalScreen extends StatefulWidget {
  final VehicleModel vehicleModel;

  const VehicleApprovalScreen({required this.vehicleModel, super.key});

  @override
  _VehicleApprovalScreenState createState() => _VehicleApprovalScreenState();
}

class _VehicleApprovalScreenState extends State<VehicleApprovalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleNumberController = TextEditingController();
  final _driverNameController = TextEditingController();
  final _driverPhoneController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    _driverNameController.dispose();
    _driverPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Requisition Details'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  VehicleDetailsWidget(
                    vehicle: VehicleModel(
                      fullName: widget.vehicleModel.fullName,
                      idCardNo: widget.vehicleModel.idCardNo,
                      departmentName: widget.vehicleModel.departmentName,
                      designationName: widget.vehicleModel.designationName,
                      destinationFrom: widget.vehicleModel.destinationFrom,
                      destinationTo: widget.vehicleModel.destinationTo,
                      distance: widget.vehicleModel.distance,
                      purpose: widget.vehicleModel.purpose,
                      requiredDate: widget.vehicleModel.requiredDate,
                      requiredTime: widget.vehicleModel.requiredTime,
                      duration: '${widget.vehicleModel.duration} hr',
                      vehicletypeId: widget.vehicleModel.vehicletypeId,
                      carryGoods: widget.vehicleModel.carryGoods,
                    ),
                  ),

                  // Vehicle Number Field
                  TextFormField(
                    controller: _vehicleNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Vehicle Number',
                      prefixIcon: Icon(Icons.directions_car),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required for approval';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Driver Name Field
                  TextFormField(
                    controller: _driverNameController,
                    decoration: const InputDecoration(
                      labelText: 'Driver Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required for approval';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Driver Phone Field
                  TextFormField(
                    controller: _driverPhoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Driver Phone (optional)',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.cancel,
                              size: 24, color: Colors.white),
                          label: const Text('REJECT',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _isLoading ? null : _showRejectionDialog,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.check_circle,
                              size: 24, color: Colors.white),
                          label: const Text('ACCEPT',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _isLoading ? null : _submitForm,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  void _showRejectionDialog() {
    final reasonController = TextEditingController();
    final dialogFormKey = GlobalKey<FormState>();
    bool isDialogLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Confirm Rejection'),
            content: Form(
              key: dialogFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Are you sure you want to reject this request?'),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: reasonController,
                    decoration: const InputDecoration(
                      labelText: 'Reason*',
                      border: OutlineInputBorder(),
                      hintText: 'Enter rejection reason',
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Reason is required';
                      }
                      return null;
                    },
                  ),
                  if (isDialogLoading) const SizedBox(height: 16),
                  if (isDialogLoading) const CircularProgressIndicator(),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed:
                    isDialogLoading ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isDialogLoading
                    ? null
                    : () async {
                        if (dialogFormKey.currentState!.validate()) {
                          setState(() => isDialogLoading = true);

                          try {
                            var hp = context.read<HrProvider>();
                            var data = {
                              "VehicleReqId": widget.vehicleModel.vehicleReqId,
                              "Status": 3, //rejected
                              "Note": reasonController.text.trim()
                            };

                            var res = await hp.rejectVehicleRequisation(data);
                            if (res) {
                              await hp.getRequestedCarList();
                              Navigator.pop(context); // Close dialog first
                              DashboardHelpers.showAlert(
                                  msg: 'Rejected the requisition');
                              _clearForm();
                              Navigator.pop(context); // Then pop the screen
                            }
                          } finally {
                            setState(() => isDialogLoading = false);
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Confirm',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        var hp = context.read<HrProvider>();
        var data = {
          "VehicleReqId": widget.vehicleModel.vehicleReqId,
          "Status": 2, //accepted
          "DriverName": _driverNameController.text.trim(),
          "VehicleNo": _vehicleNumberController.text.trim(),
          "DriverMobileNo": _driverPhoneController.text.trim()
        };

        var res = await hp.acceptVehicleRequisation(data);
        if (res) {
          await hp.getRequestedCarList();
          DashboardHelpers.showAlert(
              msg: 'Vehicle requisition accepted successfully!!');
          _clearForm();
          Navigator.pop(context); // Pop the screen after success
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _clearForm() {
    _vehicleNumberController.clear();
    _driverNameController.clear();
    _driverPhoneController.clear();
  }
}

class VehicleDetailsWidget extends StatelessWidget {
  final VehicleModel vehicle;

  const VehicleDetailsWidget({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Employee', vehicle.fullName ?? 'N/A'),
        _buildDetailRow('ID Card No', vehicle.idCardNo ?? 'N/A'),
        _buildDetailRow('Department', vehicle.departmentName ?? 'N/A'),
        _buildDetailRow('Designation', vehicle.designationName ?? 'N/A'),
        const SizedBox(height: 20),
        const Divider(),
        const Text('Trip Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        _buildDetailRow(
            'Vehicle Type', vehicle.vehicletypeId == 1 ? 'Private' : 'Hiace'),
        _buildDetailRow('From', vehicle.destinationFrom ?? 'N/A'),
        _buildDetailRow('To', vehicle.destinationTo ?? 'N/A'),
        _buildDetailRow('Distance', '${vehicle.distance} km'),
        _buildDetailRow('Purpose', vehicle.purpose ?? 'N/A'),
        const SizedBox(height: 20),
        const Divider(),
        const Text('Timing',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        _buildDetailRow('Date', vehicle.requiredDate ?? 'N/A'),
        _buildDetailRow('Time', vehicle.requiredTime ?? 'N/A'),
        _buildDetailRow('Duration', vehicle.duration ?? 'N/A'),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
