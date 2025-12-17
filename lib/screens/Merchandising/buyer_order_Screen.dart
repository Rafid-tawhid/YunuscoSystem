import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/utils/constants.dart';
import '../../models/buyer_order_details_model.dart';
import '../../providers/merchandising_provider.dart';
import '../../utils/colors.dart';

class BuyerOrderScreen extends StatefulWidget {
  const BuyerOrderScreen({super.key});

  @override
  State<BuyerOrderScreen> createState() => _BuyerOrderScreenState();
}

class _BuyerOrderScreenState extends State<BuyerOrderScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final provider = context.read<MerchandisingProvider>();
    await provider.getAllBuyerOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: _buildAppBar(context),
      body: Consumer<MerchandisingProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.allBuyerOrderList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Orders Found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start by creating a new buyer order',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          final orders = _isSearching && _searchController.text.isNotEmpty
              ? provider.allBuyerOrderList
              .where((order) =>
          (order.buyerName ?? '')
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
              (order.merMasterBuyerOrder?.orderNumber ?? '')
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              (order.merMasterBuyerOrder?.masterOrderCode ?? '')
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
              .toList()
              : provider.allBuyerOrderList;

          if (orders.isEmpty) {
            return Center(
              child: Text(
                'No results found for "${_searchController.text}"',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return _buildOrderCard(order);
            },
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: myColors.primaryColor,
      foregroundColor: Colors.white,
      title: _isSearching
          ? TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Search orders...',
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(Icons.search, color: Colors.white),
        ),
        style: const TextStyle(color: Colors.white, fontSize: 16),
        onChanged: (_) => setState(() {}),
      )
          : Row(
        children: [
          const Icon(Icons.inventory_2_outlined),
          const SizedBox(width: 8),
          const Text('Buyer Orders'),
          const Spacer(),
          Consumer<MerchandisingProvider>(
            builder: (context, provider, child) {
              return Text(
                '${provider.allBuyerOrderList.length} Orders',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ],
      ),
      actions: [
        if (!_isSearching)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
          ),
        if (_isSearching)
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                _isSearching = false;
                _searchController.clear();
              });
            },
          ),
        if (!_isSearching)
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadData();
            },
          ),
      ],
    );
  }

  Widget _buildOrderCard(BuyerOrderDetailsModel order) {
    final merOrder = order.merMasterBuyerOrder;
    final isLocked = merOrder?.isLock == true;
    final isSubmitted = merOrder?.submit == true;

    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to order details screen
          // Navigator.push(context, MaterialPageRoute(
          //   builder: (context) => BuyerOrderDetailScreen(order: order),
          // ));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with order code and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          merOrder?.masterOrderCode ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.buyerName ?? 'No Buyer Name',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildStatusChip(merOrder?.approvalStatus),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (isLocked)
                            Icon(
                              Icons.lock,
                              size: 16,
                              color: Colors.orange[700],
                            ),
                          if (isSubmitted)
                            Icon(
                              Icons.send,
                              size: 16,
                              color: Colors.green[700],
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Order Details
              _buildDetailRow(
                icon: Icons.numbers,
                label: 'Order Number',
                value: merOrder?.orderNumber ?? 'N/A',
              ),
              _buildDetailRow(
                icon: Icons.date_range,
                label: 'Order Date',
                value: _formatDate(merOrder?.orderDate),
              ),
              _buildDetailRow(
                icon: Icons.person,
                label: 'Submitted To',
                value: merOrder?.submitToName ?? 'N/A',
              ),
              _buildDetailRow(
                icon: Icons.category,
                label: 'Order Type',
                value: _getOrderType(merOrder?.orderType),
              ),
              _buildDetailRow(
                icon: Icons.attach_money,
                label: 'LC Value',
                value: merOrder?.lcvalue != null
                    ? '\$${merOrder!.lcvalue!.toStringAsFixed(2)}'
                    : 'N/A',
              ),
              _buildDetailRow(
                icon: Icons.confirmation_number,
                label: 'LC Number',
                value: merOrder?.mlcnumber ?? 'N/A',
              ),
              _buildDetailRow(
                icon: Icons.safety_check,
                label: 'Season',
                value: merOrder?.season?.toString() ?? 'N/A',
              ),
              _buildDetailRow(
                icon: Icons.flag,
                label: 'Export Country',
                value: merOrder?.exportCountry?.toString() ?? 'N/A',
              ),

              const SizedBox(height: 16),

              // Buyer Info Section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Creator Information',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildBuyerInfoRow('Name', order.fullName),
                    _buildBuyerInfoRow('Designation', order.designationName),
                    _buildBuyerInfoRow('Department', order.departmentName),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // View full details
                        //BuyerOrderBreakdown
                        var provider = context.read<MerchandisingProvider>();
                       // provider.getAllBuyerOrderDetails(order.);
                      },
                      icon: const Icon(Icons.visibility, size: 16),
                      label: const Text('View Details'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        side: const BorderSide(color: Colors.blue),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (merOrder?.approvalStatus?.toLowerCase() == 'pending')
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Approve action
                        },
                        icon: const Icon(Icons.check, size: 16),
                        label: const Text('Approve'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String? status) {
    final statusText = status?.toLowerCase() ?? 'unknown';
    Color color;
    Color textColor;

    switch (statusText) {
      case 'approved':
        color = Colors.green[100]!;
        textColor = Colors.green[800]!;
        break;
      case 'pending':
        color = Colors.orange[100]!;
        textColor = Colors.orange[800]!;
        break;
      case 'rejected':
        color = Colors.red[100]!;
        textColor = Colors.red[800]!;
        break;
      case 'submitted':
        color = Colors.blue[100]!;
        textColor = Colors.blue[800]!;
        break;
      default:
        color = Colors.grey[200]!;
        textColor = Colors.grey[800]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status?.toUpperCase() ?? 'UNKNOWN',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyerInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  String _getOrderType(num? orderType) {
    if (orderType == null) return 'N/A';
    switch (orderType) {
      case 1:
        return 'Regular';
      case 2:
        return 'Sample';
      case 3:
        return 'Development';
      default:
        return 'Unknown';
    }
  }

  String _getQuantityType(String? qtyType) {
    if (qtyType == null) return 'N/A';
    switch (qtyType.toLowerCase()) {
      case 'pcs':
        return 'Pieces';
      case 'kg':
        return 'Kilograms';
      case 'm':
        return 'Meters';
      default:
        return qtyType;
    }
  }
}