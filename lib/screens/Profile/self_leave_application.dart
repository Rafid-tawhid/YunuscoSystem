import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import 'package:yunusco_group/screens/HR&PayRoll/widgets/leave_history.dart';

class LeaveApplicationScreen extends StatefulWidget {
  @override
  _LeaveApplicationScreenState createState() => _LeaveApplicationScreenState();
}

class _LeaveApplicationScreenState extends State<LeaveApplicationScreen> {
  String _leaveType = 'Earn Leave';
  DateTime? _fromDate;
  DateTime? _toDate;
  int _dayCount = 0;
  final TextEditingController _reasonController = TextEditingController();
  bool _isFullDay = true;

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
        _calculateDayCount();
      });
    }
  }

  void _calculateDayCount() {
    if (_fromDate != null && _toDate != null) {
      final difference = _toDate!.difference(_fromDate!).inDays + 1;
      setState(() {
        _dayCount = difference > 0 ? difference : 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Leave Application'),
        actions: [
          IconButton(onPressed: (){
            var hp=context.read<HrProvider>();
            hp.showAndHideLeaveHistory();
          }, icon: Icon(Icons.menu))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<HrProvider>(
          builder: (context,pro,_)=>Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(pro.showLeavHistory) LeaveSummaryWidget(),
              Row(
                children: [
                  const Text('Full Day'),
                  Checkbox(
                    value: _isFullDay,
                    onChanged: (value) {
                      setState(() {
                        _isFullDay = value!;
                      });
                    },
                  ),
                  const Spacer(),
                  Text('Balance: DayCount $_dayCount'),
                ],
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _leaveType,
                items: ['Earn Leave', 'Sick Leave', 'Casual Leave']
                    .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _leaveType = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Leave type',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, true),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'From Date *',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _fromDate != null
                              ? DateFormat('MM-dd-yyyy').format(_fromDate!)
                              : 'Select date',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, false),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'To Date *',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _toDate != null
                              ? DateFormat('MM-dd-yyyy').format(_toDate!)
                              : 'Select date',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _reasonController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Reasons *',
                  border: OutlineInputBorder(),
                  hintText: 'Enter your reason for leave',
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_fromDate == null || _toDate == null || _reasonController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all required fields')),
                      );
                    } else {
                      // Submit leave application logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Leave application submitted for $_dayCount days')),
                      );
                    }
                  },
                  child: const Text('Submit Application'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}