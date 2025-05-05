import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/hr_provider.dart';

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
        title: const Text('Leave Applications'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue.shade800,
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
              return _buildLeaveCard(leave, context);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new leave application
        },
        backgroundColor: Colors.blue.shade800,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildLeaveCard(LeaveDataModel leave, BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    DateTime? fromDate;
    DateTime? toDate;

    try {
      if (leave.leaveFromDate != null) {
        fromDate = DateTime.parse(leave.leaveFromDate!);
      }
      if (leave.leaveToDate != null) {
        toDate = DateTime.parse(leave.leaveToDate!);
      }
    } catch (e) {
      debugPrint('Error parsing date: $e');
    }

    final duration = fromDate != null && toDate != null
        ? toDate.difference(fromDate).inDays + 1
        : 0;

    Color statusColor = Colors.grey;
    if (leave.status?.toLowerCase() == 'approved') {
      statusColor = Colors.green;
    } else if (leave.status?.toLowerCase() == 'rejected') {
      statusColor = Colors.red;
    } else if (leave.status?.toLowerCase() == 'pending') {
      statusColor = Colors.orange;
    }

    return Card(
      elevation: 3,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
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
                  leave.leavePolicyType ?? 'Unknown Leave Type',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: statusColor,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    leave.status ?? 'Unknown',
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildDateInfo(
                  icon: Icons.calendar_today,
                  label: 'From',
                  date:  leave.leaveFromDate?? 'N/A',
                ),
                const SizedBox(width: 16),
                _buildDateInfo(
                  icon: Icons.calendar_today,
                  label: 'To',
                  date: leave.leaveToDate?? 'N/A',
                ),
                const Spacer(),
                Chip(
                  backgroundColor: Colors.blue.shade50,
                  label: Text(
                    '$duration ${duration == 1 ? 'day' : 'days'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (leave.leaveBalance != null) ...[
              Row(
                children: [
                  const Icon(Icons.account_balance_wallet,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Balance: ${leave.leaveBalance} days',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            if (leave.reasons?.isNotEmpty ?? false) ...[
              const Divider(height: 20),
              const Text(
                'Reason:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                leave.reasons!,
                style: const TextStyle(color: Colors.black87),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDateInfo({
    required IconData icon,
    required String label,
    required String date,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            Text(
              date,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void getAttendanceHistory() async{
    var hp=context.read<HrProvider>();
    if(hp.leaveDataList.isEmpty){
      hp.getPersonalAttendance();
    }
  }
}



