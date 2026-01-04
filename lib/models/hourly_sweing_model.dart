class HourlySweingModel {
  HourlySweingModel({
      num? code, 
      String? productionDate, 
      String? lineCode, 
      num? qty, 
      num? targetHrQty, 
      num? targetDayQty, 
      String? status, 
      String? itemCode, 
      String? buyerCode, 
      String? lineName, 
      String? itemName, 
      num? itemBasicPrice, 
      String? buyerName, 
      String? buyerAddress, 
      String? buyerContact,}){
    _code = code;
    _productionDate = productionDate;
    _lineCode = lineCode;
    _qty = qty;
    _targetHrQty = targetHrQty;
    _targetDayQty = targetDayQty;
    _status = status;
    _itemCode = itemCode;
    _buyerCode = buyerCode;
    _lineName = lineName;
    _itemName = itemName;
    _itemBasicPrice = itemBasicPrice;
    _buyerName = buyerName;
    _buyerAddress = buyerAddress;
    _buyerContact = buyerContact;
}

  HourlySweingModel.fromJson(dynamic json) {
    _code = json['Code'];
    _productionDate = json['ProductionDate'];
    _lineCode = json['LineCode'];
    _qty = json['Qty'];
    _targetHrQty = json['TargetHrQty'];
    _targetDayQty = json['TargetDayQty'];
    _status = json['Status'];
    _itemCode = json['ItemCode'];
    _buyerCode = json['BuyerCode'];
    _lineName = json['LineName'];
    _itemName = json['ItemName'];
    _itemBasicPrice = json['ItemBasicPrice'];
    _buyerName = json['BuyerName'];
    _buyerAddress = json['BuyerAddress'];
    _buyerContact = json['BuyerContact'];
  }
  num? _code;
  String? _productionDate;
  String? _lineCode;
  num? _qty;
  num? _targetHrQty;
  num? _targetDayQty;
  String? _status;
  String? _itemCode;
  String? _buyerCode;
  String? _lineName;
  String? _itemName;
  num? _itemBasicPrice;
  String? _buyerName;
  String? _buyerAddress;
  String? _buyerContact;
HourlySweingModel copyWith({  num? code,
  String? productionDate,
  String? lineCode,
  num? qty,
  num? targetHrQty,
  num? targetDayQty,
  String? status,
  String? itemCode,
  String? buyerCode,
  String? lineName,
  String? itemName,
  num? itemBasicPrice,
  String? buyerName,
  String? buyerAddress,
  String? buyerContact,
}) => HourlySweingModel(  code: code ?? _code,
  productionDate: productionDate ?? _productionDate,
  lineCode: lineCode ?? _lineCode,
  qty: qty ?? _qty,
  targetHrQty: targetHrQty ?? _targetHrQty,
  targetDayQty: targetDayQty ?? _targetDayQty,
  status: status ?? _status,
  itemCode: itemCode ?? _itemCode,
  buyerCode: buyerCode ?? _buyerCode,
  lineName: lineName ?? _lineName,
  itemName: itemName ?? _itemName,
  itemBasicPrice: itemBasicPrice ?? _itemBasicPrice,
  buyerName: buyerName ?? _buyerName,
  buyerAddress: buyerAddress ?? _buyerAddress,
  buyerContact: buyerContact ?? _buyerContact,
);
  num? get code => _code;
  String? get productionDate => _productionDate;
  String? get lineCode => _lineCode;
  num? get qty => _qty;
  num? get targetHrQty => _targetHrQty;
  num? get targetDayQty => _targetDayQty;
  String? get status => _status;
  String? get itemCode => _itemCode;
  String? get buyerCode => _buyerCode;
  String? get lineName => _lineName;
  String? get itemName => _itemName;
  num? get itemBasicPrice => _itemBasicPrice;
  String? get buyerName => _buyerName;
  String? get buyerAddress => _buyerAddress;
  String? get buyerContact => _buyerContact;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Code'] = _code;
    map['ProductionDate'] = _productionDate;
    map['LineCode'] = _lineCode;
    map['Qty'] = _qty;
    map['TargetHrQty'] = _targetHrQty;
    map['TargetDayQty'] = _targetDayQty;
    map['Status'] = _status;
    map['ItemCode'] = _itemCode;
    map['BuyerCode'] = _buyerCode;
    map['LineName'] = _lineName;
    map['ItemName'] = _itemName;
    map['ItemBasicPrice'] = _itemBasicPrice;
    map['BuyerName'] = _buyerName;
    map['BuyerAddress'] = _buyerAddress;
    map['BuyerContact'] = _buyerContact;
    return map;
  }

}