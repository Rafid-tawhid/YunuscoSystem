import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/screens/HR&PayRoll/widgets/doctor_screen.dart';
import '../../utils/colors.dart';

class HalfDayLeaveScreen extends StatefulWidget {
  const HalfDayLeaveScreen({super.key});

  @override
  _HalfDayLeaveScreenState createState() => _HalfDayLeaveScreenState();
}

class _HalfDayLeaveScreenState extends State<HalfDayLeaveScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedSymptoms;
  String? _selectedUrgency;
  TimeOfDay? _selectedTime;
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _selectedEmployee = TextEditingController();

  final List<String> _symptoms = [
    'Fever',
    'Injury',
    'Fatigue',
    'Headache',
    'Digestive Issues'
  ];

  final List<String> _urgencyLevels = ['High', 'Medium', 'Low'];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate() &&
        _selectedTime != null) {

      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        String generate6DigitToken() {
          final random = Random();
          return 'YBDL-${1000 + random.nextInt(9000)}';
          // Ensures 6 digits (100000-999999)
        }

        var docToken=generate6DigitToken();

        // Prepare the leave request data
        final requestData = {
          'employeeId': _selectedEmployee.text,
          'symptoms': _selectedSymptoms,
          'urgency': _selectedUrgency,
          'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'time': _selectedTime!.format(context),
          'hour': _selectedTime!.hour,
          'minute': _selectedTime!.minute,
          'reason': _reasonController.text,
          'status': 'Pending',
          'requestTime': FieldValue.serverTimestamp(),
          'approvedBy': DashboardHelpers.currentUser!.userName,
          'docToken':docToken,
          'approvalTime': null,
        };

        // Save to Firestore
        await _firestore.collection('leaveRequests').add(requestData);

        // Close loading indicator
        Navigator.of(context).pop();

        // Show success dialog
        await _showSuccessDialog(docToken);

      } catch (e) {
        // Close loading indicator if still open
        Navigator.of(context).pop();

        // Show error message
        await _showErrorDialog('Failed to submit request: ${e.toString()}');
      }
    } else {
      await _showErrorDialog('Please fill all required fields');
    }
  }
  

  Future<void> _showSuccessDialog(String docToken) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Request Submitted'),
        content:  Text('Your Token is ($docToken)',style: TextStyle(fontSize: 32),),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();

            },
          ),
        ],
      ),
    );
  }

  Future<void> _showErrorDialog(String message) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Half-Day Leave Application'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>DoctorApprovalScreen()));
          }, icon: Icon(Icons.accessibility_new))
        ],
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Employee Details',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: myColors.primaryColor,
                ),
              ),
              const SizedBox(height: 16),

              // Employee Selection
              TextFormField(
                controller: _selectedEmployee,
                decoration: InputDecoration(
                  labelText: 'Employee ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Leave Details',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: myColors.primaryColor,
                ),
              ),
              const SizedBox(height: 16),


              // Time Picker
              InkWell(
                onTap: () => _selectTime(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Leave Time*',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedTime == null
                            ? 'Select time'
                            : _selectedTime!.format(context),
                      ),
                      const Icon(Icons.access_time, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Health Information',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: myColors.primaryColor,
                ),
              ),
              const SizedBox(height: 16),

              // Symptoms Dropdown
              DropdownButtonFormField<String>(
                value: _selectedSymptoms,
                decoration: InputDecoration(
                  labelText: 'Symptoms*',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: _symptoms.map((symptom) {
                  return DropdownMenuItem<String>(
                    value: symptom,
                    child: Text(symptom),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSymptoms = value;
                  });
                },
                validator: (value) =>
                value == null ? 'Please select symptoms' : null,
              ),
              const SizedBox(height: 20),

              // Urgency Level
              DropdownButtonFormField<String>(
                value: _selectedUrgency,
                decoration: InputDecoration(
                  labelText: 'Urgency Level*',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: _urgencyLevels.map((level) {
                  return DropdownMenuItem<String>(
                    value: level,
                    child: Text(level),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedUrgency = value;
                  });
                },
                validator: (value) =>
                value == null ? 'Please select urgency level' : null,
              ),
              const SizedBox(height: 20),

              // Reason Field
              TextFormField(
                controller: _reasonController,
                decoration: InputDecoration(
                  labelText: 'Additional Reason (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitRequest,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: myColors.primaryColor,
                  ),
                  child: const Text(
                    'Submit Request',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

