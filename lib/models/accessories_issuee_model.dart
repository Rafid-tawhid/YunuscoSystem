class AccessoriesIssueeModel {
  AccessoriesIssueeModel({
    num? issueId,
    String? issueCode,
    num? requisitionId,
    String? requisitionCode,
    String? date,
    num? createdBy,
    String? createdDate,
    dynamic slipNo,
    bool? isReturn,
    String? remarks,
  }) {
    _issueId = issueId;
    _issueCode = issueCode;
    _requisitionId = requisitionId;
    _requisitionCode = requisitionCode;
    _date = date;
    _createdBy = createdBy;
    _createdDate = createdDate;
    _slipNo = slipNo;
    _isReturn = isReturn;
    _remarks = remarks;
  }

  AccessoriesIssueeModel.fromJson(dynamic json) {
    _issueId = json['IssueId'];
    _issueCode = json['IssueCode'];
    _requisitionId = json['RequisitionId'];
    _requisitionCode = json['RequisitionCode'];
    _date = json['Date'];
    _createdBy = json['CreatedBy'];
    _createdDate = json['CreatedDate'];
    _slipNo = json['SlipNo'];
    _isReturn = json['IsReturn'];
    _remarks = json['Remarks'];
  }

  num? _issueId;
  String? _issueCode;
  num? _requisitionId;
  String? _requisitionCode;
  String? _date;
  num? _createdBy;
  String? _createdDate;
  dynamic _slipNo;
  bool? _isReturn;
  String? _remarks;

  AccessoriesIssueeModel copyWith({
    num? issueId,
    String? issueCode,
    num? requisitionId,
    String? requisitionCode,
    String? date,
    num? createdBy,
    String? createdDate,
    dynamic slipNo,
    bool? isReturn,
    String? remarks,
  }) =>
      AccessoriesIssueeModel(
        issueId: issueId ?? _issueId,
        issueCode: issueCode ?? _issueCode,
        requisitionId: requisitionId ?? _requisitionId,
        requisitionCode: requisitionCode ?? _requisitionCode,
        date: date ?? _date,
        createdBy: createdBy ?? _createdBy,
        createdDate: createdDate ?? _createdDate,
        slipNo: slipNo ?? _slipNo,
        isReturn: isReturn ?? _isReturn,
        remarks: remarks ?? _remarks,
      );

  num? get issueId => _issueId;
  String? get issueCode => _issueCode;
  num? get requisitionId => _requisitionId;
  String? get requisitionCode => _requisitionCode;
  String? get date => _date;
  num? get createdBy => _createdBy;
  String? get createdDate => _createdDate;
  dynamic get slipNo => _slipNo;
  bool? get isReturn => _isReturn;
  String? get remarks => _remarks;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['IssueId'] = _issueId;
    map['IssueCode'] = _issueCode;
    map['RequisitionId'] = _requisitionId;
    map['RequisitionCode'] = _requisitionCode;
    map['Date'] = _date;
    map['CreatedBy'] = _createdBy;
    map['CreatedDate'] = _createdDate;
    map['SlipNo'] = _slipNo;
    map['IsReturn'] = _isReturn;
    map['Remarks'] = _remarks;
    return map;
  }

  // Helper method to check if slipNo is not null
  bool get hasSlipNo => slipNo != null;

  // Helper method to check if remarks is not empty
  bool get hasRemarks => remarks != null && remarks!.isNotEmpty;
}