import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'lc_details_screen.dart';

class ExportRegisterScreen extends StatefulWidget {
  const ExportRegisterScreen({super.key});

  @override
  State<ExportRegisterScreen> createState() => _ExportRegisterScreenState();
}

class _ExportRegisterScreenState extends State<ExportRegisterScreen> {
  final List<LCExportItem> _allItems = [
    // Sample data - replace with your actual data
    LCExportItem(
      id: 'LC-2023-001',
      customer: 'ABC Trading',
      amount: 125000,
      currency: 'USD',
      issueDate: DateTime(2023, 5, 15),
    ),
    LCExportItem(id: 'LC-2023-002', customer: 'XYZ Exports', amount: 87500, currency: 'EUR', issueDate: DateTime(2023, 6, 22)),
    // Add more items...
  ];

  List<LCExportItem> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _filteredItems = _allItems;
  }

  void _searchItems(String query) {
    setState(() {
      _filteredItems = _allItems.where((item) {
        final searchLower = query.toLowerCase();
        return item.id.toLowerCase().contains(searchLower) || item.customer.toLowerCase().contains(searchLower) || item.currency.toLowerCase().contains(searchLower);
      }).toList();
    });
  }

  void _filterByStatus(String status) {
    setState(() {
      _selectedFilter = status;
      if (status == 'All') {
        _filteredItems = _allItems;
      } else {
        // Add your actual filtering logic here
        // For example: _filteredItems = _allItems.where((item) => item.status == status).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('LC Export Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => _showFilterDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by LC#, Customer, Currency...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchItems('');
                        },
                      )
                    : null,
              ),
              onChanged: _searchItems,
            ),
          ),
          Expanded(
            child: _filteredItems.isEmpty
                ? const Center(child: Text('No items found'))
                : ListView.builder(
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      return _buildItemCard(item);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _addNewItem(),
      ),
    );
  }

  Widget _buildItemCard(LCExportItem item) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(item.id, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.customer),
            const SizedBox(height: 4),
            Text(NumberFormat.currency(symbol: item.currency).format(item.amount), style: const TextStyle(color: Colors.green)),
          ],
        ),
        trailing: Text(DateFormat('dd-MMM-yyyy').format(item.issueDate)),
        onTap: () => _viewItemDetails(item),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Items'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterOption('All'),
              _buildFilterOption('Pending'),
              _buildFilterOption('Approved'),
              _buildFilterOption('Rejected'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String status) {
    return RadioListTile(
      title: Text(status),
      value: status,
      groupValue: _selectedFilter,
      onChanged: (value) {
        Navigator.pop(context);
        _filterByStatus(value.toString());
      },
    );
  }

  void _viewItemDetails(LCExportItem item) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>LCDetailScreen()));
  }

  void _addNewItem() {
    // Navigate to add new item screen
  }
}

class LCExportItem {
  final String id;
  final String customer;
  final double amount;
  final String currency;
  final DateTime issueDate;

  LCExportItem({
    required this.id,
    required this.customer,
    required this.amount,
    required this.currency,
    required this.issueDate,
  });
}
