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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v){
      getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Buyer Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
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
          // Navigate to order details screen
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

  void _showFilterDialog(BuildContext context) {
    // final provider = context.read<BuyerOrderProvider>();
    // String? selectedStatus;
    //
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return StatefulBuilder(
    //       builder: (context, setState) {
    //         return AlertDialog(
    //           title: const Text('Filter Orders'),
    //           content: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               DropdownButtonFormField<String>(
    //                 value: selectedStatus,
    //                 items: [
    //                   'All',
    //                   'Approved',
    //                   'Pending',
    //                   'Rejected',
    //                 ].map((status) {
    //                   return DropdownMenuItem(
    //                     value: status,
    //                     child: Text(status),
    //                   );
    //                 }).toList(),
    //                 onChanged: (value) {
    //                   setState(() {
    //                     selectedStatus = value;
    //                   });
    //                 },
    //                 decoration: const InputDecoration(
    //                   labelText: 'Approval Status',
    //                 ),
    //               ),
    //               const SizedBox(height: 16),
    //               // Add more filters as needed
    //             ],
    //           ),
    //           actions: [
    //             TextButton(
    //               onPressed: () {
    //                 Navigator.pop(context);
    //               },
    //               child: const Text('Cancel'),
    //             ),
    //             TextButton(
    //               onPressed: () {
    //                 provider.filterOrders(selectedStatus);
    //                 Navigator.pop(context);
    //               },
    //               child: const Text('Apply'),
    //             ),
    //           ],
    //         );
    //       },
    //     );
    //   },
    // );
  }

  void getData() async{
    var mp=context.read<MerchandisingProvider>();
    mp.setLoading(true);
    await mp.getAllBuyerOrders();
    mp.setLoading(false);
  }
}



