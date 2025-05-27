import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/attendence_model.dart';
import '../../providers/hr_provider.dart';

class AttendanceDashboard extends StatefulWidget {

  @override
  State<AttendanceDashboard> createState() => _AttendanceDashboardState();
}



class _AttendanceDashboardState extends State<AttendanceDashboard> {

  @override
  void initState() {
    var hp = context.read<HrProvider>();
    hp.getAllDepertmentsAttendance(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Summary',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF06113E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F7FA), Color(0xFFE4E7EB)],
          ),
        ),
        child: Column(
          children: [
            // Example usage in your screen:
            DateSelector(
              initialDate: DateTime.now(), // Default date to show
              onDateSelected: (selectedDate) {
                // Handle the selected date
                print('Selected date: $selectedDate');
                var hp=context.read<HrProvider>();
                hp.getAllDepertmentsAttendance(selectedDate);
              },
              primaryColor: Colors.blue, // Optional custom color
              dateFormat: 'dd-MM-yyyy', // Optional custom format
              padding: EdgeInsets.all(8), // Optional custom padding
            ),
            Consumer<HrProvider>(builder: (context,pro,_)=> Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: pro.allDeptAttendanceList.length,
                itemBuilder: (context, index) {
                  return _buildAttendanceCard(pro.allDeptAttendanceList[index]);
                },
              ),
            )),
          ],
        ),
      ),
    );
  }



  Widget _buildAttendanceCard(AttendenceModel attendance) {
    final total = (attendance.present ?? 0) +
        (attendance.absent ?? 0) +
        (attendance.leave ?? 0);
    final presentPercentage = total > 0
        ? (attendance.present ?? 0) / total * 100
        : 0;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  attendance.departmentName ?? 'Unknown Department',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  backgroundColor: _getStatusColor(presentPercentage.toDouble()),
                  label: Text(
                    '${presentPercentage.toStringAsFixed(1)}%',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildProgressBar(presentPercentage.toDouble()),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCircle(Icons.check_circle, 'Present',
                    attendance.present ?? 0, Colors.green),
                _buildStatCircle(Icons.cancel, 'Absent',
                    attendance.absent ?? 0, Colors.red),
                _buildStatCircle(Icons.beach_access, 'Leave',
                    attendance.leave ?? 0, Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(double percentage) {
    return Stack(
      children: [
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: 8,
              width: constraints.maxWidth * (percentage / 100),
              decoration: BoxDecoration(
                color: _getStatusColor(percentage),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatCircle(IconData icon, String label, num value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }
}


class DateSelector extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;
  final Color? primaryColor;
  final String dateFormat;
  final EdgeInsetsGeometry? padding;

  const DateSelector({
    Key? key,
    required this.initialDate,
    required this.onDateSelected,
    this.primaryColor,
    this.dateFormat = 'dd-MM-yyyy',
    this.padding,
  }) : super(key: key);

  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: widget.primaryColor ?? const Color(0xFF06113E),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(16),
      child: InkWell(
        onTap: () => _selectDate(context),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_today,
                  color: Colors.grey.shade600),
              const SizedBox(width: 12),
              Text(
                DateFormat(widget.dateFormat).format(_selectedDate),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_drop_down,
                  color: Colors.grey.shade600),
            ],
          ),
        ),
      ),
    );
  }
}