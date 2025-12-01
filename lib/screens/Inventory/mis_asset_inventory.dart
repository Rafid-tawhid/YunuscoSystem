// screens/mis_assets_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:yunusco_group/utils/constants.dart';

import '../../models/mis_asset_model.dart';
import '../../providers/riverpods/production_provider.dart';
import 'mis_asset_entry.dart';

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
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, CupertinoPageRoute(builder: (context)=>MisAssetInventoryScreen()));
          }, icon: Icon(Icons.add)),
          IconButton(onPressed: (){
            ref.invalidate(allMisAssetsProvider);
          }, icon: Icon(Icons.refresh)),
        ],
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
      child: InkWell(
        onTap: () => _showAssetDetails(context),
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

              // Minimal essential info
              _buildInfoRow('Employee', asset.employeeName),
              _buildInfoRow('Department', asset.department),
              _buildInfoRow('Asset Type', asset.assetType),

              const SizedBox(height: 8),

              // Technical summary chips
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (asset.processor != null)
                    _buildMiniChip('CPU', asset.processor!),
                  if (asset.ram != null)
                    _buildMiniChip('RAM', asset.ram!),
                  if (asset.hdd != null)
                    _buildMiniChip('HDD', asset.hdd!),
                ],
              ),

              const SizedBox(height: 8),

              // Hint for tap
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Tap for details →',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAssetDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      asset.assetNo ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 20,
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
              ),

              const SizedBox(height: 16),

              // Photo gallery if available
             // if (_hasPhotos())
                _buildPhotoSection(),

              const SizedBox(height: 16),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Employee Information
                      _buildSectionTitle('Employee Information'),
                      _buildDetailRow('Employee Name', asset.employeeName),
                      _buildDetailRow('Employee ID', asset.employeeIdcardNo),
                      _buildDetailRow('Department', asset.department),
                      _buildDetailRow('Section', asset.section),
                      _buildDetailRow('Designation', asset.designation),
                      _buildDetailRow('Location', asset.location),
                      _buildDetailRow('Business Unit', asset.businessUnitName),

                      const SizedBox(height: 16),
                      _buildSectionDivider(),

                      // Asset Details
                      _buildSectionTitle('Asset Details'),
                      _buildDetailRow('Asset Type', asset.assetType),
                      _buildDetailRow('Host Name', asset.hostName),
                      _buildDetailRow('IP Address', asset.ipAddress),
                      _buildDetailRow('IP Address 2', asset.ipAddress2),
                      _buildDetailRow('IA Group', asset.iaGroup),
                      _buildDetailRow('AD Name', asset.adName),
                      _buildDetailRow('Unit', asset.unit),
                      _buildDetailRow('Serial No/MAC', asset.serialNoOrMac),

                      const SizedBox(height: 16),
                      _buildSectionDivider(),

                      // Hardware Details
                      _buildSectionTitle('Hardware Details'),
                      _buildDetailRow('Manufacturer', asset.manufacturer),
                      _buildDetailRow('Model', asset.model),
                      _buildDetailRow('Motherboard', asset.mBoard),
                      _buildDetailRow('Processor', asset.processor),
                      _buildDetailRow('Processor Gen', asset.processorGeneration),
                      _buildDetailRow('RAM', asset.ram),
                      _buildDetailRow('HDD', asset.hdd),
                      _buildDetailRow('Speed', asset.speed),

                      const SizedBox(height: 16),
                      _buildSectionDivider(),

                      // Software Details
                      _buildSectionTitle('Software Details'),
                      _buildDetailRow('Installed OS', asset.installedOs),
                      _buildDetailRow('OS License', asset.licenseOs),
                      _buildDetailRow('OS Serial No', asset.serialNoOfOs),
                      _buildDetailRow('Antivirus License', asset.antivirusLicense),
                      _buildDetailRow('Office License', asset.officeLicense),
                      _buildDetailRow('Installed Software', asset.installedSoftware),
                      _buildDetailRow('Removed Software', asset.removedSoftware),

                      const SizedBox(height: 16),
                      _buildSectionDivider(),

                      // Purchase & Warranty
                      _buildSectionTitle('Purchase & Warranty'),
                      _buildDetailRow('Purchase Date', asset.dateOfPurchase),
                      _buildDetailRow('Purchase Price', asset.purchasePrice?.toString()),
                      _buildDetailRow('Supplier', asset.supplier),
                      _buildDetailRow('Warranty', asset.warranty),

                      const SizedBox(height: 16),
                      _buildSectionDivider(),

                      // Additional Info
                      _buildSectionTitle('Additional Information'),
                      _buildDetailRow('Transfer Date', asset.transferDate?.toString()),
                      _buildDetailRow('Remarks', asset.remarks),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
         // if (asset.frontPhotoPath != null && asset.frontPhotoPath!.isNotEmpty)
            _buildPhotoItem('Front',asset, asset.frontPhotoPath??''),
         // if (asset.backPhotoPath != null && asset.backPhotoPath!.isNotEmpty)
            _buildPhotoItem('Back',asset, asset.backPhotoPath??''),
         // if (asset.keyPhotoPath != null && asset.keyPhotoPath!.isNotEmpty)
            _buildPhotoItem('Key',asset, asset.keyPhotoPath??''),
         // if (asset.screenPhotoPath != null && asset.screenPhotoPath!.isNotEmpty)
            _buildPhotoItem('Screen',asset, asset.screenPhotoPath??''),
        ],
      ),
    );
  }

  Widget _buildPhotoItem(String label,MisAssetModel data, String path) {
    // debugPrint('IMAGES: http://202.74.243.118:1726/api/inventoryapiGetMisAssedPhoto?AssetDetailId=${asset.assetDetailID}&fileName=$path');
    return GestureDetector(
      onTap: (){
        debugPrint('http://202.74.243.118:1726/api/inventoryapi/GetMisAssedPhoto?AssetDetailId=${asset.assetDetailID}&fileName=$path');
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  'http://202.74.243.118:1726/api/inventoryapi/GetMisAssedPhoto?AssetDetailId=${asset.assetDetailID}&fileName=$path',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.photo, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasPhotos() {
    return (asset.frontPhotoPath != null && asset.frontPhotoPath!.isNotEmpty) ||
        (asset.backPhotoPath != null && asset.backPhotoPath!.isNotEmpty) ||
        (asset.keyPhotoPath != null && asset.keyPhotoPath!.isNotEmpty) ||
        (asset.screenPhotoPath != null && asset.screenPhotoPath!.isNotEmpty);
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildSectionDivider() {
    return Divider(color: Colors.grey[300]);
  }

  Widget _buildDetailRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ),
        ],
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
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 10,
          color: Colors.blue[800],
          fontWeight: FontWeight.w500,
        ),
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