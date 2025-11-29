// screens/mis_assets_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../models/mis_asset_model.dart';
import '../../providers/riverpods/production_provider.dart';

class MisAssetsScreen extends ConsumerWidget {
  const MisAssetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAssets = ref.watch(filteredMisAssetsProvider);
    final searchQuery = ref.watch(misAssetSearchQueryProvider);
    final assetsAsync = ref.watch(allMisAssetsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('MIS Assets'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search Bar
          MisAssetSearchBar(
            searchQuery: searchQuery,
            onSearchChanged: (value) {
              ref.read(misAssetSearchQueryProvider.notifier).state = value;
            },
          ),

          // Results count and loading/error states
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: assetsAsync.when(
              loading: () => const Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Loading assets...'),
                ],
              ),
              error: (error, stack) => Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Error: ${error.toString()}',
                      style: const TextStyle(color: Colors.red),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              data: (data) => Row(
                children: [
                  Text(
                    'Found ${filteredAssets.length} assets',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (searchQuery.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Chip(
                      label: Text(searchQuery),
                      onDeleted: () {
                        ref.read(misAssetSearchQueryProvider.notifier).state = '';
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Assets List
          Expanded(
            child: assetsAsync.when(
              loading: () => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading MIS assets...'),
                  ],
                ),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load assets',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(allMisAssetsProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (data) {
                if (filteredAssets.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          searchQuery.isNotEmpty ? Icons.search_off : Icons.inventory_2_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          searchQuery.isNotEmpty ? 'No assets found' : 'No assets available',
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          searchQuery.isNotEmpty
                              ? 'Try searching with different keywords'
                              : 'There are no MIS assets to display',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        if (searchQuery.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              ref.read(misAssetSearchQueryProvider.notifier).state = '';
                            },
                            child: const Text('Clear Search'),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(allMisAssetsProvider);
                  },
                  child: ListView.builder(
                    itemCount: filteredAssets.length,
                    itemBuilder: (context, index) {
                      return MisAssetCard(asset: filteredAssets[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.invalidate(allMisAssetsProvider),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}




// widgets/search_bar.dart

class MisAssetSearchBar extends StatefulWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;

  const MisAssetSearchBar({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
  });

  @override
  State<MisAssetSearchBar> createState() => _MisAssetSearchBarState();
}

class _MisAssetSearchBarState extends State<MisAssetSearchBar> {
  late TextEditingController _controller;
  bool _isControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchQuery);
    _isControllerInitialized = true;
  }

  @override
  void didUpdateWidget(MisAssetSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only update controller if the searchQuery changed from outside (like clear button)
    if (oldWidget.searchQuery != widget.searchQuery &&
        _controller.text != widget.searchQuery) {
      _controller.text = widget.searchQuery;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Search by Employee Name, ID, or Asset No...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          suffixIcon: widget.searchQuery.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
              widget.onSearchChanged('');
            },
          )
              : null,
        ),
        onChanged: (value) {
          // Only call onSearchChanged if the controller is properly initialized
          if (_isControllerInitialized) {
            widget.onSearchChanged(value);
          }
        },
      ),
    );
  }
}


class MisAssetCard extends StatelessWidget {
  final MisAssetModel asset;

  const MisAssetCard({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with Asset No and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  asset.assetNo ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(asset.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    asset.status ?? 'Unknown',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Employee Information
            _buildInfoRow('Employee', asset.employeeName),
            _buildInfoRow('Employee ID', asset.employeeIdcardNo),
            _buildInfoRow('Department', asset.department),
            _buildInfoRow('Designation', asset.designation),

            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),

            // Asset Details
            _buildInfoRow('Asset Type', asset.assetType),
            _buildInfoRow('Host Name', asset.hostName),
            _buildInfoRow('IP Address', asset.ipAddress),
            _buildInfoRow('Manufacturer', asset.manufacturer),
            _buildInfoRow('Model', asset.model),

            const SizedBox(height: 8),

            // Technical Details in a row
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                if (asset.processor != null)
                  _buildChip('Processor', asset.processor!),
                if (asset.ram != null)
                  _buildChip('RAM', asset.ram!),
                if (asset.hdd != null)
                  _buildChip('HDD', asset.hdd!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 12,
          color: Colors.blue[800],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      case 'maintenance':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}