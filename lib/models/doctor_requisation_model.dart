class DoctorRequisationModel {
  DoctorRequisationModel({
      String? idCardNo, 
      String? requestDate, 
      num? status, 
      String? remarks, 
      num? urgencyType,}){
    _idCardNo = idCardNo;
    _requestDate = requestDate;
    _status = status;
    _remarks = remarks;
    _urgencyType = urgencyType;
}

  DoctorRequisationModel.fromJson(dynamic json) {
    _idCardNo = json['idCardNo'];
    _requestDate = json['requestDate'];
    _status = json['status'];
    _remarks = json['remarks'];
    _urgencyType = json['urgencyType'];
  }
  String? _idCardNo;
  String? _requestDate;
  num? _status;
  String? _remarks;
  num? _urgencyType;
DoctorRequisationModel copyWith({  String? idCardNo,
  String? requestDate,
  num? status,
  String? remarks,
  num? urgencyType,
}) => DoctorRequisationModel(  idCardNo: idCardNo ?? _idCardNo,
  requestDate: requestDate ?? _requestDate,
  status: status ?? _status,
  remarks: remarks ?? _remarks,
  urgencyType: urgencyType ?? _urgencyType,
);
  String? get idCardNo => _idCardNo;
  String? get requestDate => _requestDate;
  num? get status => _status;
  String? get remarks => _remarks;
  num? get urgencyType => _urgencyType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['idCardNo'] = _idCardNo;
    map['requestDate'] = _requestDate;
    map['status'] = _status;
    map['remarks'] = _remarks;
    map['urgencyType'] = _urgencyType;
    return map;
  }

}