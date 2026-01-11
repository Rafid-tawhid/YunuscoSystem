// screens/error_summary_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/screens/Products/widgets/date_picker_Card.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../models/error_summery_model.dart';
import '../../providers/riverpods/production_provider.dart';

class ErrorSummaryScreen extends ConsumerStatefulWidget {
  const ErrorSummaryScreen({super.key});

  @override
  ConsumerState<ErrorSummaryScreen> createState() => _ErrorSummaryScreenState();
}

class _ErrorSummaryScreenState extends ConsumerState<ErrorSummaryScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load data for today when screen initializes
    _loadDataForDate(DateTime.now());
  }

  Future<void> _loadDataForDate(DateTime date) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final notifier = ref.read(errorSummaryProvider.notifier);
      final dateString = _formatDate(date);

      await notifier.loadErrorSummaryData(dateString);

      // Update selected date
      ref.read(selectedDateProvider.notifier).state = date;
    } catch (e) {
      // Show error snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatDisplayDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _selectDate(BuildContext context,DateTime date) async {

    await _loadDataForDate(date);
    }

  @override
  Widget build(BuildContext context) {
    final errorList = ref.watch(errorSummaryProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final notifier = ref.read(errorSummaryProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Error Summary'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : () => _loadDataForDate(selectedDate),
          ),
        ],
      ),
      body: Column(
        children: [
          // Date Selection Card
          DatePickerCard(
            initialDate: DateTime.now(),
            onDateSelected: (date) async {
             _selectDate(context,date);
            },
            label: 'Selected Date',
          ),

          // Summary Cards
          if (!_isLoading && errorList.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildSummaryCard(
                    'Total Defects',
                    notifier.totalDefects.toString(),
                    Colors.red,
                    Icons.bug_report,
                  ),
                  const SizedBox(width: 12),
                  _buildSummaryCard(
                    'Error Types',
                    notifier.uniqueErrorTypes.toString(),
                    Colors.orange,
                    Icons.warning,
                  ),
                  const SizedBox(width: 12),
                  _buildSummaryCard(
                    'Records',
                    errorList.length.toString(),
                    Colors.blue,
                    Icons.list,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Loading or Data
          Expanded(
            child: _isLoading
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading error data...'),
                ],
              ),
            )
                : errorList.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No error data found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Text(
                    'Select a different date or check your connection',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
                : _buildErrorList(errorList),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorList(List<ErrorSummaryModel> errorList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Error Details:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Card(
              color: Colors.white,
              child: ListView.builder(
                itemCount: errorList.length,
                itemBuilder: (context, index) {
                  final error = errorList[index];
                  return _buildErrorListItem(error, index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorListItem(ErrorSummaryModel error, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getColorBasedOnDefects(error.totalDefects ?? 0),
          child: Text(
            (index + 1).toString(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          error.errorName ?? 'Unknown Error',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          'Date: ${DashboardHelpers.convertDateTime(error.day.toString(),pattern: 'dd-MMM-yyyy')}',
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getColorBasedOnDefects(error.totalDefects ?? 0).withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '${error.totalDefects ?? 0} defects',
            style: TextStyle(
              color: _getColorBasedOnDefects(error.totalDefects ?? 0),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Color _getColorBasedOnDefects(num defects) {
    if (defects == 0) return Colors.green;
    if (defects <= 5) return Colors.orange;
    return Colors.red;
  }
}