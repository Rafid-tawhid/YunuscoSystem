class DocAppoinmentListModel {
  DocAppoinmentListModel({
      num? gateId, 
      String? fullName, 
      String? idCardNo, 
      String? requestDate, 
      String? createdDate, 
      String? serialNo, 
      num? status, 
      num? urgencyType, 
      dynamic gatePassStatus, 
      String? remarks, 
      num? createdBy,}){
    _gateId = gateId;
    _fullName = fullName;
    _idCardNo = idCardNo;
    _requestDate = requestDate;
    _createdDate = createdDate;
    _serialNo = serialNo;
    _status = status;
    _urgencyType = urgencyType;
    _gatePassStatus = gatePassStatus;
    _remarks = remarks;
    _createdBy = createdBy;
}

  DocAppoinmentListModel.fromJson(dynamic json) {
    _gateId = json['PrescriptionId'];
    _fullName = json['FullName'];
    _idCardNo = json['IdCardNo'];
    _requestDate = json['RequestDate'];
    _createdDate = json['CreatedDate'];
    _serialNo = json['SerialNo'];
    _status = json['Status'];
    _urgencyType = json['UrgencyType'];
    _gatePassStatus = json['GatePassStatus']??0;
    _remarks = json['Remarks'];
    _createdBy = json['CreatedBy'];
  }
  num? _gateId;
  String? _fullName;
  String? _idCardNo;
  String? _requestDate;
  String? _createdDate;
  String? _serialNo;
  num? _status;
  num? _urgencyType;
  dynamic _gatePassStatus;
  String? _remarks;
  num? _createdBy;
DocAppoinmentListModel copyWith({  num? gateId,
  String? fullName,
  String? idCardNo,
  String? requestDate,
  String? createdDate,
  String? serialNo,
  num? status,
  num? urgencyType,
  dynamic gatePassStatus,
  String? remarks,
  num? createdBy,
}) => DocAppoinmentListModel(  gateId: gateId ?? _gateId,
  fullName: fullName ?? _fullName,
  idCardNo: idCardNo ?? _idCardNo,
  requestDate: requestDate ?? _requestDate,
  createdDate: createdDate ?? _createdDate,
  serialNo: serialNo ?? _serialNo,
  status: status ?? _status,
  urgencyType: urgencyType ?? _urgencyType,
  gatePassStatus: gatePassStatus ?? _gatePassStatus,
  remarks: remarks ?? _remarks,
  createdBy: createdBy ?? _createdBy,
);
  num? get gateId => _gateId;
  String? get fullName => _fullName;
  String? get idCardNo => _idCardNo;
  String? get requestDate => _requestDate;
  String? get createdDate => _createdDate;
  String? get serialNo => _serialNo;
  num? get status => _status;
  num? get urgencyType => _urgencyType;
  dynamic get gatePassStatus => _gatePassStatus;
  String? get remarks => _remarks;
  num? get createdBy => _createdBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['PrescriptionId'] = _gateId;
    map['FullName'] = _fullName;
    map['IdCardNo'] = _idCardNo;
    map['RequestDate'] = _requestDate;
    map['CreatedDate'] = _createdDate;
    map['SerialNo'] = _serialNo;
    map['Status'] = _status;
    map['UrgencyType'] = _urgencyType;
    map['GatePassStatus'] = _gatePassStatus;
    map['Remarks'] = _remarks;
    map['CreatedBy'] = _createdBy;
    return map;
  }

}