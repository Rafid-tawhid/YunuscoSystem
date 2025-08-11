class MedicineModel {
  MedicineModel({
      num? productId, 
      String? productCode, 
      String? productName, 
      String? baseName,}){
    _productId = productId;
    _productCode = productCode;
    _productName = productName;
    _baseName = baseName;
}

  MedicineModel.fromJson(dynamic json) {
    _productId = json['ProductId'];
    _productCode = json['ProductCode'];
    _productName = json['ProductName'];
    _baseName = json['BaseName'];
  }
  num? _productId;
  String? _productCode;
  String? _productName;
  String? _baseName;
MedicineModel copyWith({  num? productId,
  String? productCode,
  String? productName,
  String? baseName,
}) => MedicineModel(  productId: productId ?? _productId,
  productCode: productCode ?? _productCode,
  productName: productName ?? _productName,
  baseName: baseName ?? _baseName,
);
  num? get productId => _productId;
  String? get productCode => _productCode;
  String? get productName => _productName;
  String? get baseName => _baseName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ProductId'] = _productId;
    map['ProductCode'] = _productCode;
    map['ProductName'] = _productName;
    map['BaseName'] = _baseName;
    return map;
  }

}