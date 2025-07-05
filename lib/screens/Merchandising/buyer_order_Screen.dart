import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import 'package:yunusco_group/screens/Merchandising/buyer_order_details.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((v) {
      getData();
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: Consumer<MerchandisingProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.allBuyerOrderList.isEmpty) {
                  return const Center(child: Text('No orders found'));
                }
                return ListView.builder(
                  itemCount: provider.allBuyerOrderList.length,
                  itemBuilder: (context, index) {
                    final order = provider.allBuyerOrderList[index];
                    return _buildOrderCard(context, order);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: _isSearching
          ? TextField(
        controller: _searchController,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Search orders...',
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.black),
        ),
        style: const TextStyle(color: Colors.black),
        onChanged: (value) {
          context.read<MerchandisingProvider>().searchOrders(value);
        },
      )
          : const Text('Buyer Orders'),
      actions: [
        _isSearching
            ? IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchController.clear();
              context.read<MerchandisingProvider>().searchOrders('');
            });
          },
        )
            : IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        ),
      ],
    );
  }



  Widget _buildOrderCard(BuildContext context, BuyerOrderDetailsModel order) {
    final isPending = order.finalStatus?.toLowerCase() == 'pending';
    final isExpanded = ValueNotifier<bool>(false);

    return ValueListenableBuilder<bool>(
      valueListenable: isExpanded,
      builder: (context, expanded, _) {
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: InkWell(
            onTap: () => isExpanded.value = !expanded,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // Compact Header (Always visible)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.masterOrderCode ?? 'No Code',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            order.buyerName ?? 'No Buyer',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      Chip(
                        label: Text(order.finalStatus ?? 'N/A'),
                        backgroundColor: _getStatusColor(order.finalStatus),
                      ),
                    ],
                  ),

                  // Expandable Details
                  if (expanded) ...[
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),

                    _buildDetailRow('Style', order.styleName),
                    _buildDetailRow('Category', order.catagoryName),
                    _buildDetailRow('Quantity', '${order.totalOrderQty}'),
                    _buildDetailRow('Total Value', '\$ ${order.totalValue}'),
                    _buildDetailRow('Created', _formatDate(order.createdDate)),

                    const SizedBox(height: 12),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            // View details action
                          },
                          child:  Text('VIEW',style: customTextStyle(14, myColors.grey, FontWeight.w600),),
                        ),
                        if (isPending) ...[
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              // Reject action
                            },
                            child:  Text('REJECT',style: customTextStyle(14,Colors.white, FontWeight.w600),),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            onPressed: () {
                              // Accept action
                            },
                            child:  Text('ACCEPT',style: customTextStyle(14,Colors.white, FontWeight.w600),),
                          ),

                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

// Helper Widgets
  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value ?? 'N/A'),
        ],
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null) return 'N/A';
    try {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(date));
    } catch (e) {
      return 'Invalid Date';
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved': return Colors.green[100]!;
      case 'pending': return Colors.orange[100]!;
      case 'rejected': return Colors.red[100]!;
      default: return Colors.grey[200]!;
    }
  }

// Helper function for status colors

  void getData() async {
    var mp = context.read<MerchandisingProvider>();
    mp.setLoading(true);
    await mp.getAllBuyerOrders();
    mp.setLoading(false);
  }
}



