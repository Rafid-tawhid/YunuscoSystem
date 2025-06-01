class BuyerOrderDetailsModel {
  BuyerOrderDetailsModel({
      num? id, 
      String? masterOrderCode, 
      num? version, 
      String? orderNumber, 
      String? approvalStatus, 
      num? buyer, 
      num? createdBy, 
      String? createdDate, 
      dynamic modifiedBy, 
      dynamic modifiedDate, 
      String? orderDate, 
      dynamic shipmentDate, 
      dynamic exportCountry, 
      num? orderType, 
      String? qtyType, 
      num? season, 
      dynamic submitTo, 
      dynamic submitToName, 
      dynamic submit, 
      dynamic mlcnumber, 
      dynamic lcvalue, 
      bool? isLock, 
      dynamic tnaid, 
      dynamic isApproved, 
      dynamic approvedBy, 
      dynamic approvedDate, 
      dynamic statusId, 
      dynamic approvedByManagement, 
      dynamic managementAppDate, 
      dynamic approvedByCommercial, 
      dynamic commercialAppDate, 
      dynamic approvedByAccounts, 
      dynamic accountsAppDate,}){
    _id = id;
    _masterOrderCode = masterOrderCode;
    _version = version;
    _orderNumber = orderNumber;
    _approvalStatus = approvalStatus;
    _buyer = buyer;
    _createdBy = createdBy;
    _createdDate = createdDate;
    _modifiedBy = modifiedBy;
    _modifiedDate = modifiedDate;
    _orderDate = orderDate;
    _shipmentDate = shipmentDate;
    _exportCountry = exportCountry;
    _orderType = orderType;
    _qtyType = qtyType;
    _season = season;
    _submitTo = submitTo;
    _submitToName = submitToName;
    _submit = submit;
    _mlcnumber = mlcnumber;
    _lcvalue = lcvalue;
    _isLock = isLock;
    _tnaid = tnaid;
    _isApproved = isApproved;
    _approvedBy = approvedBy;
    _approvedDate = approvedDate;
    _statusId = statusId;
    _approvedByManagement = approvedByManagement;
    _managementAppDate = managementAppDate;
    _approvedByCommercial = approvedByCommercial;
    _commercialAppDate = commercialAppDate;
    _approvedByAccounts = approvedByAccounts;
    _accountsAppDate = accountsAppDate;
}

  BuyerOrderDetailsModel.fromJson(dynamic json) {
    _id = json['Id'];
    _masterOrderCode = json['MasterOrderCode'];
    _version = json['Version'];
    _orderNumber = json['OrderNumber'];
    _approvalStatus = json['ApprovalStatus'];
    _buyer = json['Buyer'];
    _createdBy = json['CreatedBy'];
    _createdDate = json['CreatedDate'];
    _modifiedBy = json['ModifiedBy'];
    _modifiedDate = json['ModifiedDate'];
    _orderDate = json['OrderDate'];
    _shipmentDate = json['ShipmentDate'];
    _exportCountry = json['ExportCountry'];
    _orderType = json['OrderType'];
    _qtyType = json['QtyType'];
    _season = json['Season'];
    _submitTo = json['SubmitTo'];
    _submitToName = json['SubmitToName'];
    _submit = json['Submit'];
    _mlcnumber = json['Mlcnumber'];
    _lcvalue = json['Lcvalue'];
    _isLock = json['IsLock'];
    _tnaid = json['Tnaid'];
    _isApproved = json['IsApproved'];
    _approvedBy = json['ApprovedBy'];
    _approvedDate = json['ApprovedDate'];
    _statusId = json['StatusId'];
    _approvedByManagement = json['ApprovedByManagement'];
    _managementAppDate = json['ManagementAppDate'];
    _approvedByCommercial = json['ApprovedByCommercial'];
    _commercialAppDate = json['CommercialAppDate'];
    _approvedByAccounts = json['ApprovedByAccounts'];
    _accountsAppDate = json['AccountsAppDate'];
  }
  num? _id;
  String? _masterOrderCode;
  num? _version;
  String? _orderNumber;
  String? _approvalStatus;
  num? _buyer;
  num? _createdBy;
  String? _createdDate;
  dynamic _modifiedBy;
  dynamic _modifiedDate;
  String? _orderDate;
  dynamic _shipmentDate;
  dynamic _exportCountry;
  num? _orderType;
  String? _qtyType;
  num? _season;
  dynamic _submitTo;
  dynamic _submitToName;
  dynamic _submit;
  dynamic _mlcnumber;
  dynamic _lcvalue;
  bool? _isLock;
  dynamic _tnaid;
  dynamic _isApproved;
  dynamic _approvedBy;
  dynamic _approvedDate;
  dynamic _statusId;
  dynamic _approvedByManagement;
  dynamic _managementAppDate;
  dynamic _approvedByCommercial;
  dynamic _commercialAppDate;
  dynamic _approvedByAccounts;
  dynamic _accountsAppDate;
BuyerOrderDetailsModel copyWith({  num? id,
  String? masterOrderCode,
  num? version,
  String? orderNumber,
  String? approvalStatus,
  num? buyer,
  num? createdBy,
  String? createdDate,
  dynamic modifiedBy,
  dynamic modifiedDate,
  String? orderDate,
  dynamic shipmentDate,
  dynamic exportCountry,
  num? orderType,
  String? qtyType,
  num? season,
  dynamic submitTo,
  dynamic submitToName,
  dynamic submit,
  dynamic mlcnumber,
  dynamic lcvalue,
  bool? isLock,
  dynamic tnaid,
  dynamic isApproved,
  dynamic approvedBy,
  dynamic approvedDate,
  dynamic statusId,
  dynamic approvedByManagement,
  dynamic managementAppDate,
  dynamic approvedByCommercial,
  dynamic commercialAppDate,
  dynamic approvedByAccounts,
  dynamic accountsAppDate,
}) => BuyerOrderDetailsModel(  id: id ?? _id,
  masterOrderCode: masterOrderCode ?? _masterOrderCode,
  version: version ?? _version,
  orderNumber: orderNumber ?? _orderNumber,
  approvalStatus: approvalStatus ?? _approvalStatus,
  buyer: buyer ?? _buyer,
  createdBy: createdBy ?? _createdBy,
  createdDate: createdDate ?? _createdDate,
  modifiedBy: modifiedBy ?? _modifiedBy,
  modifiedDate: modifiedDate ?? _modifiedDate,
  orderDate: orderDate ?? _orderDate,
  shipmentDate: shipmentDate ?? _shipmentDate,
  exportCountry: exportCountry ?? _exportCountry,
  orderType: orderType ?? _orderType,
  qtyType: qtyType ?? _qtyType,
  season: season ?? _season,
  submitTo: submitTo ?? _submitTo,
  submitToName: submitToName ?? _submitToName,
  submit: submit ?? _submit,
  mlcnumber: mlcnumber ?? _mlcnumber,
  lcvalue: lcvalue ?? _lcvalue,
  isLock: isLock ?? _isLock,
  tnaid: tnaid ?? _tnaid,
  isApproved: isApproved ?? _isApproved,
  approvedBy: approvedBy ?? _approvedBy,
  approvedDate: approvedDate ?? _approvedDate,
  statusId: statusId ?? _statusId,
  approvedByManagement: approvedByManagement ?? _approvedByManagement,
  managementAppDate: managementAppDate ?? _managementAppDate,
  approvedByCommercial: approvedByCommercial ?? _approvedByCommercial,
  commercialAppDate: commercialAppDate ?? _commercialAppDate,
  approvedByAccounts: approvedByAccounts ?? _approvedByAccounts,
  accountsAppDate: accountsAppDate ?? _accountsAppDate,
);
  num? get id => _id;
  String? get masterOrderCode => _masterOrderCode;
  num? get version => _version;
  String? get orderNumber => _orderNumber;
  String? get approvalStatus => _approvalStatus;
  num? get buyer => _buyer;
  num? get createdBy => _createdBy;
  String? get createdDate => _createdDate;
  dynamic get modifiedBy => _modifiedBy;
  dynamic get modifiedDate => _modifiedDate;
  String? get orderDate => _orderDate;
  dynamic get shipmentDate => _shipmentDate;
  dynamic get exportCountry => _exportCountry;
  num? get orderType => _orderType;
  String? get qtyType => _qtyType;
  num? get season => _season;
  dynamic get submitTo => _submitTo;
  dynamic get submitToName => _submitToName;
  dynamic get submit => _submit;
  dynamic get mlcnumber => _mlcnumber;
  dynamic get lcvalue => _lcvalue;
  bool? get isLock => _isLock;
  dynamic get tnaid => _tnaid;
  dynamic get isApproved => _isApproved;
  dynamic get approvedBy => _approvedBy;
  dynamic get approvedDate => _approvedDate;
  dynamic get statusId => _statusId;
  dynamic get approvedByManagement => _approvedByManagement;
  dynamic get managementAppDate => _managementAppDate;
  dynamic get approvedByCommercial => _approvedByCommercial;
  dynamic get commercialAppDate => _commercialAppDate;
  dynamic get approvedByAccounts => _approvedByAccounts;
  dynamic get accountsAppDate => _accountsAppDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = _id;
    map['MasterOrderCode'] = _masterOrderCode;
    map['Version'] = _version;
    map['OrderNumber'] = _orderNumber;
    map['ApprovalStatus'] = _approvalStatus;
    map['Buyer'] = _buyer;
    map['CreatedBy'] = _createdBy;
    map['CreatedDate'] = _createdDate;
    map['ModifiedBy'] = _modifiedBy;
    map['ModifiedDate'] = _modifiedDate;
    map['OrderDate'] = _orderDate;
    map['ShipmentDate'] = _shipmentDate;
    map['ExportCountry'] = _exportCountry;
    map['OrderType'] = _orderType;
    map['QtyType'] = _qtyType;
    map['Season'] = _season;
    map['SubmitTo'] = _submitTo;
    map['SubmitToName'] = _submitToName;
    map['Submit'] = _submit;
    map['Mlcnumber'] = _mlcnumber;
    map['Lcvalue'] = _lcvalue;
    map['IsLock'] = _isLock;
    map['Tnaid'] = _tnaid;
    map['IsApproved'] = _isApproved;
    map['ApprovedBy'] = _approvedBy;
    map['ApprovedDate'] = _approvedDate;
    map['StatusId'] = _statusId;
    map['ApprovedByManagement'] = _approvedByManagement;
    map['ManagementAppDate'] = _managementAppDate;
    map['ApprovedByCommercial'] = _approvedByCommercial;
    map['CommercialAppDate'] = _commercialAppDate;
    map['ApprovedByAccounts'] = _approvedByAccounts;
    map['AccountsAppDate'] = _accountsAppDate;
    return map;
  }

}