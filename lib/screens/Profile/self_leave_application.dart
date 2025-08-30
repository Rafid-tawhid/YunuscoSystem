import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import 'package:yunusco_group/screens/HR&PayRoll/widgets/leave_history.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:yunusco_group/utils/constants.dart';

import '../../models/leave_model.dart';

class LeaveApplicationScreen extends StatefulWidget {
  const LeaveApplicationScreen({super.key});

  @override
  _LeaveApplicationScreenState createState() => _LeaveApplicationScreenState();
}

class _LeaveApplicationScreenState extends State<LeaveApplicationScreen> {
  LeaveBalance? _leaveType;
  DateTime? _fromDate;
  DateTime? _toDate;
  int _dayCount = 0;
  final TextEditingController _reasonController = TextEditingController();
  File? _selectedFile;
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any, // This allows all file types
        allowMultiple: false, // Set to true if you want multiple files
      );

      if (result != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  Future<void> _selectDate(
      BuildContext context, bool isFromDate, bool isPrevious) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate =
        isPrevious ? now.subtract(const Duration(days: 1)) : now;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: isPrevious ? DateTime(2000) : DateTime(2000),
      // Allow any past date when isPrevious=false
      lastDate: isPrevious ? now : DateTime(2100),
      // Allow any future date when isPrevious=false
      selectableDayPredicate: isPrevious
          ? (DateTime date) => date.isBefore(now) || date.isAtSameMomentAs(now)
          : null, // No restrictions when isPrevious=false
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
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v) {
      getLeaveApplicationData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Leave Application'),
        actions: [
          IconButton(
              onPressed: () {
                var hp = context.read<HrProvider>();
                hp.showAndHideLeaveHistory();
              },
              icon: Icon(Icons.menu))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<HrProvider>(
            builder: (context, pro, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pro.showLeavHistory) LeaveSummaryWidget(),
                SizedBox(
                  height: 12,
                ),
                Column(
                  children: [
                    // Full Day Toggle
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          const Text(
                            'Full Day Leave',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                          // Switch(
                          //   value: _isFullDay_isFullDay,
                          //   onChanged: (value) {
                          //     setState(() {
                          //       _isFullDay = value;
                          //     });
                          //   },
                          // ),
                          //
                          const SizedBox(width: 8),
                          Chip(
                            backgroundColor: Colors.grey.shade300,
                            label: Text(
                              'Selected: $_dayCount days',
                              style: TextStyle(
                                color: myColors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Leave Type Dropdown
                    Consumer<HrProvider>(
                      builder: (context, pro, _) => pro.isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Leave Type *',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: DropdownButtonFormField<LeaveBalance>(
                                    value: _leaveType,
                                    isExpanded: true,
                                    hint: Text('Select Type'),
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    items: pro.leaveTypeList
                                        .map((type) => DropdownMenuItem(
                                              value: type,
                                              child: Text(
                                                type.policyType,
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _leaveType = value;
                                        _fromDate = null;
                                        _toDate = null;
                                        _dayCount = 0;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 24),

                    // Date Range Picker

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'From Date *',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black87),
                              ),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () => _leaveType == null
                                    ? _showAlert()
                                    : _selectDate(context, true,
                                        _leaveType!.policyId == 1),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_today,
                                          size: 20,
                                          color: Colors.grey.shade700),
                                      const SizedBox(width: 12),
                                      Text(
                                        _fromDate != null
                                            ? DateFormat('MMM dd, yyyy')
                                                .format(_fromDate!)
                                            : 'Select date',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: _fromDate != null
                                              ? Colors.black
                                              : Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'To Date *',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black87),
                              ),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () => _leaveType == null
                                    ? _showAlert()
                                    : _selectDate(context, false,
                                        _leaveType!.policyId == 1),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_today,
                                          size: 20,
                                          color: Colors.grey.shade700),
                                      const SizedBox(width: 12),
                                      Text(
                                        _toDate != null
                                            ? DateFormat('MMM dd, yyyy')
                                                .format(_toDate!)
                                            : 'Select date',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: _toDate != null
                                              ? Colors.black
                                              : Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    if (_dayCount > 2 && _leaveType!.type == 'Sick Leave')
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Expanded(
                              child: _selectedFile != null
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Text(
                                          _selectedFile!.path.split('/').last),
                                    )
                                  : Text(''),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 6),
                              child: ElevatedButton(
                                onPressed: _pickFile,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade300,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          8), // Adjust the value as needed
                                    )),
                                child: Text(
                                  'Upload Doc',
                                  style: customTextStyle(
                                      12, Colors.black, FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),
                    // Reason Field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Reason *',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _reasonController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Enter your reason for leave...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: Colors.blue.shade400, width: 1.5),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: myColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () async {
                          if (_fromDate == null ||
                              _toDate == null ||
                              _reasonController.text.isEmpty ||
                              _leaveType == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Please fill all required fields'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } else if (_fromDate!.isAfter(_toDate!)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Form date ca\'nt be after to date'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } else {
                            final shouldProceed =
                                await DashboardHelpers.showConfirmDialog(
                              context: context,
                              title: 'Double Check Everything',
                              message:
                                  'Please verify all details before proceeding.\nThis action cannot be undone.',
                              confirmText: 'APPLY',
                              cancelText: 'GO BACK',
                              onSubmit: () {
                                debugPrint('on apply');
                              },
                              onCancel: () {
                                debugPrint('on cancel');
                                // Navigator.pop(context);
                              },
                            );
                            if (shouldProceed == true) {
                              var hp = context.read<HrProvider>();
                              EasyLoading.show();
                              var response = await hp.submitApplicationForLeave(
                                  _fromDate,
                                  _toDate,
                                  _selectedFile,
                                  _reasonController.text.trim(),
                                  _leaveType!,
                                  _dayCount);
                              EasyLoading.dismiss();
                              if (response) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Leave application submitted for $_dayCount days'),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pop(context);
                              }

                              // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                            }
                          }
                        },
                        child: const Text(
                          'SUBMIT APPLICATION',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
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

  Future<void> getLeaveApplicationData() async {
    var hp = context.read<HrProvider>();
    await hp.getLeaveApplicationInfo();
  }

  _showAlert() {
    DashboardHelpers.showAlert(msg: 'Select Leave type');
  }
}
