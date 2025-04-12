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
    _departmentName = json['departmentName'];
    _deparmentId = json['deparmentId'];
    _date = json['date'];
    _present = json['present'];
    _absent = json['absent'];
    _leave = json['leave'];
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
    map['departmentName'] = _departmentName;
    map['deparmentId'] = _deparmentId;
    map['date'] = _date;
    map['present'] = _present;
    map['absent'] = _absent;
    map['leave'] = _leave;
    return map;
  }

}