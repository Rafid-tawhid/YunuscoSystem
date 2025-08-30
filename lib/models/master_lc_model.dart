class MasterLcModel {
  MasterLcModel({
    num? masterLCId,
    num? version,
    String? masterLCNo,
    dynamic issueDate,
    dynamic shipDate,
    dynamic expiryDate,
    dynamic issueDateStr,
    dynamic shipDateStr,
    dynamic expiryDateStr,
    num? tenorId,
    dynamic tenorStr,
    num? shipmentModeId,
    dynamic shipmentModeStr,
    dynamic salesTerms,
    num? buyerId,
    dynamic lienRefNo,
    num? bankNameId,
    dynamic bankName,
    String? poScLcNo,
    num? eXIMStatusId,
    dynamic eXIMStatus,
    num? sCAmount,
    num? masterLCAmount,
    num? btBPercent,
    num? roam,
    num? orderQty,
    num? unitPrice,
    String? masterLCCode,
    String? buyerName,
    num? amendAmount,
    num? amendQty,
    num? amendAmountIncDec,
    num? amendQtyIncDec,
    String? amndDate,
    dynamic bLAmendNo,
    dynamic repAmendNo,
    dynamic remark,
    dynamic remainingAmount,
    dynamic totalAmountUsedForBTBFTTFDD,
    dynamic usedForBTBAmount,
    dynamic usedForBTBPercentage,
    dynamic usedForFDDAmount,
    dynamic usedForFDDPercentage,
    dynamic usedForFTTAmount,
    dynamic usedForFTTPercentage,
    String? createdDateStr,
  }) {
    _masterLCId = masterLCId;
    _version = version;
    _masterLCNo = masterLCNo;
    _issueDate = issueDate;
    _shipDate = shipDate;
    _expiryDate = expiryDate;
    _issueDateStr = issueDateStr;
    _shipDateStr = shipDateStr;
    _expiryDateStr = expiryDateStr;
    _tenorId = tenorId;
    _tenorStr = tenorStr;
    _shipmentModeId = shipmentModeId;
    _shipmentModeStr = shipmentModeStr;
    _salesTerms = salesTerms;
    _buyerId = buyerId;
    _lienRefNo = lienRefNo;
    _bankNameId = bankNameId;
    _bankName = bankName;
    _poScLcNo = poScLcNo;
    _eXIMStatusId = eXIMStatusId;
    _eXIMStatus = eXIMStatus;
    _sCAmount = sCAmount;
    _masterLCAmount = masterLCAmount;
    _btBPercent = btBPercent;
    _roam = roam;
    _orderQty = orderQty;
    _unitPrice = unitPrice;
    _masterLCCode = masterLCCode;
    _buyerName = buyerName;
    _amendAmount = amendAmount;
    _amendQty = amendQty;
    _amendAmountIncDec = amendAmountIncDec;
    _amendQtyIncDec = amendQtyIncDec;
    _amndDate = amndDate;
    _bLAmendNo = bLAmendNo;
    _repAmendNo = repAmendNo;
    _remark = remark;
    _remainingAmount = remainingAmount;
    _totalAmountUsedForBTBFTTFDD = totalAmountUsedForBTBFTTFDD;
    _usedForBTBAmount = usedForBTBAmount;
    _usedForBTBPercentage = usedForBTBPercentage;
    _usedForFDDAmount = usedForFDDAmount;
    _usedForFDDPercentage = usedForFDDPercentage;
    _usedForFTTAmount = usedForFTTAmount;
    _usedForFTTPercentage = usedForFTTPercentage;
    _createdDateStr = createdDateStr;
  }

  MasterLcModel.fromJson(dynamic json) {
    _masterLCId = json['MasterLCId'];
    _version = json['Version'];
    _masterLCNo = json['MasterLCNo'];
    _issueDate = json['IssueDate'];
    _shipDate = json['ShipDate'];
    _expiryDate = json['ExpiryDate'];
    _issueDateStr = json['IssueDateStr'];
    _shipDateStr = json['ShipDateStr'];
    _expiryDateStr = json['ExpiryDateStr'];
    _tenorId = json['TenorId'];
    _tenorStr = json['TenorStr'];
    _shipmentModeId = json['ShipmentModeId'];
    _shipmentModeStr = json['ShipmentModeStr'];
    _salesTerms = json['SalesTerms'];
    _buyerId = json['BuyerId'];
    _lienRefNo = json['LienRefNo'];
    _bankNameId = json['BankNameId'];
    _bankName = json['BankName'];
    _poScLcNo = json['PoScLcNo'];
    _eXIMStatusId = json['EXIMStatusId'];
    _eXIMStatus = json['EXIMStatus'];
    _sCAmount = json['SCAmount'];
    _masterLCAmount = json['MasterLCAmount'];
    _btBPercent = json['BtBPercent'];
    _roam = json['Roam'];
    _orderQty = json['OrderQty'];
    _unitPrice = json['UnitPrice'];
    _masterLCCode = json['MasterLCCode'];
    _buyerName = json['BuyerName'];
    _amendAmount = json['AmendAmount'];
    _amendQty = json['AmendQty'];
    _amendAmountIncDec = json['AmendAmountIncDec'];
    _amendQtyIncDec = json['AmendQtyIncDec'];
    _amndDate = json['AmndDate'];
    _bLAmendNo = json['BLAmendNo'];
    _repAmendNo = json['RepAmendNo'];
    _remark = json['Remark'];
    _remainingAmount = json['RemainingAmount'];
    _totalAmountUsedForBTBFTTFDD = json['TotalAmountUsedFor_BTB_FTT_FDD'];
    _usedForBTBAmount = json['UsedForBTB_Amount'];
    _usedForBTBPercentage = json['UsedForBTB_Percentage'];
    _usedForFDDAmount = json['UsedForFDD_Amount'];
    _usedForFDDPercentage = json['UsedForFDD_Percentage'];
    _usedForFTTAmount = json['UsedForFTT_Amount'];
    _usedForFTTPercentage = json['UsedForFTT_Percentage'];
    _createdDateStr = json['created_date_str'];
  }
  num? _masterLCId;
  num? _version;
  String? _masterLCNo;
  dynamic _issueDate;
  dynamic _shipDate;
  dynamic _expiryDate;
  dynamic _issueDateStr;
  dynamic _shipDateStr;
  dynamic _expiryDateStr;
  num? _tenorId;
  dynamic _tenorStr;
  num? _shipmentModeId;
  dynamic _shipmentModeStr;
  dynamic _salesTerms;
  num? _buyerId;
  dynamic _lienRefNo;
  num? _bankNameId;
  dynamic _bankName;
  String? _poScLcNo;
  num? _eXIMStatusId;
  dynamic _eXIMStatus;
  num? _sCAmount;
  num? _masterLCAmount;
  num? _btBPercent;
  num? _roam;
  num? _orderQty;
  num? _unitPrice;
  String? _masterLCCode;
  String? _buyerName;
  num? _amendAmount;
  num? _amendQty;
  num? _amendAmountIncDec;
  num? _amendQtyIncDec;
  String? _amndDate;
  dynamic _bLAmendNo;
  dynamic _repAmendNo;
  dynamic _remark;
  dynamic _remainingAmount;
  dynamic _totalAmountUsedForBTBFTTFDD;
  dynamic _usedForBTBAmount;
  dynamic _usedForBTBPercentage;
  dynamic _usedForFDDAmount;
  dynamic _usedForFDDPercentage;
  dynamic _usedForFTTAmount;
  dynamic _usedForFTTPercentage;
  String? _createdDateStr;
  MasterLcModel copyWith({
    num? masterLCId,
    num? version,
    String? masterLCNo,
    dynamic issueDate,
    dynamic shipDate,
    dynamic expiryDate,
    dynamic issueDateStr,
    dynamic shipDateStr,
    dynamic expiryDateStr,
    num? tenorId,
    dynamic tenorStr,
    num? shipmentModeId,
    dynamic shipmentModeStr,
    dynamic salesTerms,
    num? buyerId,
    dynamic lienRefNo,
    num? bankNameId,
    dynamic bankName,
    String? poScLcNo,
    num? eXIMStatusId,
    dynamic eXIMStatus,
    num? sCAmount,
    num? masterLCAmount,
    num? btBPercent,
    num? roam,
    num? orderQty,
    num? unitPrice,
    String? masterLCCode,
    String? buyerName,
    num? amendAmount,
    num? amendQty,
    num? amendAmountIncDec,
    num? amendQtyIncDec,
    String? amndDate,
    dynamic bLAmendNo,
    dynamic repAmendNo,
    dynamic remark,
    dynamic remainingAmount,
    dynamic totalAmountUsedForBTBFTTFDD,
    dynamic usedForBTBAmount,
    dynamic usedForBTBPercentage,
    dynamic usedForFDDAmount,
    dynamic usedForFDDPercentage,
    dynamic usedForFTTAmount,
    dynamic usedForFTTPercentage,
    String? createdDateStr,
  }) =>
      MasterLcModel(
        masterLCId: masterLCId ?? _masterLCId,
        version: version ?? _version,
        masterLCNo: masterLCNo ?? _masterLCNo,
        issueDate: issueDate ?? _issueDate,
        shipDate: shipDate ?? _shipDate,
        expiryDate: expiryDate ?? _expiryDate,
        issueDateStr: issueDateStr ?? _issueDateStr,
        shipDateStr: shipDateStr ?? _shipDateStr,
        expiryDateStr: expiryDateStr ?? _expiryDateStr,
        tenorId: tenorId ?? _tenorId,
        tenorStr: tenorStr ?? _tenorStr,
        shipmentModeId: shipmentModeId ?? _shipmentModeId,
        shipmentModeStr: shipmentModeStr ?? _shipmentModeStr,
        salesTerms: salesTerms ?? _salesTerms,
        buyerId: buyerId ?? _buyerId,
        lienRefNo: lienRefNo ?? _lienRefNo,
        bankNameId: bankNameId ?? _bankNameId,
        bankName: bankName ?? _bankName,
        poScLcNo: poScLcNo ?? _poScLcNo,
        eXIMStatusId: eXIMStatusId ?? _eXIMStatusId,
        eXIMStatus: eXIMStatus ?? _eXIMStatus,
        sCAmount: sCAmount ?? _sCAmount,
        masterLCAmount: masterLCAmount ?? _masterLCAmount,
        btBPercent: btBPercent ?? _btBPercent,
        roam: roam ?? _roam,
        orderQty: orderQty ?? _orderQty,
        unitPrice: unitPrice ?? _unitPrice,
        masterLCCode: masterLCCode ?? _masterLCCode,
        buyerName: buyerName ?? _buyerName,
        amendAmount: amendAmount ?? _amendAmount,
        amendQty: amendQty ?? _amendQty,
        amendAmountIncDec: amendAmountIncDec ?? _amendAmountIncDec,
        amendQtyIncDec: amendQtyIncDec ?? _amendQtyIncDec,
        amndDate: amndDate ?? _amndDate,
        bLAmendNo: bLAmendNo ?? _bLAmendNo,
        repAmendNo: repAmendNo ?? _repAmendNo,
        remark: remark ?? _remark,
        remainingAmount: remainingAmount ?? _remainingAmount,
        totalAmountUsedForBTBFTTFDD:
            totalAmountUsedForBTBFTTFDD ?? _totalAmountUsedForBTBFTTFDD,
        usedForBTBAmount: usedForBTBAmount ?? _usedForBTBAmount,
        usedForBTBPercentage: usedForBTBPercentage ?? _usedForBTBPercentage,
        usedForFDDAmount: usedForFDDAmount ?? _usedForFDDAmount,
        usedForFDDPercentage: usedForFDDPercentage ?? _usedForFDDPercentage,
        usedForFTTAmount: usedForFTTAmount ?? _usedForFTTAmount,
        usedForFTTPercentage: usedForFTTPercentage ?? _usedForFTTPercentage,
        createdDateStr: createdDateStr ?? _createdDateStr,
      );
  num? get masterLCId => _masterLCId;
  num? get version => _version;
  String? get masterLCNo => _masterLCNo;
  dynamic get issueDate => _issueDate;
  dynamic get shipDate => _shipDate;
  dynamic get expiryDate => _expiryDate;
  dynamic get issueDateStr => _issueDateStr;
  dynamic get shipDateStr => _shipDateStr;
  dynamic get expiryDateStr => _expiryDateStr;
  num? get tenorId => _tenorId;
  dynamic get tenorStr => _tenorStr;
  num? get shipmentModeId => _shipmentModeId;
  dynamic get shipmentModeStr => _shipmentModeStr;
  dynamic get salesTerms => _salesTerms;
  num? get buyerId => _buyerId;
  dynamic get lienRefNo => _lienRefNo;
  num? get bankNameId => _bankNameId;
  dynamic get bankName => _bankName;
  String? get poScLcNo => _poScLcNo;
  num? get eXIMStatusId => _eXIMStatusId;
  dynamic get eXIMStatus => _eXIMStatus;
  num? get sCAmount => _sCAmount;
  num? get masterLCAmount => _masterLCAmount;
  num? get btBPercent => _btBPercent;
  num? get roam => _roam;
  num? get orderQty => _orderQty;
  num? get unitPrice => _unitPrice;
  String? get masterLCCode => _masterLCCode;
  String? get buyerName => _buyerName;
  num? get amendAmount => _amendAmount;
  num? get amendQty => _amendQty;
  num? get amendAmountIncDec => _amendAmountIncDec;
  num? get amendQtyIncDec => _amendQtyIncDec;
  String? get amndDate => _amndDate;
  dynamic get bLAmendNo => _bLAmendNo;
  dynamic get repAmendNo => _repAmendNo;
  dynamic get remark => _remark;
  dynamic get remainingAmount => _remainingAmount;
  dynamic get totalAmountUsedForBTBFTTFDD => _totalAmountUsedForBTBFTTFDD;
  dynamic get usedForBTBAmount => _usedForBTBAmount;
  dynamic get usedForBTBPercentage => _usedForBTBPercentage;
  dynamic get usedForFDDAmount => _usedForFDDAmount;
  dynamic get usedForFDDPercentage => _usedForFDDPercentage;
  dynamic get usedForFTTAmount => _usedForFTTAmount;
  dynamic get usedForFTTPercentage => _usedForFTTPercentage;
  String? get createdDateStr => _createdDateStr;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['MasterLCId'] = _masterLCId;
    map['Version'] = _version;
    map['MasterLCNo'] = _masterLCNo;
    map['IssueDate'] = _issueDate;
    map['ShipDate'] = _shipDate;
    map['ExpiryDate'] = _expiryDate;
    map['IssueDateStr'] = _issueDateStr;
    map['ShipDateStr'] = _shipDateStr;
    map['ExpiryDateStr'] = _expiryDateStr;
    map['TenorId'] = _tenorId;
    map['TenorStr'] = _tenorStr;
    map['ShipmentModeId'] = _shipmentModeId;
    map['ShipmentModeStr'] = _shipmentModeStr;
    map['SalesTerms'] = _salesTerms;
    map['BuyerId'] = _buyerId;
    map['LienRefNo'] = _lienRefNo;
    map['BankNameId'] = _bankNameId;
    map['BankName'] = _bankName;
    map['PoScLcNo'] = _poScLcNo;
    map['EXIMStatusId'] = _eXIMStatusId;
    map['EXIMStatus'] = _eXIMStatus;
    map['SCAmount'] = _sCAmount;
    map['MasterLCAmount'] = _masterLCAmount;
    map['BtBPercent'] = _btBPercent;
    map['Roam'] = _roam;
    map['OrderQty'] = _orderQty;
    map['UnitPrice'] = _unitPrice;
    map['MasterLCCode'] = _masterLCCode;
    map['BuyerName'] = _buyerName;
    map['AmendAmount'] = _amendAmount;
    map['AmendQty'] = _amendQty;
    map['AmendAmountIncDec'] = _amendAmountIncDec;
    map['AmendQtyIncDec'] = _amendQtyIncDec;
    map['AmndDate'] = _amndDate;
    map['BLAmendNo'] = _bLAmendNo;
    map['RepAmendNo'] = _repAmendNo;
    map['Remark'] = _remark;
    map['RemainingAmount'] = _remainingAmount;
    map['TotalAmountUsedFor_BTB_FTT_FDD'] = _totalAmountUsedForBTBFTTFDD;
    map['UsedForBTB_Amount'] = _usedForBTBAmount;
    map['UsedForBTB_Percentage'] = _usedForBTBPercentage;
    map['UsedForFDD_Amount'] = _usedForFDDAmount;
    map['UsedForFDD_Percentage'] = _usedForFDDPercentage;
    map['UsedForFTT_Amount'] = _usedForFTTAmount;
    map['UsedForFTT_Percentage'] = _usedForFTTPercentage;
    map['created_date_str'] = _createdDateStr;
    return map;
  }
}
