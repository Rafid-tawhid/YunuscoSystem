import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/shipment_info_model.dart';
import '../../providers/riverpods/management_provider.dart';

class ShipmentInfoScreen extends ConsumerWidget {
  const ShipmentInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fromDate = ref.watch(shipmentFromDateProvider);
    final toDate = ref.watch(shipmentToDateProvider);
    final shipmentAsync = ref.watch(shipmentInfoProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          '📦 Shipment Analytics',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepPurple.shade700,
        shadowColor: Colors.black12,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Date Range Selector
            _buildDateRangeSelector(ref, fromDate, toDate,context),

            const SizedBox(height: 20),

            // 🔹 Content based on state
            shipmentAsync.when(
              data: (shipments) {
                if (shipments.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildShipmentContent(shipments);
              },
              loading: () => _buildLoadingState(),
              error: (error, stack) => _buildErrorState(ref, error),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeSelector(WidgetRef ref, String fromDate, String toDate,BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Date Range',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDateField(
                    label: 'From Date',
                    date: fromDate,
                    onTap: () => _selectDate(context, ref, true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDateField(
                    label: 'To Date',
                    date: toDate,
                    onTap: () => _selectDate(context, ref, false),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required String date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date.isEmpty ? 'Select Date' : _formatDate(date),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: date.isEmpty ? Colors.grey : Colors.deepPurple.shade700,
                  ),
                ),
                Icon(Icons.calendar_today_rounded,
                    color: Colors.deepPurple.shade500, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, WidgetRef ref, bool isFromDate) async {
    final currentDate = isFromDate
        ? ref.read(shipmentFromDateProvider)
        : ref.read(shipmentToDateProvider);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate.isNotEmpty ? DateTime.parse(currentDate) : DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final formatted = DateFormat('yyyy-MM-dd').format(pickedDate);
      if (isFromDate) {
        ref.read(shipmentFromDateProvider.notifier).state = formatted;
      } else {
        ref.read(shipmentToDateProvider.notifier).state = formatted;
      }
    }
  }

  Widget _buildShipmentContent(List<ShipmentInfoModel> shipments) {
    final overallStats = _calculateOverallStats(shipments);

    return Expanded(
      child: Column(
        children: [
          // 🔹 Overall Statistics
          _buildOverallStats(overallStats),
          const SizedBox(height: 20),

          // 🔹 Shipment List
          Expanded(
            child: _buildShipmentList(shipments),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallStats(Map<String, num> stats) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 Overall Statistics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: [
                _buildStatCard(
                  title: 'Total Delivered',
                  value: stats['delivered']?.toString() ?? '0',
                  icon: Icons.check_circle_rounded,
                  color: Colors.green,
                  subtitle: '${_calculatePercentage(stats['delivered'] ?? 0, stats['total'] ?? 1)}% of total',
                ),
                _buildStatCard(
                  title: 'Not Delivered',
                  value: stats['notDelivered']?.toString() ?? '0',
                  icon: Icons.cancel_rounded,
                  color: Colors.red,
                  subtitle: '${_calculatePercentage(stats['notDelivered'] ?? 0, stats['total'] ?? 1)}% of total',
                ),
                _buildStatCard(
                  title: 'Timely Shipped',
                  value: stats['timelyShipped']?.toString() ?? '0',
                  icon: Icons.schedule_rounded,
                  color: Colors.blue,
                  subtitle: 'On time shipments',
                ),
                _buildStatCard(
                  title: 'Delayed',
                  value: stats['delayed']?.toString() ?? '0',
                  icon: Icons.warning_rounded,
                  color: Colors.orange,
                  subtitle: '${_calculatePercentage(stats['delayed'] ?? 0, stats['total'] ?? 1)}% of total',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShipmentList(List<ShipmentInfoModel> shipments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Monthly Shipment Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              Text(
                '${shipments.length} months',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ListView.separated(
                itemCount: shipments.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: Colors.grey.shade100,
                  indent: 16,
                  endIndent: 16,
                ),
                itemBuilder: (context, index) {
                  final shipment = shipments[index];
                  return _buildShipmentItem(shipment, index);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShipmentItem(ShipmentInfoModel shipment, int index) {
    final totalShipments = _calculateTotalShipments(shipment);
    final onTimeRate = totalShipments > 0
        ? ((shipment.timelyShiped ?? 0) / totalShipments * 100)
        : 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(
            color: _getPerformanceColor(onTimeRate.toDouble()),
            width: 4,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple.shade100,
                Colors.purple.shade100,
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.deepPurple.shade700,
                fontSize: 14,
              ),
            ),
          ),
        ),
        title: Text(
          shipment.monthYear ?? 'Unknown Month',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.local_shipping_rounded, size: 12, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(
                  'Total: $totalShipments',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.timer_rounded, size: 12, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(
                  'On Time: ${shipment.timelyShiped ?? 0}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${onTimeRate.toStringAsFixed(1)}%',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: _getPerformanceColor(onTimeRate.toDouble()),
              ),
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getPerformanceColor(onTimeRate.toDouble()).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _getPerformanceText(onTimeRate.toDouble()),
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: _getPerformanceColor(onTimeRate.toDouble()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_shipping_rounded, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 20),
            const Text(
              'No Shipment Data',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'No shipment records found for the selected date range',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
            ),
            SizedBox(height: 16),
            Text(
              'Loading Shipment Data...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(WidgetRef ref, Object error) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            const Text(
              'Failed to Load Data',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              'Error: $error',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => ref.refresh(shipmentInfoProvider),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info_rounded, color: Colors.deepPurple),
            SizedBox(width: 8),
            Text('Shipment Analytics'),
          ],
        ),
        content: const Text(
          'This screen displays monthly shipment analytics including delivery status, '
              'timely shipments, and delay analysis for the selected date range.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    try {
      return DateFormat('MMM dd, yyyy').format(DateTime.parse(date));
    } catch (e) {
      return date;
    }
  }

  Color _getPerformanceColor(double rate) {
    if (rate >= 80) return Colors.green;
    if (rate >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getPerformanceText(double rate) {
    if (rate >= 80) return 'EXCELLENT';
    if (rate >= 60) return 'GOOD';
    return 'NEEDS IMPROVEMENT';
  }

  Map<String, num> _calculateOverallStats(List<ShipmentInfoModel> shipments) {
    num totalDelivered = 0;
    num totalNotDelivered = 0;
    num totalTimelyShipped = 0;
    num totalDelayed = 0;
    num totalShipments = 0;

    for (final shipment in shipments) {
      totalDelivered += shipment.delivered ?? 0;
      totalNotDelivered += shipment.notDelivered ?? 0;
      totalTimelyShipped += shipment.timelyShiped ?? 0;
      totalDelayed += (shipment.oneWeekDelay ?? 0) +
          (shipment.twoWeekDelay ?? 0) +
          (shipment.moreTwoWeekDelay ?? 0);
      totalShipments += _calculateTotalShipments(shipment);
    }

    return {
      'delivered': totalDelivered,
      'notDelivered': totalNotDelivered,
      'timelyShipped': totalTimelyShipped,
      'delayed': totalDelayed,
      'total': totalShipments,
    };
  }

  num _calculateTotalShipments(ShipmentInfoModel shipment) {
    return (shipment.delivered ?? 0) +
        (shipment.notDelivered ?? 0) +
        (shipment.beforeShiped ?? 0) +
        (shipment.timelyShiped ?? 0) +
        (shipment.oneWeekDelay ?? 0) +
        (shipment.twoWeekDelay ?? 0) +
        (shipment.moreTwoWeekDelay ?? 0);
  }

  double _calculatePercentage(num value, num total) {
    if (total == 0) return 0.0;
    return (value / total * 100);
  }
}

