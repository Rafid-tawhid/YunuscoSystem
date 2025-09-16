// screens/purchase_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yunusco_group/providers/riverpods/purchase_order_riverpod.dart';

import '../../models/purchase_order_model.dart';

class PurchaseScreen2 extends ConsumerWidget {
  const PurchaseScreen2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(currentPageProvider);
    final purchaseAsync = ref.watch(purchaseProvider(currentPage));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Orders'),
        actions: [
          // Previous page button
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: currentPage > 1
                ? () => ref.read(currentPageProvider.notifier).state--
                : null,
          ),

          // Current page indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Text(
                'Page $currentPage',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),

          // Next page button
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => ref.read(currentPageProvider.notifier).state++,
          ),

          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(purchaseProvider(currentPage)),
          ),
        ],
      ),
      body: purchaseAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(purchaseProvider(currentPage)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (purchases) => _buildPurchaseList(purchases, currentPage),
      ),
    );
  }

  Widget _buildPurchaseList(List<PurchaseOrderModel> purchases, int currentPage) {
    if (purchases.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inventory_2, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No purchase orders found on page $currentPage',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: purchases.length,
      itemBuilder: (context, index) => _buildPurchaseItem(purchases[index]),
    );
  }

  Widget _buildPurchaseItem(PurchaseOrderModel purchase) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Code and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  purchase.purchaseOrderCode ?? 'No Code',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: purchase.isConfirmed == true
                        ? Colors.green.withOpacity(0.2)
                        : Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    purchase.isConfirmed == true ? 'Confirmed' : 'Pending',
                    style: TextStyle(
                      color: purchase.isConfirmed == true
                          ? Colors.green[800]
                          : Colors.orange[800],
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Supplier Info
            if (purchase.supplierName != null)
              Row(
                children: [
                  const Icon(Icons.business, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      purchase.supplierName!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 8),

            // Order Date
            if (purchase.orderDate != null)
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    purchase.orderDate!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}