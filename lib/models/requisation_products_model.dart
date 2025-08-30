class RequisationProductsModel {
  RequisationProductsModel({
    this.productId,
    this.productName,
    this.productCategoryName,
    this.typeName,
    this.masterProductName,
    this.currencyName,
    this.uomName,
    this.uomId,
    this.productDescription,
    this.actualReqQty,
    this.excessForStock,
    this.totalReqQty,
    this.consumeDays,
    this.note,
    this.brand,
    this.approvedQty,
    this.requiredDate,
  });

  factory RequisationProductsModel.fromJson(Map<String, dynamic> json) {
    return RequisationProductsModel(
      productId: json['ProductId'],
      productName: json['ProductName'],
      productCategoryName: json['ProductCategoryName'],
      typeName: json['TypeName'],
      masterProductName: json['MasterProductName'],
      currencyName: json['CurrencyName'],
      uomName: json['UomName'],
      uomId: json['UomId'],
      productDescription: json['productDescription'],
      actualReqQty: json['actualReqQty'],
      excessForStock: json['excessForStock'],
      totalReqQty: json['totalReqQty'],
      consumeDays: json['consumeDays'],
      note: json['note'],
      brand: json['brand'],
      approvedQty: json['approvedQty'],
      requiredDate: json['requiredDate'],
    );
  }
  factory RequisationProductsModel.fromJson2(Map<String, dynamic> json) {
    return RequisationProductsModel(
      productId: json['productId'],
      productName: json['productName'],
      productDescription: json['productDescription'],
      uomId: json['unitId'], // Note: mapping 'unitId' to 'uomId'
      actualReqQty: json['actualReqQty'],
      excessForStock: json['excessForStock'],
      totalReqQty: json['totalReqQty'],
      consumeDays: json['consumeDays'],
      note: json['note'],
      brand: json['brand'],
      approvedQty: json['approvedQty'],
      requiredDate: json['requiredDate'],
      // Preserve existing fields from other JSON mappings
      productCategoryName: json['ProductCategoryName'],
      typeName: json['TypeName'],
      masterProductName: json['MasterProductName'],
      currencyName: json['CurrencyName'],
      uomName: json['UomName'],
    );
  }

  num? productId;
  String? productName;
  String? productCategoryName;
  String? typeName;
  String? masterProductName;
  String? currencyName;
  String? uomName;
  num? uomId;
  String? productDescription;
  num? actualReqQty;
  num? excessForStock;
  num? totalReqQty;
  num? consumeDays;
  String? note;
  String? brand;
  num? approvedQty;
  String? requiredDate;

  RequisationProductsModel copyWith({
    num? productId,
    String? productName,
    String? productCategoryName,
    String? typeName,
    String? masterProductName,
    String? currencyName,
    String? uomName,
    num? uomId,
    String? productDescription,
    num? actualReqQty,
    num? excessForStock,
    num? totalReqQty,
    num? consumeDays,
    String? note,
    String? brand,
    num? approvedQty,
    String? requiredDate,
  }) {
    return RequisationProductsModel(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productCategoryName: productCategoryName ?? this.productCategoryName,
      typeName: typeName ?? this.typeName,
      masterProductName: masterProductName ?? this.masterProductName,
      currencyName: currencyName ?? this.currencyName,
      uomName: uomName ?? this.uomName,
      uomId: uomId ?? this.uomId,
      productDescription: productDescription ?? this.productDescription,
      actualReqQty: actualReqQty ?? this.actualReqQty,
      excessForStock: excessForStock ?? this.excessForStock,
      totalReqQty: totalReqQty ?? this.totalReqQty,
      consumeDays: consumeDays ?? this.consumeDays,
      note: note ?? this.note,
      brand: brand ?? this.brand,
      approvedQty: approvedQty ?? this.approvedQty,
      requiredDate: requiredDate ?? this.requiredDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ProductId': productId,
      'ProductName': productName,
      'ProductCategoryName': productCategoryName,
      'TypeName': typeName,
      'MasterProductName': masterProductName,
      'CurrencyName': currencyName,
      'UomName': uomName,
      'UomId': uomId,
      'productDescription': productDescription,
      'actualReqQty': actualReqQty,
      'excessForStock': excessForStock,
      'totalReqQty': totalReqQty,
      'consumeDays': consumeDays,
      'note': note,
      'brand': brand,
      'approvedQty': approvedQty,
      'requiredDate': requiredDate,
    };
  }
}
