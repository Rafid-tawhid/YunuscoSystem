import 'package:flutter/material.dart';
import 'package:yunusco_group/common_widgets/custom_button.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../../models/employee_appointment_info_model.dart';
import 'get_all_medicine.dart';

class DoctorPrescriptionScreen extends StatefulWidget {
  final EmployeeAppointmentInfoModel employee;

  const DoctorPrescriptionScreen({super.key, required this.employee});

  @override
  State<DoctorPrescriptionScreen> createState() => _DoctorPrescriptionScreenState();
}

class _DoctorPrescriptionScreenState extends State<DoctorPrescriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _diseaseController = TextEditingController();
  final _instructionController = TextEditingController();
  bool _needsGatePass = false;

  @override
  void dispose() {
    _diseaseController.dispose();
    _instructionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Doctor Prescription'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Employee Information Section
              _buildEmployeeInfoCard(),
              const SizedBox(height: 24),

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
                onTap: (){

                },
                child: Container(
                  padding: const EdgeInsets.all(6.0), // Add padding inside the container
                  decoration: BoxDecoration(
                    border: Border.all( // Add border
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
                      IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>MedicineListScreen()));
                        },
                        icon: const Icon(Icons.add, color: Colors.green),
                        padding: const EdgeInsets.all(8.0), // Add padding to the button
                      ),
                    ],
                  ),
                ),
              ),

              // Medicine Field

              const SizedBox(height: 16),

              // Instructions Field
              TextFormField(
                controller: _instructionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Instructions',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.note),
                ),
              ),
              const SizedBox(height: 16),

              // Gate Pass Radio
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
              const SizedBox(height: 24),

              // Submit Button
              CustomElevatedButton(
                onPressed: _submitPrescription,
                text: 'Submit Prescription',
              ),
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
            _buildInfoRow('Age/Gender',
                '${widget.employee.ageYears} yrs / ${widget.employee.gender}'),
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

  void _submitPrescription() {
    if (_formKey.currentState!.validate()) {
      // Process the prescription data
      final prescriptionData = {
        'employeeId': widget.employee.idCardNo,
        'disease': _diseaseController.text,
        'instructions': _instructionController.text,
        'needsGatePass': _needsGatePass,
        'timestamp': DateTime.now().toString(),
      };

      // Here you would typically send this data to your backend
      print('Prescription Data: $prescriptionData');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prescription submitted successfully!')),
      );

      // Optionally navigate back
      // Navigator.pop(context);
    }
  }
}