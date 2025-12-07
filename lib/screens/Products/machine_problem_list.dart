// lib/screens/machine_breakdown_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/screens/Products/widgets/update_status_bottomsheet.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../helper_class/dashboard_helpers.dart';
import '../../models/machine_breakdown_model.dart';
import '../../providers/riverpods/production_provider.dart';
import 'machine_problem_request.dart';

class MachineBreakdownListScreen extends ConsumerWidget {
  const MachineBreakdownListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakdownsAsync = ref.watch(machineBreakdownListProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final sortOption = ref.watch(sortProvider);
    final sortedBreakdowns = ref.watch(sortedBreakdownsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Machine Breakdown Reports'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(machineBreakdownListProvider),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          _buildSearchFilterBar(ref, searchQuery, sortOption),

          // Stats Summary
          _buildStatsSummary(breakdownsAsync),

          // Breakdown List
          Expanded(
            child: breakdownsAsync.when(
              data: (breakdowns) {
                if (sortedBreakdowns.isEmpty) {
                  return _buildEmptyState(searchQuery);
                }
                return _buildBreakdownList(sortedBreakdowns);
              },
              loading: () => _buildLoadingState(),
              error: (error, stackTrace) => _buildErrorState(error, stackTrace, ref),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to create new breakdown screen
           Navigator.push(context, MaterialPageRoute(builder: (_) => MachineRepairScreen()));
        },
        icon: const Icon(Icons.add,color: Colors.white,),
        label: const Text('New Report',style: TextStyle(color: Colors.white),),
        backgroundColor: myColors.primaryColor,
      ),
    );
  }

