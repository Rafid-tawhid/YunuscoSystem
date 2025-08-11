class EmployeeAppointmentInfoModel {
  EmployeeAppointmentInfoModel({
      String? idCardNo, 
      String? fullName, 
      String? joiningDate, 
      String? departmentName, 
      String? designationName, 
      String? sectionName, 
      String? productionLineName, 
      String? productionUnitName, 
      String? gender, 
      String? dateOfBirth, 
      num? ageYears,}){
    _idCardNo = idCardNo;
    _fullName = fullName;
    _joiningDate = joiningDate;
    _departmentName = departmentName;
    _designationName = designationName;
    _sectionName = sectionName;
    _productionLineName = productionLineName;
    _productionUnitName = productionUnitName;
    _gender = gender;
    _dateOfBirth = dateOfBirth;
    _ageYears = ageYears;
}

  EmployeeAppointmentInfoModel.fromJson(dynamic json) {
    _idCardNo = json['IdCardNo'];
    _fullName = json['FullName'];
    _joiningDate = json['JoiningDate'];
    _departmentName = json['DepartmentName'];
    _designationName = json['DesignationName'];
    _sectionName = json['SectionName'];
    _productionLineName = json['ProductionLineName'];
    _productionUnitName = json['ProductionUnitName'];
    _gender = json['Gender'];
    _dateOfBirth = json['DateOfBirth'];
    _ageYears = json['AgeYears'];
  }
  String? _idCardNo;
  String? _fullName;
  String? _joiningDate;
  String? _departmentName;
  String? _designationName;
  String? _sectionName;
  String? _productionLineName;
  String? _productionUnitName;
  String? _gender;
  String? _dateOfBirth;
  num? _ageYears;
EmployeeAppointmentInfoModel copyWith({  String? idCardNo,
  String? fullName,
  String? joiningDate,
  String? departmentName,
  String? designationName,
  String? sectionName,
  String? productionLineName,
  String? productionUnitName,
  String? gender,
  String? dateOfBirth,
  num? ageYears,
}) => EmployeeAppointmentInfoModel(  idCardNo: idCardNo ?? _idCardNo,
  fullName: fullName ?? _fullName,
  joiningDate: joiningDate ?? _joiningDate,
  departmentName: departmentName ?? _departmentName,
  designationName: designationName ?? _designationName,
  sectionName: sectionName ?? _sectionName,
  productionLineName: productionLineName ?? _productionLineName,
  productionUnitName: productionUnitName ?? _productionUnitName,
  gender: gender ?? _gender,
  dateOfBirth: dateOfBirth ?? _dateOfBirth,
  ageYears: ageYears ?? _ageYears,
);
  String? get idCardNo => _idCardNo;
  String? get fullName => _fullName;
  String? get joiningDate => _joiningDate;
  String? get departmentName => _departmentName;
  String? get designationName => _designationName;
  String? get sectionName => _sectionName;
  String? get productionLineName => _productionLineName;
  String? get productionUnitName => _productionUnitName;
  String? get gender => _gender;
  String? get dateOfBirth => _dateOfBirth;
  num? get ageYears => _ageYears;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['IdCardNo'] = _idCardNo;
    map['FullName'] = _fullName;
    map['JoiningDate'] = _joiningDate;
    map['DepartmentName'] = _departmentName;
    map['DesignationName'] = _designationName;
    map['SectionName'] = _sectionName;
    map['ProductionLineName'] = _productionLineName;
    map['ProductionUnitName'] = _productionUnitName;
    map['Gender'] = _gender;
    map['DateOfBirth'] = _dateOfBirth;
    map['AgeYears'] = _ageYears;
    return map;
  }

}