// providers/purchase_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../models/purchase_order_model.dart';
import '../../service_class/api_services.dart';

// Family provider that accepts page number as parameter
final purchaseProvider = FutureProvider.family<List<PurchaseOrderModel>, int>((ref, pageNumber) async {
  final apiService = ref.read(apiServiceProvider);
  const pageSize = 50; // Fixed page size as requested

  try {
    final data = await apiService.getData3(
      'api/Inventory/PurchaseOrderList?pageNumber=$pageNumber&pageSize=$pageSize',
    );

    if (data != null && data['Data'] != null) {
      final items = (data['Data']['Items'] as List)
          .map((i) => PurchaseOrderModel.fromJson(i))
          .toList();

      return items;
    }
    return [];
  } catch (e) {
    throw Exception('Failed to load purchase orders: $e');
  }
});

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

// Provider to track current page
final currentPageProvider = StateProvider<int>((ref) => 1);