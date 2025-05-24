class PayslipModel {
  PayslipModel({
      String? id, 
      String? fullName, 
      String? fullNameBang, 
      String? company, 
      String? companyBang, 
      String? departmentName, 
      String? departmentNameBang, 
      String? sectionName, 
      String? sectionNameBang, 
      String? unitName, 
      String? unitNameBang, 
      String? lineName, 
      String? lineNameBang, 
      String? gradeName, 
      String? gradeNameBang, 
      String? designationName, 
      String? designationNameBang, 
      String? division, 
      String? divisionBang, 
      num? netPayable, 
      num? grossSalary, 
      String? totalWorkingDays, 
      String? presentDays, 
      String? absentDays, 
      String? lateDays, 
      String? extra2, 
      String? oTRate, 
      String? otHour, 
      String? idCardNo, 
      String? salaryMonth, 
      String? salaryYear, 
      String? joiningDate, 
      String? extra1, 
      num? netIncome, 
      num? netDeduction, 
      String? extra3, 
      String? extra4, 
      String? extra5,}){
    _id = id;
    _fullName = fullName;
    _fullNameBang = fullNameBang;
    _company = company;
    _companyBang = companyBang;
    _departmentName = departmentName;
    _departmentNameBang = departmentNameBang;
    _sectionName = sectionName;
    _sectionNameBang = sectionNameBang;
    _unitName = unitName;
    _unitNameBang = unitNameBang;
    _lineName = lineName;
    _lineNameBang = lineNameBang;
    _gradeName = gradeName;
    _gradeNameBang = gradeNameBang;
    _designationName = designationName;
    _designationNameBang = designationNameBang;
    _division = division;
    _divisionBang = divisionBang;
    _netPayable = netPayable;
    _grossSalary = grossSalary;
    _totalWorkingDays = totalWorkingDays;
    _presentDays = presentDays;
    _absentDays = absentDays;
    _lateDays = lateDays;
    _extra2 = extra2;
    _oTRate = oTRate;
    _otHour = otHour;
    _idCardNo = idCardNo;
    _salaryMonth = salaryMonth;
    _salaryYear = salaryYear;
    _joiningDate = joiningDate;
    _extra1 = extra1;
    _netIncome = netIncome;
    _netDeduction = netDeduction;
    _extra3 = extra3;
    _extra4 = extra4;
    _extra5 = extra5;
}

  PayslipModel.fromJson(dynamic json) {
    _id = json['Id'];
    _fullName = json['FullName'];
    _fullNameBang = json['FullNameBang'];
    _company = json['Company'];
    _companyBang = json['CompanyBang'];
    _departmentName = json['DepartmentName'];
    _departmentNameBang = json['DepartmentNameBang'];
    _sectionName = json['SectionName'];
    _sectionNameBang = json['SectionNameBang'];
    _unitName = json['UnitName'];
    _unitNameBang = json['UnitNameBang'];
    _lineName = json['LineName'];
    _lineNameBang = json['LineNameBang'];
    _gradeName = json['GradeName'];
    _gradeNameBang = json['GradeNameBang'];
    _designationName = json['DesignationName'];
    _designationNameBang = json['DesignationNameBang'];
    _division = json['Division'];
    _divisionBang = json['DivisionBang'];
    _netPayable = json['NetPayable'];
    _grossSalary = json['GrossSalary'];
    _totalWorkingDays = json['TotalWorkingDays'];
    _presentDays = json['PresentDays'];
    _absentDays = json['AbsentDays'];
    _lateDays = json['LateDays'];
    _extra2 = json['Extra2'];
    _oTRate = json['OTRate'];
    _otHour = json['OtHour'];
    _idCardNo = json['IdCardNo'];
    _salaryMonth = json['SalaryMonth'];
    _salaryYear = json['SalaryYear'];
    _joiningDate = json['JoiningDate'];
    _extra1 = json['Extra1'];
    _netIncome = json['NetIncome'];
    _netDeduction = json['NetDeduction'];
    _extra3 = json['Extra3'];
    _extra4 = json['Extra4'];
    _extra5 = json['Extra5'];
  }
  String? _id;
  String? _fullName;
  String? _fullNameBang;
  String? _company;
  String? _companyBang;
  String? _departmentName;
  String? _departmentNameBang;
  String? _sectionName;
  String? _sectionNameBang;
  String? _unitName;
  String? _unitNameBang;
  String? _lineName;
  String? _lineNameBang;
  String? _gradeName;
  String? _gradeNameBang;
  String? _designationName;
  String? _designationNameBang;
  String? _division;
  String? _divisionBang;
  num? _netPayable;
  num? _grossSalary;
  String? _totalWorkingDays;
  String? _presentDays;
  String? _absentDays;
  String? _lateDays;
  String? _extra2;
  String? _oTRate;
  String? _otHour;
  String? _idCardNo;
  String? _salaryMonth;
  String? _salaryYear;
  String? _joiningDate;
  String? _extra1;
  num? _netIncome;
  num? _netDeduction;
  String? _extra3;
  String? _extra4;
  String? _extra5;
PayslipModel copyWith({  String? id,
  String? fullName,
  String? fullNameBang,
  String? company,
  String? companyBang,
  String? departmentName,
  String? departmentNameBang,
  String? sectionName,
  String? sectionNameBang,
  String? unitName,
  String? unitNameBang,
  String? lineName,
  String? lineNameBang,
  String? gradeName,
  String? gradeNameBang,
  String? designationName,
  String? designationNameBang,
  String? division,
  String? divisionBang,
  num? netPayable,
  num? grossSalary,
  String? totalWorkingDays,
  String? presentDays,
  String? absentDays,
  String? lateDays,
  String? extra2,
  String? oTRate,
  String? otHour,
  String? idCardNo,
  String? salaryMonth,
  String? salaryYear,
  String? joiningDate,
  String? extra1,
  num? netIncome,
  num? netDeduction,
  String? extra3,
  String? extra4,
  String? extra5,
}) => PayslipModel(  id: id ?? _id,
  fullName: fullName ?? _fullName,
  fullNameBang: fullNameBang ?? _fullNameBang,
  company: company ?? _company,
  companyBang: companyBang ?? _companyBang,
  departmentName: departmentName ?? _departmentName,
  departmentNameBang: departmentNameBang ?? _departmentNameBang,
  sectionName: sectionName ?? _sectionName,
  sectionNameBang: sectionNameBang ?? _sectionNameBang,
  unitName: unitName ?? _unitName,
  unitNameBang: unitNameBang ?? _unitNameBang,
  lineName: lineName ?? _lineName,
  lineNameBang: lineNameBang ?? _lineNameBang,
  gradeName: gradeName ?? _gradeName,
  gradeNameBang: gradeNameBang ?? _gradeNameBang,
  designationName: designationName ?? _designationName,
  designationNameBang: designationNameBang ?? _designationNameBang,
  division: division ?? _division,
  divisionBang: divisionBang ?? _divisionBang,
  netPayable: netPayable ?? _netPayable,
  grossSalary: grossSalary ?? _grossSalary,
  totalWorkingDays: totalWorkingDays ?? _totalWorkingDays,
  presentDays: presentDays ?? _presentDays,
  absentDays: absentDays ?? _absentDays,
  lateDays: lateDays ?? _lateDays,
  extra2: extra2 ?? _extra2,
  oTRate: oTRate ?? _oTRate,
  otHour: otHour ?? _otHour,
  idCardNo: idCardNo ?? _idCardNo,
  salaryMonth: salaryMonth ?? _salaryMonth,
  salaryYear: salaryYear ?? _salaryYear,
  joiningDate: joiningDate ?? _joiningDate,
  extra1: extra1 ?? _extra1,
  netIncome: netIncome ?? _netIncome,
  netDeduction: netDeduction ?? _netDeduction,
  extra3: extra3 ?? _extra3,
  extra4: extra4 ?? _extra4,
  extra5: extra5 ?? _extra5,
);
  String? get id => _id;
  String? get fullName => _fullName;
  String? get fullNameBang => _fullNameBang;
  String? get company => _company;
  String? get companyBang => _companyBang;
  String? get departmentName => _departmentName;
  String? get departmentNameBang => _departmentNameBang;
  String? get sectionName => _sectionName;
  String? get sectionNameBang => _sectionNameBang;
  String? get unitName => _unitName;
  String? get unitNameBang => _unitNameBang;
  String? get lineName => _lineName;
  String? get lineNameBang => _lineNameBang;
  String? get gradeName => _gradeName;
  String? get gradeNameBang => _gradeNameBang;
  String? get designationName => _designationName;
  String? get designationNameBang => _designationNameBang;
  String? get division => _division;
  String? get divisionBang => _divisionBang;
  num? get netPayable => _netPayable;
  num? get grossSalary => _grossSalary;
  String? get totalWorkingDays => _totalWorkingDays;
  String? get presentDays => _presentDays;
  String? get absentDays => _absentDays;
  String? get lateDays => _lateDays;
  String? get extra2 => _extra2;
  String? get oTRate => _oTRate;
  String? get otHour => _otHour;
  String? get idCardNo => _idCardNo;
  String? get salaryMonth => _salaryMonth;
  String? get salaryYear => _salaryYear;
  String? get joiningDate => _joiningDate;
  String? get extra1 => _extra1;
  num? get netIncome => _netIncome;
  num? get netDeduction => _netDeduction;
  String? get extra3 => _extra3;
  String? get extra4 => _extra4;
  String? get extra5 => _extra5;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = _id;
    map['FullName'] = _fullName;
    map['FullNameBang'] = _fullNameBang;
    map['Company'] = _company;
    map['CompanyBang'] = _companyBang;
    map['DepartmentName'] = _departmentName;
    map['DepartmentNameBang'] = _departmentNameBang;
    map['SectionName'] = _sectionName;
    map['SectionNameBang'] = _sectionNameBang;
    map['UnitName'] = _unitName;
    map['UnitNameBang'] = _unitNameBang;
    map['LineName'] = _lineName;
    map['LineNameBang'] = _lineNameBang;
    map['GradeName'] = _gradeName;
    map['GradeNameBang'] = _gradeNameBang;
    map['DesignationName'] = _designationName;
    map['DesignationNameBang'] = _designationNameBang;
    map['Division'] = _division;
    map['DivisionBang'] = _divisionBang;
    map['NetPayable'] = _netPayable;
    map['GrossSalary'] = _grossSalary;
    map['TotalWorkingDays'] = _totalWorkingDays;
    map['PresentDays'] = _presentDays;
    map['AbsentDays'] = _absentDays;
    map['LateDays'] = _lateDays;
    map['Extra2'] = _extra2;
    map['OTRate'] = _oTRate;
    map['OtHour'] = _otHour;
    map['IdCardNo'] = _idCardNo;
    map['SalaryMonth'] = _salaryMonth;
    map['SalaryYear'] = _salaryYear;
    map['JoiningDate'] = _joiningDate;
    map['Extra1'] = _extra1;
    map['NetIncome'] = _netIncome;
    map['NetDeduction'] = _netDeduction;
    map['Extra3'] = _extra3;
    map['Extra4'] = _extra4;
    map['Extra5'] = _extra5;
    return map;
  }

}