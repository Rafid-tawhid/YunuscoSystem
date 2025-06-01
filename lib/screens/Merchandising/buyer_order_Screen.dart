import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import 'package:yunusco_group/screens/Merchandising/buyer_order_details.dart';

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
    final statusColor = _getStatusColor(order.approvalStatus);
    final formattedDate = DateFormat('dd MMM yyyy').format(
      DateTime.parse(order.orderDate ?? DateTime.now().toString()),
    );

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => BuyerOrderDetailsScreen(order: order),
          //   ),
          // );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.masterOrderCode ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Chip(
                  //   label: Text(
                  //     order.approvalStatus ?? 'N/A',
                  //     style: const TextStyle(color: Colors.white),
                  //   ),
                  //   backgroundColor: statusColor,
                  // ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Buyer: ${order.buyer ?? 'N/A'}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Order Date: $formattedDate',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Qty Type: ${order.qtyType ?? 'N/A'}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  if (order.isLock ?? false)
                    const Icon(Icons.lock, color: Colors.orange),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void getData() async {
    var mp = context.read<MerchandisingProvider>();
    mp.setLoading(true);
    await mp.getAllBuyerOrders();
    mp.setLoading(false);
  }
}



