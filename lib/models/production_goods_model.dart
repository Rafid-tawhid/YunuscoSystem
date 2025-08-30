class ProductionGoodsModel {
  ProductionGoodsModel({
    num? requisitionId,
    String? requisitionCode,
    dynamic fromSection,
    dynamic fromEmployee,
    String? remarks,
    dynamic isSubContanct,
    dynamic supplierId,
    dynamic floorUnitId,
    dynamic floorLineId,
    String? batchNo,
    dynamic refNo,
    String? buyerOrderCode,
    dynamic masterOrderCode,
    num? buyerId,
    String? styleCode,
    dynamic requisitionSection,
    dynamic colorCode,
    String? bomcode,
    dynamic supplierId1,
    dynamic styleRef,
    dynamic requisitionStatus,
    dynamic approvalFieldCode,
    String? buyerPo,
    num? createdBy,
    String? createdDate,
    dynamic modifiedBy,
    dynamic modifiedDate,
    bool? isIssued,
    bool? partiallyIssued,
    dynamic requisitionForId,
    String? styleNumber,
  }) {
    _requisitionId = requisitionId;
    _requisitionCode = requisitionCode;
    _fromSection = fromSection;
    _fromEmployee = fromEmployee;
    _remarks = remarks;
    _isSubContanct = isSubContanct;
    _supplierId = supplierId;
    _floorUnitId = floorUnitId;
    _floorLineId = floorLineId;
    _batchNo = batchNo;
    _refNo = refNo;
    _buyerOrderCode = buyerOrderCode;
    _masterOrderCode = masterOrderCode;
    _buyerId = buyerId;
    _styleCode = styleCode;
    _requisitionSection = requisitionSection;
    _colorCode = colorCode;
    _bomcode = bomcode;
    _supplierId1 = supplierId1;
    _styleRef = styleRef;
    _requisitionStatus = requisitionStatus;
    _approvalFieldCode = approvalFieldCode;
    _buyerPo = buyerPo;
    _createdBy = createdBy;
    _createdDate = createdDate;
    _modifiedBy = modifiedBy;
    _modifiedDate = modifiedDate;
    _isIssued = isIssued;
    _partiallyIssued = partiallyIssued;
    _requisitionForId = requisitionForId;
    _styleNumber = styleNumber;
  }

  ProductionGoodsModel.fromJson(dynamic json) {
    _requisitionId = json['RequisitionId'];
    _requisitionCode = json['RequisitionCode'];
    _fromSection = json['FromSection'];
    _fromEmployee = json['FromEmployee'];
    _remarks = json['Remarks'];
    _isSubContanct = json['IsSubContanct'];
    _supplierId = json['SupplierId'];
    _floorUnitId = json['FloorUnitId'];
    _floorLineId = json['FloorLineId'];
    _batchNo = json['BatchNo'];
    _refNo = json['RefNo'];
    _buyerOrderCode = json['BuyerOrderCode'];
    _masterOrderCode = json['MasterOrderCode'];
    _buyerId = json['BuyerId'];
    _styleCode = json['StyleCode'];
    _requisitionSection = json['RequisitionSection'];
    _colorCode = json['ColorCode'];
    _bomcode = json['Bomcode'];
    _supplierId1 = json['SupplierId1'];
    _styleRef = json['StyleRef'];
    _requisitionStatus = json['RequisitionStatus'];
    _approvalFieldCode = json['ApprovalFieldCode'];
    _buyerPo = json['BuyerPo'];
    _createdBy = json['CreatedBy'];
    _createdDate = json['CreatedDate'];
    _modifiedBy = json['ModifiedBy'];
    _modifiedDate = json['ModifiedDate'];
    _isIssued = json['IsIssued'];
    _partiallyIssued = json['PartiallyIssued'];
    _requisitionForId = json['RequisitionForId'];
    _styleNumber = json['StyleNumber'];
  }
  num? _requisitionId;
  String? _requisitionCode;
  dynamic _fromSection;
  dynamic _fromEmployee;
  String? _remarks;
  dynamic _isSubContanct;
  dynamic _supplierId;
  dynamic _floorUnitId;
  dynamic _floorLineId;
  String? _batchNo;
  dynamic _refNo;
  String? _buyerOrderCode;
  dynamic _masterOrderCode;
  num? _buyerId;
  String? _styleCode;
  dynamic _requisitionSection;
  dynamic _colorCode;
  String? _bomcode;
  dynamic _supplierId1;
  dynamic _styleRef;
  dynamic _requisitionStatus;
  dynamic _approvalFieldCode;
  String? _buyerPo;
  num? _createdBy;
  String? _createdDate;
  dynamic _modifiedBy;
  dynamic _modifiedDate;
  bool? _isIssued;
  bool? _partiallyIssued;
  dynamic _requisitionForId;
  String? _styleNumber;
  ProductionGoodsModel copyWith({
    num? requisitionId,
    String? requisitionCode,
    dynamic fromSection,
    dynamic fromEmployee,
    String? remarks,
    dynamic isSubContanct,
    dynamic supplierId,
    dynamic floorUnitId,
    dynamic floorLineId,
    String? batchNo,
    dynamic refNo,
    String? buyerOrderCode,
    dynamic masterOrderCode,
    num? buyerId,
    String? styleCode,
    dynamic requisitionSection,
    dynamic colorCode,
    String? bomcode,
    dynamic supplierId1,
    dynamic styleRef,
    dynamic requisitionStatus,
    dynamic approvalFieldCode,
    String? buyerPo,
    num? createdBy,
    String? createdDate,
    dynamic modifiedBy,
    dynamic modifiedDate,
    bool? isIssued,
    bool? partiallyIssued,
    dynamic requisitionForId,
    String? styleNumber,
  }) =>
      ProductionGoodsModel(
        requisitionId: requisitionId ?? _requisitionId,
        requisitionCode: requisitionCode ?? _requisitionCode,
        fromSection: fromSection ?? _fromSection,
        fromEmployee: fromEmployee ?? _fromEmployee,
        remarks: remarks ?? _remarks,
        isSubContanct: isSubContanct ?? _isSubContanct,
        supplierId: supplierId ?? _supplierId,
        floorUnitId: floorUnitId ?? _floorUnitId,
        floorLineId: floorLineId ?? _floorLineId,
        batchNo: batchNo ?? _batchNo,
        refNo: refNo ?? _refNo,
        buyerOrderCode: buyerOrderCode ?? _buyerOrderCode,
        masterOrderCode: masterOrderCode ?? _masterOrderCode,
        buyerId: buyerId ?? _buyerId,
        styleCode: styleCode ?? _styleCode,
        requisitionSection: requisitionSection ?? _requisitionSection,
        colorCode: colorCode ?? _colorCode,
        bomcode: bomcode ?? _bomcode,
        supplierId1: supplierId1 ?? _supplierId1,
        styleRef: styleRef ?? _styleRef,
        requisitionStatus: requisitionStatus ?? _requisitionStatus,
        approvalFieldCode: approvalFieldCode ?? _approvalFieldCode,
        buyerPo: buyerPo ?? _buyerPo,
        createdBy: createdBy ?? _createdBy,
        createdDate: createdDate ?? _createdDate,
        modifiedBy: modifiedBy ?? _modifiedBy,
        modifiedDate: modifiedDate ?? _modifiedDate,
        isIssued: isIssued ?? _isIssued,
        partiallyIssued: partiallyIssued ?? _partiallyIssued,
        requisitionForId: requisitionForId ?? _requisitionForId,
        styleNumber: styleNumber ?? _styleNumber,
      );
  num? get requisitionId => _requisitionId;
  String? get requisitionCode => _requisitionCode;
  dynamic get fromSection => _fromSection;
  dynamic get fromEmployee => _fromEmployee;
  String? get remarks => _remarks;
  dynamic get isSubContanct => _isSubContanct;
  dynamic get supplierId => _supplierId;
  dynamic get floorUnitId => _floorUnitId;
  dynamic get floorLineId => _floorLineId;
  String? get batchNo => _batchNo;
  dynamic get refNo => _refNo;
  String? get buyerOrderCode => _buyerOrderCode;
  dynamic get masterOrderCode => _masterOrderCode;
  num? get buyerId => _buyerId;
  String? get styleCode => _styleCode;
  dynamic get requisitionSection => _requisitionSection;
  dynamic get colorCode => _colorCode;
  String? get bomcode => _bomcode;
  dynamic get supplierId1 => _supplierId1;
  dynamic get styleRef => _styleRef;
  dynamic get requisitionStatus => _requisitionStatus;
  dynamic get approvalFieldCode => _approvalFieldCode;
  String? get buyerPo => _buyerPo;
  num? get createdBy => _createdBy;
  String? get createdDate => _createdDate;
  dynamic get modifiedBy => _modifiedBy;
  dynamic get modifiedDate => _modifiedDate;
  bool? get isIssued => _isIssued;
  bool? get partiallyIssued => _partiallyIssued;
  dynamic get requisitionForId => _requisitionForId;
  String? get styleNumber => _styleNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['RequisitionId'] = _requisitionId;
    map['RequisitionCode'] = _requisitionCode;
    map['FromSection'] = _fromSection;
    map['FromEmployee'] = _fromEmployee;
    map['Remarks'] = _remarks;
    map['IsSubContanct'] = _isSubContanct;
    map['SupplierId'] = _supplierId;
    map['FloorUnitId'] = _floorUnitId;
    map['FloorLineId'] = _floorLineId;
    map['BatchNo'] = _batchNo;
    map['RefNo'] = _refNo;
    map['BuyerOrderCode'] = _buyerOrderCode;
    map['MasterOrderCode'] = _masterOrderCode;
    map['BuyerId'] = _buyerId;
    map['StyleCode'] = _styleCode;
    map['RequisitionSection'] = _requisitionSection;
    map['ColorCode'] = _colorCode;
    map['Bomcode'] = _bomcode;
    map['SupplierId1'] = _supplierId1;
    map['StyleRef'] = _styleRef;
    map['RequisitionStatus'] = _requisitionStatus;
    map['ApprovalFieldCode'] = _approvalFieldCode;
    map['BuyerPo'] = _buyerPo;
    map['CreatedBy'] = _createdBy;
    map['CreatedDate'] = _createdDate;
    map['ModifiedBy'] = _modifiedBy;
    map['ModifiedDate'] = _modifiedDate;
    map['IsIssued'] = _isIssued;
    map['PartiallyIssued'] = _partiallyIssued;
    map['RequisitionForId'] = _requisitionForId;
    map['StyleNumber'] = _styleNumber;
    return map;
  }
}
