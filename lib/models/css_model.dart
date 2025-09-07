class CssModel {
  CssModel({
      String? code, 
      String? purchaseRequisitionCode, 
      String? userName, 
      String? createdDate, 
      String? purchaseType, 
      String? type,}){
    _code = code;
    _purchaseRequisitionCode = purchaseRequisitionCode;
    _userName = userName;
    _createdDate = createdDate;
    _purchaseType = purchaseType;
    _type = type;
}

  CssModel.fromJson(dynamic json) {
    _code = json['Code'];
    _purchaseRequisitionCode = json['PurchaseRequisitionCode'];
    _userName = json['UserName'];
    _createdDate = json['CreatedDate'];
    _purchaseType = json['PurchaseType'];
    _type = json['Type'];
  }
  String? _code;
  String? _purchaseRequisitionCode;
  String? _userName;
  String? _createdDate;
  String? _purchaseType;
  String? _type;
CssModel copyWith({  String? code,
  String? purchaseRequisitionCode,
  String? userName,
  String? createdDate,
  String? purchaseType,
  String? type,
}) => CssModel(  code: code ?? _code,
  purchaseRequisitionCode: purchaseRequisitionCode ?? _purchaseRequisitionCode,
  userName: userName ?? _userName,
  createdDate: createdDate ?? _createdDate,
  purchaseType: purchaseType ?? _purchaseType,
  type: type ?? _type,
);
  String? get code => _code;
  String? get purchaseRequisitionCode => _purchaseRequisitionCode;
  String? get userName => _userName;
  String? get createdDate => _createdDate;
  String? get purchaseType => _purchaseType;
  String? get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Code'] = _code;
    map['PurchaseRequisitionCode'] = _purchaseRequisitionCode;
    map['UserName'] = _userName;
    map['CreatedDate'] = _createdDate;
    map['PurchaseType'] = _purchaseType;
    map['Type'] = _type;
    return map;
  }

}