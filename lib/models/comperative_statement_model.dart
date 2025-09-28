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
  final double oldRateFirst;
  final double oldRateSecond;
  final double oldRateThird;
  final double oldRateFour;
  final double rateFirst;
  final double rateSecond;
  final double rateThird;
  final double rateFour;
  final double adiRateFirst;
  final double adiRateSecond;
  final double adiRateThird;
  final double adiRateFour;
  final double fcRateFirst;
  final double fcRateSecond;
  final double fcRateThird;
  final double fcRateFour;
  final double mgRateFirst;
  final double mgRateSecond;
  final double mgRateThird;
  final double mgRateFour;
  final String commentFirst;
  final String commentSecond;
  final String commentThird;
  final String commentFour;
  final String adCommentFirst;
  final String adCommentSecond;
  final String adCommentThird;
  final String adCommentFour;
  final String fcCommentFirst;
  final String fcCommentSecond;
  final String fcCommentThird;
  final String fcCommentFour;
  final String mgCommentFirst;
  final String mgCommentSecond;
  final String mgCommentThird;
  final String mgCommentFour;
  final String mrFirst;
  final String mrSecond;
  final String mrThird;
  final String mrFour;
  final double csQty;
  final double mtFirst;
  final double mtSecond;
  final double mtThird;
  final double mtFour;
  final double mgtFirst;
  final double mgtSecond;
  final double mgtThird;
  final double mgtFour;
  final double vFirst;
  final double vSecond;
  final double vThird;
  final double vFour;
  final double tFirst;
  final double tSecond;
  final double tThird;
  final double tFour;
  final double discountFirst;
  final double discountSecond;
  final double discountThird;
  final double discountFour;
  final String caringCostFirst;
  final String caringCostSecond;
  final String caringCostThird;
  final String caringCostFour;
  final String gateCostFirst;
  final String gateCostSecond;
  final String gateCostThird;
  final String gateCostFour;
  final String warrantyFirst;
  final String warrantySecond;
  final String warrantyThird;
  final String warrantyFour;
  final String creditPeriod;
  final String payMode;
  final String vatType;
  final String taxType;
  final double taxPFirst;
  final double taxPSecond;
  final double taxPThird;
  final double taxPFour;
  final double vatPFirst;
  final double vatPSecond;
  final double vatPThird;
  final double vatPFour;
  final double csgtFirst;
  final double csgtSecond;
  final double csgtThird;
  final double csgtFour;
  final double dfValue;
  final double dsValue;
  final double dtValue;
  final double dFoValue;
  final String inTax1;
  final String inTax2;
  final String inTax3;
  final String inTax4;
  final String inVat1;
  final String inVat2;
  final String inVat3;
  final String inVat4;

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
    required this.oldRateFirst,
    required this.oldRateSecond,
    required this.oldRateThird,
    required this.oldRateFour,
    required this.rateFirst,
    required this.rateSecond,
    required this.rateThird,
    required this.rateFour,
    required this.adiRateFirst,
    required this.adiRateSecond,
    required this.adiRateThird,
    required this.adiRateFour,
    required this.fcRateFirst,
    required this.fcRateSecond,
    required this.fcRateThird,
    required this.fcRateFour,
    required this.mgRateFirst,
    required this.mgRateSecond,
    required this.mgRateThird,
    required this.mgRateFour,
    required this.commentFirst,
    required this.commentSecond,
    required this.commentThird,
    required this.commentFour,
    required this.adCommentFirst,
    required this.adCommentSecond,
    required this.adCommentThird,
    required this.adCommentFour,
    required this.fcCommentFirst,
    required this.fcCommentSecond,
    required this.fcCommentThird,
    required this.fcCommentFour,
    required this.mgCommentFirst,
    required this.mgCommentSecond,
    required this.mgCommentThird,
    required this.mgCommentFour,
    required this.mrFirst,
    required this.mrSecond,
    required this.mrThird,
    required this.mrFour,
    required this.csQty,
    required this.mtFirst,
    required this.mtSecond,
    required this.mtThird,
    required this.mtFour,
    required this.mgtFirst,
    required this.mgtSecond,
    required this.mgtThird,
    required this.mgtFour,
    required this.vFirst,
    required this.vSecond,
    required this.vThird,
    required this.vFour,
    required this.tFirst,
    required this.tSecond,
    required this.tThird,
    required this.tFour,
    required this.discountFirst,
    required this.discountSecond,
    required this.discountThird,
    required this.discountFour,
    required this.caringCostFirst,
    required this.caringCostSecond,
    required this.caringCostThird,
    required this.caringCostFour,
    required this.gateCostFirst,
    required this.gateCostSecond,
    required this.gateCostThird,
    required this.gateCostFour,
    required this.warrantyFirst,
    required this.warrantySecond,
    required this.warrantyThird,
    required this.warrantyFour,
    required this.creditPeriod,
    required this.payMode,
    required this.vatType,
    required this.taxType,
    required this.taxPFirst,
    required this.taxPSecond,
    required this.taxPThird,
    required this.taxPFour,
    required this.vatPFirst,
    required this.vatPSecond,
    required this.vatPThird,
    required this.vatPFour,
    required this.csgtFirst,
    required this.csgtSecond,
    required this.csgtThird,
    required this.csgtFour,
    required this.dfValue,
    required this.dsValue,
    required this.dtValue,
    required this.dFoValue,
    required this.inTax1,
    required this.inTax2,
    required this.inTax3,
    required this.inTax4,
    required this.inVat1,
    required this.inVat2,
    required this.inVat3,
    required this.inVat4,
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
      oldRateFirst: (json['OldRateFirst'] ?? 0.0).toDouble(),
      oldRateSecond: (json['OldRateSecond'] ?? 0.0).toDouble(),
      oldRateThird: (json['OldRateThird'] ?? 0.0).toDouble(),
      oldRateFour: (json['OldRateFour'] ?? 0.0).toDouble(),
      rateFirst: (json['RateFirst'] ?? 0.0).toDouble(),
      rateSecond: (json['RateSecond'] ?? 0.0).toDouble(),
      rateThird: (json['RateThird'] ?? 0.0).toDouble(),
      rateFour: (json['RateFour'] ?? 0.0).toDouble(),
      adiRateFirst: (json['AdiRateFirst'] ?? 0.0).toDouble(),
      adiRateSecond: (json['AdiRateSecond'] ?? 0.0).toDouble(),
      adiRateThird: (json['AdiRateThird'] ?? 0.0).toDouble(),
      adiRateFour: (json['AdiRateFour'] ?? 0.0).toDouble(),
      fcRateFirst: (json['FcRateFirst'] ?? 0.0).toDouble(),
      fcRateSecond: (json['FcRateSecond'] ?? 0.0).toDouble(),
      fcRateThird: (json['FcRateThird'] ?? 0.0).toDouble(),
      fcRateFour: (json['FcRateFour'] ?? 0.0).toDouble(),
      mgRateFirst: (json['MgRateFirst'] ?? 0.0).toDouble(),
      mgRateSecond: (json['MgRateSecond'] ?? 0.0).toDouble(),
      mgRateThird: (json['MgRateThird'] ?? 0.0).toDouble(),
      mgRateFour: (json['MgRateFour'] ?? 0.0).toDouble(),
      commentFirst: json['CommentFirst'] ?? '',
      commentSecond: json['CommentSecond'] ?? '',
      commentThird: json['CommentThird'] ?? '',
      commentFour: json['CommentFour'] ?? '',
      adCommentFirst: json['AdCommentFirst'] ?? '',
      adCommentSecond: json['AdCommentSecond'] ?? '',
      adCommentThird: json['AdCommentThird'] ?? '',
      adCommentFour: json['AdCommentFour'] ?? '',
      fcCommentFirst: json['FcCommentFirst'] ?? '',
      fcCommentSecond: json['FcCommentSecond'] ?? '',
      fcCommentThird: json['FcCommentThird'] ?? '',
      fcCommentFour: json['FcCommentFourth'] ?? '',
      mgCommentFirst: json['MgCommentFirst'] ?? '',
      mgCommentSecond: json['MgCommentSecond'] ?? '',
      mgCommentThird: json['MgCommentThird'] ?? '',
      mgCommentFour: json['MgCommentFour'] ?? '',
      mrFirst: json['MRFirst'] ?? '',
      mrSecond: json['MRSecond'] ?? '',
      mrThird: json['MRThird'] ?? '',
      mrFour: json['MRFour'] ?? '',
      csQty: (json['CsQty'] ?? 0.0).toDouble(),
      mtFirst: (json['MTFirst'] ?? 0.0).toDouble(),
      mtSecond: (json['MTSecond'] ?? 0.0).toDouble(),
      mtThird: (json['MTThird'] ?? 0.0).toDouble(),
      mtFour: (json['MTFour'] ?? 0.0).toDouble(),
      mgtFirst: (json['MGTFirst'] ?? 0.0).toDouble(),
      mgtSecond: (json['MGTSecond'] ?? 0.0).toDouble(),
      mgtThird: (json['MGTThird'] ?? 0.0).toDouble(),
      mgtFour: (json['MGTFour'] ?? 0.0).toDouble(),
      vFirst: (json['VFirst'] ?? 0.0).toDouble(),
      vSecond: (json['VSecond'] ?? 0.0).toDouble(),
      vThird: (json['VTThird'] ?? 0.0).toDouble(),
      vFour: (json['VFour'] ?? 0.0).toDouble(),
      tFirst: (json['TFirst'] ?? 0.0).toDouble(),
      tSecond: (json['TSecond'] ?? 0.0).toDouble(),
      tThird: (json['TTThird'] ?? 0.0).toDouble(),
      tFour: (json['TFour'] ?? 0.0).toDouble(),
      discountFirst: (json['DiscountFirst'] ?? 0.0).toDouble(),
      discountSecond: (json['DiscountSecond'] ?? 0.0).toDouble(),
      discountThird: (json['DiscountThird'] ?? 0.0).toDouble(),
      discountFour: (json['DiscountFour'] ?? 0.0).toDouble(),
      caringCostFirst: json['CaringCostFirst'] ?? '',
      caringCostSecond: json['CaringCostSecond'] ?? '',
      caringCostThird: json['CaringCostThird'] ?? '',
      caringCostFour: json['CaringCostFour'] ?? '',
      gateCostFirst: json['GateCostFirst'] ?? '',
      gateCostSecond: json['GateCostSecond'] ?? '',
      gateCostThird: json['GateCostThird'] ?? '',
      gateCostFour: json['GateCostFour'] ?? '',
      warrantyFirst: json['WarrantyFirst'] ?? '',
      warrantySecond: json['WarrantySecond'] ?? '',
      warrantyThird: json['WarrantyThird'] ?? '',
      warrantyFour: json['WarrantyFour'] ?? '',
      creditPeriod: json['CreditPeriod'] ?? '',
      payMode: json['PayMode'] ?? '',
      vatType: json['VatType'] ?? '',
      taxType: json['TaxType'] ?? '',
      taxPFirst: (json['TaxPFirst'] ?? 0.0).toDouble(),
      taxPSecond: (json['TaxPSecond'] ?? 0.0).toDouble(),
      taxPThird: (json['TaxPThird'] ?? 0.0).toDouble(),
      taxPFour: (json['TaxPFour'] ?? 0.0).toDouble(),
      vatPFirst: (json['VatPFirst'] ?? 0.0).toDouble(),
      vatPSecond: (json['VatPSecond'] ?? 0.0).toDouble(),
      vatPThird: (json['VatPThird'] ?? 0.0).toDouble(),
      vatPFour: (json['VatPFour'] ?? 0.0).toDouble(),
      csgtFirst: (json['CSGTFirst'] ?? 0.0).toDouble(),
      csgtSecond: (json['CSGTSecond'] ?? 0.0).toDouble(),
      csgtThird: (json['CSGTThird'] ?? 0.0).toDouble(),
      csgtFour: (json['CSGTFour'] ?? 0.0).toDouble(),
      dfValue: (json['DFValue'] ?? 0.0).toDouble(),
      dsValue: (json['DSValue'] ?? 0.0).toDouble(),
      dtValue: (json['DTValue'] ?? 0.0).toDouble(),
      dFoValue: (json['DFoValue'] ?? 0.0).toDouble(),
      inTax1: json['InTax1'] ?? '',
      inTax2: json['InTax2'] ?? '',
      inTax3: json['InTax3'] ?? '',
      inTax4: json['InTax4'] ?? '',
      inVat1: json['InVat1'] ?? '',
      inVat2: json['InVat2'] ?? '',
      inVat3: json['InVat3'] ?? '',
      inVat4: json['InVat4'] ?? '',
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
        'comment': commentFirst,
        'oldRate': oldRateFirst,
        'vatAmount': vatPFirst,
        'taxAmount': taxPFirst,
        'grandTotal': csgtFirst,
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
        'comment': commentSecond,
        'oldRate': oldRateSecond,
        'vatAmount': vatPSecond,
        'taxAmount': taxPSecond,
        'grandTotal': csgtSecond,
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
        'comment': commentThird,
        'oldRate': oldRateThird,
        'vatAmount': vatPThird,
        'taxAmount': taxPThird,
        'grandTotal': csgtThird,
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
        'comment': commentFour,
        'oldRate': oldRateFour,
        'vatAmount': vatPFour,
        'taxAmount': taxPFour,
        'grandTotal': csgtFour,
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
      'OldRateFirst': selected['position'] == 'First' ? oldRateFirst : 0.0,
      'OldRateSecond': selected['position'] == 'Second' ? oldRateSecond : 0.0,
      'OldRateThird': selected['position'] == 'Third' ? oldRateThird : 0.0,
      'OldRateFour': selected['position'] == 'Four' ? oldRateFour : 0.0,
      'RateFirst': selected['position'] == 'First' ? rateFirst : 0.0,
      'RateSecond': selected['position'] == 'Second' ? rateSecond : 0.0,
      'RateThird': selected['position'] == 'Third' ? rateThird : 0.0,
      'RateFour': selected['position'] == 'Four' ? rateFour : 0.0,
      'CommentFirst': selected['position'] == 'First' ? commentFirst : '',
      'CommentSecond': selected['position'] == 'Second' ? commentSecond : '',
      'CommentThird': selected['position'] == 'Third' ? commentThird : '',
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
      'TaxPFirst': selected['position'] == 'First' ? taxPFirst : 0.0,
      'TaxPSecond': selected['position'] == 'Second' ? taxPSecond : 0.0,
      'TaxPThird': selected['position'] == 'Third' ? taxPThird : 0.0,
      'TaxPFour': selected['position'] == 'Four' ? taxPFour : 0.0,
      'VatPFirst': selected['position'] == 'First' ? vatPFirst : 0.0,
      'VatPSecond': selected['position'] == 'Second' ? vatPSecond : 0.0,
      'VatPThird': selected['position'] == 'Third' ? vatPThird : 0.0,
      'VatPFour': selected['position'] == 'Four' ? vatPFour : 0.0,
      'CSGTFirst': selected['position'] == 'First' ? csgtFirst : 0.0,
      'CSGTSecond': selected['position'] == 'Second' ? csgtSecond : 0.0,
      'CSGTThird': selected['position'] == 'Third' ? csgtThird : 0.0,
      'CSGTFour': selected['position'] == 'Four' ? csgtFour : 0.0,
      'SelectedSupplierPosition': selectedSupplierPosition,
      'SelectedSupplierName': selected['name'],
      'SelectedRate': selected['rate'],
      'SelectedTotal': selected['total'],
      'SelectedGrandTotal': selected['grandTotal'],
      'SelectedComment': selected['comment'],
    };
  }
}