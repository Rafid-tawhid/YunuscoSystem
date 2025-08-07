class PfMainModel {
  PfMainModel({
      num? pfid, 
      String? pfvoucherNo, 
      String? idCardNo, 
      String? employeeName, 
      String? department, 
      String? section, 
      String? productionLineName, 
      String? productionUnitName, 
      String? designation, 
      String? joinDate, 
      String? bankName, 
      String? salaryAccountNo, 
      String? activeDate, 
      String? pfdeactivatedDate, 
      num? totalPfinstallment, 
      num? totalEmployeeAmount, 
      num? totalCompanyAmount, 
      num? employeeTotalInterest, 
      num? companyTotalInterest, 
      dynamic providentFundDeduct, 
      dynamic interestOnProvidentFund, 
      num? totalAmount, 
      num? createdBy, 
      String? createdDate, 
      dynamic updatedBy, 
      dynamic updatedDate,}){
    _pfid = pfid;
    _pfvoucherNo = pfvoucherNo;
    _idCardNo = idCardNo;
    _employeeName = employeeName;
    _department = department;
    _section = section;
    _productionLineName = productionLineName;
    _productionUnitName = productionUnitName;
    _designation = designation;
    _joinDate = joinDate;
    _bankName = bankName;
    _salaryAccountNo = salaryAccountNo;
    _activeDate = activeDate;
    _pfdeactivatedDate = pfdeactivatedDate;
    _totalPfinstallment = totalPfinstallment;
    _totalEmployeeAmount = totalEmployeeAmount;
    _totalCompanyAmount = totalCompanyAmount;
    _employeeTotalInterest = employeeTotalInterest;
    _companyTotalInterest = companyTotalInterest;
    _providentFundDeduct = providentFundDeduct;
    _interestOnProvidentFund = interestOnProvidentFund;
    _totalAmount = totalAmount;
    _createdBy = createdBy;
    _createdDate = createdDate;
    _updatedBy = updatedBy;
    _updatedDate = updatedDate;
}

  PfMainModel.fromJson(dynamic json) {
    _pfid = json['Pfid'];
    _pfvoucherNo = json['PfvoucherNo'];
    _idCardNo = json['IdCardNo'];
    _employeeName = json['EmployeeName'];
    _department = json['Department'];
    _section = json['Section'];
    _productionLineName = json['ProductionLineName'];
    _productionUnitName = json['ProductionUnitName'];
    _designation = json['Designation'];
    _joinDate = json['JoinDate'];
    _bankName = json['BankName'];
    _salaryAccountNo = json['SalaryAccountNo'];
    _activeDate = json['ActiveDate'];
    _pfdeactivatedDate = json['PfdeactivatedDate'];
    _totalPfinstallment = json['TotalPfinstallment'];
    _totalEmployeeAmount = json['TotalEmployeeAmount'];
    _totalCompanyAmount = json['TotalCompanyAmount'];
    _employeeTotalInterest = json['EmployeeTotalInterest'];
    _companyTotalInterest = json['CompanyTotalInterest'];
    _providentFundDeduct = json['ProvidentFundDeduct'];
    _interestOnProvidentFund = json['InterestOnProvidentFund'];
    _totalAmount = json['TotalAmount'];
    _createdBy = json['CreatedBy'];
    _createdDate = json['CreatedDate'];
    _updatedBy = json['UpdatedBy'];
    _updatedDate = json['UpdatedDate'];
  }
  num? _pfid;
  String? _pfvoucherNo;
  String? _idCardNo;
  String? _employeeName;
  String? _department;
  String? _section;
  String? _productionLineName;
  String? _productionUnitName;
  String? _designation;
  String? _joinDate;
  String? _bankName;
  String? _salaryAccountNo;
  String? _activeDate;
  String? _pfdeactivatedDate;
  num? _totalPfinstallment;
  num? _totalEmployeeAmount;
  num? _totalCompanyAmount;
  num? _employeeTotalInterest;
  num? _companyTotalInterest;
  dynamic _providentFundDeduct;
  dynamic _interestOnProvidentFund;
  num? _totalAmount;
  num? _createdBy;
  String? _createdDate;
  dynamic _updatedBy;
  dynamic _updatedDate;
PfMainModel copyWith({  num? pfid,
  String? pfvoucherNo,
  String? idCardNo,
  String? employeeName,
  String? department,
  String? section,
  String? productionLineName,
  String? productionUnitName,
  String? designation,
  String? joinDate,
  String? bankName,
  String? salaryAccountNo,
  String? activeDate,
  String? pfdeactivatedDate,
  num? totalPfinstallment,
  num? totalEmployeeAmount,
  num? totalCompanyAmount,
  num? employeeTotalInterest,
  num? companyTotalInterest,
  dynamic providentFundDeduct,
  dynamic interestOnProvidentFund,
  num? totalAmount,
  num? createdBy,
  String? createdDate,
  dynamic updatedBy,
  dynamic updatedDate,
}) => PfMainModel(  pfid: pfid ?? _pfid,
  pfvoucherNo: pfvoucherNo ?? _pfvoucherNo,
  idCardNo: idCardNo ?? _idCardNo,
  employeeName: employeeName ?? _employeeName,
  department: department ?? _department,
  section: section ?? _section,
  productionLineName: productionLineName ?? _productionLineName,
  productionUnitName: productionUnitName ?? _productionUnitName,
  designation: designation ?? _designation,
  joinDate: joinDate ?? _joinDate,
  bankName: bankName ?? _bankName,
  salaryAccountNo: salaryAccountNo ?? _salaryAccountNo,
  activeDate: activeDate ?? _activeDate,
  pfdeactivatedDate: pfdeactivatedDate ?? _pfdeactivatedDate,
  totalPfinstallment: totalPfinstallment ?? _totalPfinstallment,
  totalEmployeeAmount: totalEmployeeAmount ?? _totalEmployeeAmount,
  totalCompanyAmount: totalCompanyAmount ?? _totalCompanyAmount,
  employeeTotalInterest: employeeTotalInterest ?? _employeeTotalInterest,
  companyTotalInterest: companyTotalInterest ?? _companyTotalInterest,
  providentFundDeduct: providentFundDeduct ?? _providentFundDeduct,
  interestOnProvidentFund: interestOnProvidentFund ?? _interestOnProvidentFund,
  totalAmount: totalAmount ?? _totalAmount,
  createdBy: createdBy ?? _createdBy,
  createdDate: createdDate ?? _createdDate,
  updatedBy: updatedBy ?? _updatedBy,
  updatedDate: updatedDate ?? _updatedDate,
);
  num? get pfid => _pfid;
  String? get pfvoucherNo => _pfvoucherNo;
  String? get idCardNo => _idCardNo;
  String? get employeeName => _employeeName;
  String? get department => _department;
  String? get section => _section;
  String? get productionLineName => _productionLineName;
  String? get productionUnitName => _productionUnitName;
  String? get designation => _designation;
  String? get joinDate => _joinDate;
  String? get bankName => _bankName;
  String? get salaryAccountNo => _salaryAccountNo;
  String? get activeDate => _activeDate;
  String? get pfdeactivatedDate => _pfdeactivatedDate;
  num? get totalPfinstallment => _totalPfinstallment;
  num? get totalEmployeeAmount => _totalEmployeeAmount;
  num? get totalCompanyAmount => _totalCompanyAmount;
  num? get employeeTotalInterest => _employeeTotalInterest;
  num? get companyTotalInterest => _companyTotalInterest;
  dynamic get providentFundDeduct => _providentFundDeduct;
  dynamic get interestOnProvidentFund => _interestOnProvidentFund;
  num? get totalAmount => _totalAmount;
  num? get createdBy => _createdBy;
  String? get createdDate => _createdDate;
  dynamic get updatedBy => _updatedBy;
  dynamic get updatedDate => _updatedDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Pfid'] = _pfid;
    map['PfvoucherNo'] = _pfvoucherNo;
    map['IdCardNo'] = _idCardNo;
    map['EmployeeName'] = _employeeName;
    map['Department'] = _department;
    map['Section'] = _section;
    map['ProductionLineName'] = _productionLineName;
    map['ProductionUnitName'] = _productionUnitName;
    map['Designation'] = _designation;
    map['JoinDate'] = _joinDate;
    map['BankName'] = _bankName;
    map['SalaryAccountNo'] = _salaryAccountNo;
    map['ActiveDate'] = _activeDate;
    map['PfdeactivatedDate'] = _pfdeactivatedDate;
    map['TotalPfinstallment'] = _totalPfinstallment;
    map['TotalEmployeeAmount'] = _totalEmployeeAmount;
    map['TotalCompanyAmount'] = _totalCompanyAmount;
    map['EmployeeTotalInterest'] = _employeeTotalInterest;
    map['CompanyTotalInterest'] = _companyTotalInterest;
    map['ProvidentFundDeduct'] = _providentFundDeduct;
    map['InterestOnProvidentFund'] = _interestOnProvidentFund;
    map['TotalAmount'] = _totalAmount;
    map['CreatedBy'] = _createdBy;
    map['CreatedDate'] = _createdDate;
    map['UpdatedBy'] = _updatedBy;
    map['UpdatedDate'] = _updatedDate;
    return map;
  }

}