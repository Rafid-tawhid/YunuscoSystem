import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/utils/colors.dart';
import '../../models/hourly_sweing_model.dart';
import '../../providers/riverpods/production_provider.dart';

class HourlySewingStatusScreen extends ConsumerStatefulWidget {
  const HourlySewingStatusScreen({super.key});

  @override
  ConsumerState<HourlySewingStatusScreen> createState() =>
      _HourlySewingStatusScreenState();
}

class _HourlySewingStatusScreenState extends ConsumerState<HourlySewingStatusScreen> {
  late String selectedDate;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now().toIso8601String().split('T')[0];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(selectedDate),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked.toIso8601String().split('T')[0];
        _searchQuery = '';
        _searchController.clear();
      });
    }
  }

  // Group data by line
  Map<String, List<HourlySweingModel>> _groupByLine(List<HourlySweingModel> data) {
    final Map<String, List<HourlySweingModel>> grouped = {};

    for (final item in data) {
      final lineKey = '${item.lineName ?? item.lineCode}';
      if (!grouped.containsKey(lineKey)) {
        grouped[lineKey] = [];
      }
      grouped[lineKey]!.add(item);
    }

    // Sort each line's data by hour (status)
    for (final key in grouped.keys) {
      grouped[key]!.sort((a, b) {
        final hourA = _extractHourNumber(a.status ?? '');
        final hourB = _extractHourNumber(b.status ?? '');
        return hourA.compareTo(hourB);
      });
    }

    return grouped;
  }

  int _extractHourNumber(String status) {
    if (status.toLowerCase().startsWith('h')) {
      final hourStr = status.substring(1);
      return int.tryParse(hourStr) ?? 0;
    }
    return 0;
  }

  String _formatHour(String status) {
    final hour = _extractHourNumber(status);
    return hour > 0 ? 'Hour $hour' : status;
  }

  List<MapEntry<String, List<HourlySweingModel>>> _filterGroupedData(
      Map<String, List<HourlySweingModel>> groupedData) {
    if (_searchQuery.isEmpty) return groupedData.entries.toList();

    return groupedData.entries.where((entry) {
      final lineName = entry.key.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return lineName.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final sewingAsync = ref.watch(hourlySewingStatusProvider(selectedDate));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          'Hourly Sewing Status',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, size: 22),
            onPressed: pickDate,
            tooltip: 'Select Date',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.date_range, size: 20, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      selectedDate,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${sewingAsync.value?.length ?? 0} records',
                        style: TextStyle(
                          fontSize: 14,
                          color: myColors.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search by line...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[600]),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _searchController.clear();
                          });
                        },
                      )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: sewingAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Loading sewing data...',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading data',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  err.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.invalidate(hourlySewingStatusProvider(selectedDate));
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (list) {
          final groupedData = _groupByLine(list);
          final filteredEntries = _filterGroupedData(groupedData);

          if (filteredEntries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _searchQuery.isEmpty ? Icons.inbox : Icons.search_off,
                    size: 72,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _searchQuery.isEmpty
                        ? 'No data found for $selectedDate'
                        : 'No results for "$_searchQuery"',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                          _searchController.clear();
                        });
                      },
                      child: const Text('Clear search'),
                    ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredEntries.length,
            itemBuilder: (context, index) {
              final entry = filteredEntries[index];
              final lineData = entry.value;
              final lineName = entry.key;

              // Calculate totals
              final totalQty = lineData.fold<double>(0, (sum, item) => sum + (item.qty ?? 0));
              final totalTargetHr = lineData.fold<double>(0, (sum, item) => sum + (item.targetHrQty ?? 0));
              final totalTargetDay = lineData.fold<double>(0, (sum, item) => sum + (item.targetDayQty ?? 0));

              // Get common item and buyer info (assuming same for all hours)
              final firstItem = lineData.first;
              final itemName = firstItem.itemName ?? firstItem.itemCode ?? '-';
              final buyerName = firstItem.buyerName ?? firstItem.buyerCode ?? '-';

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Line Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: myColors.primaryColor.withOpacity(0.08),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: myColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.factory,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lineName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$itemName • $buyerName',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Total Summary
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSummaryItem('Total Qty', totalQty.toStringAsFixed(0), Icons.summarize),
                          _buildSummaryItem('Hour Target', totalTargetHr.toStringAsFixed(0), Icons.timer),
                          _buildSummaryItem('Day Target', totalTargetDay.toStringAsFixed(0), Icons.today),
                        ],
                      ),
                    ),

                    // Hourly Production Timeline
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Hourly Production',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Hourly Data Cards
                    ...lineData.map((item) {
                      final hour = _extractHourNumber(item.status ?? '');
                      final isCurrentHour = hour == DateTime.now().hour;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isCurrentHour ? Colors.blue[50] : Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isCurrentHour ? Colors.blue[100]! : Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Hour Indicator
                              Container(
                                width: 60,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isCurrentHour ? Colors.blue[100] : Colors.grey[100],
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _formatHour(item.status ?? ''),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: isCurrentHour ? Colors.blue[700] : Colors.grey[700],
                                      ),
                                    ),
                                    if (isCurrentHour)
                                      Text(
                                        'Current',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.blue[600],
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildHourlyStat(
                                        'Production',
                                        '${item.qty?.toStringAsFixed(0) ?? '0'}',
                                        Icons.trending_up,
                                        Colors.green,
                                      ),
                                      _buildHourlyStat(
                                        'Hour Target',
                                        '${item.targetHrQty?.toStringAsFixed(0) ?? '0'}',
                                        Icons.filter_center_focus,
                                        Colors.orange,
                                      ),
                                      _buildHourlyStat(
                                        'Efficiency',
                                        '${item.targetHrQty != null && item.targetHrQty! > 0 ? ((item.qty ?? 0) / item.targetHrQty! * 100).toStringAsFixed(1) : '0'}%',
                                        Icons.bar_chart,
                                        Colors.purple,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),

                    // Additional Details
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                          title: Row(
                            children: [
                              Icon(Icons.info_outline, size: 18, color: Colors.grey[600]),
                              const SizedBox(width: 8),
                              Text(
                                'Additional Information',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (firstItem.buyerAddress != null && firstItem.buyerAddress!.isNotEmpty)
                                    _buildDetailRow('Buyer Address:', firstItem.buyerAddress!),
                                  if (firstItem.buyerContact != null && firstItem.buyerContact!.isNotEmpty)
                                    _buildDetailRow('Buyer Contact:', firstItem.buyerContact!),
                                  if (firstItem.itemBasicPrice != null)
                                    _buildDetailRow('Item Price:', firstItem.itemBasicPrice!.toStringAsFixed(2)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }


  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: myColors.primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildHourlyStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
