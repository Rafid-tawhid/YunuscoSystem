class EmployeeAttendanceModel {
  EmployeeAttendanceModel({
    num? employeeId,
    String? idCardNo,
    String? attendancedate,
    String? dayDate,
    String? officeInTime,
    String? inTime,
    num? absent,
    num? present,
    num? late,
    String? outTime,
    String? officeOutTime,
    String? inFlag,
    String? outFlag,
    num? leave,
    String? totalWorkingHours,
    String? lateDuration,
  }) {
    _employeeId = employeeId;
    _idCardNo = idCardNo;
    _attendancedate = attendancedate;
    _dayDate = dayDate;
    _officeInTime = officeInTime;
    _inTime = inTime;
    _absent = absent;
    _present = present;
    _late = late;
    _outTime = outTime;
    _officeOutTime = officeOutTime;
    _inFlag = inFlag;
    _outFlag = outFlag;
    _leave = leave;
    _totalWorkingHours = totalWorkingHours;
    _lateDuration = lateDuration;
  }

  EmployeeAttendanceModel.fromJson(dynamic json) {
    _employeeId = json['EmployeeId'];
    _idCardNo = json['IdCardNo'];
    _attendancedate = json['Attendancedate'];
    _dayDate = json['dayDate'];
    _officeInTime = json['OfficeInTime'];
    _inTime = json['InTime'];
    _absent = json['Absent'];
    _present = json['present'];
    _late = json['Late'];
    _outTime = json['OutTime'];
    _officeOutTime = json['OfficeOutTime'];
    _inFlag = json['InFlag'];
    _outFlag = json['OutFlag'];
    _leave = json['Leave'];
    _totalWorkingHours = json['TotalWorkingHours'];
    _lateDuration = json['LateDuration'];
  }
  num? _employeeId;
  String? _idCardNo;
  String? _attendancedate;
  String? _dayDate;
  String? _officeInTime;
  String? _inTime;
  num? _absent;
  num? _present;
  num? _late;
  String? _outTime;
  String? _officeOutTime;
  String? _inFlag;
  String? _outFlag;
  num? _leave;
  String? _totalWorkingHours;
  String? _lateDuration;
  EmployeeAttendanceModel copyWith({
    num? employeeId,
    String? idCardNo,
    String? attendancedate,
    String? dayDate,
    String? officeInTime,
    String? inTime,
    num? absent,
    num? present,
    num? late,
    String? outTime,
    String? officeOutTime,
    String? inFlag,
    String? outFlag,
    num? leave,
    String? totalWorkingHours,
    String? lateDuration,
  }) =>
      EmployeeAttendanceModel(
        employeeId: employeeId ?? _employeeId,
        idCardNo: idCardNo ?? _idCardNo,
        attendancedate: attendancedate ?? _attendancedate,
        dayDate: dayDate ?? _dayDate,
        officeInTime: officeInTime ?? _officeInTime,
        inTime: inTime ?? _inTime,
        absent: absent ?? _absent,
        present: present ?? _present,
        late: late ?? _late,
        outTime: outTime ?? _outTime,
        officeOutTime: officeOutTime ?? _officeOutTime,
        inFlag: inFlag ?? _inFlag,
        outFlag: outFlag ?? _outFlag,
        leave: leave ?? _leave,
        totalWorkingHours: totalWorkingHours ?? _totalWorkingHours,
        lateDuration: lateDuration ?? _lateDuration,
      );
  num? get employeeId => _employeeId;
  String? get idCardNo => _idCardNo;
  String? get attendancedate => _attendancedate;
  String? get dayDate => _dayDate;
  String? get officeInTime => _officeInTime;
  String? get inTime => _inTime;
  num? get absent => _absent;
  num? get present => _present;
  num? get late => _late;
  String? get outTime => _outTime;
  String? get officeOutTime => _officeOutTime;
  String? get inFlag => _inFlag;
  String? get outFlag => _outFlag;
  num? get leave => _leave;
  String? get totalWorkingHours => _totalWorkingHours;
  String? get lateDuration => _lateDuration;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['EmployeeId'] = _employeeId;
    map['IdCardNo'] = _idCardNo;
    map['Attendancedate'] = _attendancedate;
    map['dayDate'] = _dayDate;
    map['OfficeInTime'] = _officeInTime;
    map['InTime'] = _inTime;
    map['Absent'] = _absent;
    map['present'] = _present;
    map['Late'] = _late;
    map['OutTime'] = _outTime;
    map['OfficeOutTime'] = _officeOutTime;
    map['InFlag'] = _inFlag;
    map['OutFlag'] = _outFlag;
    map['Leave'] = _leave;
    map['TotalWorkingHours'] = _totalWorkingHours;
    map['LateDuration'] = _lateDuration;
    return map;
  }
}
