import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/providers/riverpods/production_provider.dart';
import 'package:yunusco_group/screens/Products/widgets/date_compare_dialoge.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../helper_class/dashboard_helpers.dart';
import '../../models/qc_difference_model.dart';

class QcDifferenceDashboard extends ConsumerStatefulWidget {
  final String date1Label;
  final String date2Label;

  const QcDifferenceDashboard({
    Key? key,
    this.date1Label = 'Date 1',
    this.date2Label = 'Date 2',
  }) : super(key: key);

  @override
  ConsumerState createState() => _QcDifferenceDashboardState();
}

class _QcDifferenceDashboardState extends ConsumerState<QcDifferenceDashboard> {
  List<QcDifferenceModel> _filteredItems = [];
  String _searchQuery = '';
  String _selectedFilter = 'All';
  String _selectedMetric = 'Defect';
  bool _showImprovementsOnly = false;

  @override
  void initState() {
    super.initState();
    _filteredItems = ref.read(differenceDataProvider);
  }

  void _filterItems() {
    setState(() {
      _filteredItems = ref.read(differenceDataProvider).where((item) {
        final matchesSearch = _searchQuery.isEmpty ||
            item.lineName?.toLowerCase().contains(_searchQuery.toLowerCase()) == true ||
            item.sectionName?.toLowerCase().contains(_searchQuery.toLowerCase()) == true ||
            item.buyerName?.toLowerCase().contains(_searchQuery.toLowerCase()) == true;

        bool matchesFilter = true;
        if (_selectedFilter == 'Improving') {
          matchesFilter = (item.defectDifference ?? 0) < 0;
        } else if (_selectedFilter == 'Declining') {
          matchesFilter = (item.defectDifference ?? 0) > 0;
        } else if (_selectedFilter == 'No Change') {
          matchesFilter = (item.defectDifference ?? 0) == 0;
        }

        if (_showImprovementsOnly) {
          matchesFilter = matchesFilter && (item.defectDifference ?? 0) < 0;
        }

        return matchesSearch && matchesFilter;
      }).toList();

      // Sort by selected metric
      _filteredItems.sort((a, b) {
        num aValue = 0;
        num bValue = 0;

        switch (_selectedMetric) {
          case 'Defect':
            aValue = a.defectDifference ?? 0;
            bValue = b.defectDifference ?? 0;
            break;
          case 'Pass':
            aValue = a.passDifference ?? 0;
            bValue = b.passDifference ?? 0;
            break;
          case 'Reject':
            aValue = a.rejectDifference ?? 0;
            bValue = b.rejectDifference ?? 0;
            break;
        }

        return bValue.compareTo(aValue);
      });
    });
  }

  Color _getDifferenceColor(num? difference, bool reverseColor) {
    final diff = difference ?? 0;
    if (reverseColor) {
      return diff > 0 ? Colors.green : diff < 0 ? Colors.red : Colors.grey;
    }
    return diff > 0 ? Colors.red : diff < 0 ? Colors.green : Colors.grey;
  }

  IconData _getDifferenceIcon(num? difference) {
    final diff = difference ?? 0;
    if (diff > 0) return Icons.arrow_upward;
    if (diff < 0) return Icons.arrow_downward;
    return Icons.remove;
  }

  String _getTrendText(num? difference) {
    final diff = difference ?? 0;
    if (diff > 0) return 'Increased';
    if (diff < 0) return 'Improved';
    return 'No Change';
  }

  Widget _buildMetricCard(String title, num? date1Value, num? date2Value, num? difference) {
    final isImprovement = (difference ?? 0) < 0;
    final color = _getDifferenceColor(difference, title == 'Pass');

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${date1Value ?? 0}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.date1Label,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${date2Value ?? 0}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.date2Label,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getDifferenceIcon(difference),
                    size: 14,
                    color: color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${difference?.abs() ?? 0}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('QC Comparison Dashboard'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Quick Filters
          _buildSearchSection(),

          // Summary Statistics
          _buildSummaryStats(),

          // List Header
          _buildListHeader(),

          // Items List
          Expanded(
            child: _filteredItems.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                return _buildComparisonCard(_filteredItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.only(left: 16,right: 16,top: 16),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search by Line, Section, Buyer...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            onChanged: (value) {
              _searchQuery = value;
              _filterItems();
            },
          ),


        ],
      ),
    );
  }
//
  Widget _buildSummaryStats() {
    final totalImprovements = _filteredItems.where((item) => (item.defectDifference ?? 0) < 0).length;
    final totalDeclines = _filteredItems.where((item) => (item.defectDifference ?? 0) > 0).length;
    final avgDefectChange = _filteredItems.isEmpty
        ? 0
        : _filteredItems.fold(0, (sum, item) => sum + (item.defectDifference!.toInt() ?? 0)) / _filteredItems.length;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(Icons.trending_up, color: Colors.green, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    '$totalImprovements',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Improving',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(Icons.trending_down, color: Colors.red, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    '$totalDeclines',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Declining',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(Icons.analytics, color: Colors.blue, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    avgDefectChange.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _getDifferenceColor(avgDefectChange, false),
                    ),
                  ),
                  Text(
                    'Avg Change',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.purple[50],
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text('Line/Section', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple[800])),
          ),
          Expanded(
            child: Text('Pass', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple[800])),
          ),
          Expanded(
            child: Text('Defect', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple[800])),
          ),
          Expanded(
            child: Text('Reject', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple[800])),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonCard(QcDifferenceModel item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header with Line, Section, Buyer
            Row(
              children: [
                Icon(Icons.compare_arrows, color: Colors.purple[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.lineName ?? 'No Line',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        '${item.sectionName} • ${item.buyerName}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getDifferenceColor(item.defectDifference, false).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _getDifferenceColor(item.defectDifference, false)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getDifferenceIcon(item.defectDifference),
                        size: 12,
                        color: _getDifferenceColor(item.defectDifference, false),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getTrendText(item.defectDifference),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _getDifferenceColor(item.defectDifference, false),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Metrics Row
            Row(
              children: [
                _buildMetricCard('Pass', item.totalPassDate1, item.totalPassDate2, item.passDifference),
                const SizedBox(width: 8),
                _buildMetricCard('Defect', item.totalDefectDate1, item.totalDefectDate2, item.defectDifference),
                const SizedBox(width: 8),
                _buildMetricCard('Reject', item.totalRejectDate1, item.totalRejectDate2, item.rejectDifference),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.filter_list_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No matching comparisons',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Future<void> _showFilterDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => DateComparisonDialog(),
    );

    if (result != null) {
      // Use the selected dates
      String startDate = DashboardHelpers.convertDateTime(result['startDate'].toString(),pattern: 'yyyy-MM-dd');
      String endDate = DashboardHelpers.convertDateTime(result['endDate'].toString(),pattern: 'yyyy-MM-dd');
      await ref.read(differenceDataProvider.notifier).loadDifferenceData(startDate, endDate);
      setState(() {
        _filteredItems = ref.read(differenceDataProvider);
      });
    }
  }
}