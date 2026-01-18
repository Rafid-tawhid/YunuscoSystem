import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../models/attendance_board_model.dart';
import '../../providers/riverpods/employee_provider.dart';

class AttandanceBoardScreen extends ConsumerStatefulWidget {
  const AttandanceBoardScreen({super.key});

  @override
  ConsumerState<AttandanceBoardScreen> createState() => _AttandanceBoardScreenState();
}

class _AttandanceBoardScreenState extends ConsumerState<AttandanceBoardScreen> {
  String? _selectedMonth;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _searchOn=false;
  final TextEditingController _searchController=TextEditingController();

  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
    // Use Future.microtask to ensure widget is fully built
    Future.microtask(() {
      _setCurrentMonth();
    });
  }

  void _setCurrentMonth() {
    final now = DateTime.now();
    _selectedMonth = _months[now.month - 1];
    _calculateDates(now.month);
  }

  Future<void> _fetchAttendanceData() async {
    // Add null check as safety
    if (_startDate == null || _endDate == null) {
      debugPrint('Dates are null, skipping API call');
      return;
    }

    try {
      ref.read(isLoadingProvider.notifier).state = true;
      await ref.read(userListProvider.notifier).getEmployeeAttendance(
          _formatDate(_startDate!),
          _formatDate(_endDate!)
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load attendance: $e'))
      );
    } finally {
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  Future<void> _calculateDates(int month) async {
    final now = DateTime.now();
    final currentYear = now.year;

    // Set dates first
    _startDate = DateTime(currentYear, month, 1);
    _endDate = month == now.month ? now : DateTime(currentYear, month + 1, 0);

    setState(() {});

    // Then call API - no need to check for null since we just set them
    await _fetchAttendanceData();
  }


  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        title: _searchOn?TextField(
          autofocus: true,
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search employee...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            ref.read(userListProvider.notifier).searchEmployees(value);
          },
        ): Text('Attendance Board'),

        actions: [
          _searchOn
              ? IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              ref.read(userListProvider.notifier).clearSearch();
              setState(() {
                _searchOn = false;
                _searchController.clear();

              });
            },
          )
              : IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _searchOn = true;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Dropdown
            DropdownButtonFormField<String>(
              value: _selectedMonth,
              decoration: InputDecoration(
                labelText: 'Select Month',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              items: _months.map((String month) {
                return DropdownMenuItem<String>(
                  value: month,
                  child: Text(month),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedMonth = newValue;
                    final monthIndex = _months.indexOf(newValue) + 1;
                    _calculateDates(monthIndex);
                  });
                }
              },
            ),

            const SizedBox(height: 16.0),

            // Attendance List
            Expanded(
              child: AttendanceListWidget(),
            ),
          ],
        ),
      ),
    );
  }
}



