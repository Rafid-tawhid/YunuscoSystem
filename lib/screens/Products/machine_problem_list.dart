// lib/screens/machine_breakdown_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/screens/Products/widgets/update_status_bottomsheet.dart';
import 'package:yunusco_group/utils/colors.dart';

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

  Widget _buildBreakdownCard(MachineBreakdownModel breakdown,BuildContext context) {
    Color statusColor = StatusFlow.getStatusColor(breakdown.status);
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _showUpdateBottomSheet(breakdown,context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with ID and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ID: ${breakdown.maintenanceId ?? 'N/A'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      breakdown.status ?? 'Unknown',
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Machine Info
              _buildInfoRow(
                icon: Icons.business_center,
                label: 'Machine',
                value: '${breakdown.machineType ?? 'N/A'} - ${breakdown.machineNo ?? 'N/A'}',
              ),

              // Line and Operation
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow(
                      icon: Icons.line_style,
                      label: 'Line',
                      value: breakdown.lineName ?? 'N/A',
                    ),
                  ),
                  Expanded(
                    child: _buildInfoRow(
                      icon: Icons.settings,
                      label: 'Operation',
                      value: breakdown.operationName ?? 'N/A',
                    ),
                  ),
                ],
              ),

              // Task and Reported Time
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow(
                      icon: Icons.task,
                      label: 'Task',
                      value: breakdown.taskCode ?? 'N/A',
                    ),
                  ),
                  Expanded(
                    child: _buildInfoRow(
                      icon: Icons.access_time,
                      label: 'Reported',
                      value: breakdown.reportedTime ?? 'N/A',
                    ),
                  ),
                ],
              ),

              // Employee
              _buildInfoRow(
                icon: Icons.person,
                label: 'Employee',
                value: breakdown.fullName ?? 'N/A',
              ),

              // Dates
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow(
                      icon: Icons.date_range,
                      label: 'Created',
                      value: _formatDate(breakdown.createdDate),
                    ),
                  ),
                  Expanded(
                    child: _buildInfoRow(
                      icon: Icons.update,
                      label: 'Updated',
                      value: _formatDate(breakdown.updatedDate),
                    ),
                  ),
                ],
              ),

              // Timeline if available
              if (breakdown.workStartTime != null && breakdown.workEndTime != null)
                _buildTimelineInfo(breakdown),
            ],
          ),
        ),
      ),
    );
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

  Widget _buildTimelineInfo(MachineBreakdownModel breakdown) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Timeline',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          _buildTimelineRow('Start', breakdown.workStartTime),
          _buildTimelineRow('Delay', breakdown.delayTime),
          _buildTimelineRow('End', breakdown.workEndTime),
          _buildTimelineRow('Total Work', breakdown.mechanicWorkTime),
        ],
      ),
    );
  }

  Widget _buildTimelineRow(String label, dynamic time) {
    if (time == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            time.toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.blue[700],
            ),
          ),
        ],
      ),
    );
  }



  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}