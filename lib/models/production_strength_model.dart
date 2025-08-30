class ProductionStrengthModel {
  ProductionStrengthModel({
    String? departmentName,
    String? sectionName,
    String? designation,
    num? present,
    num? absent,
    num? strength,
    num? absentPercent,
  }) {
    _departmentName = departmentName;
    _sectionName = sectionName;
    _designation = designation;
    _present = present;
    _absent = absent;
    _strength = strength;
    _absentPercent = absentPercent;
  }

  ProductionStrengthModel.fromJson(dynamic json) {
    _departmentName = json['DepartmentName'];
    _sectionName = json['SectionName'];
    _designation = json['Designation'];
    _present = json['Present'];
    _absent = json['Absent'];
    _strength = json['Strength'];
    _absentPercent = json['AbsentPercent'];
  }
  String? _departmentName;
  String? _sectionName;
  String? _designation;
  num? _present;
  num? _absent;
  num? _strength;
  num? _absentPercent;
  ProductionStrengthModel copyWith({
    String? departmentName,
    String? sectionName,
    String? designation,
    num? present,
    num? absent,
    num? strength,
    num? absentPercent,
  }) =>
      ProductionStrengthModel(
        departmentName: departmentName ?? _departmentName,
        sectionName: sectionName ?? _sectionName,
        designation: designation ?? _designation,
        present: present ?? _present,
        absent: absent ?? _absent,
        strength: strength ?? _strength,
        absentPercent: absentPercent ?? _absentPercent,
      );
  String? get departmentName => _departmentName;
  String? get sectionName => _sectionName;
  String? get designation => _designation;
  num? get present => _present;
  num? get absent => _absent;
  num? get strength => _strength;
  num? get absentPercent => _absentPercent;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DepartmentName'] = _departmentName;
    map['SectionName'] = _sectionName;
    map['Designation'] = _designation;
    map['Present'] = _present;
    map['Absent'] = _absent;
    map['Strength'] = _strength;
    map['AbsentPercent'] = _absentPercent;
    return map;
  }
}
