import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/common_widgets/custom_button.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../../models/doc_appoinment_list_model.dart';
import '../../../models/employee_appointment_info_model.dart';
import 'get_all_medicine.dart';

class DoctorPrescriptionScreen extends StatefulWidget {
  final EmployeeAppointmentInfoModel employee;
  final DocAppoinmentListModel listInfo;

  const DoctorPrescriptionScreen({super.key, required this.employee, required this.listInfo});

  @override
  State<DoctorPrescriptionScreen> createState() => _DoctorPrescriptionScreenState();
}

class _DoctorPrescriptionScreenState extends State<DoctorPrescriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _diseaseController = TextEditingController();
  final _instructionController = TextEditingController();
  final _gatePassNotes = TextEditingController();
  bool _needsGatePass = false;

  @override
  void dispose() {
    _diseaseController.dispose();
    _instructionController.dispose();
    _gatePassNotes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Dr. Prescription'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Chip(
                    backgroundColor: widget.listInfo.status == 1 ? Colors.orange : Colors.red,
                    label: Text(
                      widget.listInfo.status == 1 ? 'Emergency' : 'Regular',
                      textAlign: TextAlign.end,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    )),
              ),
              // Employee Information Section
              _buildEmployeeInfoCard(),
              const SizedBox(height: 24),
              //
              // Prescription Form Section
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Prescription Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: myColors.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Disease Field
              TextFormField(
                controller: _diseaseController,
                decoration: const InputDecoration(
                  labelText: 'Disease/Diagnosis',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.medical_services),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter disease/diagnosis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MedicineListScreen()));
                },
                child: Container(
                  padding: const EdgeInsets.all(6.0), // Add padding inside the container
                  decoration: BoxDecoration(
                    border: Border.all(
                      // Add border
                      color: Colors.grey, // Border color
                      width: 1.0, // Border width
                    ),
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.medication, color: Colors.green), // Medicine icon
                      const SizedBox(width: 8), // Add some spacing
                      const Expanded(child: Text('Medicine', style: TextStyle(fontSize: 16))),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(Icons.add, color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ),

              // Medicine Field

              Consumer<HrProvider>(
                builder: (context, pro, _) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  pro.prepareMedicineList.isNotEmpty ? SizedBox(height: 16) : SizedBox.shrink(),
                  ...pro.prepareMedicineList.map((e) => Card(
                        child: ListTile(
                          title: Text(e.productName),
                          subtitle: Text('Qty: ${e.quantity.toString()}'),
                          trailing: IconButton(
                              onPressed: () {
                                var hp = context.read<HrProvider>();
                                hp.removeMedicine(e);
                              },
                              icon: Icon(Icons.close)),
                        ),
                      )),
                ]),
              ),
              const SizedBox(height: 16),

              // Instructions Field
              TextFormField(
                controller: _instructionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Dr. Advice',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.note),
                ),
              ),
              // Gate Pass Radio
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.exit_to_app, color: Colors.blue),
                      const SizedBox(width: 8),
                      const Text(
                        'Needs Gate Pass:',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 16),
                      Radio<bool>(
                        value: true,
                        groupValue: _needsGatePass,
                        onChanged: (value) {
                          setState(() {
                            _needsGatePass = value ?? false;
                          });
                        },
                      ),
                      const Text('Yes'),
                      const SizedBox(width: 16),
                      Radio<bool>(
                        value: false,
                        groupValue: _needsGatePass,
                        onChanged: (value) {
                          setState(() {
                            _needsGatePass = value ?? false;
                          });
                        },
                      ),
                      const Text('No'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              //gate pass notes
              if (_needsGatePass)
                TextFormField(
                  controller: _gatePassNotes,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    labelText: 'Leave Notes',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.note),
                  ),
                ),
              const SizedBox(height: 24),
              // Submit Button
              Consumer<HrProvider>(
                builder: (context, pro, _) => CustomElevatedButton(
                  onPressed: _submitPrescription,
                  isLoading: pro.isLoading,
                  text: 'Submit Prescription',
                ),
              ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeInfoCard() {
    return Card(
      elevation: 3,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(alignment: Alignment.bottomRight, child: Text('Serial No: ${widget.listInfo.serialNo}')),
            Text(
              'Patient Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: myColors.primaryColor,
              ),
            ),
            const Divider(),
            _buildInfoRow('Name', widget.employee.fullName),
            _buildInfoRow('ID', widget.employee.idCardNo),
            _buildInfoRow('Department', widget.employee.departmentName),
            _buildInfoRow('Designation', widget.employee.designationName),
            _buildInfoRow('Age/Gender', '${widget.employee.ageYears} yrs / ${widget.employee.gender}'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitPrescription() async {
    if (_formKey.currentState!.validate()) {
      var hp = context.read<HrProvider>();
      List<Map<String, dynamic>> medicins = [];
      for (var e in hp.prepareMedicineList) {
        medicins.add(e.toJson());
      }
      // debugPrint('hp.prepareMedicineList ${medicins}');
      // Process the prescription data
      final prescriptionData = {
        'idCardNo': widget.employee.idCardNo,
        "diagnosis": _diseaseController.text,
        "advice": _instructionController.text,
        "remarks": _gatePassNotes.text,
        "prescriptionDate": DashboardHelpers.convertDateTime2(DateTime.now()),
        'gatePassStatus': _needsGatePass,
        "NotifyAccessType": 4,
        "PrescriptionDetails": medicins
      };
      if (await hp.saveGatePassInfo(prescriptionData)) {
        await hp.getAllDocAppointment();
        if (mounted) {
          DashboardHelpers.showSnakBar(context: context, message: 'Prescription submitted successfully!');
        }
        if (mounted) Navigator.pop(context);
      }

      // Show success message

      // Optionally navigate back
      // Navigator.pop(context);
    }
  }
}
