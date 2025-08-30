class BuyerWiseMaterialModel {
  BuyerWiseMaterialModel({
    num? buyerId,
    String? buyerName,
    String? typeName,
    String? productCategoryName,
    String? productName,
    String? uomName,
  }) {
    _buyerId = buyerId;
    _buyerName = buyerName;
    _typeName = typeName;
    _productCategoryName = productCategoryName;
    _productName = productName;
    _uomName = uomName;
  }

  BuyerWiseMaterialModel.fromJson(dynamic json) {
    _buyerId = json['BuyerId'];
    _buyerName = json['BuyerName'];
    _typeName = json['TypeName'];
    _productCategoryName = json['ProductCategoryName'];
    _productName = json['ProductName'];
    _uomName = json['UomName'];
  }
  num? _buyerId;
  String? _buyerName;
  String? _typeName;
  String? _productCategoryName;
  String? _productName;
  String? _uomName;
  BuyerWiseMaterialModel copyWith({
    num? buyerId,
    String? buyerName,
    String? typeName,
    String? productCategoryName,
    String? productName,
    String? uomName,
  }) =>
      BuyerWiseMaterialModel(
        buyerId: buyerId ?? _buyerId,
        buyerName: buyerName ?? _buyerName,
        typeName: typeName ?? _typeName,
        productCategoryName: productCategoryName ?? _productCategoryName,
        productName: productName ?? _productName,
        uomName: uomName ?? _uomName,
      );
  num? get buyerId => _buyerId;
  String? get buyerName => _buyerName;
  String? get typeName => _typeName;
  String? get productCategoryName => _productCategoryName;
  String? get productName => _productName;
  String? get uomName => _uomName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['BuyerId'] = _buyerId;
    map['BuyerName'] = _buyerName;
    map['TypeName'] = _typeName;
    map['ProductCategoryName'] = _productCategoryName;
    map['ProductName'] = _productName;
    map['UomName'] = _uomName;
    return map;
  }
}
