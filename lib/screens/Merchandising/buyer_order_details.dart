import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/merchandising_provider.dart';

import '../../models/buyer_order_details_model.dart';

class BuyerOrderDetailsScreen extends StatefulWidget {
  final String buyerId;

  const BuyerOrderDetailsScreen({super.key,required this.buyerId});

  @override
  State<BuyerOrderDetailsScreen> createState() => _BuyerOrderDetailsModelState();
}

class _BuyerOrderDetailsModelState extends State<BuyerOrderDetailsScreen> {


  @override
  void initState() {
    var mp=context.read<MerchandisingProvider>();
    mp.getBuyerOrdersDetails(widget.buyerId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Consumer<MerchandisingProvider>(
          builder: (context,pro,_)=>pro.buyerOrderDetailsList.isEmpty?Center(child: Text('No Data Found.'),):
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pro.buyerOrderDetailsList.length,
            itemBuilder: (context, index) {
              final order = pro.buyerOrderDetailsList[index];
              return _buildOrderCard(order, context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuyerOrderDetails order, BuildContext context) {
    final progress = (order.inQty ?? 0) / (order.orderQuantity ?? 1);

    return Card(
      elevation: 4,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    order.productName ?? 'Unknown Product',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
                Chip(
                  backgroundColor: Colors.blue.shade100,
                  label: Text(
                    order.spoReference ?? 'N/A',
                    style: TextStyle(color: Colors.blue.shade800),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 8),

            // Order Info Row
            _buildInfoRow(
              context,
              Icons.calendar_today,
              'Order Date',
              _formatDate(order.orderDate),
            ),
            const SizedBox(height: 8),

            _buildInfoRow(
              context,
              Icons.delivery_dining,
              'Expected Delivery',
              _formatDate(order.expectedDeliveryDate),
            ),
            const SizedBox(height: 8),

            _buildInfoRow(
              context,
              Icons.scale,
              'Unit',
              order.unit ?? 'N/A',
            ),
            const SizedBox(height: 16),

            // Quantity Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quantity:',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${order.inQty?.toStringAsFixed(0) ?? '0'} / ${order.orderQuantity?.toStringAsFixed(0) ?? '0'}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),

            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade300,
              color: progress >= 1
                  ? Colors.green
                  : progress >= 0.75
                  ? Colors.blue
                  : progress >= 0.5
                  ? Colors.orange
                  : Colors.red,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${(progress * 100).toStringAsFixed(1)}% completed',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue.shade600),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }

  }
}
