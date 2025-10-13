class ComparativeStatementNew {
  final String code;
  final String productName;
  final String currencyName;
  final String creditPeriod;
  final String payMode;
  final String purchaseRequisitionCode;
  final String csDate;
  final String userName;
  final String purchaseType;
  final String productCategoryName;
  final String uomName;
  final String? brandName;
  final String storeType;
  final String lastPurQty;
  final String lastPurRate;
  final String lastPurDate;
  final String csQty;
  final List<SupplierData> suppliers;

  String? selectedSupplierName;

  ComparativeStatementNew({
    required this.code,
    required this.productName,
    required this.currencyName,
    required this.creditPeriod,
    required this.payMode,
    required this.purchaseRequisitionCode,
    required this.csDate,
    required this.userName,
    required this.purchaseType,
    required this.productCategoryName,
    required this.uomName,
    this.brandName,
    required this.storeType,
    required this.lastPurQty,
    required this.lastPurRate,
    required this.lastPurDate,
    required this.csQty,
    required this.suppliers,
    this.selectedSupplierName,
  });

  factory ComparativeStatementNew.fromJson(Map<String, dynamic> json) {
    return ComparativeStatementNew(
      code: json['Code'] ?? '',
      productName: json['ProductName'] ?? '',
      currencyName: json['CurrencyName'] ?? '',
      creditPeriod: json['CreditPeriod'] ?? '',
      payMode: json['PayMode'] ?? '',
      purchaseRequisitionCode: json['PurchaseRequisitionCode'] ?? '',
      csDate: json['CSDate'] ?? '',
      userName: json['UserName'] ?? '',
      purchaseType: json['PurchaseType'] ?? '',
      productCategoryName: json['ProductCategoryName'] ?? '',
      uomName: json['UomName'] ?? '',
      brandName: json['BrandName'],
      storeType: json['StoreType'] ?? '',
      lastPurQty: json['LastPurQty'] ?? '',
      lastPurRate: json['LastPurRate'] ?? '',
      lastPurDate: json['LastPurDate'] ?? '',
      csQty: json['CsQty'] ?? '',
      suppliers: [
        SupplierData(
          name: json['SupplierName'] ?? '',
          rate: json['Rate'] ?? '',
          csg: json['CSG'] ?? '',
          discount: json['Discount'] ?? '',
          tax: json['Tax'] ?? '',
          vat: json['Vat'] ?? '',
          caringCost: json['CaringCost'] ?? '',
          inTax: json['InTax'] ?? '',
          inVat: json['InVat'] ?? '',
          oldRate: json['OldRate'] ?? '',
          adiRate: json['AdiRate'] ?? '',
          fcRate: json['FcRate'] ?? '',
          mgRate: json['MgRate'] ?? '',
          comment: json['Comment'] ?? '',
          adComment: json['AdComment'] ?? '',
          fcComment: json['FcComment'] ?? '',
          mgComment: json['MgComment'] ?? '',
          mtf: json['MTF'] ?? '',
          mgt: json['MGT'] ?? '',
          v: json['V'] ?? '',
          t: json['T'] ?? '',
          gateCost: json['GateCost'] ?? '',
          warranty: json['Warranty'] ?? '',
          taxP: json['TaxP'] ?? '',
          vatP: json['VatP'] ?? '',
        )
      ],
    );
  }

  double get selectedTotal {
    if (selectedSupplierName == null) return 0.0;
    final supplier = suppliers.firstWhere(
          (s) => s.name == selectedSupplierName,
      orElse: () => suppliers.first,
    );
    final rate = double.tryParse(supplier.rate) ?? 0.0;
    final qty = double.tryParse(csQty) ?? 0.0;
    return rate * qty;
  }

  SupplierData? get selectedSupplier {
    if (selectedSupplierName == null) return null;
    return suppliers.firstWhere(
          (s) => s.name == selectedSupplierName,
      orElse: () => suppliers.first,
    );
  }

  Map<String, dynamic> toSelectedJson() {
    final supplier = selectedSupplier ?? suppliers.first;
    final total = (double.tryParse(supplier.rate) ?? 0) * (double.tryParse(csQty) ?? 0);

    return {
      'ProductName': productName,
      'CurrencyName': currencyName,
      'ProductCategoryName': productCategoryName,
      'UomName': uomName,
      'CsQty': csQty,
      'SelectedSupplierName': selectedSupplierName ?? supplier.name,
      'SelectedRate': double.tryParse(supplier.rate) ?? 0,
      'SelectedTotal': total,
      'CreditPeriod': creditPeriod,
      'PayMode': payMode,
      'Warranty': supplier.warranty,
    };
  }
}

class SupplierData {
  final String name;
  final String rate;
  final String csg;
  final String discount;
  final String tax;
  final String vat;
  final String caringCost;
  final String inTax;
  final String inVat;
  final String oldRate;
  final String adiRate;
  final String fcRate;
  final String mgRate;
  final String comment;
  final String adComment;
  final String fcComment;
  final String mgComment;
  final String mtf;
  final String mgt;
  final String v;
  final String t;
  final String gateCost;
  final String warranty;
  final String taxP;
  final String vatP;

  SupplierData({
    required this.name,
    required this.rate,
    required this.csg,
    required this.discount,
    required this.tax,
    required this.vat,
    required this.caringCost,
    required this.inTax,
    required this.inVat,
    required this.oldRate,
    required this.adiRate,
    required this.fcRate,
    required this.mgRate,
    required this.comment,
    required this.adComment,
    required this.fcComment,
    required this.mgComment,
    required this.mtf,
    required this.mgt,
    required this.v,
    required this.t,
    required this.gateCost,
    required this.warranty,
    required this.taxP,
    required this.vatP,
  });
}