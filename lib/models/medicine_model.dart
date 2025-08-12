class MedicineModel {
  MedicineModel({
    num? productId,
    String? productCode,
    String? productName,
    String? baseName,
    num? productCategoryId,
    num? productTypeId,
  }) {
    _productId = productId;
    _productCode = productCode;
    _productName = productName;
    _baseName = baseName;
    _productCategoryId = productCategoryId;
    _productTypeId = productTypeId;
  }

  MedicineModel.fromJson(dynamic json) {
    _productId = json['ProductId'];
    _productCode = json['ProductCode'];
    _productName = json['ProductName'];
    _baseName = json['BaseName'];
    _productCategoryId = json['ProductCategoryId'];
    _productTypeId = json['ProductTypeId'];
  }

  num? _productId;
  String? _productCode;
  String? _productName;
  String? _baseName;
  num? _productCategoryId;
  num? _productTypeId;

  MedicineModel copyWith({
    num? productId,
    String? productCode,
    String? productName,
    String? baseName,
    num? productCategoryId,
    num? productTypeId,
  }) => MedicineModel(
    productId: productId ?? _productId,
    productCode: productCode ?? _productCode,
    productName: productName ?? _productName,
    baseName: baseName ?? _baseName,
    productCategoryId: productCategoryId ?? _productCategoryId,
    productTypeId: productTypeId ?? _productTypeId,
  );

  num? get productId => _productId;
  String? get productCode => _productCode;
  String? get productName => _productName;
  String? get baseName => _baseName;
  num? get productCategoryId => _productCategoryId;
  num? get productTypeId => _productTypeId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ProductId'] = _productId;
    map['ProductCode'] = _productCode;
    map['ProductName'] = _productName;
    map['BaseName'] = _baseName;
    map['ProductCategoryId'] = _productCategoryId;
    map['ProductTypeId'] = _productTypeId;
    return map;
  }
}