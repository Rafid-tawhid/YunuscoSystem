// comparative_statement_model.dart
class ComparativeStatement {
  final String code;
  final int productId;
  final String createdDate;
  final String storeType;
  final String typeName;
  final String productCategoryName;
  final String userName;
  final String currencyName;
  final double cRate;
  final String purchaseType;
  final String productName;
  final String uomName;
  final String? brandName;
  final String purchaseRequisitionCode;
  final double cStock;
  final double lastPurQty;
  final double lastPurRate;
  final String lastPurDate;
  final String supplierFirst;
  final String supplierSecond;
  final String supplierThird;
  final String supplierFour;
  final String vatFirst;
  final String vatSecond;
  final String vatThird;
  final String vatFour;
  final String taxFirst;
  final String taxSecond;
  final String taxThird;
  final String taxFour;
  final double rateFirst;
  final double rateSecond;
  final double rateThird;
  final double rateFour;
  final double csQty;
  final double mtFirst;
  final double mtSecond;
  final double mtThird;
  final double mtFour;
  final String warrantyFirst;
  final String warrantySecond;
  final String warrantyThird;
  final String warrantyFour;
  final String creditPeriod;
  final String payMode;
  final String vatType;
  final String taxType;

  // Selection state
  String selectedSupplierPosition; // 'First', 'Second', 'Third', 'Four'

  ComparativeStatement({
    required this.code,
    required this.productId,
    required this.createdDate,
    required this.storeType,
    required this.typeName,
    required this.productCategoryName,
    required this.userName,
    required this.currencyName,
    required this.cRate,
    required this.purchaseType,
    required this.productName,
    required this.uomName,
    this.brandName,
    required this.purchaseRequisitionCode,
    required this.cStock,
    required this.lastPurQty,
    required this.lastPurRate,
    required this.lastPurDate,
    required this.supplierFirst,
    required this.supplierSecond,
    required this.supplierThird,
    required this.supplierFour,
    required this.vatFirst,
    required this.vatSecond,
    required this.vatThird,
    required this.vatFour,
    required this.taxFirst,
    required this.taxSecond,
    required this.taxThird,
    required this.taxFour,
    required this.rateFirst,
    required this.rateSecond,
    required this.rateThird,
    required this.rateFour,
    required this.csQty,
    required this.mtFirst,
    required this.mtSecond,
    required this.mtThird,
    required this.mtFour,
    required this.warrantyFirst,
    required this.warrantySecond,
    required this.warrantyThird,
    required this.warrantyFour,
    required this.creditPeriod,
    required this.payMode,
    required this.vatType,
    required this.taxType,
    this.selectedSupplierPosition = 'First', // Default to first supplier
  });

  factory ComparativeStatement.fromJson(Map<String, dynamic> json) {
    return ComparativeStatement(
      code: json['Code'] ?? '',
      productId: json['ProductId'] ?? 0,
      createdDate: json['CreatedDate'] ?? '',
      storeType: json['StoreType'] ?? '',
      typeName: json['TypeName'] ?? '',
      productCategoryName: json['ProductCategoryName'] ?? '',
      userName: json['UserName'] ?? '',
      currencyName: json['CurrencyName'] ?? '',
      cRate: (json['CRate'] ?? 0.0).toDouble(),
      purchaseType: json['PurchaseType'] ?? '',
      productName: json['ProductName'] ?? '',
      uomName: json['UomName'] ?? '',
      brandName: json['BrandName'],
      purchaseRequisitionCode: json['PurchaseRequisitionCode'] ?? '',
      cStock: (json['CStock'] ?? 0.0).toDouble(),
      lastPurQty: (json['LastPurQty'] ?? 0.0).toDouble(),
      lastPurRate: (json['LastPurRate'] ?? 0.0).toDouble(),
      lastPurDate: json['LastPurDate'] ?? '',
      supplierFirst: json['SupplierFirst'] ?? '',
      supplierSecond: json['SupplierSecond'] ?? '',
      supplierThird: json['SupplierThird'] ?? '',
      supplierFour: json['SupplierFour'] ?? '',
      vatFirst: json['VatFirst'] ?? '',
      vatSecond: json['VatSecond'] ?? '',
      vatThird: json['VatThird'] ?? '',
      vatFour: json['VatFour'] ?? '',
      taxFirst: json['TaxFirst'] ?? '',
      taxSecond: json['TaxSecond'] ?? '',
      taxThird: json['TaxThird'] ?? '',
      taxFour: json['TaxFour'] ?? '',
      rateFirst: (json['RateFirst'] ?? 0.0).toDouble(),
      rateSecond: (json['RateSecond'] ?? 0.0).toDouble(),
      rateThird: (json['RateThird'] ?? 0.0).toDouble(),
      rateFour: (json['RateFour'] ?? 0.0).toDouble(),
      csQty: (json['CsQty'] ?? 0.0).toDouble(),
      mtFirst: (json['MTFirst'] ?? 0.0).toDouble(),
      mtSecond: (json['MTSecond'] ?? 0.0).toDouble(),
      mtThird: (json['MTThird'] ?? 0.0).toDouble(),
      mtFour: (json['MTFour'] ?? 0.0).toDouble(),
      warrantyFirst: json['WarrantyFirst'] ?? '',
      warrantySecond: json['WarrantySecond'] ?? '',
      warrantyThird: json['WarrantyThird'] ?? '',
      warrantyFour: json['WarrantyFour'] ?? '',
      creditPeriod: json['CreditPeriod'] ?? '',
      payMode: json['PayMode'] ?? '',
      vatType: json['VatType'] ?? '',
      taxType: json['TaxType'] ?? '',
    );
  }

