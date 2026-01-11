import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../models/buyer_order_breakdown.dart';

class BuyerOrderBreakdownScreen extends ConsumerStatefulWidget {
  final List<BuyerOrderBreakdown> orderBreakdownList;

  const BuyerOrderBreakdownScreen({
    super.key,
    required this.orderBreakdownList,
  });

  @override
  ConsumerState<BuyerOrderBreakdownScreen> createState() => _BuyerOrderBreakdownScreenState();
}

class _BuyerOrderBreakdownScreenState extends ConsumerState<BuyerOrderBreakdownScreen> {
  List<BuyerOrderBreakdown> _filteredList = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredList = widget.orderBreakdownList;
  }

  void _filterOrders(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredList = widget.orderBreakdownList;
      } else {
        _filteredList = widget.orderBreakdownList.where((order) {
          return (order.orderCode?.toLowerCase().contains(_searchQuery) ?? false) ||
              (order.orderNumber?.toLowerCase().contains(_searchQuery) ?? false) ||
              (order.buyerPoNumber?.toLowerCase().contains(_searchQuery) ?? false) ||
              (order.style?.toLowerCase().contains(_searchQuery) ?? false) ||
              (order.itemName?.toLowerCase().contains(_searchQuery) ?? false) ||
              (order.colorName?.toLowerCase().contains(_searchQuery) ?? false) ||
              (order.masterOrderCode?.toLowerCase().contains(_searchQuery) ?? false);
        }).toList();
      }
    });
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Color _getStatusColor(BuyerOrderBreakdown order) {
    if (order.isPOClosed == true) {
      return Colors.red;
    } else if (order.balance != null && order.balance! <= 0) {
      return Colors.green;
    } else {
      return Colors.orange;
    }
  }

  String _getStatusText(BuyerOrderBreakdown order) {
    if (order.isPOClosed == true) {
      return 'PO Closed';
    } else if (order.balance != null && order.balance! <= 0) {
      return 'Completed';
    } else {
      return 'In Progress';
    }
  }

  Widget _buildOrderCard(BuyerOrderBreakdown order) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.itemName ?? 'No Item Name',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${order.style ?? 'No Style'} • ${order.colorName ?? 'No Color'}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _getStatusColor(order), width: 1),
                  ),
                  child: Text(
                    _getStatusText(order),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(order),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Order Information
            _buildInfoSection('Order Details', [
              _buildDetailRow('Order Number:', order.orderNumber ?? '-'),
              _buildDetailRow('PO Number:', order.buyerPoNumber ?? '-'),
              _buildDetailRow('Master Order:', order.masterOrderCode ?? '-'),
              _buildDetailRow('Order Code:', order.orderCode ?? '-'),
              _buildDetailRow('Style Reference:', order.styleReferance ?? '-'),
              _buildDetailRow('Sample No:', order.sampleNo ?? '-'),
            ]),

            const SizedBox(height: 16),

            // Item Information
            _buildInfoSection('Item Details', [
              _buildDetailRow('Item Size:', order.itemSize ?? '-'),
              _buildDetailRow('Size Name:', order.sizeName ?? '-'),
              _buildDetailRow('Pre Costing:', order.preCostingCode ?? '-'),
              _buildDetailRow('Color:', order.color ?? '-'),
            ]),

            const SizedBox(height: 16),

            // Dates Information
            _buildInfoSection('Dates', [
              _buildDetailRow('PO Receive:', _formatDate(order.poReceiveDate)),
              _buildDetailRow('Shipment:', _formatDate(order.shipmentDate)),
              _buildDetailRow('Fabric:', _formatDate(order.fabricDate)),
              _buildDetailRow('Sewing:', _formatDate(order.sewingDate)),
              _buildDetailRow('Inspection:', _formatDate(order.insDate)),
            ]),

            const SizedBox(height: 16),

            // Quantity & Price Grid
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  // Header
                  const Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Quantity',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Price',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Amount',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Values
                  Row(
                    children: [
                      // Quantity Column
                      Expanded(
                        child: Column(
                          children: [
                            _buildMetricItem('Order Qty', order.orderQty?.toString() ?? '-'),
                            _buildMetricItem('Quantity', order.quantity?.toString() ?? '-'),
                            _buildMetricItem('Balance', order.balance?.toString() ?? '-',
                                isBalance: true, balance: order.balance ?? 0),
                            if (order.extraAllowedQty != null && order.extraAllowedQty.toString().isNotEmpty)
                              _buildMetricItem('Extra Allowed', order.extraAllowedQty.toString()),
                            if (order.extraAllowedPercentage != null && order.extraAllowedPercentage.toString().isNotEmpty)
                              _buildMetricItem('Extra %', order.extraAllowedPercentage.toString()),
                          ],
                        ),
                      ),

                      // Price Column
                      Expanded(
                        child: Column(
                          children: [
                            _buildMetricItem('Basic Price', order.basicPrice?.toStringAsFixed(2) ?? '-'),
                            _buildMetricItem('Price', order.price?.toStringAsFixed(2) ?? '-'),
                          ],
                        ),
                      ),

                      // Amount Column
                      Expanded(
                        child: Column(
                          children: [
                            _buildMetricItem('Amount', order.amount?.toStringAsFixed(2) ?? '-'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Additional Info
            if (order.exportCountry != null || order.tnaid != null)
              _buildInfoSection('Additional Information', [
                if (order.exportCountry != null)
                  _buildDetailRow('Export Country:', order.exportCountry.toString()),
                if (order.tnaid != null)
                  _buildDetailRow('TNA ID:', order.tnaid.toString()),
                if (order.id != null)
                  _buildDetailRow('ID:', order.id.toString()),
                if (order.version != null)
                  _buildDetailRow('Version:', order.version.toString()),
              ]),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, {bool isBalance = false, num balance = 0}) {
    Color valueColor = Colors.blueGrey;
    if (isBalance) {
      if (balance > 0) {
        valueColor = Colors.orange;
      } else if (balance < 0) {
        valueColor = Colors.red;
      } else {
        valueColor = Colors.green;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalQuantity = _filteredList.fold<num>(0, (sum, order) => sum + (order.quantity ?? 0));
    final totalAmount = _filteredList.fold<num>(0, (sum, order) => sum + (order.amount ?? 0));
    final totalBalance = _filteredList.fold<num>(0, (sum, order) => sum + (order.balance ?? 0));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        title: const Text(
          'Order Breakdown',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterOrders,
                decoration: InputDecoration(
                  hintText: 'Search orders...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      _filterOrders('');
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
          ),

          // Summary Stats
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              border: Border(
                top: BorderSide(color: Colors.blue[100]!),
                bottom: BorderSide(color: Colors.blue[100]!),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(Icons.list_alt, 'Items', _filteredList.length.toString()),
                _buildStatItem(Icons.inventory, 'Total Qty', totalQuantity.toString()),
                _buildStatItem(Icons.account_balance_wallet, 'Total Amount', totalAmount.toStringAsFixed(2)),
                _buildStatItem(Icons.balance, 'Balance', totalBalance.toString()),
              ],
            ),
          ),

          // Results Counter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Showing ${_filteredList.length} of ${widget.orderBreakdownList.length} items',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (_searchQuery.isNotEmpty)
                  Chip(
                    label: Text('Search: "$_searchQuery"'),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {
                      _searchController.clear();
                      _filterOrders('');
                    },
                  ),
              ],
            ),
          ),

          // Orders List
          Expanded(
            child: _filteredList.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _searchQuery.isEmpty ? Icons.inventory : Icons.search_off,
                    size: 72,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _searchQuery.isEmpty
                        ? 'No orders found'
                        : 'No results for "$_searchQuery"',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    const SizedBox(height: 8),
                  if (_searchQuery.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        _searchController.clear();
                        _filterOrders('');
                      },
                      child: const Text('Clear search'),
                    ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: _filteredList.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(_filteredList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF1976D2)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1976D2),
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
}