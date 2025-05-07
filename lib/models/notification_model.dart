class NotificationModel {
  NotificationModel({
      String? employeeIdCardNo, 
      String? applaiedForEmployee, 
      String? departmentName, 
      String? joiningDate, 
      String? leaveFromDate, 
      String? leaveToDate, 
      String? leaveCreationDate, 
      String? leaveType, 
      String? reasons, 
      num? dayCount, 
      num? sl, 
      num? el, 
      num? cl, 
      String? leavePolicyType, 
      String? appliedByName, 
      String? passedByName, 
      String? leaveStatus, 
      num? currentApprover,}){
    _employeeIdCardNo = employeeIdCardNo;
    _applaiedForEmployee = applaiedForEmployee;
    _departmentName = departmentName;
    _joiningDate = joiningDate;
    _leaveFromDate = leaveFromDate;
    _leaveToDate = leaveToDate;
    _leaveCreationDate = leaveCreationDate;
    _leaveType = leaveType;
    _reasons = reasons;
    _dayCount = dayCount;
    _sl = sl;
    _el = el;
    _cl = cl;
    _leavePolicyType = leavePolicyType;
    _appliedByName = appliedByName;
    _passedByName = passedByName;
    _leaveStatus = leaveStatus;
    _currentApprover = currentApprover;
}

  NotificationModel.fromJson(dynamic json) {
    _employeeIdCardNo = json['EmployeeIdCardNo'];
    _applaiedForEmployee = json['ApplaiedForEmployee'];
    _departmentName = json['DepartmentName'];
    _joiningDate = json['JoiningDate'];
    _leaveFromDate = json['LeaveFromDate'];
    _leaveToDate = json['LeaveToDate'];
    _leaveCreationDate = json['LeaveCreationDate'];
    _leaveType = json['LeaveType'];
    _reasons = json['Reasons'];
    _dayCount = json['DayCount'];
    _sl = json['SL'];
    _el = json['EL'];
    _cl = json['CL'];
    _leavePolicyType = json['LeavePolicyType'];
    _appliedByName = json['AppliedByName'];
    _passedByName = json['PassedByName'];
    _leaveStatus = json['LeaveStatus'];
    _currentApprover = json['CurrentApprover'];
  }
  String? _employeeIdCardNo;
  String? _applaiedForEmployee;
  String? _departmentName;
  String? _joiningDate;
  String? _leaveFromDate;
  String? _leaveToDate;
  String? _leaveCreationDate;
  String? _leaveType;
  String? _reasons;
  num? _dayCount;
  num? _sl;
  num? _el;
  num? _cl;
  String? _leavePolicyType;
  String? _appliedByName;
  String? _passedByName;
  String? _leaveStatus;
  num? _currentApprover;
NotificationModel copyWith({  String? employeeIdCardNo,
  String? applaiedForEmployee,
  String? departmentName,
  String? joiningDate,
  String? leaveFromDate,
  String? leaveToDate,
  String? leaveCreationDate,
  String? leaveType,
  String? reasons,
  num? dayCount,
  num? sl,
  num? el,
  num? cl,
  String? leavePolicyType,
  String? appliedByName,
  String? passedByName,
  String? leaveStatus,
  num? currentApprover,
}) => NotificationModel(  employeeIdCardNo: employeeIdCardNo ?? _employeeIdCardNo,
  applaiedForEmployee: applaiedForEmployee ?? _applaiedForEmployee,
  departmentName: departmentName ?? _departmentName,
  joiningDate: joiningDate ?? _joiningDate,
  leaveFromDate: leaveFromDate ?? _leaveFromDate,
  leaveToDate: leaveToDate ?? _leaveToDate,
  leaveCreationDate: leaveCreationDate ?? _leaveCreationDate,
  leaveType: leaveType ?? _leaveType,
  reasons: reasons ?? _reasons,
  dayCount: dayCount ?? _dayCount,
  sl: sl ?? _sl,
  el: el ?? _el,
  cl: cl ?? _cl,
  leavePolicyType: leavePolicyType ?? _leavePolicyType,
  appliedByName: appliedByName ?? _appliedByName,
  passedByName: passedByName ?? _passedByName,
  leaveStatus: leaveStatus ?? _leaveStatus,
  currentApprover: currentApprover ?? _currentApprover,
);
  String? get employeeIdCardNo => _employeeIdCardNo;
  String? get applaiedForEmployee => _applaiedForEmployee;
  String? get departmentName => _departmentName;
  String? get joiningDate => _joiningDate;
  String? get leaveFromDate => _leaveFromDate;
  String? get leaveToDate => _leaveToDate;
  String? get leaveCreationDate => _leaveCreationDate;
  String? get leaveType => _leaveType;
  String? get reasons => _reasons;
  num? get dayCount => _dayCount;
  num? get sl => _sl;
  num? get el => _el;
  num? get cl => _cl;
  String? get leavePolicyType => _leavePolicyType;
  String? get appliedByName => _appliedByName;
  String? get passedByName => _passedByName;
  String? get leaveStatus => _leaveStatus;
  num? get currentApprover => _currentApprover;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['EmployeeIdCardNo'] = _employeeIdCardNo;
    map['ApplaiedForEmployee'] = _applaiedForEmployee;
    map['DepartmentName'] = _departmentName;
    map['JoiningDate'] = _joiningDate;
    map['LeaveFromDate'] = _leaveFromDate;
    map['LeaveToDate'] = _leaveToDate;
    map['LeaveCreationDate'] = _leaveCreationDate;
    map['LeaveType'] = _leaveType;
    map['Reasons'] = _reasons;
    map['DayCount'] = _dayCount;
    map['SL'] = _sl;
    map['EL'] = _el;
    map['CL'] = _cl;
    map['LeavePolicyType'] = _leavePolicyType;
    map['AppliedByName'] = _appliedByName;
    map['PassedByName'] = _passedByName;
    map['LeaveStatus'] = _leaveStatus;
    map['CurrentApprover'] = _currentApprover;
    return map;
  }

}