  // Get available suppliers (non-empty)
  List<Map<String, dynamic>> get availableSuppliers {
    List<Map<String, dynamic>> suppliers = [];

    if (supplierFirst.isNotEmpty && rateFirst > 0) {
      suppliers.add({
        'position': 'First',
        'name': supplierFirst,
        'rate': rateFirst,
        'total': mtFirst,
        'warranty': warrantyFirst,
        'vat': vatFirst,
        'tax': taxFirst,
      });
    }

    if (supplierSecond.isNotEmpty && rateSecond > 0) {
      suppliers.add({
        'position': 'Second',
        'name': supplierSecond,
        'rate': rateSecond,
        'total': mtSecond,
        'warranty': warrantySecond,
        'vat': vatSecond,
        'tax': taxSecond,
      });
    }

    if (supplierThird.isNotEmpty && rateThird > 0) {
      suppliers.add({
        'position': 'Third',
        'name': supplierThird,
        'rate': rateThird,
        'total': mtThird,
        'warranty': warrantyThird,
        'vat': vatThird,
        'tax': taxThird,
      });
    }

    if (supplierFour.isNotEmpty && rateFour > 0) {
      suppliers.add({
        'position': 'Four',
        'name': supplierFour,
        'rate': rateFour,
        'total': mtFour,
        'warranty': warrantyFour,
        'vat': vatFour,
        'tax': taxFour,
      });
    }

    return suppliers;
  }

  // Get selected supplier details
  Map<String, dynamic>? get selectedSupplier {
    return availableSuppliers.firstWhere(
          (supplier) => supplier['position'] == selectedSupplierPosition,
      orElse: () => availableSuppliers.isNotEmpty ? availableSuppliers.first : {},
    );
  }

  // Get selected supplier rate
  double get selectedRate {
    switch (selectedSupplierPosition) {
      case 'First': return rateFirst;
      case 'Second': return rateSecond;
      case 'Third': return rateThird;
      case 'Four': return rateFour;
      default: return rateFirst;
    }
  }

  // Get selected supplier total
  double get selectedTotal {
    switch (selectedSupplierPosition) {
      case 'First': return mtFirst;
      case 'Second': return mtSecond;
      case 'Third': return mtThird;
      case 'Four': return mtFour;
      default: return mtFirst;
    }
  }

  // Convert to JSON with only selected supplier data
  Map<String, dynamic> toSelectedJson() {
    final selected = selectedSupplier;
    if (selected == null) return {};

    return {
      'Code': code,
      'ProductId': productId,
      'CreatedDate': createdDate,
      'StoreType': storeType,
      'TypeName': typeName,
      'ProductCategoryName': productCategoryName,
      'UserName': userName,
      'CurrencyName': currencyName,
      'CRate': cRate,
      'PurchaseType': purchaseType,
      'ProductName': productName,
      'UomName': uomName,
      'BrandName': brandName,
      'PurchaseRequisitionCode': purchaseRequisitionCode,
      'CStock': cStock,
      'LastPurQty': lastPurQty,
      'LastPurRate': lastPurRate,
      'LastPurDate': lastPurDate,
      'SupplierFirst': selected['position'] == 'First' ? supplierFirst : '',
      'SupplierSecond': selected['position'] == 'Second' ? supplierSecond : '',
      'SupplierThird': selected['position'] == 'Third' ? supplierThird : '',
      'SupplierFour': selected['position'] == 'Four' ? supplierFour : '',
      'VatFirst': selected['position'] == 'First' ? vatFirst : '',
      'VatSecond': selected['position'] == 'Second' ? vatSecond : '',
      'VatThird': selected['position'] == 'Third' ? vatThird : '',
      'VatFour': selected['position'] == 'Four' ? vatFour : '',
      'TaxFirst': selected['position'] == 'First' ? taxFirst : '',
      'TaxSecond': selected['position'] == 'Second' ? taxSecond : '',
      'TaxThird': selected['position'] == 'Third' ? taxThird : '',
      'TaxFour': selected['position'] == 'Four' ? taxFour : '',
      'RateFirst': selected['position'] == 'First' ? rateFirst : 0.0,
      'RateSecond': selected['position'] == 'Second' ? rateSecond : 0.0,
      'RateThird': selected['position'] == 'Third' ? rateThird : 0.0,
      'RateFour': selected['position'] == 'Four' ? rateFour : 0.0,
      'CsQty': csQty,
      'MTFirst': selected['position'] == 'First' ? mtFirst : 0.0,
      'MTSecond': selected['position'] == 'Second' ? mtSecond : 0.0,
      'MTThird': selected['position'] == 'Third' ? mtThird : 0.0,
      'MTFour': selected['position'] == 'Four' ? mtFour : 0.0,
      'WarrantyFirst': selected['position'] == 'First' ? warrantyFirst : '',
      'WarrantySecond': selected['position'] == 'Second' ? warrantySecond : '',
      'WarrantyThird': selected['position'] == 'Third' ? warrantyThird : '',
      'WarrantyFour': selected['position'] == 'Four' ? warrantyFour : '',
      'CreditPeriod': creditPeriod,
      'PayMode': payMode,
      'VatType': vatType,
      'TaxType': taxType,
      'SelectedSupplierPosition': selectedSupplierPosition,
      'SelectedSupplierName': selected['name'],
      'SelectedRate': selected['rate'],
      'SelectedTotal': selected['total'],
    };
  }
}