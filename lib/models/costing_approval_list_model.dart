class CostingApprovalListModel {
  CostingApprovalListModel({
    num? id,
    String? finalStatus,
    String? costingCode,
    num? version,
    bool? isLock,
    String? createdDate,
    String? createdBy,
    String? submitToPerson,
    String? buyerName,
    String? styleName,
    String? catagoryName,
    num? materialMaxBudget,
    String? styleRef,
    String? qtyType,
    num? qtyPerPack,
    num? cm,
    num? smv,
    num? actualCM,
    num? fixedPrice,
    num? commercialCharge,
    num? materialCost,
    num? buyingCost,
    num? othersCost,
    num? profitCostInPercent,
    num? financialExpence,
    num? totalOrderQty,
    num? approvalId,
    num? approvalTypeId,
    num? aprrovalPolicyId,
    num? approvalLevel,
    String? aprrovalTypePrimaryKey,
    num? currentApprover,
  }) {
    _id = id;
    _finalStatus = finalStatus;
    _costingCode = costingCode;
    _version = version;
    _isLock = isLock;
    _createdDate = createdDate;
    _createdBy = createdBy;
    _submitToPerson = submitToPerson;
    _buyerName = buyerName;
    _styleName = styleName;
    _catagoryName = catagoryName;
    _materialMaxBudget = materialMaxBudget;
    _styleRef = styleRef;
    _qtyType = qtyType;
    _qtyPerPack = qtyPerPack;
    _cm = cm;
    _smv = smv;
    _actualCM = actualCM;
    _fixedPrice = fixedPrice;
    _commercialCharge = commercialCharge;
    _materialCost = materialCost;
    _buyingCost = buyingCost;
    _othersCost = othersCost;
    _profitCostInPercent = profitCostInPercent;
    _financialExpence = financialExpence;
    _totalOrderQty = totalOrderQty;
    _approvalId = approvalId;
    _approvalTypeId = approvalTypeId;
    _aprrovalPolicyId = aprrovalPolicyId;
    _approvalLevel = approvalLevel;
    _aprrovalTypePrimaryKey = aprrovalTypePrimaryKey;
    _currentApprover = currentApprover;
  }

  CostingApprovalListModel.fromJson(dynamic json) {
    _id = json['ID'];
    _finalStatus = json['FinalStatus'];
    _costingCode = json['CostingCode'];
    _version = json['Version'];
    _isLock = json['IsLock'];
    _createdDate = json['CreatedDate'];
    _createdBy = json['CreatedBy'];
    _submitToPerson = json['SubmitToPerson'];
    _buyerName = json['BuyerName'];
    _styleName = json['StyleName'];
    _catagoryName = json['CatagoryName'];
    _materialMaxBudget = json['MaterialMaxBudget'];
    _styleRef = json['StyleRef'];
    _qtyType = json['QtyType'];
    _qtyPerPack = json['QtyPerPack'];
    _cm = json['CM'];
    _smv = json['SMV'];
    _actualCM = json['ActualCM'];
    _fixedPrice = json['FixedPrice'];
    _commercialCharge = json['CommercialCharge'];
    _materialCost = json['MaterialCost'];
    _buyingCost = json['BuyingCost'];
    _othersCost = json['OthersCost'];
    _profitCostInPercent = json['ProfitCostInPercent'];
    _financialExpence = json['FinancialExpence'];
    _totalOrderQty = json['TotalOrderQty'];
    _approvalId = json['ApprovalId'];
    _approvalTypeId = json['ApprovalTypeId'];
    _aprrovalPolicyId = json['AprrovalPolicyId'];
    _approvalLevel = json['ApprovalLevel'];
    _aprrovalTypePrimaryKey = json['AprrovalTypePrimaryKey'];
    _currentApprover = json['CurrentApprover'];
  }
  num? _id;
  String? _finalStatus;
  String? _costingCode;
  num? _version;
  bool? _isLock;
  String? _createdDate;
  String? _createdBy;
  String? _submitToPerson;
  String? _buyerName;
  String? _styleName;
  String? _catagoryName;
  num? _materialMaxBudget;
  String? _styleRef;
  String? _qtyType;
  num? _qtyPerPack;
  num? _cm;
  num? _smv;
  num? _actualCM;
  num? _fixedPrice;
  num? _commercialCharge;
  num? _materialCost;
  num? _buyingCost;
  num? _othersCost;
  num? _profitCostInPercent;
  num? _financialExpence;
  num? _totalOrderQty;
  num? _approvalId;
  num? _approvalTypeId;
  num? _aprrovalPolicyId;
  num? _approvalLevel;
  String? _aprrovalTypePrimaryKey;
  num? _currentApprover;
  CostingApprovalListModel copyWith({
    num? id,
    String? finalStatus,
    String? costingCode,
    num? version,
    bool? isLock,
    String? createdDate,
    String? createdBy,
    String? submitToPerson,
    String? buyerName,
    String? styleName,
    String? catagoryName,
    num? materialMaxBudget,
    String? styleRef,
    String? qtyType,
    num? qtyPerPack,
    num? cm,
    num? smv,
    num? actualCM,
    num? fixedPrice,
    num? commercialCharge,
    num? materialCost,
    num? buyingCost,
    num? othersCost,
    num? profitCostInPercent,
    num? financialExpence,
    num? totalOrderQty,
    num? approvalId,
    num? approvalTypeId,
    num? aprrovalPolicyId,
    num? approvalLevel,
    String? aprrovalTypePrimaryKey,
    num? currentApprover,
  }) =>
      CostingApprovalListModel(
        id: id ?? _id,
        finalStatus: finalStatus ?? _finalStatus,
        costingCode: costingCode ?? _costingCode,
        version: version ?? _version,
        isLock: isLock ?? _isLock,
        createdDate: createdDate ?? _createdDate,
        createdBy: createdBy ?? _createdBy,
        submitToPerson: submitToPerson ?? _submitToPerson,
        buyerName: buyerName ?? _buyerName,
        styleName: styleName ?? _styleName,
        catagoryName: catagoryName ?? _catagoryName,
        materialMaxBudget: materialMaxBudget ?? _materialMaxBudget,
        styleRef: styleRef ?? _styleRef,
        qtyType: qtyType ?? _qtyType,
        qtyPerPack: qtyPerPack ?? _qtyPerPack,
        cm: cm ?? _cm,
        smv: smv ?? _smv,
        actualCM: actualCM ?? _actualCM,
        fixedPrice: fixedPrice ?? _fixedPrice,
        commercialCharge: commercialCharge ?? _commercialCharge,
        materialCost: materialCost ?? _materialCost,
        buyingCost: buyingCost ?? _buyingCost,
        othersCost: othersCost ?? _othersCost,
        profitCostInPercent: profitCostInPercent ?? _profitCostInPercent,
        financialExpence: financialExpence ?? _financialExpence,
        totalOrderQty: totalOrderQty ?? _totalOrderQty,
        approvalId: approvalId ?? _approvalId,
        approvalTypeId: approvalTypeId ?? _approvalTypeId,
        aprrovalPolicyId: aprrovalPolicyId ?? _aprrovalPolicyId,
        approvalLevel: approvalLevel ?? _approvalLevel,
        aprrovalTypePrimaryKey:
            aprrovalTypePrimaryKey ?? _aprrovalTypePrimaryKey,
        currentApprover: currentApprover ?? _currentApprover,
      );
  num? get id => _id;
  String? get finalStatus => _finalStatus;
  String? get costingCode => _costingCode;
  num? get version => _version;
  bool? get isLock => _isLock;
  String? get createdDate => _createdDate;
  String? get createdBy => _createdBy;
  String? get submitToPerson => _submitToPerson;
  String? get buyerName => _buyerName;
  String? get styleName => _styleName;
  String? get catagoryName => _catagoryName;
  num? get materialMaxBudget => _materialMaxBudget;
  String? get styleRef => _styleRef;
  String? get qtyType => _qtyType;
  num? get qtyPerPack => _qtyPerPack;
  num? get cm => _cm;
  num? get smv => _smv;
  num? get actualCM => _actualCM;
  num? get fixedPrice => _fixedPrice;
  num? get commercialCharge => _commercialCharge;
  num? get materialCost => _materialCost;
  num? get buyingCost => _buyingCost;
  num? get othersCost => _othersCost;
  num? get profitCostInPercent => _profitCostInPercent;
  num? get financialExpence => _financialExpence;
  num? get totalOrderQty => _totalOrderQty;
  num? get approvalId => _approvalId;
  num? get approvalTypeId => _approvalTypeId;
  num? get aprrovalPolicyId => _aprrovalPolicyId;
  num? get approvalLevel => _approvalLevel;
  String? get aprrovalTypePrimaryKey => _aprrovalTypePrimaryKey;
  num? get currentApprover => _currentApprover;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ID'] = _id;
    map['FinalStatus'] = _finalStatus;
    map['CostingCode'] = _costingCode;
    map['Version'] = _version;
    map['IsLock'] = _isLock;
    map['CreatedDate'] = _createdDate;
    map['CreatedBy'] = _createdBy;
    map['SubmitToPerson'] = _submitToPerson;
    map['BuyerName'] = _buyerName;
    map['StyleName'] = _styleName;
    map['CatagoryName'] = _catagoryName;
    map['MaterialMaxBudget'] = _materialMaxBudget;
    map['StyleRef'] = _styleRef;
    map['QtyType'] = _qtyType;
    map['QtyPerPack'] = _qtyPerPack;
    map['CM'] = _cm;
    map['SMV'] = _smv;
    map['ActualCM'] = _actualCM;
    map['FixedPrice'] = _fixedPrice;
    map['CommercialCharge'] = _commercialCharge;
    map['MaterialCost'] = _materialCost;
    map['BuyingCost'] = _buyingCost;
    map['OthersCost'] = _othersCost;
    map['ProfitCostInPercent'] = _profitCostInPercent;
    map['FinancialExpence'] = _financialExpence;
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
