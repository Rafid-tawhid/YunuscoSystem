class LeaveDataModel {
  LeaveDataModel({
      String? leavePolicyType, 
      String? leaveFromDate, 
      String? leaveToDate, 
      num? leaveBalance, 
      String? reasons, 
      String? status,}){
    _leavePolicyType = leavePolicyType;
    _leaveFromDate = leaveFromDate;
    _leaveToDate = leaveToDate;
    _leaveBalance = leaveBalance;
    _reasons = reasons;
    _status = status;
}

  LeaveDataModel.fromJson(dynamic json) {
    _leavePolicyType = json['leavePolicyType'];
    _leaveFromDate = json['leaveFromDate'];
    _leaveToDate = json['leaveToDate'];
    _leaveBalance = json['leaveBalance'];
    _reasons = json['reasons'];
    _status = json['status'];
  }
  String? _leavePolicyType;
  String? _leaveFromDate;
  String? _leaveToDate;
  num? _leaveBalance;
  String? _reasons;
  String? _status;
LeaveDataModel copyWith({  String? leavePolicyType,
  String? leaveFromDate,
  String? leaveToDate,
  num? leaveBalance,
  String? reasons,
  String? status,
}) => LeaveDataModel(  leavePolicyType: leavePolicyType ?? _leavePolicyType,
  leaveFromDate: leaveFromDate ?? _leaveFromDate,
  leaveToDate: leaveToDate ?? _leaveToDate,
  leaveBalance: leaveBalance ?? _leaveBalance,
  reasons: reasons ?? _reasons,
  status: status ?? _status,
);
  String? get leavePolicyType => _leavePolicyType;
  String? get leaveFromDate => _leaveFromDate;
  String? get leaveToDate => _leaveToDate;
  num? get leaveBalance => _leaveBalance;
  String? get reasons => _reasons;
  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['leavePolicyType'] = _leavePolicyType;
    map['leaveFromDate'] = _leaveFromDate;
    map['leaveToDate'] = _leaveToDate;
    map['leaveBalance'] = _leaveBalance;
    map['reasons'] = _reasons;
    map['status'] = _status;
    return map;
  }

}