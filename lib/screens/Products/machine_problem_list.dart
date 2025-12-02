// screens/reports_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../helper_class/firebase_helpers.dart';
import '../../providers/riverpods/production_provider.dart';

class MachineProblemList extends ConsumerWidget {
  const MachineProblemList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(machineReportsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Problem Reports'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.refresh(machineReportsProvider);
            },
          ),
        ],
      ),
      body: reportsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (reports) => _buildReportsList(reports),
      ),
    );
  }

  Widget _buildReportsList(List<Map<String, dynamic>> reports) {
    if (reports.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 20),
            Text(
              'No Reports Yet',
              style: TextStyle(color: Colors.grey[600], fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Submit your first problem report',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reports.length,
      itemBuilder: (context, index) => _buildReportCard(reports[index],context),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report,BuildContext context) {
    return GestureDetector(
      onTap: () async {
        handleReportDataAction(context, report);
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Priority
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(report['status']),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      report['priority']?.toString().toUpperCase() ?? 'MEDIUM',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(report['reported_at']),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Problem Title
              Text(
                report['problem'] ?? 'No Title',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              // Problem Code
              if (report['problem_code'] != null)
                Text(
                  'Code: ${report['problem_code']}',
                  style: TextStyle(
                    color: Colors.blueGrey[600],
                    fontSize: 14,
                  ),
                ),

              const SizedBox(height: 16),

              // People Section
              Row(
                children: [
                  // Officer
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Officer',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          report['officer'] ?? 'N/A',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Maintenance Person
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Engineer',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          report['maintenance_person'] ?? 'N/A',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Footer with Status and Ticket ID
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(report['status']),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Status: ${report['status'] ?? 'pending'}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    report['ticket_id']?.toString().substring(0, 10) ?? '',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(String? priority) {
    switch (priority?.toLowerCase()) {
      case MachineBreakdownStatus.pending:
        return Colors.orange;
      case MachineBreakdownStatus.pending_maintance:
        return Colors.blue;
      case MachineBreakdownStatus.in_progress:
        return Colors.pink;
      case MachineBreakdownStatus.resolved:
      return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '';

    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  void handleReportDataAction(BuildContext context, Map<String, dynamic> report) async {
    final firebaseService = FirebaseService();

    if (MachineBreakdownStatus.pending_maintance == report['status']) {
      final confirmed = await showConfirmationDialog(
          context,
          'Start Maintenance Process',
          'Do you want to start working on this issue?'
      );

      if (confirmed) {
        await firebaseService.updateMachineProblemReport(
            report['id'],
            MachineBreakdownStatus.in_progress
        );
        DashboardHelpers.showAlert(msg: 'Maintenance process has started');
      }
      return;
    }

    if (MachineBreakdownStatus.in_progress == report['status']) {
      final confirmed = await showConfirmationDialog(
          context,
          'Mark as Resolved',
          'Have you completed the repair? This will mark the issue as resolved.'
      );

      if (confirmed) {
        await firebaseService.updateMachineProblemReport(
            report['id'],
            MachineBreakdownStatus.resolved
        );
        DashboardHelpers.showAlert(msg: 'Issue marked as resolved');
      }
      return;
    }

    if (MachineBreakdownStatus.resolved == report['status']) {
      final confirmed = await showConfirmationDialog(
          context,
          'Complete Process',
          'Is everything finalized and ready to close? This will mark the issue as complete.'
      );

      if (confirmed) {
        await firebaseService.updateMachineProblemReport(
            report['id'],
            MachineBreakdownStatus.complete
        );
        DashboardHelpers.showAlert(msg: 'Issue marked as complete');
      }
      return;
    }

    if (MachineBreakdownStatus.pending == report['status']) {
      final confirmed = await showConfirmationDialog(
          context,
          'Assign to Maintenance',
          'Do you want to assign this issue to the maintenance team?'
      );

      if (!confirmed) return;

      final result = await firebaseService.fetchUserRole('38389');

      if (result == 'admin' || result == 'maintance') {
        final data = await DashboardHelpers.getTodaysTimeFromUser(context);
        if (data != null) {
          final scheduleConfirmed = await showConfirmationDialog(
              context,
              'Confirm Schedule',
              'Schedule maintenance for ${DashboardHelpers.convertDateTime(data.toString())}?'
          );

          if (scheduleConfirmed) {
            await firebaseService.updateMachineProblemReport(
                report['id'],
                MachineBreakdownStatus.pending_maintance
            );
            DashboardHelpers.showAlert(
                msg: 'Time has been set to ${DashboardHelpers.convertDateTime(data.toString())}'
            );
          }
        }
      }
    }
  }

// Helper function for confirmation dialogs
  Future<bool> showConfirmationDialog(
      BuildContext context,
      String title,
      String message,
      ) async {
    bool isLoading = false;

    return await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isLoading
                  ? Column(
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Processing...',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
                  : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.task_alt_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            content: isLoading
                ? null
                : Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
              ),
            ),
            actions: isLoading
                ? null
                : [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() => isLoading = true);
                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.of(context).pop(true);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    ) ?? false;
  }
}