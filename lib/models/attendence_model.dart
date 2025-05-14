class AttendenceModel {
  AttendenceModel({
      String? departmentName, 
      num? deparmentId, 
      String? date, 
      num? present, 
      num? absent, 
      num? leave,}){
    _departmentName = departmentName;
    _deparmentId = deparmentId;
    _date = date;
    _present = present;
    _absent = absent;
    _leave = leave;
}

  AttendenceModel.fromJson(dynamic json) {
    _departmentName = json['DepartmentName'];
    _deparmentId = json['DeparmentId'];
    _date = json['Date'];
    _present = json['present'];
    _absent = json['Absent'];
    _leave = json['Leave'];
  }
  String? _departmentName;
  num? _deparmentId;
  String? _date;
  num? _present;
  num? _absent;
  num? _leave;
AttendenceModel copyWith({  String? departmentName,
  num? deparmentId,
  String? date,
  num? present,
  num? absent,
  num? leave,
}) => AttendenceModel(  departmentName: departmentName ?? _departmentName,
  deparmentId: deparmentId ?? _deparmentId,
  date: date ?? _date,
  present: present ?? _present,
  absent: absent ?? _absent,
  leave: leave ?? _leave,
);
  String? get departmentName => _departmentName;
  num? get deparmentId => _deparmentId;
  String? get date => _date;
  num? get present => _present;
  num? get absent => _absent;
  num? get leave => _leave;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DepartmentName'] = _departmentName;
    map['DeparmentId'] = _deparmentId;
    map['Date'] = _date;
    map['present'] = _present;
    map['Absent'] = _absent;
    map['Leave'] = _leave;
    return map;
  }

}