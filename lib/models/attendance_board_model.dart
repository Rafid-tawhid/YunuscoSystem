class AttendanceBoardModel {
  AttendanceBoardModel({
      String? employeeId, 
      String? employeeName, 
      String? date, 
      String? departmentName, 
      String? designationName, 
      String? inTime, 
      String? outTime, 
      String? flagType, 
      String? workingHours, 
      num? totalPCount, 
      num? workingHoursDecimal,}){
    _employeeId = employeeId;
    _employeeName = employeeName;
    _date = date;
    _departmentName = departmentName;
    _designationName = designationName;
    _inTime = inTime;
    _outTime = outTime;
    _flagType = flagType;
    _workingHours = workingHours;
    _totalPCount = totalPCount;
    _workingHoursDecimal = workingHoursDecimal;
}

  AttendanceBoardModel.fromJson(dynamic json) {
    _employeeId = json['employee_id'];
    _employeeName = json['employee_name'];
    _date = json['date'];
    _departmentName = json['departmentName'];
    _designationName = json['designationName'];
    _inTime = json['in_time'];
    _outTime = json['out_time'];
    _flagType = json['flag_type'];
    _workingHours = json['working_hours'];
    _totalPCount = json['total_p_count'];
    _workingHoursDecimal = json['working_hours_decimal'];
  }
  String? _employeeId;
  String? _employeeName;
  String? _date;
  String? _departmentName;
  String? _designationName;
  String? _inTime;
  String? _outTime;
  String? _flagType;
  String? _workingHours;
  num? _totalPCount;
  num? _workingHoursDecimal;
AttendanceBoardModel copyWith({  String? employeeId,
  String? employeeName,
  String? date,
  String? departmentName,
  String? designationName,
  String? inTime,
  String? outTime,
  String? flagType,
  String? workingHours,
  num? totalPCount,
  num? workingHoursDecimal,
}) => AttendanceBoardModel(  employeeId: employeeId ?? _employeeId,
  employeeName: employeeName ?? _employeeName,
  date: date ?? _date,
  departmentName: departmentName ?? _departmentName,
  designationName: designationName ?? _designationName,
  inTime: inTime ?? _inTime,
  outTime: outTime ?? _outTime,
  flagType: flagType ?? _flagType,
  workingHours: workingHours ?? _workingHours,
  totalPCount: totalPCount ?? _totalPCount,
  workingHoursDecimal: workingHoursDecimal ?? _workingHoursDecimal,
);
  String? get employeeId => _employeeId;
  String? get employeeName => _employeeName;
  String? get date => _date;
  String? get departmentName => _departmentName;
  String? get designationName => _designationName;
  String? get inTime => _inTime;
  String? get outTime => _outTime;
  String? get flagType => _flagType;
  String? get workingHours => _workingHours;
  num? get totalPCount => _totalPCount;
  num? get workingHoursDecimal => _workingHoursDecimal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['employee_id'] = _employeeId;
    map['employee_name'] = _employeeName;
    map['date'] = _date;
    map['departmentName'] = _departmentName;
    map['designationName'] = _designationName;
    map['in_time'] = _inTime;
    map['out_time'] = _outTime;
    map['flag_type'] = _flagType;
    map['working_hours'] = _workingHours;
    map['total_p_count'] = _totalPCount;
    map['working_hours_decimal'] = _workingHoursDecimal;
    return map;
  }

}