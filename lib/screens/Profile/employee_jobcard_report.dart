import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/models/employee_attendance_model.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import 'package:yunusco_group/screens/HR&PayRoll/widgets/employee_attendance_card.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:yunusco_group/utils/constants.dart';

class EmployeeJobCardReportScreen extends StatefulWidget {
  const EmployeeJobCardReportScreen({super.key});

  @override
  _EmployeeJobCardReportScreenState createState() => _EmployeeJobCardReportScreenState();
}

class _EmployeeJobCardReportScreenState extends State<EmployeeJobCardReportScreen> {
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
  void initState() {
    //set your id
    setYourIdToTextFielld();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text('Employee JobCard Report',style: customTextStyle(18, Colors.white, FontWeight.w600),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: myColors.primaryColor,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Username Field
              TextField(
                controller: _usernameController,
                enabled: DashboardHelpers.currentUser!.isDepartmentHead,
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
                    backgroundColor: myColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child:  Text(
                    'Find Attendance',
                    style: customTextStyle(16, Colors.white, FontWeight.w500),
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

  void setYourIdToTextFielld() {
    setState(() {
      _usernameController.text=DashboardHelpers.currentUser!.loginName??'';
    });
  }
}