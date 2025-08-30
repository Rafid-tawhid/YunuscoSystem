class PurchaseApprovalModel {
  PurchaseApprovalModel({
    num? purchaseOrderId,
    String? finalStatus,
    String? purchaseOrderCode,
    num? version,
    bool? isLock,
    String? createdDate,
    String? createdBy,
    String? submitToPerson,
    String? buyerName,
    String? supplierName,
    num? styleNumber,
    num? buyerPO,
    num? buyerOrderCode,
    num? costsheetCode,
    num? totalAmount,
    num? totalOrderQty,
    num? approvalId,
    num? approvalTypeId,
    num? aprrovalPolicyId,
    num? approvalLevel,
    String? aprrovalTypePrimaryKey,
    num? currentApprover,
  }) {
    _purchaseOrderId = purchaseOrderId;
    _finalStatus = finalStatus;
    _purchaseOrderCode = purchaseOrderCode;
    _version = version;
    _isLock = isLock;
    _createdDate = createdDate;
    _createdBy = createdBy;
    _submitToPerson = submitToPerson;
    _buyerName = buyerName;
    _supplierName = supplierName;
    _styleNumber = styleNumber;
    _buyerPO = buyerPO;
    _buyerOrderCode = buyerOrderCode;
    _costsheetCode = costsheetCode;
    _totalAmount = totalAmount;
    _totalOrderQty = totalOrderQty;
    _approvalId = approvalId;
    _approvalTypeId = approvalTypeId;
    _aprrovalPolicyId = aprrovalPolicyId;
    _approvalLevel = approvalLevel;
    _aprrovalTypePrimaryKey = aprrovalTypePrimaryKey;
    _currentApprover = currentApprover;
  }

  PurchaseApprovalModel.fromJson(dynamic json) {
    _purchaseOrderId = json['PurchaseOrderId'];
    _finalStatus = json['FinalStatus'];
    _purchaseOrderCode = json['PurchaseOrderCode'];
    _version = json['Version'];
    _isLock = json['IsLock'];
    _createdDate = json['CreatedDate'];
    _createdBy = json['CreatedBy'];
    _submitToPerson = json['SubmitToPerson'];
    _buyerName = json['BuyerName'];
    _supplierName = json['SupplierName'];
    _styleNumber = json['StyleNumber'];
    _buyerPO = json['BuyerPO'];
    _buyerOrderCode = json['BuyerOrderCode'];
    _costsheetCode = json['CostsheetCode'];
    _totalAmount = json['TotalAmount'];
    _totalOrderQty = json['TotalOrderQty'];
    _approvalId = json['ApprovalId'];
    _approvalTypeId = json['ApprovalTypeId'];
    _aprrovalPolicyId = json['AprrovalPolicyId'];
    _approvalLevel = json['ApprovalLevel'];
    _aprrovalTypePrimaryKey = json['AprrovalTypePrimaryKey'];
    _currentApprover = json['CurrentApprover'];
  }
  num? _purchaseOrderId;
  String? _finalStatus;
  String? _purchaseOrderCode;
  num? _version;
  bool? _isLock;
  String? _createdDate;
  String? _createdBy;
  String? _submitToPerson;
  String? _buyerName;
  String? _supplierName;
  num? _styleNumber;
  num? _buyerPO;
  num? _buyerOrderCode;
  num? _costsheetCode;
  num? _totalAmount;
  num? _totalOrderQty;
  num? _approvalId;
  num? _approvalTypeId;
  num? _aprrovalPolicyId;
  num? _approvalLevel;
  String? _aprrovalTypePrimaryKey;
  num? _currentApprover;
  PurchaseApprovalModel copyWith({
    num? purchaseOrderId,
    String? finalStatus,
    String? purchaseOrderCode,
    num? version,
    bool? isLock,
    String? createdDate,
    String? createdBy,
    String? submitToPerson,
    String? buyerName,
    String? supplierName,
    num? styleNumber,
    num? buyerPO,
    num? buyerOrderCode,
    num? costsheetCode,
    num? totalAmount,
    num? totalOrderQty,
    num? approvalId,
    num? approvalTypeId,
    num? aprrovalPolicyId,
    num? approvalLevel,
    String? aprrovalTypePrimaryKey,
    num? currentApprover,
  }) =>
      PurchaseApprovalModel(
        purchaseOrderId: purchaseOrderId ?? _purchaseOrderId,
        finalStatus: finalStatus ?? _finalStatus,
        purchaseOrderCode: purchaseOrderCode ?? _purchaseOrderCode,
        version: version ?? _version,
        isLock: isLock ?? _isLock,
        createdDate: createdDate ?? _createdDate,
        createdBy: createdBy ?? _createdBy,
        submitToPerson: submitToPerson ?? _submitToPerson,
        buyerName: buyerName ?? _buyerName,
        supplierName: supplierName ?? _supplierName,
        styleNumber: styleNumber ?? _styleNumber,
        buyerPO: buyerPO ?? _buyerPO,
        buyerOrderCode: buyerOrderCode ?? _buyerOrderCode,
        costsheetCode: costsheetCode ?? _costsheetCode,
        totalAmount: totalAmount ?? _totalAmount,
        totalOrderQty: totalOrderQty ?? _totalOrderQty,
        approvalId: approvalId ?? _approvalId,
        approvalTypeId: approvalTypeId ?? _approvalTypeId,
        aprrovalPolicyId: aprrovalPolicyId ?? _aprrovalPolicyId,
        approvalLevel: approvalLevel ?? _approvalLevel,
        aprrovalTypePrimaryKey:
            aprrovalTypePrimaryKey ?? _aprrovalTypePrimaryKey,
        currentApprover: currentApprover ?? _currentApprover,
      );
  num? get purchaseOrderId => _purchaseOrderId;
  String? get finalStatus => _finalStatus;
  String? get purchaseOrderCode => _purchaseOrderCode;
  num? get version => _version;
  bool? get isLock => _isLock;
  String? get createdDate => _createdDate;
  String? get createdBy => _createdBy;
  String? get submitToPerson => _submitToPerson;
  String? get buyerName => _buyerName;
  String? get supplierName => _supplierName;
  num? get styleNumber => _styleNumber;
  num? get buyerPO => _buyerPO;
  num? get buyerOrderCode => _buyerOrderCode;
  num? get costsheetCode => _costsheetCode;
  num? get totalAmount => _totalAmount;
  num? get totalOrderQty => _totalOrderQty;
  num? get approvalId => _approvalId;
  num? get approvalTypeId => _approvalTypeId;
  num? get aprrovalPolicyId => _aprrovalPolicyId;
  num? get approvalLevel => _approvalLevel;
  String? get aprrovalTypePrimaryKey => _aprrovalTypePrimaryKey;
  num? get currentApprover => _currentApprover;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['PurchaseOrderId'] = _purchaseOrderId;
    map['FinalStatus'] = _finalStatus;
    map['PurchaseOrderCode'] = _purchaseOrderCode;
    map['Version'] = _version;
    map['IsLock'] = _isLock;
    map['CreatedDate'] = _createdDate;
    map['CreatedBy'] = _createdBy;
    map['SubmitToPerson'] = _submitToPerson;
    map['BuyerName'] = _buyerName;
    map['SupplierName'] = _supplierName;
    map['StyleNumber'] = _styleNumber;
    map['BuyerPO'] = _buyerPO;
    map['BuyerOrderCode'] = _buyerOrderCode;
    map['CostsheetCode'] = _costsheetCode;
    map['TotalAmount'] = _totalAmount;
    map['TotalOrderQty'] = _totalOrderQty;
    map['ApprovalId'] = _approvalId;
    map['ApprovalTypeId'] = _approvalTypeId;
    map['AprrovalPolicyId'] = _aprrovalPolicyId;
    map['ApprovalLevel'] = _approvalLevel;
    map['AprrovalTypePrimaryKey'] = _aprrovalTypePrimaryKey;
    map['CurrentApprover'] = _currentApprover;
    return map;
  }
}
