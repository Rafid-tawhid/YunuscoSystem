import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/hr_provider.dart';

import '../../../models/vehicle_model.dart';

class VehicleApprovalScreen extends StatefulWidget {
  final VehicleModel vehicleModel;

  VehicleApprovalScreen({required this.vehicleModel});

  @override
  _VehicleApprovalScreenState createState() => _VehicleApprovalScreenState();
}

class _VehicleApprovalScreenState extends State<VehicleApprovalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleNumberController = TextEditingController();
  final _driverNameController = TextEditingController();
  final _driverPhoneController = TextEditingController();
  final _rejectionReasonController = TextEditingController();

  bool _isRejecting = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    _driverNameController.dispose();
    _driverPhoneController.dispose();
    _rejectionReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Vehicle Approval'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Vehicle Number Field
              TextFormField(
                controller: _vehicleNumberController,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Number',
                  prefixIcon: Icon(Icons.directions_car),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (!_isRejecting && (value == null || value.isEmpty)) {
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
                  if (!_isRejecting && (value == null || value.isEmpty)) {
                    return 'Required for approval';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Driver Phone Field (optional)
              TextFormField(
                controller: _driverPhoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Driver Phone (optional)',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Rejection Reason (only shown/required when rejecting)

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.cancel,
                        size: 24,
                        color: Colors.white,
                      ),
                      label: const Text('REJECT', style: TextStyle(fontSize: 16, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _isSubmitting
                          ? null
                          : _showRejectionDialog,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.check_circle,
                        size: 24,
                        color: Colors.white,
                      ),
                      label: const Text('ACCEPT', style: TextStyle(fontSize: 16, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _isSubmitting
                          ? null
                          : () {
                              _submitForm();
                            },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRejectionDialog() {
    final reasonController = TextEditingController();
    final dialogFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Rejection'),
        backgroundColor: Colors.white,
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
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',),
          ),
          ElevatedButton(
            onPressed: () async {
              var hp = context.read<HrProvider>();
              var data =
                {
                  "VehicleReqId":widget.vehicleModel.vehicleReqId,
                  "Status": 3, //rejected
                  "Note": reasonController.text.trim()
                };
              var res = await hp.rejectVehicleRequisation(data);
              if (res) {
                await hp.getRequestedCarList();
                Navigator.pop(context);
                DashboardHelpers.showAlert(msg: 'Reject The requisition');
                setState(() {
                  _vehicleNumberController.clear();
                  _driverNameController.clear();
                  _driverPhoneController.clear();
                  reasonController.clear();
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Confirm',style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
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
        DashboardHelpers.showAnimatedDialog(context, 'Vehicle requisition accepted successfully!!', 'Successful');
        setState(() {
          _vehicleNumberController.clear();
          _driverNameController.clear();
          _driverPhoneController.clear();
        });
      }
    }

    setState(() => _isSubmitting = true);

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _isSubmitting = false);
    });
  }
}
