import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/product_provider.dart';

import '../../models/master_lc_model.dart';

class MasterLCListScreen extends StatefulWidget {
  const MasterLCListScreen({super.key});

  @override
  State<MasterLCListScreen> createState() => _MasterLCListScreenState();
}

class _MasterLCListScreenState extends State<MasterLCListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final provider = context.read<ProductProvider>();
    await provider.getMasterLcData('', _currentPage, _pageSize);
  }

  Future<void> _loadMoreData() async {
    debugPrint('This is calling.. ');
    _currentPage++;
    setState(() {
      _isLoading = true;
    });

    final provider = context.read<ProductProvider>();
    final success = await provider.getMasterLcData(
        _searchController.text,
        _currentPage,
        _pageSize
    );

    setState(() {
      _isLoading = false;
    });
  }
  Future<void> _loadPrevious() async {

    _currentPage--;
    setState(() {
      _isLoading = true;
    });

    final provider = context.read<ProductProvider>();
    final success = await provider.getMasterLcData(
        _searchController.text,
        _currentPage,
        _pageSize
    );

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshData() async {
    _currentPage = 1;
    await _loadInitialData();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreData();
    }
  }

  Future<void> _searchData() async {
    _currentPage = 1;
    final provider = context.read<ProductProvider>();
    await provider.getMasterLcData(_searchController.text, _currentPage, _pageSize);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final items = provider.masterLcList;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Master LC List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: items.isEmpty && !_isLoading
                  ? const Center(child: Text('No LC items found'))
                  : ListView.builder(
                controller: _scrollController,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  if (index >= items.length) {
                    return _buildLoader();
                  }
                  return _buildLcItem(items[index]);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 8),
            child: Row(
              children: [
                ElevatedButton(onPressed: _loadPrevious, child: Text('Previous')),
                Expanded(child: Text('Page: ${_currentPage}',textAlign: TextAlign.center,)),
                ElevatedButton(onPressed:  _loadMoreData, child: Text('Next')),
              ],
            ),
          ),
          SizedBox(height: 12,)
        ],
      ),
    );
  }

  Widget _buildLcItem(MasterLcModel item) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(item.masterLCNo ?? 'No LC Number'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.buyerName ?? 'No Buyer'),
            const SizedBox(height: 4),
            Text('Amount: ${NumberFormat.currency(symbol: '\$').format(item.masterLCAmount)}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item.eXIMStatus ?? 'No Status'),
            const SizedBox(height: 4),
            Text(DateFormat('MMM dd, yyyy').format(
                DateTime.parse(item.issueDateStr ?? DateTime.now().toString()))),
          ],
        ),
        onTap: () => _showLcDetails(item),
      ),
    );
  }

  Widget _buildLoader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: const CircularProgressIndicator()

      ),
    );
  }

  void _showLcDetails(MasterLcModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.masterLCNo ?? 'LC Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Buyer', item.buyerName),
              _buildDetailRow('Amount', NumberFormat.currency(symbol: '\$').format(item.masterLCAmount)),
              _buildDetailRow('Status', item.eXIMStatus),
              _buildDetailRow('Issue Date', item.issueDateStr),
              _buildDetailRow('Expiry Date', item.expiryDateStr),
              if (item.remark != null) _buildDetailRow('Remarks', item.remark),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value ?? 'N/A')),
        ],
      ),
    );
  }
}