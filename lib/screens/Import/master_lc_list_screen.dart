import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/product_provider.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../models/master_lc_model.dart';
import 'lc_details_screen.dart';

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
  bool _isSearching = false;
  Timer? _debounce;

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
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final provider = context.read<ProductProvider>();
    await provider.getMasterLcData('', _currentPage, _pageSize);
  }

  Future<void> _loadMoreData() async {
    if (_isLoading) return;

    _currentPage++;
    setState(() {
      _isLoading = true;
    });

    final provider = context.read<ProductProvider>();
    await provider.getMasterLcData(
      _searchController.text,
      _currentPage,
      _pageSize,
    );

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadPrevious() async {
    if (_currentPage <= 1 || _isLoading) return;

    _currentPage--;
    setState(() {
      _isLoading = true;
    });

    final provider = context.read<ProductProvider>();
    await provider.getMasterLcData(
      _searchController.text,
      _currentPage,
      _pageSize,
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
    await provider.getMasterLcData(
        _searchController.text, _currentPage, _pageSize);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final items = provider.masterLcList;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search Master LC...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) => _onSearchChanged(),
                onSubmitted: (value) {
                  _searchData();
                  setState(() => _isSearching = false);
                },
              )
            : const Text('Master LC List'),
        actions: [
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() => _isSearching = true);
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                  _searchData();
                });
              },
            ),
        ],
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
                      itemCount: items.length + (_isLoading ? 1 : 0),
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
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
            child: Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: myColors.primaryColor,
                    foregroundColor: Colors.white
                  ),
                  onPressed: _loadPrevious,
                  child: const Text('Previous'),
                ),
                //
                Expanded(
                  child: Text(
                    'Page: $_currentPage',
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton(
                  onPressed: _loadMoreData,
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
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
            Text(
                'Amount: ${NumberFormat.currency(symbol: '\$').format(item.masterLCAmount)}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item.eXIMStatus ?? 'No Status'),
            const SizedBox(height: 4),
            Text(DateFormat('MMM dd, yyyy').format(DateTime.parse(
                item.issueDateStr ?? DateTime.now().toString()))),
          ],
        ),
        onTap: () async {
          var pp = context.read<ProductProvider>();
          if (await pp.getLcDetails(item.masterLCId)) {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) =>
                        LCDetailScreen(lcData: pp.lcDetailsData)));
          }
        },
      ),
    );
  }

  Widget _buildLoader() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: CircularProgressIndicator(),
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
