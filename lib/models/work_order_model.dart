class WorkOrderModel {
  WorkOrderModel({
      String? code, 
      String? blockOrder, 
      String? blockVersion, 
      String? buyerName, 
      num? buyerId, 
      String? po, 
      String? color, 
      String? styleCodes, 
      num? createdBy, 
      String? createdDate, 
      bool? isOnlineShortName, 
      bool? isLock,}){
    _code = code;
    _blockOrder = blockOrder;
    _blockVersion = blockVersion;
    _buyerName = buyerName;
    _buyerId = buyerId;
    _po = po;
    _color = color;
    _styleCodes = styleCodes;
    _createdBy = createdBy;
    _createdDate = createdDate;
    _isOnlineShortName = isOnlineShortName;
    _isLock = isLock;
}

  WorkOrderModel.fromJson(dynamic json) {
    _code = json['Code'];
    _blockOrder = json['BlockOrder'];
    _blockVersion = json['BlockVersion'];
    _buyerName = json['BuyerName'];
    _buyerId = json['BuyerId'];
    _po = json['PO'];
    _color = json['Color'];
    _styleCodes = json['StyleCodes'];
    _createdBy = json['CreatedBy'];
    _createdDate = json['CreatedDate'];
    _isOnlineShortName = json['IsOnlineShortName'];
    _isLock = json['IsLock'];
  }
  String? _code;
  String? _blockOrder;
  String? _blockVersion;
  String? _buyerName;
  num? _buyerId;
  String? _po;
  String? _color;
  String? _styleCodes;
  num? _createdBy;
  String? _createdDate;
  bool? _isOnlineShortName;
  bool? _isLock;
WorkOrderModel copyWith({  String? code,
  String? blockOrder,
  String? blockVersion,
  String? buyerName,
  num? buyerId,
  String? po,
  String? color,
  String? styleCodes,
  num? createdBy,
  String? createdDate,
  bool? isOnlineShortName,
  bool? isLock,
}) => WorkOrderModel(  code: code ?? _code,
  blockOrder: blockOrder ?? _blockOrder,
  blockVersion: blockVersion ?? _blockVersion,
  buyerName: buyerName ?? _buyerName,
  buyerId: buyerId ?? _buyerId,
  po: po ?? _po,
  color: color ?? _color,
  styleCodes: styleCodes ?? _styleCodes,
  createdBy: createdBy ?? _createdBy,
  createdDate: createdDate ?? _createdDate,
  isOnlineShortName: isOnlineShortName ?? _isOnlineShortName,
  isLock: isLock ?? _isLock,
);
  String? get code => _code;
  String? get blockOrder => _blockOrder;
  String? get blockVersion => _blockVersion;
  String? get buyerName => _buyerName;
  num? get buyerId => _buyerId;
  String? get po => _po;
  String? get color => _color;
  String? get styleCodes => _styleCodes;
  num? get createdBy => _createdBy;
  String? get createdDate => _createdDate;
  bool? get isOnlineShortName => _isOnlineShortName;
  bool? get isLock => _isLock;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Code'] = _code;
    map['BlockOrder'] = _blockOrder;
    map['BlockVersion'] = _blockVersion;
    map['BuyerName'] = _buyerName;
    map['BuyerId'] = _buyerId;
    map['PO'] = _po;
    map['Color'] = _color;
    map['StyleCodes'] = _styleCodes;
    map['CreatedBy'] = _createdBy;
    map['CreatedDate'] = _createdDate;
    map['IsOnlineShortName'] = _isOnlineShortName;
    map['IsLock'] = _isLock;
    return map;
  }

}