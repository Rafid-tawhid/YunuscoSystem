import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/management_provider.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../../models/JobCardDropdownModel.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/broken_needle_model.dart';
import '../../../providers/riverpods/management_provider.dart';

// Assuming these are already defined elsewhere in your project
// import '../providers/broken_needle_provider.dart';
// import '../models/broken_needle_model.dart';

class NeedleDashboard extends ConsumerWidget {
  const NeedleDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brokenNeedleSummaryAsync = ref.watch(brokenNeedleSummary);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Needle Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(brokenNeedleSummary);
            },
          ),
        ],
      ),
      body: brokenNeedleSummaryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 50),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(brokenNeedleSummary),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (data) {
          if (data.isEmpty) {
            return const Center(
              child: Text('No data available'),
            );
          }

          return _DashboardContent(data: data);
        },
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final List<BrokenNeedleModel> data;

  const _DashboardContent({required this.data});

  @override
  Widget build(BuildContext context) {
    // Calculate totals for summary cards
    final totalIssued = data.fold<num>(0, (sum, item) => sum + (item.totalIssueQty ?? 0));
    final totalBroken = data.fold<num>(0, (sum, item) => sum + (item.brokenQty ?? 0));
    final totalMissing = data.fold<num>(0, (sum, item) => sum + (item.missingQty ?? 0));
    final totalUsed = data.fold<num>(0, (sum, item) => sum + (item.used ?? 0));
    final overallBrokenPercentage = totalIssued > 0
        ? ((totalBroken / totalIssued) * 100).toStringAsFixed(2)
        : '0.00';

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _SummaryCard(
                  title: 'Total Issued',
                  value: totalIssued.toString(),
                  color: Colors.blue,
                  icon: Icons.inventory,
                ),
                _SummaryCard(
                  title: 'Total Broken',
                  value: totalBroken.toString(),
                  color: Colors.red,
                  icon: Icons.broken_image,
                ),
                _SummaryCard(
                  title: 'Total Missing',
                  value: totalMissing.toString(),
                  color: Colors.orange,
                  icon: Icons.find_in_page,
                ),
                _SummaryCard(
                  title: 'Total Used',
                  value: totalUsed.toString(),
                  color: Colors.green,
                  icon: Icons.check_circle,
                ),
                _SummaryCard(
                  title: 'Broken %',
                  value: '$overallBrokenPercentage%',
                  color: Colors.purple,
                  icon: Icons.percent,
                ),
              ],
            ),
          ),
      
          const Divider(thickness: 1),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8.0),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return _NeedleDataCard(item: item);
            },
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Container(
        alignment: Alignment.center,
        width: 180,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color,size: 20,),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NeedleDataCard extends StatelessWidget {
  final BrokenNeedleModel item;

  const _NeedleDataCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final brokenPercentage = item.brokenPercentage != null
        ? '${item.brokenPercentage!.toStringAsFixed(2)}%'
        : '0.00%';

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Year/Month
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${item.year} - ${item.monthName}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text('Month: ${item.monthNumber}'),
                  backgroundColor: Colors.blue[50],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Metrics Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                _MetricTile(
                  label: 'Issued',
                  value: item.totalIssueQty?.toString() ?? '0',
                  color: Colors.blue,
                ),
                _MetricTile(
                  label: 'Used',
                  value: item.used?.toString() ?? '0',
                  color: Colors.green,
                ),
                _MetricTile(
                  label: 'Balance',
                  value: item.balance?.toString() ?? '0',
                  color: Colors.teal,
                ),
                _MetricTile(
                  label: 'Broken %',
                  value: brokenPercentage,
                  color: Colors.purple,
                ),
                _MetricTile(
                  label: 'Broken',
                  value: item.brokenQty?.toString() ?? '0',
                  color: Colors.red,
                ),
                _MetricTile(
                  label: 'Missing',
                  value: item.missingQty?.toString() ?? '0',
                  color: Colors.orange,
                ),
                _MetricTile(
                  label: 'Blunt',
                  value: item.bluntQty?.toString() ?? '0',
                  color: Colors.amber,
                ),
              ],
            ),

            // Additional Info (if needed)
            if (item.balance != null && item.totalIssueQty != null && item.totalIssueQty! > 0)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: LinearProgressIndicator(
                  value: (item.used ?? 0) / item.totalIssueQty!,
                  backgroundColor: Colors.grey[200],
                  color: Colors.green,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTile extends StatelessWidget {
  final Units department;
  final VoidCallback onTap;

  const SectionTile({
    super.key,
    required this.department,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          department.id?.toString() ?? '?',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        department.name ?? 'Unnamed Department',
        style: const TextStyle(fontSize: 16),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
