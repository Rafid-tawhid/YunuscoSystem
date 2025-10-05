import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../../providers/riverpods/management_provider.dart';

class KaizanCountScreen extends ConsumerWidget {
  const KaizanCountScreen({super.key});

  Future<void> _selectFromDate(BuildContext context, WidgetRef ref) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      ref.read(dateStateProvider.notifier).update((state) => {
        ...state,
        'fromDate': picked,
      });
    }
  }

  Future<void> _selectToDate(BuildContext context, WidgetRef ref) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      ref.read(dateStateProvider.notifier).update((state) => {
        ...state,
        'toDate': picked,
      });
    }
  }

  void _clearDates(WidgetRef ref) {
    ref.read(dateStateProvider.notifier).state = {
      'fromDate': null,
      'toDate': null,
    };
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dates = ref.watch(dateStateProvider);
    final nums = ref.watch(randNum);
    final numValueAsync = ref.watch(numValueProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Kaizan Count'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(numValueProvider),
          ),
          IconButton(
            icon: const Icon(Icons.numbers),
            onPressed: () {
              var dd=ref.read(randNum.notifier);
              dd.state=5;
            },
          ),


        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date Selection Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'From Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => _selectFromDate(context, ref),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatDate(dates['fromDate'])),
                              const Icon(Icons.calendar_today, size: 20),
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
                        'To Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => _selectToDate(context, ref),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatDate(dates['toDate'])),
                              const Icon(Icons.calendar_today, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(nums.toString()),
            // Clear Dates Button
            if (dates['fromDate'] != null || dates['toDate'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  onPressed: () => _clearDates(ref),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Clear Dates'),
                ),
              ),

            const SizedBox(height: 32),

            // Display API Value
            Expanded(
              child: Center(
                child: numValueAsync.when(
                  loading: () => const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading Kaizan Count...'),
                    ],
                  ),
                  error: (error, stack) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 50, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Error: $error',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.invalidate(numValueProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                  data: (value) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.analytics,
                          size: 50,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Kaizan Count',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        value.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        dates['fromDate'] == null && dates['toDate'] == null
                            ? 'All Time'
                            : 'From: ${_formatDate(dates['fromDate'])} To: ${_formatDate(dates['toDate'])}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button for refresh
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.invalidate(numValueProvider),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}