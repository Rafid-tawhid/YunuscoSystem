class SingleEmpLeaveHistoryModel {
  SingleEmpLeaveHistoryModel({
    dynamic idCardNo,
    String? leavePolicyType,
    num? userId,
    String? leaveFromDate,
    String? leaveToDate,
    num? leaveType,
    num? leaveBalance,
    String? reasons,
    String? status,
    num? remainingLeaveDay,
    num? policyId,
    bool? isFirst,
  }) {
    _idCardNo = idCardNo;
    _leavePolicyType = leavePolicyType;
    _userId = userId;
    _leaveFromDate = leaveFromDate;
    _leaveToDate = leaveToDate;
    _leaveType = leaveType;
    _leaveBalance = leaveBalance;
    _reasons = reasons;
    _status = status;
    _remainingLeaveDay = remainingLeaveDay;
    _policyId = policyId;
    _isFirst = isFirst;
  }

  SingleEmpLeaveHistoryModel.fromJson(dynamic json) {
    _idCardNo = json['IdCardNo'];
    _leavePolicyType = json['LeavePolicyType'];
    _userId = json['UserId'];
    _leaveFromDate = json['LeaveFromDate'];
    _leaveToDate = json['LeaveToDate'];
    _leaveType = json['LeaveType'];
    _leaveBalance = json['LeaveBalance'];
    _reasons = json['Reasons'];
    _status = json['Status'];
    _remainingLeaveDay = json['remainingLeaveDay'];
    _policyId = json['policyId'];
    _isFirst = json['IsFirst'];
  }
  dynamic _idCardNo;
  String? _leavePolicyType;
  num? _userId;
  String? _leaveFromDate;
  String? _leaveToDate;
  num? _leaveType;
  num? _leaveBalance;
  String? _reasons;
  String? _status;
  num? _remainingLeaveDay;
  num? _policyId;
  bool? _isFirst;
  SingleEmpLeaveHistoryModel copyWith({
    dynamic idCardNo,
    String? leavePolicyType,
    num? userId,
    String? leaveFromDate,
    String? leaveToDate,
    num? leaveType,
    num? leaveBalance,
    String? reasons,
    String? status,
    num? remainingLeaveDay,
    num? policyId,
    bool? isFirst,
  }) =>
      SingleEmpLeaveHistoryModel(
        idCardNo: idCardNo ?? _idCardNo,
        leavePolicyType: leavePolicyType ?? _leavePolicyType,
        userId: userId ?? _userId,
        leaveFromDate: leaveFromDate ?? _leaveFromDate,
        leaveToDate: leaveToDate ?? _leaveToDate,
        leaveType: leaveType ?? _leaveType,
        leaveBalance: leaveBalance ?? _leaveBalance,
        reasons: reasons ?? _reasons,
        status: status ?? _status,
        remainingLeaveDay: remainingLeaveDay ?? _remainingLeaveDay,
        policyId: policyId ?? _policyId,
        isFirst: isFirst ?? _isFirst,
      );
  dynamic get idCardNo => _idCardNo;
  String? get leavePolicyType => _leavePolicyType;
  num? get userId => _userId;
  String? get leaveFromDate => _leaveFromDate;
  String? get leaveToDate => _leaveToDate;
  num? get leaveType => _leaveType;
  num? get leaveBalance => _leaveBalance;
  String? get reasons => _reasons;
  String? get status => _status;
  num? get remainingLeaveDay => _remainingLeaveDay;
  num? get policyId => _policyId;
  bool? get isFirst => _isFirst;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['IdCardNo'] = _idCardNo;
    map['LeavePolicyType'] = _leavePolicyType;
    map['UserId'] = _userId;
    map['LeaveFromDate'] = _leaveFromDate;
    map['LeaveToDate'] = _leaveToDate;
    map['LeaveType'] = _leaveType;
    map['LeaveBalance'] = _leaveBalance;
    map['Reasons'] = _reasons;
    map['Status'] = _status;
    map['remainingLeaveDay'] = _remainingLeaveDay;
    map['policyId'] = _policyId;
    map['IsFirst'] = _isFirst;
    return map;
  }
}
