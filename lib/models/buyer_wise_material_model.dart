class BuyerWiseMaterialModel {
  BuyerWiseMaterialModel({
      num? buyerId, 
      String? buyerName, 
      String? typeName, 
      String? productCategoryName, 
      String? productName, 
      String? uomName,}){
    _buyerId = buyerId;
    _buyerName = buyerName;
    _typeName = typeName;
    _productCategoryName = productCategoryName;
    _productName = productName;
    _uomName = uomName;
}

  BuyerWiseMaterialModel.fromJson(dynamic json) {
    _buyerId = json['buyerId'];
    _buyerName = json['buyerName'];
    _typeName = json['typeName'];
    _productCategoryName = json['productCategoryName'];
    _productName = json['productName'];
    _uomName = json['uomName'];
  }
  num? _buyerId;
  String? _buyerName;
  String? _typeName;
  String? _productCategoryName;
  String? _productName;
  String? _uomName;
BuyerWiseMaterialModel copyWith({  num? buyerId,
  String? buyerName,
  String? typeName,
  String? productCategoryName,
  String? productName,
  String? uomName,
}) => BuyerWiseMaterialModel(  buyerId: buyerId ?? _buyerId,
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
    map['buyerId'] = _buyerId;
    map['buyerName'] = _buyerName;
    map['typeName'] = _typeName;
    map['productCategoryName'] = _productCategoryName;
    map['productName'] = _productName;
    map['uomName'] = _uomName;
    return map;
  }

}