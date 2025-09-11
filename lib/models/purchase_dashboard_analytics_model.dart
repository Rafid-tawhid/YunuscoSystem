class PurchaseAnalyticsResponse {
  final List<MonthlyPurchase> currentYearMonthlyPurchases;
  final YearlyGrandTotal yearlyGrandTotal;
  final List<TopProduct> topProducts;
  final ProductGrandTotal productGrandTotal;
  final List<TopSupplier> topSuppliers;
  final SupplierGrandTotal supplierGrandTotal;

  PurchaseAnalyticsResponse({
    required this.currentYearMonthlyPurchases,
    required this.yearlyGrandTotal,
    required this.topProducts,
    required this.productGrandTotal,
    required this.topSuppliers,
    required this.supplierGrandTotal,
  });

  factory PurchaseAnalyticsResponse.fromJson(Map<String, dynamic> json) {
    return PurchaseAnalyticsResponse(
      currentYearMonthlyPurchases: (json['CurrentYearMonthlyPurchases'] as List)
          .map((item) => MonthlyPurchase.fromJson(item))
          .toList(),
      yearlyGrandTotal: YearlyGrandTotal.fromJson(json['YearlyGrandTotal']),
      topProducts: (json['TopProducts'] as List)
          .map((item) => TopProduct.fromJson(item))
          .toList(),
      productGrandTotal: ProductGrandTotal.fromJson(json['ProductGrandTotal']),
      topSuppliers: (json['TopSuppliers'] as List)
          .map((item) => TopSupplier.fromJson(item))
          .toList(),
      supplierGrandTotal: SupplierGrandTotal.fromJson(json['SupplierGrandTotal']),
    );
  }
}

class MonthlyPurchase {
  final String monthName;
  final int monthNumber;
  final String purchaseYear;
  final double totalPurchase;

  MonthlyPurchase({
    required this.monthName,
    required this.monthNumber,
    required this.purchaseYear,
    required this.totalPurchase,
  });

  factory MonthlyPurchase.fromJson(Map<String, dynamic> json) {
    return MonthlyPurchase(
      monthName: json['MonthName'],
      monthNumber: json['MonthNumber'],
      purchaseYear: json['PurchaseYear'],
      totalPurchase: (json['TotalPurchase'] is double)
          ? json['TotalPurchase']
          : double.parse(json['TotalPurchase'].toString()),
    );
  }
}

class YearlyGrandTotal {
  final double grandTotalPurchase;

  YearlyGrandTotal({
    required this.grandTotalPurchase,
  });

  factory YearlyGrandTotal.fromJson(Map<String, dynamic> json) {
    return YearlyGrandTotal(
      grandTotalPurchase: (json['GrandTotalPurchase'] is double)
          ? json['GrandTotalPurchase']
          : double.parse(json['GrandTotalPurchase'].toString()),
    );
  }
}

class TopProduct {
  final String monthName;
  final String productName;
  final int purOrderQty;
  final double totalPurchase;

  TopProduct({
    required this.monthName,
    required this.productName,
    required this.purOrderQty,
    required this.totalPurchase,
  });

  factory TopProduct.fromJson(Map<String, dynamic> json) {
    return TopProduct(
      monthName: json['MonthName'],
      productName: json['ProductName'],
      purOrderQty: json['PurOrderQty'],
      totalPurchase: (json['TotalPurchase'] is double)
          ? json['TotalPurchase']
          : double.parse(json['TotalPurchase'].toString()),
    );
  }
}

class ProductGrandTotal {
  final double grandTotalPurchase;

  ProductGrandTotal({
    required this.grandTotalPurchase,
  });

  factory ProductGrandTotal.fromJson(Map<String, dynamic> json) {
    return ProductGrandTotal(
      grandTotalPurchase: (json['GrandTotalPurchase'] is double)
          ? json['GrandTotalPurchase']
          : double.parse(json['GrandTotalPurchase'].toString()),
    );
  }
}

class TopSupplier {
  final String monthName;
  final String supplierName;
  final int purOrderQty;
  final double totalPurchase;

  TopSupplier({
    required this.monthName,
    required this.supplierName,
    required this.purOrderQty,
    required this.totalPurchase,
  });

  factory TopSupplier.fromJson(Map<String, dynamic> json) {
    return TopSupplier(
      monthName: json['MonthName'],
      supplierName: json['SupplierName'],
      purOrderQty: json['PurOrderQty'],
      totalPurchase: (json['TotalPurchase'] is double)
          ? json['TotalPurchase']
          : double.parse(json['TotalPurchase'].toString()),
    );
  }
}

class SupplierGrandTotal {
  final double grandTotalPurchase;

  SupplierGrandTotal({
    required this.grandTotalPurchase,
  });

  factory SupplierGrandTotal.fromJson(Map<String, dynamic> json) {
    return SupplierGrandTotal(
      grandTotalPurchase: (json['GrandTotalPurchase'] is double)
          ? json['GrandTotalPurchase']
          : double.parse(json['GrandTotalPurchase'].toString()),
    );
  }
}