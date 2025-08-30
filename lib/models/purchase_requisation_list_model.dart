class PurchaseRequisationListModel {
  PurchaseRequisationListModel({
    num? purchaseRequisitionId,
    String? purchaseRequisitionCode,
    dynamic department,
    String? userName,
    num? createdBy,
    String? createdDate,
    String? productType,
    dynamic approvalFieldCode,
    String? remarks,
    dynamic isComplete,
  }) {
    _purchaseRequisitionId = purchaseRequisitionId;
    _purchaseRequisitionCode = purchaseRequisitionCode;
    _department = department;
    _userName = userName;
    _createdBy = createdBy;
    _createdDate = createdDate;
    _productType = productType;
    _approvalFieldCode = approvalFieldCode;
    _remarks = remarks;
    _isComplete = isComplete;
  }

  PurchaseRequisationListModel.fromJson(dynamic json) {
    _purchaseRequisitionId = json['PurchaseRequisitionId'];
    _purchaseRequisitionCode = json['PurchaseRequisitionCode'];
    _department = json['Department'];
    _userName = json['UserName'];
    _createdBy = json['CreatedBy'];
    _createdDate = json['CreatedDate'];
    _productType = json['ProductType'];
    _approvalFieldCode = json['ApprovalFieldCode'];
    _remarks = json['Remarks'];
    _isComplete = json['IsComplete'];
  }
  num? _purchaseRequisitionId;
  String? _purchaseRequisitionCode;
  dynamic _department;
  String? _userName;
  num? _createdBy;
  String? _createdDate;
  String? _productType;
  dynamic _approvalFieldCode;
  String? _remarks;
  dynamic _isComplete;
  PurchaseRequisationListModel copyWith({
    num? purchaseRequisitionId,
    String? purchaseRequisitionCode,
    dynamic department,
    String? userName,
    num? createdBy,
    String? createdDate,
    String? productType,
    dynamic approvalFieldCode,
    String? remarks,
    dynamic isComplete,
  }) =>
      PurchaseRequisationListModel(
        purchaseRequisitionId: purchaseRequisitionId ?? _purchaseRequisitionId,
        purchaseRequisitionCode:
            purchaseRequisitionCode ?? _purchaseRequisitionCode,
        department: department ?? _department,
        userName: userName ?? _userName,
        createdBy: createdBy ?? _createdBy,
        createdDate: createdDate ?? _createdDate,
        productType: productType ?? _productType,
        approvalFieldCode: approvalFieldCode ?? _approvalFieldCode,
        remarks: remarks ?? _remarks,
        isComplete: isComplete ?? _isComplete,
      );
  num? get purchaseRequisitionId => _purchaseRequisitionId;
  String? get purchaseRequisitionCode => _purchaseRequisitionCode;
  dynamic get department => _department;
  String? get userName => _userName;
  num? get createdBy => _createdBy;
  String? get createdDate => _createdDate;
  String? get productType => _productType;
  dynamic get approvalFieldCode => _approvalFieldCode;
  String? get remarks => _remarks;
  dynamic get isComplete => _isComplete;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['PurchaseRequisitionId'] = _purchaseRequisitionId;
    map['PurchaseRequisitionCode'] = _purchaseRequisitionCode;
    map['Department'] = _department;
    map['UserName'] = _userName;
    map['CreatedBy'] = _createdBy;
    map['CreatedDate'] = _createdDate;
    map['ProductType'] = _productType;
    map['ApprovalFieldCode'] = _approvalFieldCode;
    map['Remarks'] = _remarks;
    map['IsComplete'] = _isComplete;
    return map;
  }
}
