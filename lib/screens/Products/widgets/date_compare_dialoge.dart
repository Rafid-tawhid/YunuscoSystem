import 'package:flutter/material.dart';

class DateComparisonDialog extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  const DateComparisonDialog({
    Key? key,
    this.initialStartDate,
    this.initialEndDate,
  }) : super(key: key);

  @override
  _DateComparisonDialogState createState() => _DateComparisonDialogState();
}

class _DateComparisonDialogState extends State<DateComparisonDialog> {
  DateTime? _startDate;
  DateTime? _endDate;
  final List<String> _quickOptions = [
    'Today vs Yesterday',
    'This Week vs Last Week',
    'This Month vs Last Month',
    'Last 7 Days',
    'Last 30 Days'
  ];
  String? _selectedQuickOption;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue[800],
            colorScheme: ColorScheme.light(primary: Colors.blue[800]!),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        _selectedQuickOption = null;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue[800],
            colorScheme: ColorScheme.light(primary: Colors.blue[800]!),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
        _selectedQuickOption = null;
      });
    }
  }

  void _applyQuickOption(String option) {
    setState(() {
      _selectedQuickOption = option;
      final now = DateTime.now();

      switch (option) {
        case 'Today vs Yesterday':
          _endDate = now;
          _startDate = now.subtract(const Duration(days: 1));
          break;
        case 'This Week vs Last Week':
          _endDate = now;
          _startDate = now.subtract(const Duration(days: 7));
          break;
        case 'This Month vs Last Month':
          _endDate = now;
          _startDate = DateTime(now.year, now.month - 1, now.day);
          break;
        case 'Last 7 Days':
          _endDate = now;
          _startDate = now.subtract(const Duration(days: 7));
          break;
        case 'Last 30 Days':
          _endDate = now;
          _startDate = now.subtract(const Duration(days: 30));
          break;
      }
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return '${date.day}/${date.month}/${date.year}';
  }

  bool get _isValidSelection {
    return _startDate != null && _endDate != null;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.blue[800], size: 24),
                  const SizedBox(width: 12),
                  const Text(
                    'Compare Production Dates',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Select two dates to compare production QC data',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),


              // Date 1 Selection
              _buildDateField(
                label: 'First Date (Date 1)',
                date: _startDate,
                onTap: () => _selectStartDate(context),
                icon: Icons.calendar_today,
              ),
              const SizedBox(height: 16),

              // Date 2 Selection
              _buildDateField(
                label: 'Second Date (Date 2)',
                date: _endDate,
                onTap: () => _selectEndDate(context),
                icon: Icons.calendar_today,
              ),
              const SizedBox(height: 8),

              // Date Validation
              if (_startDate != null && _endDate != null)
                _buildDateComparisonInfo(),

              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: BorderSide(color: Colors.grey[400]!),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isValidSelection
                          ? () {
                        Navigator.pop(context, {
                          'startDate': _startDate,
                          'endDate': _endDate,
                          'quickOption': _selectedQuickOption,
                        });
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Apply Comparison',
                        style: TextStyle(color: Colors.white),
                      ),
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

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.blue[800], size: 20),
                const SizedBox(width: 12),
                Text(
                  _formatDate(date),
                  style: TextStyle(
                    fontSize: 16,
                    color: date == null ? Colors.grey : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateComparisonInfo() {
    if (_startDate == null || _endDate == null) return const SizedBox();

    final daysDifference = _endDate!.difference(_startDate!).inDays;
    final isChronological = _endDate!.isAfter(_startDate!);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isChronological ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isChronological ? Colors.green[100]! : Colors.orange[100]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isChronological ? Icons.check_circle : Icons.warning,
            color: isChronological ? Colors.green : Colors.orange,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isChronological
                  ? 'Comparing $daysDifference day${daysDifference == 1 ? '' : 's'} of data'
                  : 'Date 2 should be after Date 1 for proper comparison',
              style: TextStyle(
                fontSize: 12,
                color: isChronological ? Colors.green[800] : Colors.orange[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Usage Example in your screen:
class ProductionComparisonScreen extends StatefulWidget {
  @override
  _ProductionComparisonScreenState createState() => _ProductionComparisonScreenState();
}

class _ProductionComparisonScreenState extends State<ProductionComparisonScreen> {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  void _showDateComparisonDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => DateComparisonDialog(
        initialStartDate: _selectedStartDate,
        initialEndDate: _selectedEndDate,
      ),
    );

    if (result != null) {
      setState(() {
        _selectedStartDate = result['startDate'];
        _selectedEndDate = result['endDate'];
      });

      // Call your API or filter data here
      _compareProductionData(_selectedStartDate!, _selectedEndDate!);
    }
  }

  void _compareProductionData(DateTime startDate, DateTime endDate) {
    // Implement your data comparison logic here
    print('Comparing production from ${startDate.toIso8601String()} to ${endDate.toIso8601String()}');

    // Show loading or update your QcDifferenceModel list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Production Comparison'),
        actions: [
          IconButton(
            icon: const Icon(Icons.compare_arrows),
            onPressed: _showDateComparisonDialog,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedStartDate != null && _selectedEndDate != null)
              Text(
                'Selected: ${_selectedStartDate!.day}/${_selectedStartDate!.month}/${_selectedStartDate!.year} - ${_selectedEndDate!.day}/${_selectedEndDate!.month}/${_selectedEndDate!.year}',
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showDateComparisonDialog,
              child: const Text('Select Dates for Comparison'),
            ),
          ],
        ),
      ),
    );
  }
}