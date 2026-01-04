class BuyerOrderBreakdown {
  BuyerOrderBreakdown({
      String? itemName, 
      String? itemSize, 
      num? basicPrice, 
      String? sampleNo, 
      String? colorName, 
      String? sizeName, 
      num? id, 
      String? masterOrderCode, 
      num? version, 
      String? orderCode, 
      String? orderNumber, 
      String? preCostingCode, 
      String? buyerPoNumber, 
      num? exportCountry, 
      String? poReceiveDate, 
      String? shipmentDate, 
      String? item, 
      String? style, 
      String? styleReferance, 
      String? color, 
      String? size, 
      num? quantity, 
      num? price, 
      num? amount, 
      num? balance, 
      String? fabricDate, 
      String? sewingDate, 
      String? insDate, 
      dynamic extraAllowedPercentage, 
      dynamic extraAllowedQty, 
      dynamic orderQty, 
      num? tnaid, 
      dynamic isPOClosed,}){
    _itemName = itemName;
    _itemSize = itemSize;
    _basicPrice = basicPrice;
    _sampleNo = sampleNo;
    _colorName = colorName;
    _sizeName = sizeName;
    _id = id;
    _masterOrderCode = masterOrderCode;
    _version = version;
    _orderCode = orderCode;
    _orderNumber = orderNumber;
    _preCostingCode = preCostingCode;
    _buyerPoNumber = buyerPoNumber;
    _exportCountry = exportCountry;
    _poReceiveDate = poReceiveDate;
    _shipmentDate = shipmentDate;
    _item = item;
    _style = style;
    _styleReferance = styleReferance;
    _color = color;
    _size = size;
    _quantity = quantity;
    _price = price;
    _amount = amount;
    _balance = balance;
    _fabricDate = fabricDate;
    _sewingDate = sewingDate;
    _insDate = insDate;
    _extraAllowedPercentage = extraAllowedPercentage;
    _extraAllowedQty = extraAllowedQty;
    _orderQty = orderQty;
    _tnaid = tnaid;
    _isPOClosed = isPOClosed;
}

  BuyerOrderBreakdown.fromJson(dynamic json) {
    _itemName = json['ItemName'];
    _itemSize = json['ItemSize'];
    _basicPrice = json['BasicPrice'];
    _sampleNo = json['SampleNo'];
    _colorName = json['ColorName'];
    _sizeName = json['SizeName'];
    _id = json['ID'];
    _masterOrderCode = json['MasterOrderCode'];
    _version = json['Version'];
    _orderCode = json['OrderCode'];
    _orderNumber = json['OrderNumber'];
    _preCostingCode = json['PreCostingCode'];
    _buyerPoNumber = json['BuyerPoNumber'];
    _exportCountry = json['ExportCountry'];
    _poReceiveDate = json['PoReceiveDate'];
    _shipmentDate = json['ShipmentDate'];
    _item = json['Item'];
    _style = json['Style'];
    _styleReferance = json['StyleReferance'];
    _color = json['Color'];
    _size = json['Size'];
    _quantity = json['Quantity'];
    _price = json['Price'];
    _amount = json['Amount'];
    _balance = json['Balance'];
    _fabricDate = json['FabricDate'];
    _sewingDate = json['SewingDate'];
    _insDate = json['InsDate'];
    _extraAllowedPercentage = json['ExtraAllowedPercentage'];
    _extraAllowedQty = json['ExtraAllowedQty'];
    _orderQty = json['OrderQty'];
    _tnaid = json['TNAID'];
    _isPOClosed = json['IsPOClosed'];
  }
  String? _itemName;
  String? _itemSize;
  num? _basicPrice;
  String? _sampleNo;
  String? _colorName;
  String? _sizeName;
  num? _id;
  String? _masterOrderCode;
  num? _version;
  String? _orderCode;
  String? _orderNumber;
  String? _preCostingCode;
  String? _buyerPoNumber;
  num? _exportCountry;
  String? _poReceiveDate;
  String? _shipmentDate;
  String? _item;
  String? _style;
  String? _styleReferance;
  String? _color;
  String? _size;
  num? _quantity;
  num? _price;
  num? _amount;
  num? _balance;
  String? _fabricDate;
  String? _sewingDate;
  String? _insDate;
  dynamic _extraAllowedPercentage;
  dynamic _extraAllowedQty;
  dynamic _orderQty;
  num? _tnaid;
  dynamic _isPOClosed;
BuyerOrderBreakdown copyWith({  String? itemName,
  String? itemSize,
  num? basicPrice,
  String? sampleNo,
  String? colorName,
  String? sizeName,
  num? id,
  String? masterOrderCode,
  num? version,
  String? orderCode,
  String? orderNumber,
  String? preCostingCode,
  String? buyerPoNumber,
  num? exportCountry,
  String? poReceiveDate,
  String? shipmentDate,
  String? item,
  String? style,
  String? styleReferance,
  String? color,
  String? size,
  num? quantity,
  num? price,
  num? amount,
  num? balance,
  String? fabricDate,
  String? sewingDate,
  String? insDate,
  dynamic extraAllowedPercentage,
  dynamic extraAllowedQty,
  dynamic orderQty,
  num? tnaid,
  dynamic isPOClosed,
}) => BuyerOrderBreakdown(  itemName: itemName ?? _itemName,
  itemSize: itemSize ?? _itemSize,
  basicPrice: basicPrice ?? _basicPrice,
  sampleNo: sampleNo ?? _sampleNo,
  colorName: colorName ?? _colorName,
  sizeName: sizeName ?? _sizeName,
  id: id ?? _id,
  masterOrderCode: masterOrderCode ?? _masterOrderCode,
  version: version ?? _version,
  orderCode: orderCode ?? _orderCode,
  orderNumber: orderNumber ?? _orderNumber,
  preCostingCode: preCostingCode ?? _preCostingCode,
  buyerPoNumber: buyerPoNumber ?? _buyerPoNumber,
  exportCountry: exportCountry ?? _exportCountry,
  poReceiveDate: poReceiveDate ?? _poReceiveDate,
  shipmentDate: shipmentDate ?? _shipmentDate,
  item: item ?? _item,
  style: style ?? _style,
  styleReferance: styleReferance ?? _styleReferance,
  color: color ?? _color,
  size: size ?? _size,
  quantity: quantity ?? _quantity,
  price: price ?? _price,
  amount: amount ?? _amount,
  balance: balance ?? _balance,
  fabricDate: fabricDate ?? _fabricDate,
  sewingDate: sewingDate ?? _sewingDate,
  insDate: insDate ?? _insDate,
  extraAllowedPercentage: extraAllowedPercentage ?? _extraAllowedPercentage,
  extraAllowedQty: extraAllowedQty ?? _extraAllowedQty,
  orderQty: orderQty ?? _orderQty,
  tnaid: tnaid ?? _tnaid,
  isPOClosed: isPOClosed ?? _isPOClosed,
);
  String? get itemName => _itemName;
  String? get itemSize => _itemSize;
  num? get basicPrice => _basicPrice;
  String? get sampleNo => _sampleNo;
  String? get colorName => _colorName;
  String? get sizeName => _sizeName;
  num? get id => _id;
  String? get masterOrderCode => _masterOrderCode;
  num? get version => _version;
  String? get orderCode => _orderCode;
  String? get orderNumber => _orderNumber;
  String? get preCostingCode => _preCostingCode;
  String? get buyerPoNumber => _buyerPoNumber;
  num? get exportCountry => _exportCountry;
  String? get poReceiveDate => _poReceiveDate;
  String? get shipmentDate => _shipmentDate;
  String? get item => _item;
  String? get style => _style;
  String? get styleReferance => _styleReferance;
  String? get color => _color;
  String? get size => _size;
  num? get quantity => _quantity;
  num? get price => _price;
  num? get amount => _amount;
  num? get balance => _balance;
  String? get fabricDate => _fabricDate;
  String? get sewingDate => _sewingDate;
  String? get insDate => _insDate;
  dynamic get extraAllowedPercentage => _extraAllowedPercentage;
  dynamic get extraAllowedQty => _extraAllowedQty;
  dynamic get orderQty => _orderQty;
  num? get tnaid => _tnaid;
  dynamic get isPOClosed => _isPOClosed;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ItemName'] = _itemName;
    map['ItemSize'] = _itemSize;
    map['BasicPrice'] = _basicPrice;
    map['SampleNo'] = _sampleNo;
    map['ColorName'] = _colorName;
    map['SizeName'] = _sizeName;
    map['ID'] = _id;
    map['MasterOrderCode'] = _masterOrderCode;
    map['Version'] = _version;
    map['OrderCode'] = _orderCode;
    map['OrderNumber'] = _orderNumber;
    map['PreCostingCode'] = _preCostingCode;
    map['BuyerPoNumber'] = _buyerPoNumber;
    map['ExportCountry'] = _exportCountry;
    map['PoReceiveDate'] = _poReceiveDate;
    map['ShipmentDate'] = _shipmentDate;
    map['Item'] = _item;
    map['Style'] = _style;
    map['StyleReferance'] = _styleReferance;
    map['Color'] = _color;
    map['Size'] = _size;
    map['Quantity'] = _quantity;
    map['Price'] = _price;
    map['Amount'] = _amount;
    map['Balance'] = _balance;
    map['FabricDate'] = _fabricDate;
    map['SewingDate'] = _sewingDate;
    map['InsDate'] = _insDate;
    map['ExtraAllowedPercentage'] = _extraAllowedPercentage;
    map['ExtraAllowedQty'] = _extraAllowedQty;
    map['OrderQty'] = _orderQty;
    map['TNAID'] = _tnaid;
    map['IsPOClosed'] = _isPOClosed;
    return map;
  }

}