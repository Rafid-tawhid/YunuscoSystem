class BomModel {
  BomModel({
    num? id,
    String? bOMCode,
    String? buyer,
    String? buyerOrderCode,
    String? buyerPo,
    String? item,
    String? styleName,
    num? styleID,
    String? color,
    num? createdByID,
    String? createdBy,
    String? createdDate,
    bool? isSubmit,
    bool? isLock,
    bool? isLockFinish,
    String? styleNumber,
  }) {
    _id = id;
    _bOMCode = bOMCode;
    _buyer = buyer;
    _buyerOrderCode = buyerOrderCode;
    _buyerPo = buyerPo;
    _item = item;
    _styleName = styleName;
    _styleID = styleID;
    _color = color;
    _createdByID = createdByID;
    _createdBy = createdBy;
    _createdDate = createdDate;
    _isSubmit = isSubmit;
    _isLock = isLock;
    _isLockFinish = isLockFinish;
    _styleNumber = styleNumber;
  }

  BomModel.fromJson(dynamic json) {
    _id = json['ID'];
    _bOMCode = json['BOMCode'];
    _buyer = json['Buyer'];
    _buyerOrderCode = json['BuyerOrderCode'];
    _buyerPo = json['BuyerPo'];
    _item = json['Item'];
    _styleName = json['StyleName'];
    _styleID = json['StyleID'];
    _color = json['Color'];
    _createdByID = json['CreatedByID'];
    _createdBy = json['CreatedBy'];
    _createdDate = json['CreatedDate'];
    _isSubmit = json['IsSubmit'];
    _isLock = json['IsLock'];
    _isLockFinish = json['IsLockFinish'];
    _styleNumber = json['StyleNumber'];
  }
  num? _id;
  String? _bOMCode;
  String? _buyer;
  String? _buyerOrderCode;
  String? _buyerPo;
  String? _item;
  String? _styleName;
  num? _styleID;
  String? _color;
  num? _createdByID;
  String? _createdBy;
  String? _createdDate;
  bool? _isSubmit;
  bool? _isLock;
  bool? _isLockFinish;
  String? _styleNumber;
  BomModel copyWith({
    num? id,
    String? bOMCode,
    String? buyer,
    String? buyerOrderCode,
    String? buyerPo,
    String? item,
    String? styleName,
    num? styleID,
    String? color,
    num? createdByID,
    String? createdBy,
    String? createdDate,
    bool? isSubmit,
    bool? isLock,
    bool? isLockFinish,
    String? styleNumber,
  }) =>
      BomModel(
        id: id ?? _id,
        bOMCode: bOMCode ?? _bOMCode,
        buyer: buyer ?? _buyer,
        buyerOrderCode: buyerOrderCode ?? _buyerOrderCode,
        buyerPo: buyerPo ?? _buyerPo,
        item: item ?? _item,
        styleName: styleName ?? _styleName,
        styleID: styleID ?? _styleID,
        color: color ?? _color,
        createdByID: createdByID ?? _createdByID,
        createdBy: createdBy ?? _createdBy,
        createdDate: createdDate ?? _createdDate,
        isSubmit: isSubmit ?? _isSubmit,
        isLock: isLock ?? _isLock,
        isLockFinish: isLockFinish ?? _isLockFinish,
        styleNumber: styleNumber ?? _styleNumber,
      );
  num? get id => _id;
  String? get bOMCode => _bOMCode;
  String? get buyer => _buyer;
  String? get buyerOrderCode => _buyerOrderCode;
  String? get buyerPo => _buyerPo;
  String? get item => _item;
  String? get styleName => _styleName;
  num? get styleID => _styleID;
  String? get color => _color;
  num? get createdByID => _createdByID;
  String? get createdBy => _createdBy;
  String? get createdDate => _createdDate;
  bool? get isSubmit => _isSubmit;
  bool? get isLock => _isLock;
  bool? get isLockFinish => _isLockFinish;
  String? get styleNumber => _styleNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ID'] = _id;
    map['BOMCode'] = _bOMCode;
    map['Buyer'] = _buyer;
    map['BuyerOrderCode'] = _buyerOrderCode;
    map['BuyerPo'] = _buyerPo;
    map['Item'] = _item;
    map['StyleName'] = _styleName;
    map['StyleID'] = _styleID;
    map['Color'] = _color;
    map['CreatedByID'] = _createdByID;
    map['CreatedBy'] = _createdBy;
    map['CreatedDate'] = _createdDate;
    map['IsSubmit'] = _isSubmit;
    map['IsLock'] = _isLock;
    map['IsLockFinish'] = _isLockFinish;
    map['StyleNumber'] = _styleNumber;
    return map;
  }
}
