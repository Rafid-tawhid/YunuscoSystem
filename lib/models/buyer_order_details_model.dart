class BuyerOrderDetailsModel {
  BuyerOrderDetailsModel({
    num? id,
    num? approvalId,
    num? currentApprover,
    num? aprrovalPolicyId,
    num? approvalLevel,
    num? approvalTypeId,
    String? aprrovalTypePrimaryKey,
    num? submitToPerson,
    String? masterOrderCode,
    num? version,
    num? buyerId,
    String? buyerName,
    String? styleName,
    String? catagoryName,
    String? createdDate,
    String? createdBy,
    num? materialMaxBudget,
    num? totalOrderQty,
    num? totalValue,
    num? totalStyleReferance,
    num? totalPreCosting,
    bool? isLock,
    String? finalStatus,
  }) {
    _id = id;
    _approvalId = approvalId;
    _currentApprover = currentApprover;
    _aprrovalPolicyId = aprrovalPolicyId;
    _approvalLevel = approvalLevel;
    _approvalTypeId = approvalTypeId;
    _aprrovalTypePrimaryKey = aprrovalTypePrimaryKey;
    _submitToPerson = submitToPerson;
    _masterOrderCode = masterOrderCode;
    _version = version;
    _buyerId = buyerId;
    _buyerName = buyerName;
    _styleName = styleName;
    _catagoryName = catagoryName;
    _createdDate = createdDate;
    _createdBy = createdBy;
    _materialMaxBudget = materialMaxBudget;
    _totalOrderQty = totalOrderQty;
    _totalValue = totalValue;
    _totalStyleReferance = totalStyleReferance;
    _totalPreCosting = totalPreCosting;
    _isLock = isLock;
    _finalStatus = finalStatus;
  }

  BuyerOrderDetailsModel.fromJson(dynamic json) {
    _id = json['ID'];
    _approvalId = json['ApprovalId'];
    _currentApprover = json['CurrentApprover'];
    _aprrovalPolicyId = json['AprrovalPolicyId'];
    _approvalLevel = json['ApprovalLevel'];
    _approvalTypeId = json['ApprovalTypeId'];
    _aprrovalTypePrimaryKey = json['AprrovalTypePrimaryKey'];
    _submitToPerson = json['SubmitToPerson'];
    _masterOrderCode = json['MasterOrderCode'];
    _version = json['Version'];
    _buyerId = json['BuyerId'];
    _buyerName = json['BuyerName'];
    _styleName = json['StyleName'];
    _catagoryName = json['CatagoryName'];
    _createdDate = json['CreatedDate'];
    _createdBy = json['CreatedBy'];
    _materialMaxBudget = json['MaterialMaxBudget'];
    _totalOrderQty = json['TotalOrderQty'];
    _totalValue = json['TotalValue'];
    _totalStyleReferance = json['TotalStyleReferance'];
    _totalPreCosting = json['TotalPreCosting'];
    _isLock = json['IsLock'];
    _finalStatus = json['FinalStatus'];
  }
  num? _id;
  num? _approvalId;
  num? _currentApprover;
  num? _aprrovalPolicyId;
  num? _approvalLevel;
  num? _approvalTypeId;
  String? _aprrovalTypePrimaryKey;
  num? _submitToPerson;
  String? _masterOrderCode;
  num? _version;
  num? _buyerId;
  String? _buyerName;
  String? _styleName;
  String? _catagoryName;
  String? _createdDate;
  String? _createdBy;
  num? _materialMaxBudget;
  num? _totalOrderQty;
  num? _totalValue;
  num? _totalStyleReferance;
  num? _totalPreCosting;
  bool? _isLock;
  String? _finalStatus;
  BuyerOrderDetailsModel copyWith({
    num? id,
    num? approvalId,
    num? currentApprover,
    num? aprrovalPolicyId,
    num? approvalLevel,
    num? approvalTypeId,
    String? aprrovalTypePrimaryKey,
    num? submitToPerson,
    String? masterOrderCode,
    num? version,
    num? buyerId,
    String? buyerName,
    String? styleName,
    String? catagoryName,
    String? createdDate,
    String? createdBy,
    num? materialMaxBudget,
    num? totalOrderQty,
    num? totalValue,
    num? totalStyleReferance,
    num? totalPreCosting,
    bool? isLock,
    String? finalStatus,
  }) =>
      BuyerOrderDetailsModel(
        id: id ?? _id,
        approvalId: approvalId ?? _approvalId,
        currentApprover: currentApprover ?? _currentApprover,
        aprrovalPolicyId: aprrovalPolicyId ?? _aprrovalPolicyId,
        approvalLevel: approvalLevel ?? _approvalLevel,
        approvalTypeId: approvalTypeId ?? _approvalTypeId,
        aprrovalTypePrimaryKey:
            aprrovalTypePrimaryKey ?? _aprrovalTypePrimaryKey,
        submitToPerson: submitToPerson ?? _submitToPerson,
        masterOrderCode: masterOrderCode ?? _masterOrderCode,
        version: version ?? _version,
        buyerId: buyerId ?? _buyerId,
        buyerName: buyerName ?? _buyerName,
        styleName: styleName ?? _styleName,
        catagoryName: catagoryName ?? _catagoryName,
        createdDate: createdDate ?? _createdDate,
        createdBy: createdBy ?? _createdBy,
        materialMaxBudget: materialMaxBudget ?? _materialMaxBudget,
        totalOrderQty: totalOrderQty ?? _totalOrderQty,
        totalValue: totalValue ?? _totalValue,
        totalStyleReferance: totalStyleReferance ?? _totalStyleReferance,
        totalPreCosting: totalPreCosting ?? _totalPreCosting,
        isLock: isLock ?? _isLock,
        finalStatus: finalStatus ?? _finalStatus,
      );
  num? get id => _id;
  num? get approvalId => _approvalId;
  num? get currentApprover => _currentApprover;
  num? get aprrovalPolicyId => _aprrovalPolicyId;
  num? get approvalLevel => _approvalLevel;
  num? get approvalTypeId => _approvalTypeId;
  String? get aprrovalTypePrimaryKey => _aprrovalTypePrimaryKey;
  num? get submitToPerson => _submitToPerson;
  String? get masterOrderCode => _masterOrderCode;
  num? get version => _version;
  num? get buyerId => _buyerId;
  String? get buyerName => _buyerName;
  String? get styleName => _styleName;
  String? get catagoryName => _catagoryName;
  String? get createdDate => _createdDate;
  String? get createdBy => _createdBy;
  num? get materialMaxBudget => _materialMaxBudget;
  num? get totalOrderQty => _totalOrderQty;
  num? get totalValue => _totalValue;
  num? get totalStyleReferance => _totalStyleReferance;
  num? get totalPreCosting => _totalPreCosting;
  bool? get isLock => _isLock;
  String? get finalStatus => _finalStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ID'] = _id;
    map['ApprovalId'] = _approvalId;
    map['CurrentApprover'] = _currentApprover;
    map['AprrovalPolicyId'] = _aprrovalPolicyId;
    map['ApprovalLevel'] = _approvalLevel;
    map['ApprovalTypeId'] = _approvalTypeId;
    map['AprrovalTypePrimaryKey'] = _aprrovalTypePrimaryKey;
    map['SubmitToPerson'] = _submitToPerson;
    map['MasterOrderCode'] = _masterOrderCode;
    map['Version'] = _version;
    map['BuyerId'] = _buyerId;
    map['BuyerName'] = _buyerName;
    map['StyleName'] = _styleName;
    map['CatagoryName'] = _catagoryName;
    map['CreatedDate'] = _createdDate;
    map['CreatedBy'] = _createdBy;
    map['MaterialMaxBudget'] = _materialMaxBudget;
    map['TotalOrderQty'] = _totalOrderQty;
    map['TotalValue'] = _totalValue;
    map['TotalStyleReferance'] = _totalStyleReferance;
    map['TotalPreCosting'] = _totalPreCosting;
    map['IsLock'] = _isLock;
    map['FinalStatus'] = _finalStatus;
    return map;
  }
}
