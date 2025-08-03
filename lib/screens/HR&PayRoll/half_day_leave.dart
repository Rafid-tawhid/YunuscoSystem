import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/hr_provider.dart';

class HalfDayLeaveScreen extends StatefulWidget {
  const HalfDayLeaveScreen({super.key});

  @override
  _HalfDayLeaveScreenState createState() => _HalfDayLeaveScreenState();
}

class _HalfDayLeaveScreenState extends State<HalfDayLeaveScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedEmployee;
  String? _selectedSymptoms;
  String? _selectedUrgency;
  DateTime? _selectedDate;
  bool _isMorning = true;
  final TextEditingController _reasonController = TextEditingController();

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

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      final requestData = {
        'employeeId': _selectedEmployee,
        'symptoms': _selectedSymptoms,
        'urgency': _selectedUrgency,
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
        'timeSlot': _isMorning ? 'Morning' : 'Afternoon',
        'reason': _reasonController.text,
        'status': 'Pending',
        'requestTime': DateTime.now().toIso8601String(),
      };

      // Here you would typically send to your backend
      print('Submitting request: $requestData');

      // Show success dialog
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Request Submitted'),
          content: Text('Your half-day leave request has been submitted for approval.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop(); // Return to previous screen
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final employees = Provider.of<HrProvider>(context).member_list;

    return Scaffold(
      appBar: AppBar(
        title: Text('Half-Day Leave Application'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Employee Selection
              DropdownButtonFormField<String>(
                value: _selectedEmployee,
                decoration: InputDecoration(
                  labelText: 'Employee*',
                  border: OutlineInputBorder(),
                ),
                items: employees.map((employee) {
                  return DropdownMenuItem<String>(
                    value: employee.idCardNo,
                    child: Text(employee.fullName??''),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedEmployee = value;
                  });
                },
                validator: (value) =>
                value == null ? 'Please select an employee' : null,
              ),
              SizedBox(height: 20),

              // Date Picker
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 30)),
                  );
                  if (date != null) {
                    setState(() {
                      _selectedDate = date;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Leave Date*',
                    border: OutlineInputBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'Select date'
                            : DateFormat('MMM dd, yyyy').format(_selectedDate!),
                      ),
                      Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Time Slot Toggle
              Text('Time Slot*', style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: Text('Morning (8AM-12PM)'),
                      selected: _isMorning,
                      onSelected: (selected) {
                        setState(() {
                          _isMorning = selected;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ChoiceChip(
                      label: Text('Afternoon (1PM-5PM)'),
                      selected: !_isMorning,
                      onSelected: (selected) {
                        setState(() {
                          _isMorning = !selected;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Symptoms Dropdown
              DropdownButtonFormField<String>(
                value: _selectedSymptoms,
                decoration: InputDecoration(
                  labelText: 'Symptoms*',
                  border: OutlineInputBorder(),
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
              SizedBox(height: 20),

              // Urgency Level
              DropdownButtonFormField<String>(
                value: _selectedUrgency,
                decoration: InputDecoration(
                  labelText: 'Urgency Level*',
                  border: OutlineInputBorder(),
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
              SizedBox(height: 20),

              // Reason Field
              TextFormField(
                controller: _reasonController,
                decoration: InputDecoration(
                  labelText: 'Additional Reason (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitRequest,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Submit Request',
                    style: TextStyle(fontSize: 16),
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

// Example Provider (you should replace with your actual provider)
// class EmployeeProvider with ChangeNotifier {
//   List<Employee> employees = [
//     Employee(id: 'EMP-101', name: 'John Doe'),
//     Employee(id: 'EMP-102', name: 'Jane Smith'),
//     // Add more employees
//   ];
// }

class Employee {
  final String id;
  final String name;

  Employee({required this.id, required this.name});
}