class AttendanceListWidget extends ConsumerWidget {
  const AttendanceListWidget({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceList = ref.watch(userListProvider);
    final isLoading = ref.watch(isLoadingProvider);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (attendanceList.isEmpty) {
      return const Center(
        child: Text(
          'No attendance records found',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    // Get the original ranks from the provider's original list
    final originalRanks = ref.read(userListProvider.notifier).getOriginalRanks();

    // Rest of your grouping logic for the current (filtered) list
    final Map<String, List<AttendanceBoardModel>> groupedAttendance = {};
    for (final attendance in attendanceList) {
      final employeeId = attendance.employeeId ?? 'unknown';
      if (!groupedAttendance.containsKey(employeeId)) {
        groupedAttendance[employeeId] = [];
      }
      groupedAttendance[employeeId]!.add(attendance);
    }

    // Sort the current employee IDs by their original ranks
    final currentEmployeeIds = groupedAttendance.keys.toList()
      ..sort((a, b) {
        final rankA = originalRanks[a] ?? 999;
        final rankB = originalRanks[b] ?? 999;
        return rankA.compareTo(rankB); // Ascending order (lower rank first)
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Employees (${groupedAttendance.length})',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Expanded(
          child: ListView.builder(
            itemCount: currentEmployeeIds.length,
            itemBuilder: (context, index) {
              final employeeId = currentEmployeeIds[index];
              final employeeRecords = groupedAttendance[employeeId]!;
              final firstRecord = employeeRecords.first;

              return _EmployeeGroupItem(
                employee: firstRecord,
                attendanceRecords: employeeRecords,
                index: originalRanks[employeeId] ?? 999, // Use original rank, fallback for safety
              );
            },
          ),
        ),
      ],
    );
  }
}

// Employee Group Item Widget
class _EmployeeGroupItem extends StatefulWidget {
  final AttendanceBoardModel employee;
  final List<AttendanceBoardModel> attendanceRecords;
  final int index;

  const _EmployeeGroupItem({
    required this.employee,
    required this.attendanceRecords,
    required this.index,
  });

  @override
  State<_EmployeeGroupItem> createState() => _EmployeeGroupItemState();
}

class _EmployeeGroupItemState extends State<_EmployeeGroupItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          // Employee Header (Always visible)
          ListTile(
            leading: Stack(
              children: [
                CircleAvatar(
                  backgroundColor: widget.index<10?Colors.amber: Colors.blue[100],
                  child: Text(
                    _getAvatarText(widget.employee.employeeName??'', widget.index),
                    style:  TextStyle(fontWeight: FontWeight.bold,color: widget.index<10?Colors.black:Colors.black),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child:  widget.index<10? Icon(Icons.emoji_events,size: 12,color: Colors.red,):Text(''),
                )
              ],
            ),
            title: Text(
              widget.employee.employeeName ?? 'Unknown Employee',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.employee.departmentName != null)
                  Text('Dept: ${widget.employee.departmentName!}'),
                if (widget.employee.designationName != null)
                  Text('Designation: ${widget.employee.designationName!}'),
                Text('Records: ${widget.attendanceRecords.length} days'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Total Working Hours
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _calculateTotalHours(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.grey[600],
                ),
              ],
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),

          // Expandable Attendance Details
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attendance Details:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...widget.attendanceRecords.map((attendance) =>
                      _AttendanceDetailItem(attendance: attendance)
                  ).toList(),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _calculateTotalHours() {
    double totalHours = 0;
    for (final record in widget.attendanceRecords) {
      if (record.workingHoursDecimal != null) {
        totalHours += record.workingHoursDecimal!;
      }
    }
    return '${totalHours.toStringAsFixed(1)}h';
  }

  String _getAvatarText(String name, int rank) {
    // For first 10 items, show 1st, 2nd, 3rd, etc. up to 10th
    if (rank < 10) {
      switch (rank) {
        case 0:
          return '1st';
        case 1:
          return '2nd';
        case 2:
          return '3rd';
        case 3:
          return '4th';
        case 4:
          return '5th';
        case 5:
          return '6th';
        case 6:
          return '7th';
        case 7:
          return '8th';
        case 8:
          return '9th';
        case 9:
          return '10th';
        default:
          return rank.toString();
      }
    }

    // For items beyond 10, show rank number
    return (rank + 1).toString();
  }
}

// Individual Attendance Detail Item
class _AttendanceDetailItem extends StatelessWidget {
  final AttendanceBoardModel attendance;

  const _AttendanceDetailItem({required this.attendance});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          // Date
          Expanded(
            flex: 2,
            child: Text(
              DashboardHelpers.convertDateTime(attendance.date??'',pattern: 'dd/MM/yyyy'),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          // In Time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'In',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  attendance.inTime ?? '--:--',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          // Out Time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Out',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  attendance.outTime ?? '--:--',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          // Working Hours
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Hours',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getHoursColor(attendance.workingHoursDecimal!.toDouble() ?? 0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    attendance.workingHours ?? '0h',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Status
          // Expanded(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.end,
          //     children: [
          //       const Text(
          //         'Status',
          //         style: TextStyle(fontSize: 12, color: Colors.grey),
          //       ),
          //       Container(
          //         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          //         decoration: BoxDecoration(
          //           color: _getStatusColor(attendance.flagType),
          //           borderRadius: BorderRadius.circular(8),
          //         ),
          //         child: Text(
          //           _getStatusText(attendance.flagType),
          //           style: const TextStyle(
          //             color: Colors.white,
          //             fontSize: 11,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Color _getHoursColor(double hours) {
    if (hours >= 8.0) return Colors.green;
    if (hours >= 6.0) return Colors.orange;
    return Colors.red;
  }

}