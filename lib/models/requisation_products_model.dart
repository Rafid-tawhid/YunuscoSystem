class RequisationProductsModel {
  RequisationProductsModel({
      num? productId, 
      String? productName, 
      String? productCategoryName, 
      String? typeName, 
      String? masterProductName, 
      String? currencyName, 
      String? uomName, 
      num? uomId,}){
    _productId = productId;
    _productName = productName;
    _productCategoryName = productCategoryName;
    _typeName = typeName;
    _masterProductName = masterProductName;
    _currencyName = currencyName;
    _uomName = uomName;
    _uomId = uomId;
}

  RequisationProductsModel.fromJson(dynamic json) {
    _productId = json['ProductId'];
    _productName = json['ProductName'];
    _productCategoryName = json['ProductCategoryName'];
    _typeName = json['TypeName'];
    _masterProductName = json['MasterProductName'];
    _currencyName = json['CurrencyName'];
    _uomName = json['UomName'];
    _uomId = json['UomId'];
  }
  num? _productId;
  String? _productName;
  String? _productCategoryName;
  String? _typeName;
  String? _masterProductName;
  String? _currencyName;
  String? _uomName;
  num? _uomId;
RequisationProductsModel copyWith({  num? productId,
  String? productName,
  String? productCategoryName,
  String? typeName,
  String? masterProductName,
  String? currencyName,
  String? uomName,
  num? uomId,
}) => RequisationProductsModel(  productId: productId ?? _productId,
  productName: productName ?? _productName,
  productCategoryName: productCategoryName ?? _productCategoryName,
  typeName: typeName ?? _typeName,
  masterProductName: masterProductName ?? _masterProductName,
  currencyName: currencyName ?? _currencyName,
  uomName: uomName ?? _uomName,
  uomId: uomId ?? _uomId,
);
  num? get productId => _productId;
  String? get productName => _productName;
  String? get productCategoryName => _productCategoryName;
  String? get typeName => _typeName;
  String? get masterProductName => _masterProductName;
  String? get currencyName => _currencyName;
  String? get uomName => _uomName;
  num? get uomId => _uomId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ProductId'] = _productId;
    map['ProductName'] = _productName;
    map['ProductCategoryName'] = _productCategoryName;
    map['TypeName'] = _typeName;
    map['MasterProductName'] = _masterProductName;
    map['CurrencyName'] = _currencyName;
    map['UomName'] = _uomName;
    map['UomId'] = _uomId;
    return map;
  }

}