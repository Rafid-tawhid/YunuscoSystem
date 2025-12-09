class ProductHistoryModel {
  ProductHistoryModel({
      String? requisitionCode, 
      String? grnCode, 
      String? createdDate, 
      String? productName, 
      String? unitName, 
      num? requisitionQty, 
      num? purchaseQty, 
      String? purchaseStatus, 
      String? purchaseOrderCode, 
      String? purchaseDate, 
      num? purPrice, 
      num? totalPrice,}){
    _requisitionCode = requisitionCode;
    _grnCode = grnCode;
    _createdDate = createdDate;
    _productName = productName;
    _unitName = unitName;
    _requisitionQty = requisitionQty;
    _purchaseQty = purchaseQty;
    _purchaseStatus = purchaseStatus;
    _purchaseOrderCode = purchaseOrderCode;
    _purchaseDate = purchaseDate;
    _purPrice = purPrice;
    _totalPrice = totalPrice;
}

  ProductHistoryModel.fromJson(dynamic json) {
    _requisitionCode = json['RequisitionCode'];
    _grnCode = json['GrnCode'];
    _createdDate = json['CreatedDate'];
    _productName = json['ProductName'];
    _unitName = json['UnitName'];
    _requisitionQty = json['RequisitionQty'];
    _purchaseQty = json['PurchaseQty'];
    _purchaseStatus = json['PurchaseStatus'];
    _purchaseOrderCode = json['PurchaseOrderCode'];
    _purchaseDate = json['PurchaseDate'];
    _purPrice = json['PurPrice'];
    _totalPrice = json['TotalPrice'];
  }
  String? _requisitionCode;
  String? _grnCode;
  String? _createdDate;
  String? _productName;
  String? _unitName;
  num? _requisitionQty;
  num? _purchaseQty;
  String? _purchaseStatus;
  String? _purchaseOrderCode;
  String? _purchaseDate;
  num? _purPrice;
  num? _totalPrice;
ProductHistoryModel copyWith({  String? requisitionCode,
  String? grnCode,
  String? createdDate,
  String? productName,
  String? unitName,
  num? requisitionQty,
  num? purchaseQty,
  String? purchaseStatus,
  String? purchaseOrderCode,
  String? purchaseDate,
  num? purPrice,
  num? totalPrice,
}) => ProductHistoryModel(  requisitionCode: requisitionCode ?? _requisitionCode,
  grnCode: grnCode ?? _grnCode,
  createdDate: createdDate ?? _createdDate,
  productName: productName ?? _productName,
  unitName: unitName ?? _unitName,
  requisitionQty: requisitionQty ?? _requisitionQty,
  purchaseQty: purchaseQty ?? _purchaseQty,
  purchaseStatus: purchaseStatus ?? _purchaseStatus,
  purchaseOrderCode: purchaseOrderCode ?? _purchaseOrderCode,
  purchaseDate: purchaseDate ?? _purchaseDate,
  purPrice: purPrice ?? _purPrice,
  totalPrice: totalPrice ?? _totalPrice,
);
  String? get requisitionCode => _requisitionCode;
  String? get grnCode => _grnCode;
  String? get createdDate => _createdDate;
  String? get productName => _productName;
  String? get unitName => _unitName;
  num? get requisitionQty => _requisitionQty;
  num? get purchaseQty => _purchaseQty;
  String? get purchaseStatus => _purchaseStatus;
  String? get purchaseOrderCode => _purchaseOrderCode;
  String? get purchaseDate => _purchaseDate;
  num? get purPrice => _purPrice;
  num? get totalPrice => _totalPrice;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['RequisitionCode'] = _requisitionCode;
    map['GrnCode'] = _grnCode;
    map['CreatedDate'] = _createdDate;
    map['ProductName'] = _productName;
    map['UnitName'] = _unitName;
    map['RequisitionQty'] = _requisitionQty;
    map['PurchaseQty'] = _purchaseQty;
    map['PurchaseStatus'] = _purchaseStatus;
    map['PurchaseOrderCode'] = _purchaseOrderCode;
    map['PurchaseDate'] = _purchaseDate;
    map['PurPrice'] = _purPrice;
    map['TotalPrice'] = _totalPrice;
    return map;
  }

}