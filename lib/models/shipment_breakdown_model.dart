class ShipmentBreakdownModel {
  ShipmentBreakdownModel({
      String? buyerName, 
      String? shipmentDate, 
      String? masterOrderCode, 
      num? version, 
      String? preCostingCode, 
      String? buyerPoNumber, 
      String? style, 
      String? colorName, 
      String? sizeName, 
      num? shipmentQuantity,}){
    _buyerName = buyerName;
    _shipmentDate = shipmentDate;
    _masterOrderCode = masterOrderCode;
    _version = version;
    _preCostingCode = preCostingCode;
    _buyerPoNumber = buyerPoNumber;
    _style = style;
    _colorName = colorName;
    _sizeName = sizeName;
    _shipmentQuantity = shipmentQuantity;
}

  ShipmentBreakdownModel.fromJson(dynamic json) {
    _buyerName = json['BuyerName'];
    _shipmentDate = json['ShipmentDate'];
    _masterOrderCode = json['MasterOrderCode'];
    _version = json['Version'];
    _preCostingCode = json['PreCostingCode'];
    _buyerPoNumber = json['BuyerPoNumber'];
    _style = json['Style'];
    _colorName = json['ColorName'];
    _sizeName = json['SizeName'];
    _shipmentQuantity = json['ShipmentQuantity'];
  }
  String? _buyerName;
  String? _shipmentDate;
  String? _masterOrderCode;
  num? _version;
  String? _preCostingCode;
  String? _buyerPoNumber;
  String? _style;
  String? _colorName;
  String? _sizeName;
  num? _shipmentQuantity;
ShipmentBreakdownModel copyWith({  String? buyerName,
  String? shipmentDate,
  String? masterOrderCode,
  num? version,
  String? preCostingCode,
  String? buyerPoNumber,
  String? style,
  String? colorName,
  String? sizeName,
  num? shipmentQuantity,
}) => ShipmentBreakdownModel(  buyerName: buyerName ?? _buyerName,
  shipmentDate: shipmentDate ?? _shipmentDate,
  masterOrderCode: masterOrderCode ?? _masterOrderCode,
  version: version ?? _version,
  preCostingCode: preCostingCode ?? _preCostingCode,
  buyerPoNumber: buyerPoNumber ?? _buyerPoNumber,
  style: style ?? _style,
  colorName: colorName ?? _colorName,
  sizeName: sizeName ?? _sizeName,
  shipmentQuantity: shipmentQuantity ?? _shipmentQuantity,
);
  String? get buyerName => _buyerName;
  String? get shipmentDate => _shipmentDate;
  String? get masterOrderCode => _masterOrderCode;
  num? get version => _version;
  String? get preCostingCode => _preCostingCode;
  String? get buyerPoNumber => _buyerPoNumber;
  String? get style => _style;
  String? get colorName => _colorName;
  String? get sizeName => _sizeName;
  num? get shipmentQuantity => _shipmentQuantity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['BuyerName'] = _buyerName;
    map['ShipmentDate'] = _shipmentDate;
    map['MasterOrderCode'] = _masterOrderCode;
    map['Version'] = _version;
    map['PreCostingCode'] = _preCostingCode;
    map['BuyerPoNumber'] = _buyerPoNumber;
    map['Style'] = _style;
    map['ColorName'] = _colorName;
    map['SizeName'] = _sizeName;
    map['ShipmentQuantity'] = _shipmentQuantity;
    return map;
  }

}