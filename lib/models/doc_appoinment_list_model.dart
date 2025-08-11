class DocAppoinmentListModel {
  DocAppoinmentListModel({
      num? gateId, 
      String? idCardNo, 
      String? serialNo, 
      String? requestDate, 
      num? status, 
      String? remarks, 
      num? urgencyType, 
      String? createdDate, 
      num? createdBy, 
      dynamic updatedDate, 
      dynamic updatedBy,}){
    _gateId = gateId;
    _idCardNo = idCardNo;
    _serialNo = serialNo;
    _requestDate = requestDate;
    _status = status;
    _remarks = remarks;
    _urgencyType = urgencyType;
    _createdDate = createdDate;
    _createdBy = createdBy;
    _updatedDate = updatedDate;
    _updatedBy = updatedBy;
}

  DocAppoinmentListModel.fromJson(dynamic json) {
    _gateId = json['GateId'];
    _idCardNo = json['IdCardNo'];
    _serialNo = json['SerialNo'];
    _requestDate = json['RequestDate'];
    _status = json['Status'];
    _remarks = json['Remarks'];
    _urgencyType = json['UrgencyType'];
    _createdDate = json['CreatedDate'];
    _createdBy = json['CreatedBy'];
    _updatedDate = json['UpdatedDate'];
    _updatedBy = json['UpdatedBy'];
  }
  num? _gateId;
  String? _idCardNo;
  String? _serialNo;
  String? _requestDate;
  num? _status;
  String? _remarks;
  num? _urgencyType;
  String? _createdDate;
  num? _createdBy;
  dynamic _updatedDate;
  dynamic _updatedBy;
DocAppoinmentListModel copyWith({  num? gateId,
  String? idCardNo,
  String? serialNo,
  String? requestDate,
  num? status,
  String? remarks,
  num? urgencyType,
  String? createdDate,
  num? createdBy,
  dynamic updatedDate,
  dynamic updatedBy,
}) => DocAppoinmentListModel(  gateId: gateId ?? _gateId,
  idCardNo: idCardNo ?? _idCardNo,
  serialNo: serialNo ?? _serialNo,
  requestDate: requestDate ?? _requestDate,
  status: status ?? _status,
  remarks: remarks ?? _remarks,
  urgencyType: urgencyType ?? _urgencyType,
  createdDate: createdDate ?? _createdDate,
  createdBy: createdBy ?? _createdBy,
  updatedDate: updatedDate ?? _updatedDate,
  updatedBy: updatedBy ?? _updatedBy,
);
  num? get gateId => _gateId;
  String? get idCardNo => _idCardNo;
  String? get serialNo => _serialNo;
  String? get requestDate => _requestDate;
  num? get status => _status;
  String? get remarks => _remarks;
  num? get urgencyType => _urgencyType;
  String? get createdDate => _createdDate;
  num? get createdBy => _createdBy;
  dynamic get updatedDate => _updatedDate;
  dynamic get updatedBy => _updatedBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['GateId'] = _gateId;
    map['IdCardNo'] = _idCardNo;
    map['SerialNo'] = _serialNo;
    map['RequestDate'] = _requestDate;
    map['Status'] = _status;
    map['Remarks'] = _remarks;
    map['UrgencyType'] = _urgencyType;
    map['CreatedDate'] = _createdDate;
    map['CreatedBy'] = _createdBy;
    map['UpdatedDate'] = _updatedDate;
    map['UpdatedBy'] = _updatedBy;
    return map;
  }

}