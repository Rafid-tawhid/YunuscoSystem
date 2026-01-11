import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../models/accessories_req_details.dart';
import '../../providers/riverpods/inventory_provider.dart';

class AccessoriesReqDetailsScreen extends StatelessWidget {
  final String id;

  const AccessoriesReqDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Accessories Details'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final detailsAsync = ref.watch(accessoriesReqDetailsListProvider(id));

          return detailsAsync.when(
            data: (detailsList) {
              if (detailsList.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No details found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              // Get first item for header info (assuming all items share same header data)
              final firstItem = detailsList.first;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Header Card
                    _HeaderCard(item: firstItem),
                    // Summary Statistics
                  //  _SummaryCard(detailsList: detailsList),
                    // Items List
                    _ItemsList(detailsList: detailsList),
                  ],
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stackTrace) => Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 20),
                    const Text(
                      'Failed to load details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(accessoriesReqDetailsListProvider(id)),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final AccessoriesReqDetails item;

  const _HeaderCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.issueCode ?? 'No Issue Code',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (item.slipNo != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Slip: ${item.slipNo}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),

            _buildInfoRow('Requisition Code', item.requisitionCode),
            _buildInfoRow('Date', _formatDate(item.issueDate)),
            _buildInfoRow('Issued By', item.issuedBy),

            if (item.clientName != null && item.clientName!.isNotEmpty)
              _buildInfoRow('Client', item.clientName),

            if (item.poCode != null && item.poCode!.isNotEmpty)
              _buildInfoRow('PO Code', item.poCode),

            if (item.challanNo != null && item.challanNo!.isNotEmpty)
              _buildInfoRow('Challan No', item.challanNo),

            if (item.jobNo != null && item.jobNo!.isNotEmpty)
              _buildInfoRow('Job No', item.jobNo),

            if (item.batchNo != null && item.batchNo!.isNotEmpty)
              _buildInfoRow('Batch No', item.batchNo),

            // if (item.remarks != null && item.remarks!.isNotEmpty) ...[
            //   const SizedBox(height: 8),
            //   const Text(
            //     'Remarks:',
            //     style: TextStyle(
            //       fontSize: 14,
            //       fontWeight: FontWeight.w500,
            //       color: Colors.grey,
            //     ),
            //   ),
            //   const SizedBox(height: 4),
            //   Text(
            //     item.remarks!,
            //     style: const TextStyle(fontSize: 14),
            //   ),
            // ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';

    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}

class _ItemsList extends StatelessWidget {
  final List<AccessoriesReqDetails> detailsList;

  const _ItemsList({required this.detailsList});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: detailsList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = detailsList[index];
        return _ItemCard(item: item, index: index + 1);
      },
    );
  }
}

class _ItemCard extends StatelessWidget {
  final AccessoriesReqDetails item;
  final int index;

  const _ItemCard({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    final totalValue = (item.quantity ?? 0) * (item.price ?? 0);

    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${index}. ${item.productName ?? 'Unknown Product'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (item.materialType != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getMaterialColor(item.materialType!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.materialType!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Quantity and Price Row
            Row(
              children: [
                Expanded(
                  child: _buildItemDetail('Quantity', '${item.quantity ?? 0} ${item.unitName ?? ''}'),
                ),
                if (item.reqQty != null && item.reqQty! > 0)
                  Expanded(
                    child: _buildItemDetail('Req Qty', '${item.reqQty} ${item.unitName ?? ''}'),
                  ),
                if (item.price != null && item.price! > 0)
                  Expanded(
                    child: _buildItemDetail('Price', item.price!.toStringAsFixed(2)),
                  ),
              ],
            ),

            if (item.stockBalance != null)
              Row(
                children: [
                  Expanded(
                    child: _buildItemDetail('Stock Balance', item.stockBalance!.toStringAsFixed(0)),
                  ),
                  if (item.altStockBalance != null)
                    Expanded(
                      child: _buildItemDetail('Alt Balance', item.altStockBalance!.toStringAsFixed(0)),
                    ),
                ],
              ),

            if (totalValue > 0) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade100),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Value:',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      totalValue.toStringAsFixed(2),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Additional Info
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (item.binCode != null && item.binCode!.isNotEmpty)
                  _buildInfoChip(Icons.location_on, 'Bin: ${item.binCode}'),
                if (item.baseUnit != null && item.baseUnit!.isNotEmpty)
                  _buildInfoChip(Icons.square_foot, 'Base: ${item.baseUnit}'),
                if (item.alterUnit != null && item.alterUnit.toString().isNotEmpty)
                  _buildInfoChip(Icons.sync_alt, 'Alt: ${item.alterUnit}'),
                if (item.clientName != null && item.clientName!.isNotEmpty)
                  _buildInfoChip(Icons.business, item.clientName!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Chip(
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      label: Text(
        text,
        style: const TextStyle(fontSize: 11),
      ),
      avatar: Icon(icon, size: 14),
      visualDensity: VisualDensity.compact,
      backgroundColor: Colors.grey.shade100,
    );
  }

  Color _getMaterialColor(String materialType) {
    switch (materialType.toLowerCase()) {
      case 'raw':
        return Colors.orange;
      case 'finished':
        return Colors.green;
      case 'semi-finished':
        return Colors.blue;
      case 'component':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}