  Widget _buildSearchFilterBar(WidgetRef ref, String searchQuery, SortOption sortOption) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search by machine, line, employee, status...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => ref.read(searchQueryProvider.notifier).state = '',
              )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            onChanged: (value) {
              ref.read(searchQueryProvider.notifier).state = value;
            },
          ),
          const SizedBox(height: 8),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'All',
                  selected: sortOption == SortOption.newestFirst,
                  onSelected: () => ref.read(sortProvider.notifier).state = SortOption.newestFirst,
                ),
                _buildFilterChip(
                  label: 'Status',
                  selected: sortOption == SortOption.byStatus,
                  onSelected: () => ref.read(sortProvider.notifier).state = SortOption.byStatus,
                ),
                _buildFilterChip(
                  label: 'Machine',
                  selected: sortOption == SortOption.byMachine,
                  onSelected: () => ref.read(sortProvider.notifier).state = SortOption.byMachine,
                ),
                _buildFilterChip(
                  label: 'Oldest',
                  selected: sortOption == SortOption.oldestFirst,
                  onSelected: () => ref.read(sortProvider.notifier).state = SortOption.oldestFirst,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required VoidCallback onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
        backgroundColor: Colors.grey[200],
        selectedColor: Colors.blue[100],
        checkmarkColor: Colors.blue,
        labelStyle: TextStyle(
          color: selected ? Colors.blue : Colors.black87,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildStatsSummary(AsyncValue<List<MachineBreakdownModel>> breakdownsAsync) {
    return breakdownsAsync.when(
      data: (breakdowns) {
        final total = breakdowns.length;
        final pending = breakdowns.where((b) => b.status?.toLowerCase() == 'pending').length;
        final completed = breakdowns.where((b) => b.status?.toLowerCase() == 'completed').length;
        final inProgress = breakdowns.where((b) => b.status?.toLowerCase() == 'in progress').length;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Total', total.toString(), Colors.blue),
              _buildStatItem('Pending', pending.toString(), Colors.orange),
              _buildStatItem('In Progress', inProgress.toString(), Colors.yellow[700]!),
              _buildStatItem('Completed', completed.toString(), Colors.green),
            ],
          ),
        );
      },
      loading: () => Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.all(12),
        child: const LinearProgressIndicator(),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String searchQuery) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            searchQuery.isEmpty ? Icons.list_alt : Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            searchQuery.isEmpty
                ? 'No machine breakdown reports found'
                : 'No results for "$searchQuery"',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            searchQuery.isEmpty
                ? 'Tap the + button to create a new report'
                : 'Try a different search term',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading machine breakdowns...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error, StackTrace stackTrace, WidgetRef ref) {
    String errorMessage = 'An error occurred';

    if (error is Exception) {
      errorMessage = error.toString().replaceAll('Exception: ', '');
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red[400],
              size: 70,
            ),
            const SizedBox(height: 20),
            Text(
              'Failed to load reports',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Text(
                errorMessage,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(machineBreakdownListProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text(
                'Retry',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownList(List<MachineBreakdownModel> breakdowns) {
    return RefreshIndicator(
      onRefresh: () async {
        // Refresh logic
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: breakdowns.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final breakdown = breakdowns[index];
          return _buildBreakdownCard(breakdown,context);
        },
      ),
    );
  }

  Widget _buildBreakdownCard(MachineBreakdownModel breakdown, BuildContext context) {
    Color statusColor = StatusFlow.getStatusColor(breakdown.status);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: InkWell(
          onTap: () => _showUpdateBottomSheet(breakdown, context),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: ID, Status, and Quick Status Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ID with priority indicator
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(
                              'ID: ${breakdown.maintenanceId ?? 'N/A'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),

                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _getStatusIcon(breakdown.status),
                            size: 14,
                            color: statusColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            breakdown.status ?? 'Unknown',
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Machine Info - Compact horizontal layout
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      // Machine Icon
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.business_center,
                          size: 16,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Machine Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${breakdown.machineType ?? 'Machine'} - ${breakdown.machineNo ?? 'N/A'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(Icons.line_style, size: 12, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  breakdown.lineName ?? 'No Line',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(Icons.settings, size: 12, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  breakdown.operationName ?? 'No Operation',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Details Grid - 2x2 layout
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 3.5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: [
                    _buildDetailItem(
                      icon: Icons.person,
                      title: 'Employee',
                      value: breakdown.fullName ?? 'N/A',
                      color: Colors.green,
                    ),
                    _buildDetailItem(
                      icon: Icons.task,
                      title: 'Task',
                      value: breakdown.taskCode ?? 'N/A',
                      color: Colors.orange,
                    ),
                    _buildDetailItem(
                      icon: Icons.access_time,
                      title: 'Reported',
                      value: breakdown.reportedTime?.split(' ').last ?? 'N/A',
                      color: Colors.purple,
                    ),
                    _buildDetailItem(
                      icon: Icons.calendar_today,
                      title: 'Updated',
                      value: _formatRelativeDate(breakdown.updatedDate),
                      color: Colors.blue,
                    ),
                  ],
                ),

                // Timeline Progress Bar (if in progress)
                if (breakdown.status == MachineBreakdownStatus.in_progress ||
                    breakdown.status == MachineBreakdownStatus.resolved)
                  _buildProgressTimeline(breakdown),

                // Action Button Row
                if (!StatusFlow.isFinalStatus(breakdown.status ?? ''))
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _showUpdateBottomSheet(breakdown, context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: BorderSide(color: statusColor),
                            ),
                            icon: Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: statusColor,
                            ),
                            label: Text(
                              'Update to ${StatusFlow.getNextStatus(breakdown.status ?? '')}',
                              style: TextStyle(
                                fontSize: 13,
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Helper widget for detail items
  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Progress timeline for active breakdowns
  Widget _buildProgressTimeline(MachineBreakdownModel breakdown) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progress',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              if (breakdown.delayTime != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.timer, size: 10, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        'Delay: ${breakdown.delayTime}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (breakdown.workStartTime != null || breakdown.workEndTime != null)
            Column(
              children: [
                if (breakdown.workStartTime != null)
                  _buildTimelineRow('Started', breakdown.workStartTime!, Icons.play_arrow, Colors.green),
                if (breakdown.mechanicWorkTime != null)
                  _buildTimelineRow('Work Time', '${breakdown.mechanicWorkTime} min', Icons.timer, Colors.blue),
                if (breakdown.workEndTime != null)
                  _buildTimelineRow('Ended', breakdown.workEndTime!, Icons.check_circle, Colors.green),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTimelineRow(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

// Helper methods
  IconData _getStatusIcon(String? status) {
    switch (status) {
      case MachineBreakdownStatus.reported:
        return Icons.report;
      case MachineBreakdownStatus.awaiting:
        return Icons.hourglass_empty;
      case MachineBreakdownStatus.in_progress:
        return Icons.build;
      case MachineBreakdownStatus.resolved:
        return Icons.check_circle;
      case MachineBreakdownStatus.completed:
        return Icons.done_all;
      default:
        return Icons.help;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatRelativeDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      }
      return 'Just now';
    } catch (e) {
      return dateString;
    }
  }

  void _showUpdateBottomSheet(MachineBreakdownModel breakdown,BuildContext context) {
    // Check if status is already completed
    if (StatusFlow.isFinalStatus(breakdown.status ?? '')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This breakdown is already completed.'),
          backgroundColor: Colors.grey,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return UpdateStatusBottomSheet(breakdown: breakdown);
      },
    ).then((updateData) {
      if (updateData != null) {
       // _handleUpdateSubmit(updateData);
      }
    });
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}