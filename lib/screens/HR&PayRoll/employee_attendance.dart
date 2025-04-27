import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/models/employee_attendance_model.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import 'package:yunusco_group/screens/HR&PayRoll/widgets/employee_attendance_card.dart';

class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({super.key});

  @override
  _AttendanceReportScreenState createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  DateTime? _fromDate;
  DateTime? _toDate;
  final TextEditingController _usernameController = TextEditingController();

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _fromDate) {
      setState(() {
        _fromDate = picked;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: _fromDate ?? DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _toDate) {
      setState(() {
        _toDate = picked;
      });
    }
  }

  void _searchAttendance() {
    if (_fromDate == null || _toDate == null || _usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Here you would call your API 2025-04-16
    final formattedFromDate = DateFormat('yyyy-MM-dd').format(_fromDate!);
    final formattedToDate = DateFormat('yyyy-MM-dd').format(_toDate!);

    debugPrint('Searching attendance for:');
    debugPrint('Username: ${_usernameController.text}');
    debugPrint('From Date: $formattedFromDate');
    debugPrint('To Date: $formattedToDate');

    var hp=context.read<HrProvider>();
    hp.getEmployeeAttendance(_usernameController.text.trim(),formattedFromDate,formattedToDate);

    // Add your API call logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Attendance Report'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Username Field
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter employee username',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
          
              // From Date Picker
              InkWell(
                onTap: () => _selectFromDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'From Date',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    _fromDate != null
                        ? DateFormat('dd-MM-yyyy').format(_fromDate!)
                        : 'Select date',
                  ),
                ),
              ),
              const SizedBox(height: 20),
          
              // To Date Picker
              InkWell(
                onTap: () => _selectToDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'To Date',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    _toDate != null
                        ? DateFormat('dd-MM-yyyy').format(_toDate!)
                        : 'Select date',
                  ),
                ),
              ),
              const SizedBox(height: 20),
          
              // Search Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _searchAttendance,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Find Attendance',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Consumer<HrProvider>(builder: (context,pro,_)=>EmployeeCards(attendanceList: pro.employeeAttendanceList))
            ],
          ),
        ),
      ),
    );
  }
}