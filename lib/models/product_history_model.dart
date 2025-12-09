class ProductHistoryModel {
  ProductHistoryModel({
      String? requisitionCode, 
      String? grnCode, 
      String? createdDate, 
      String? productName, 
      String? unitName, 
      num? requisitionQty, 
      num? purchaseQty, 
      num? purchasePrice, 
      num? totalAmount, 
      num? leftToPurchase, 
      String? purchaseStatus, 
      String? purchaseOrderCode, 
      String? purchaseDate,}){
    _requisitionCode = requisitionCode;
    _grnCode = grnCode;
    _createdDate = createdDate;
    _productName = productName;
    _unitName = unitName;
    _requisitionQty = requisitionQty;
    _purchaseQty = purchaseQty;
    _purchasePrice = purchasePrice;
    _totalAmount = totalAmount;
    _leftToPurchase = leftToPurchase;
    _purchaseStatus = purchaseStatus;
    _purchaseOrderCode = purchaseOrderCode;
    _purchaseDate = purchaseDate;
}

  ProductHistoryModel.fromJson(dynamic json) {
    _requisitionCode = json['RequisitionCode'];
    _grnCode = json['GrnCode'];
    _createdDate = json['CreatedDate'];
    _productName = json['ProductName'];
    _unitName = json['UnitName'];
    _requisitionQty = json['RequisitionQty'];
    _purchaseQty = json['PurchaseQty'];
    _purchasePrice = json['PurchasePrice'];
    _totalAmount = json['TotalAmount'];
    _leftToPurchase = json['LeftToPurchase'];
    _purchaseStatus = json['PurchaseStatus'];
    _purchaseOrderCode = json['PurchaseOrderCode'];
    _purchaseDate = json['PurchaseDate'];
  }
  String? _requisitionCode;
  String? _grnCode;
  String? _createdDate;
  String? _productName;
  String? _unitName;
  num? _requisitionQty;
  num? _purchaseQty;
  num? _purchasePrice;
  num? _totalAmount;
  num? _leftToPurchase;
  String? _purchaseStatus;
  String? _purchaseOrderCode;
  String? _purchaseDate;
ProductHistoryModel copyWith({  String? requisitionCode,
  String? grnCode,
  String? createdDate,
  String? productName,
  String? unitName,
  num? requisitionQty,
  num? purchaseQty,
  num? purchasePrice,
  num? totalAmount,
  num? leftToPurchase,
  String? purchaseStatus,
  String? purchaseOrderCode,
  String? purchaseDate,
}) => ProductHistoryModel(  requisitionCode: requisitionCode ?? _requisitionCode,
  grnCode: grnCode ?? _grnCode,
  createdDate: createdDate ?? _createdDate,
  productName: productName ?? _productName,
  unitName: unitName ?? _unitName,
  requisitionQty: requisitionQty ?? _requisitionQty,
  purchaseQty: purchaseQty ?? _purchaseQty,
  purchasePrice: purchasePrice ?? _purchasePrice,
  totalAmount: totalAmount ?? _totalAmount,
  leftToPurchase: leftToPurchase ?? _leftToPurchase,
  purchaseStatus: purchaseStatus ?? _purchaseStatus,
  purchaseOrderCode: purchaseOrderCode ?? _purchaseOrderCode,
  purchaseDate: purchaseDate ?? _purchaseDate,
);
  String? get requisitionCode => _requisitionCode;
  String? get grnCode => _grnCode;
  String? get createdDate => _createdDate;
  String? get productName => _productName;
  String? get unitName => _unitName;
  num? get requisitionQty => _requisitionQty;
  num? get purchaseQty => _purchaseQty;
  num? get purchasePrice => _purchasePrice;
  num? get totalAmount => _totalAmount;
  num? get leftToPurchase => _leftToPurchase;
  String? get purchaseStatus => _purchaseStatus;
  String? get purchaseOrderCode => _purchaseOrderCode;
  String? get purchaseDate => _purchaseDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['RequisitionCode'] = _requisitionCode;
    map['GrnCode'] = _grnCode;
    map['CreatedDate'] = _createdDate;
    map['ProductName'] = _productName;
    map['UnitName'] = _unitName;
    map['RequisitionQty'] = _requisitionQty;
    map['PurchaseQty'] = _purchaseQty;
    map['PurchasePrice'] = _purchasePrice;
    map['TotalAmount'] = _totalAmount;
    map['LeftToPurchase'] = _leftToPurchase;
    map['PurchaseStatus'] = _purchaseStatus;
    map['PurchaseOrderCode'] = _purchaseOrderCode;
    map['PurchaseDate'] = _purchaseDate;
    return map;
  }

}