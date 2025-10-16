import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentDialog extends StatefulWidget {
  final String title;
  final String? note;
  final Function(DateTime, String) onConfirm;
  final Function()? onCancel;
  final Function()? remarks;

  const AppointmentDialog({
    Key? key,
    this.title = 'Set Appointment',
    this.note,
    this.remarks,
    required this.onConfirm,
    this.onCancel,
  }) : super(key: key);

  @override
  _AppointmentDialogState createState() => _AppointmentDialogState();
}

class _AppointmentDialogState extends State<AppointmentDialog> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  final TextEditingController _noteCon = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial values to current date and time
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
    _noteCon.text = widget.note ?? '';
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade700,
              onPrimary: Colors.white,
              onSurface: Colors.grey.shade800,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade700,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade700,
              onPrimary: Colors.white,
              onSurface: Colors.grey.shade800,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade700,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _confirmAppointment() {
    final DateTime appointmentDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    widget.onConfirm(appointmentDateTime, _noteCon.text.trim());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('EEE, MMM d, yyyy').format(_selectedDate);
    final String formattedTime = _selectedTime.format(context);

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      title: Row(
        children: [
          Icon(Icons.calendar_today, color: Colors.blue.shade700, size: 24),
          SizedBox(width: 12),
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Selection
            _buildSelectionCard(
              icon: Icons.calendar_month,
              title: 'Date',
              value: formattedDate,
              onTap: _selectDate,
            ),
            SizedBox(height: 16),

            // Time Selection
            _buildSelectionCard(
              icon: Icons.access_time,
              title: 'Time',
              value: formattedTime,
              onTap: _selectTime,
            ),
            SizedBox(height: 16),

            // Description
            Text(
              'Description (Optional)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _noteCon,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add appointment notes...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
      actions: [
        // Cancel Button
        TextButton(
          onPressed: () {
            widget.onCancel?.call();
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey.shade600,
          ),
          child: Text('Cancel'),
        ),

        // Confirm Button
        ElevatedButton(
          onPressed: _confirmAppointment,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(
            'Set Appointment',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionCard({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade100),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: Colors.blue.shade700),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade500),
          ],
        ),
      ),
    );
  }
}