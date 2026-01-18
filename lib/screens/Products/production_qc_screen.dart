import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/common_widgets/custom_button.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../models/production_qc_model.dart';
import '../../providers/riverpods/production_provider.dart';

class ProductionQcListScreen extends ConsumerStatefulWidget {
  const ProductionQcListScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ProductionQcListScreenState();
}

class _ProductionQcListScreenState
    extends ConsumerState<ProductionQcListScreen> {
  List<ProductionQcModel> _filteredItems = [];
  String _searchQuery = '';
  final bool _sortAscending = true;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().subtract(const Duration(days: 1));
    _filteredItems = ref.read(qcDataProvider);
  }

  void _filterItems() {
    setState(() {
      _filteredItems = ref.read(qcDataProvider).where((item) {
        final matchesSearch = _searchQuery.isEmpty ||
            item.style?.toLowerCase().contains(_searchQuery.toLowerCase()) ==
                true ||
            item.buyerName
                    ?.toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ==
                true ||
            item.po?.toLowerCase().contains(_searchQuery.toLowerCase()) == true;

        return matchesSearch;
      }).toList();

      // Sort by defect count
      _filteredItems.sort((a, b) {
        final aDefects = a.totalDefect ?? 0;
        final bDefects = b.totalDefect ?? 0;
        return _sortAscending
            ? aDefects.compareTo(bDefects)
            : bDefects.compareTo(aDefects);
      });
    });
  }

  Color _getDefectColor(num? defectCount) {
    return Colors.green;
  }

  Future<void> _selectDate(BuildContext context, WidgetRef ref) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      debugPrint('Selected Date $picked');
      setState(() {
        _selectedDate = picked;
      });

      final date = DashboardHelpers.convertDateTime(_selectedDate.toString(),
          pattern: 'yyyy-MM-dd');
      await ref.read(qcDataProvider.notifier).loadQcData(date);

      // FIX: Update filteredItems with the new data from Riverpod
      setState(() {
        _filteredItems = ref.read(qcDataProvider); // Use read instead of watch
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Production QC Dashboard'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month),
            onPressed: () {
              _selectDate(context, ref);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Text(
              'Date: ${DashboardHelpers.convertDateTime(_selectedDate.toString(), pattern: 'dd-MM-yyyy')}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          // Search and Filter Section
          _buildSearchFilterSection(),

          // Summary Cards
          _buildSummaryCards(),

          // List Header
          _buildListHeader(),

          // Items List
          Expanded(
            child: _filteredItems.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      return _buildQcItemCard(_filteredItems[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchFilterSection() {
    return Container(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      color: Colors.white,
      child: Column(
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search by Style, Buyer, PO...',
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
  Widget _buildSummaryCards() {
    final totalItems = _filteredItems.length;
    final totalDefects = _filteredItems.fold(
        0, (sum, item) => sum + (item.totalDefect!.toInt() ?? 0));
    final totalPass = _filteredItems.fold(
        0, (sum, item) => sum + (item.totalPass!.toInt() ?? 0));

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildSummaryCard('Total Lines', totalItems.toString(),
              Icons.list_alt, Colors.blue),
          const SizedBox(width: 12),
          _buildSummaryCard('Total Pass', totalPass.toStringAsFixed(1),
              Icons.analytics, Colors.green),
          SizedBox(
            width: 12,
          ),
          _buildSummaryCard('Total Defects', totalDefects.toString(),
              Icons.warning, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
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
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.blue[50],
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child:
                Text('Style/PO', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Text('Buyer', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child:
                Text('Defects', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child:
                Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SizedBox(width: 40), // Space for action button
        ],
      ),
    );
  }

  Widget _buildQcItemCard(ProductionQcModel item) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 1,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getDefectColor(item.totalDefect!.toInt()).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.assignment,
            color: _getDefectColor(item.totalDefect!.toInt()),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.style ?? 'No Style',
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              item.po ?? 'No PO',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              item.buyerName ?? 'No Buyer',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              'Section: ${item.sectionName ?? 'N/A'}',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Pass: ${item.totalPass}'),
            Text('Defect: ${item.totalDefect}'),
          ],
        ),
        onTap: () {
          _showItemDetails(item);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No items found',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filter',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _showItemDetails(ProductionQcModel item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildDetailSheet(item),
    );
  }

  Widget _buildDetailSheet(ProductionQcModel item) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.assignment, color: _getDefectColor(item.totalDefect)),
              const SizedBox(width: 8),
              Text(
                'QC Details',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Style', item.style),
          _buildDetailRow('PO Number', item.po),
          _buildDetailRow('Buyer', item.buyerName),
          _buildDetailRow('Section', item.sectionName),
          _buildDetailRow('Date', item.date),
          const SizedBox(height: 16),
          const Text('Defect Analysis',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildDefectChip('Total Pass', '${item.totalPass}'),
              _buildDefectChip('Total Defects', '${item.totalDefect}'),
              _buildDefectChip('Rejects', '${item.totalReject}'),
              _buildDefectChip('Broken Stitch', '${item.brokenStitch}'),
              _buildDefectChip('Open Seam', '${item.openSeam}'),
              _buildDefectChip('Skip Stitch', '${item.skipStitch}'),
            ],
          ),
          const SizedBox(height: 24),
          CustomElevatedButton(
              text: 'Close',
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text('$label:',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text(value ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildDefectChip(String label, String value) {
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: Colors.grey[100],
      visualDensity: VisualDensity.compact,
    );
  }
}
