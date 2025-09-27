// supply_chain_model.dart
import 'package:yunusco_group/models/puchaseMasterModelFirebase.dart';


// Add to your approval_Supply_model.dart
class ProductSupplierSelection {
  final String productId;
  final String productName;
  final int requiredQty;
  final String unitName;
  final List<SupplierQuote> suppliers;
  String selectedSupplierId;

  ProductSupplierSelection({
    required this.productId,
    required this.productName,
    required this.requiredQty,
    required this.unitName,
    required this.suppliers,
    this.selectedSupplierId = '',
  }) {
    // Auto-select first supplier if available
    if (selectedSupplierId.isEmpty && suppliers.isNotEmpty) {
      selectedSupplierId = suppliers.first.supplierId;
    }
  }

  SupplierQuote? get selectedSupplier {
    return suppliers.firstWhere(
          (supplier) => supplier.supplierId == selectedSupplierId,
      orElse: () => suppliers.isNotEmpty ? suppliers.first : SupplierQuote(
        supplierId: '',
        supplierName: 'No Supplier',
        unitRate: 0,
      ),
    );
  }
}

class RequisitionSupplierSummary {
  final String reqId;
  final DateTime createdAt;
  final List<ProductSupplierSelection> productSelections;
  final String status;

  RequisitionSupplierSummary({
    required this.reqId,
    required this.createdAt,
    required this.productSelections,
    this.status = 'pending',
  });

  double get totalCost {
    return productSelections.fold(0.0, (sum, product) {
      final supplier = product.selectedSupplier;
      final subtotal = supplier!.unitRate * product.requiredQty;
      final taxAmount = subtotal * (supplier.taxRate / 100);
      final vatAmount = subtotal * (supplier.vatRate / 100);
      final discountAmount = subtotal * (supplier.discount / 100);
      return sum + subtotal + taxAmount + vatAmount +
          supplier.carryingCost + supplier.otherCost - discountAmount;
    });
  }
}

class ApprovedRequisition {
  final String reqId;
  final PuchaseMasterModelFirebase master;
  final List<RequisitionDetail> details;

  ApprovedRequisition({
    required this.reqId,
    required this.master,
    required this.details,
  });
}

class SupplierQuote {
  final String supplierId;
  final String supplierName;
  final double unitRate;
  final String warranty;
  final String taxType;
  final String vatType;
  final double taxRate;
  final double vatRate;
  final String currency;
  final int creditPeriodDays;
  final String payMode;
  final bool taxPayee;
  final bool vatPayee;
  final double carryingCost;
  final double otherCost;
  final double discount;
  final String comments;

  SupplierQuote({
    required this.supplierId,
    required this.supplierName,
    required this.unitRate,
    this.warranty = '',
    this.taxType = 'Local',
    this.vatType = 'Local',
    this.taxRate = 0.0,
    this.vatRate = 0.0,
    this.currency = 'BDT',
    this.creditPeriodDays = 0,
    this.payMode = 'Cash',
    this.taxPayee = false,
    this.vatPayee = false,
    this.carryingCost = 0.0,
    this.otherCost = 0.0,
    this.discount = 0.0,
    this.comments = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'supplierId': supplierId,
      'supplierName': supplierName,
      'unitRate': unitRate,
      'warranty': warranty,
      'taxType': taxType,
      'vatType': vatType,
      'taxRate': taxRate,
      'vatRate': vatRate,
      'currency': currency,
      'creditPeriodDays': creditPeriodDays,
      'payMode': payMode,
      'taxPayee': taxPayee,
      'vatPayee': vatPayee,
      'carryingCost': carryingCost,
      'otherCost': otherCost,
      'discount': discount,
      'comments': comments,
    };
  }

  factory SupplierQuote.fromMap(Map<String, dynamic> map) {
    return SupplierQuote(
      supplierId: map['supplierId'] ?? '',
      supplierName: map['supplierName'] ?? '',
      unitRate: (map['unitRate'] ?? 0.0).toDouble(),
      warranty: map['warranty'] ?? '',
      taxType: map['taxType'] ?? 'Local',
      vatType: map['vatType'] ?? 'Local',
      taxRate: (map['taxRate'] ?? 0.0).toDouble(),
      vatRate: (map['vatRate'] ?? 0.0).toDouble(),
      currency: map['currency'] ?? 'BDT',
      creditPeriodDays: map['creditPeriodDays'] ?? 0,
      payMode: map['payMode'] ?? 'Cash',
      taxPayee: map['taxPayee'] ?? false,
      vatPayee: map['vatPayee'] ?? false,
      carryingCost: (map['carryingCost'] ?? 0.0).toDouble(),
      otherCost: (map['otherCost'] ?? 0.0).toDouble(),
      discount: (map['discount'] ?? 0.0).toDouble(),
      comments: map['comments'] ?? '',
    );
  }
}

class SupplyChainRecord {
  final String id;
  final String reqId;
  final String productId;
  final String productName;
  final String unitName;
  final String requiredQty;
  final List<SupplierQuote> supplierQuotes;
  final DateTime createdAt;
  final String status; // pending, completed

  SupplyChainRecord({
    required this.id,
    required this.reqId,
    required this.productId,
    required this.productName,
    required this.unitName,
    required this.requiredQty,
    required this.supplierQuotes,
    required this.createdAt,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reqId': reqId,
      'productId': productId,
      'productName': productName,
      'unitName': unitName,
      'requiredQty': requiredQty,
      'supplierQuotes': supplierQuotes.map((quote) => quote.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  double calculateTotalCost(SupplierQuote quote) {
    double subtotal = quote.unitRate * int.parse(requiredQty);
    double taxAmount = subtotal * (quote.taxRate / 100);
    double vatAmount = subtotal * (quote.vatRate / 100);
    double discountAmount = subtotal * (quote.discount / 100);

    return subtotal + taxAmount + vatAmount + quote.carryingCost +
        quote.otherCost - discountAmount;
  }

  // Get the best quote (lowest total cost)
  SupplierQuote? get bestQuote {
    if (supplierQuotes.isEmpty) return null;

    supplierQuotes.sort((a, b) => calculateTotalCost(a).compareTo(calculateTotalCost(b)));
    return supplierQuotes.first;
  }

  factory SupplyChainRecord.fromMap(Map<String, dynamic> map) {
    return SupplyChainRecord(
      id: map['id'] ?? '',
      reqId: map['reqId'] ?? '',
      productId: map['productId'] ?? 0,
      productName: map['productName'] ?? '',
      unitName: map['unitName'] ?? '',
      requiredQty: map['requiredQty'] ?? 0,
      supplierQuotes: (map['supplierQuotes'] as List? ?? [])
          .map((quote) => SupplierQuote.fromMap(quote))
          .toList(),
      createdAt: DateTime.parse(map['createdAt']),
      status: map['status'] ?? 'pending',
    );
  }
}