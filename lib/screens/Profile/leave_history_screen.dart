import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:yunusco_group/utils/constants.dart';

import '../../models/leave_data_model.dart';

class LeaveHistoryScreen extends StatefulWidget {
  const LeaveHistoryScreen({super.key});

  @override
  State<LeaveHistoryScreen> createState() => _LeaveHistoryScreenState();
}

class _LeaveHistoryScreenState extends State<LeaveHistoryScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v){
      getAttendanceHistory();
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title:  Text('Leave Applications',style: customTextStyle(18, Colors.white, FontWeight.w600),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: myColors.primaryColor,
        iconTheme: IconThemeData(
          color: Colors.white, // Custom color for this AppBar's icons
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Consumer<HrProvider>(
          builder: (context,pro,_)=>pro.isLoading?Center(child: CircularProgressIndicator(),):
          pro.leaveDataList.isEmpty
              ? const Center(
            child: Text(
              'No leave applications found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pro.leaveDataList.length,
            itemBuilder: (context, index) {
              final leave = pro.leaveDataList[index];
              return _buildLeaveCard(leave);
            },
          ),
        ),
      ),

    );
  }
  //


  Widget _buildLeaveCard(LeaveDataModel leave) {
    return Card(
      elevation: 4,
      color: Colors.white,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // Header row with employee info
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
               'Employee Id : ${leave.employeeIdCardNo}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Chip(
              label: Text(
                leave.leaveStatus ?? 'Pending',
                style: const TextStyle(color: Colors.white),),
                backgroundColor: _getStatusColor(leave.leaveStatus),
              ),
              ],
            ),
            const SizedBox(height: 8),

            // Applied for employee (if different)
            if (leave.applaiedForEmployee != null && leave.applaiedForEmployee != leave.employeeIdCardNo)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  'Applied for: ${leave.applaiedForEmployee}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),

            // Department info
            Text(
              leave.departmentName ?? 'No Department',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const Divider(height: 20, thickness: 1),

            // Leave dates
            _buildInfoRow('Leave Dates',
                '${_formatDate(leave.leaveFromDate)} to ${_formatDate(leave.leaveToDate)}'),

            // Leave type and days
            _buildInfoRow('Leave Type',
                '${leave.leaveType} (${leave.dayCount?.toStringAsFixed(1) ?? '0'} days)'),

            // Leave balances
            if (leave.sl != null || leave.el != null || leave.cl != null)
              _buildLeaveBalances(leave.sl, leave.el, leave.cl),

            // Reason for leave
            if (leave.reasons != null && leave.reasons!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Reason:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(leave.reasons!),
                ],
              ),

            const Divider(height: 20, thickness: 1),

            // Footer with applied/passed by info
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     if (leave.appliedByName != null)
            //       Text(
            //         'Applied by: ${leave.appliedByName}',
            //         style: TextStyle(color: Colors.grey[600], fontSize: 12),
            //       ),
            //     if (leave.passedByName != null)
            //       Text(
            //         'Approved by: ${leave.passedByName}',
            //         style: TextStyle(color: Colors.grey[600], fontSize: 12),
            //       ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

// Helper widget for consistent info rows
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

// Helper widget to show leave balances
  Widget _buildLeaveBalances(num? sl, num? el, num? cl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const SizedBox(
            width: 100,
            child: Text(
              'Balances:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              if (sl != null) _buildBalanceChip('SL: $sl', Colors.blue),
              if (el != null) _buildBalanceChip('EL: $el', Colors.green),
              if (cl != null) _buildBalanceChip('CL: $cl', Colors.orange),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBalanceChip(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Chip(
        label: Text(text, style: const TextStyle(fontSize: 10)),
        backgroundColor: color.withOpacity(0.2),
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

// Helper function to format dates
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

// Helper function to get status color
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void getAttendanceHistory() async{
    var hp=context.read<HrProvider>();
    if(hp.leaveDataList.isEmpty){
      hp.getPersonalAttendance();
    }
  }
}



