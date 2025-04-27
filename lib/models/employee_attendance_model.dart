class EmployeeAttendanceModel {
  EmployeeAttendanceModel({
      num? employeeId, 
      String? idCardNo, 
      String? attendancedate, 
      String? dayDate, 
      String? inTime, 
      num? absent, 
      num? present, 
      num? late, 
      String? outTime, 
      String? inFlag, 
      num? leave,}){
    _employeeId = employeeId;
    _idCardNo = idCardNo;
    _attendancedate = attendancedate;
    _dayDate = dayDate;
    _inTime = inTime;
    _absent = absent;
    _present = present;
    _late = late;
    _outTime = outTime;
    _inFlag = inFlag;
    _leave = leave;
}

  EmployeeAttendanceModel.fromJson(dynamic json) {
    _employeeId = json['employeeId'];
    _idCardNo = json['idCardNo'];
    _attendancedate = json['attendancedate'];
    _dayDate = json['dayDate'];
    _inTime = json['inTime'];
    _absent = json['absent'];
    _present = json['present'];
    _late = json['late'];
    _outTime = json['outTime'];
    _inFlag = json['inFlag'];
    _leave = json['leave'];
  }
  num? _employeeId;
  String? _idCardNo;
  String? _attendancedate;
  String? _dayDate;
  String? _inTime;
  num? _absent;
  num? _present;
  num? _late;
  String? _outTime;
  String? _inFlag;
  num? _leave;
EmployeeAttendanceModel copyWith({  num? employeeId,
  String? idCardNo,
  String? attendancedate,
  String? dayDate,
  String? inTime,
  num? absent,
  num? present,
  num? late,
  String? outTime,
  String? inFlag,
  num? leave,
}) => EmployeeAttendanceModel(  employeeId: employeeId ?? _employeeId,
  idCardNo: idCardNo ?? _idCardNo,
  attendancedate: attendancedate ?? _attendancedate,
  dayDate: dayDate ?? _dayDate,
  inTime: inTime ?? _inTime,
  absent: absent ?? _absent,
  present: present ?? _present,
  late: late ?? _late,
  outTime: outTime ?? _outTime,
  inFlag: inFlag ?? _inFlag,
  leave: leave ?? _leave,
);
  num? get employeeId => _employeeId;
  String? get idCardNo => _idCardNo;
  String? get attendancedate => _attendancedate;
  String? get dayDate => _dayDate;
  String? get inTime => _inTime;
  num? get absent => _absent;
  num? get present => _present;
  num? get late => _late;
  String? get outTime => _outTime;
  String? get inFlag => _inFlag;
  num? get leave => _leave;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['employeeId'] = _employeeId;
    map['idCardNo'] = _idCardNo;
    map['attendancedate'] = _attendancedate;
    map['dayDate'] = _dayDate;
    map['inTime'] = _inTime;
    map['absent'] = _absent;
    map['present'] = _present;
    map['late'] = _late;
    map['outTime'] = _outTime;
    map['inFlag'] = _inFlag;
    map['leave'] = _leave;
    return map;
  }

}