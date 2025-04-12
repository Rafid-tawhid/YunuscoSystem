class BuyerOrderDetails {
  BuyerOrderDetails({
    String? spoReference,
    String? expectedDeliveryDate,
    String? orderDate,
    String? productName,
    String? unit,
    num? orderQuantity,
    num? inQty,}){
    _spoReference = spoReference;
    _expectedDeliveryDate = expectedDeliveryDate;
    _orderDate = orderDate;
    _productName = productName;
    _unit = unit;
    _orderQuantity = orderQuantity;
    _inQty = inQty;
  }

  BuyerOrderDetails.fromJson(dynamic json) {
    _spoReference = json['spoReference'];
    _expectedDeliveryDate = json['expectedDeliveryDate'];
    _orderDate = json['orderDate'];
    _productName = json['productName'];
    _unit = json['unit'];
    _orderQuantity = json['orderQuantity'];
    _inQty = json['inQty'];
  }
  String? _spoReference;
  String? _expectedDeliveryDate;
  String? _orderDate;
  String? _productName;
  String? _unit;
  num? _orderQuantity;
  num? _inQty;
  BuyerOrderDetails copyWith({  String? spoReference,
    String? expectedDeliveryDate,
    String? orderDate,
    String? productName,
    String? unit,
    num? orderQuantity,
    num? inQty,
  }) => BuyerOrderDetails(  spoReference: spoReference ?? _spoReference,
    expectedDeliveryDate: expectedDeliveryDate ?? _expectedDeliveryDate,
    orderDate: orderDate ?? _orderDate,
    productName: productName ?? _productName,
    unit: unit ?? _unit,
    orderQuantity: orderQuantity ?? _orderQuantity,
    inQty: inQty ?? _inQty,
  );
  String? get spoReference => _spoReference;
  String? get expectedDeliveryDate => _expectedDeliveryDate;
  String? get orderDate => _orderDate;
  String? get productName => _productName;
  String? get unit => _unit;
  num? get orderQuantity => _orderQuantity;
  num? get inQty => _inQty;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['spoReference'] = _spoReference;
    map['expectedDeliveryDate'] = _expectedDeliveryDate;
    map['orderDate'] = _orderDate;
    map['productName'] = _productName;
    map['unit'] = _unit;
    map['orderQuantity'] = _orderQuantity;
    map['inQty'] = _inQty;
    return map;
  }

}