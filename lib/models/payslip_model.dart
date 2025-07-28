class PayslipModel {
  PayslipModel({
      String? fullName, 
      dynamic contactNo, 
      dynamic email, 
      String? company, 
      String? addressLine1, 
      String? addressLine2, 
      String? departmentName, 
      String? sectionName, 
      String? lineName, 
      String? designationName, 
      String? salaryMonthName, 
      String? salaryYearName, 
      num? netIncomeTotal, 
      num? maternityDeduction, 
      num? absent, 
      num? late, 
      num? netDeduction, 
      num? ait, 
      num? leaveWithoutPay, 
      num? othersDeduction, 
      num? advance, 
      num? stamp, 
      num? outAttendance, 
      num? pf, 
      num? loan, 
      num? noticeDeduction, 
      num? pFCompanys, 
      num? netPeyable, 
      num? grossAbsent, 
      num? allowanceDeduction, 
      num? attnBonusDeduct, 
      num? convenceDeduct, 
      num? foodDeduct, 
      num? mobileBill, 
      num? arear, 
      num? oTAmount, 
      num? holidayAllowance, 
      num? salaryId, 
      num? employeeId, 
      String? formDate, 
      String? toDate, 
      num? grossSalary, 
      num? medical, 
      num? basicSalary, 
      num? houseRent, 
      num? conveyance, 
      num? allowence, 
      num? attendanceBonus, 
      num? foodAllowence, 
      num? bankPay, 
      num? cashPay, 
      String? companyAccount, 
      num? absentFee, 
      num? lateFee, 
      num? providentFund, 
      num? stampFees, 
      num? otherDeduction, 
      num? otherDeduction1, 
      num? otherDeduction2, 
      num? otherAllowence, 
      num? otherAllowence2, 
      bool? isPaid, 
      bool? isApprove, 
      String? salaryMonth, 
      String? salaryYear, 
      String? idCardNo, 
      String? grade, 
      String? joiningDate, 
      num? totalWorkingDays, 
      num? lateDays, 
      num? cMLCount, 
      num? casualLeave, 
      num? sickLeave, 
      num? weekEndDays, 
      num? presentDays, 
      num? earnLeave, 
      num? holidays, 
      num? maternityLeave, 
      num? lw, 
      num? otRate, 
      num? totalOTHour, 
      num? totalOTHourICS, 
      num? absentDays, 
      num? tds, 
      num? grossAbsentDays, 
      String? totalLateHour, 
      num? totalLateDeductionSal, 
      num? actOTHour, 
      num? otherOtHour, 
      num? semiComplinceOtHour, 
      dynamic accountNo,}){
    _fullName = fullName;
    _contactNo = contactNo;
    _email = email;
    _company = company;
    _addressLine1 = addressLine1;
    _addressLine2 = addressLine2;
    _departmentName = departmentName;
    _sectionName = sectionName;
    _lineName = lineName;
    _designationName = designationName;
    _salaryMonthName = salaryMonthName;
    _salaryYearName = salaryYearName;
    _netIncomeTotal = netIncomeTotal;
    _maternityDeduction = maternityDeduction;
    _absent = absent;
    _late = late;
    _netDeduction = netDeduction;
    _ait = ait;
    _leaveWithoutPay = leaveWithoutPay;
    _othersDeduction = othersDeduction;
    _advance = advance;
    _stamp = stamp;
    _outAttendance = outAttendance;
    _pf = pf;
    _loan = loan;
    _noticeDeduction = noticeDeduction;
    _pFCompanys = pFCompanys;
    _netPeyable = netPeyable;
    _grossAbsent = grossAbsent;
    _allowanceDeduction = allowanceDeduction;
    _attnBonusDeduct = attnBonusDeduct;
    _convenceDeduct = convenceDeduct;
    _foodDeduct = foodDeduct;
    _mobileBill = mobileBill;
    _arear = arear;
    _oTAmount = oTAmount;
    _holidayAllowance = holidayAllowance;
    _salaryId = salaryId;
    _employeeId = employeeId;
    _formDate = formDate;
    _toDate = toDate;
    _grossSalary = grossSalary;
    _medical = medical;
    _basicSalary = basicSalary;
    _houseRent = houseRent;
    _conveyance = conveyance;
    _allowence = allowence;
    _attendanceBonus = attendanceBonus;
    _foodAllowence = foodAllowence;
    _bankPay = bankPay;
    _cashPay = cashPay;
    _companyAccount = companyAccount;
    _absentFee = absentFee;
    _lateFee = lateFee;
    _providentFund = providentFund;
    _stampFees = stampFees;
    _otherDeduction = otherDeduction;
    _otherDeduction1 = otherDeduction1;
    _otherDeduction2 = otherDeduction2;
    _otherAllowence = otherAllowence;
    _otherAllowence2 = otherAllowence2;
    _isPaid = isPaid;
    _isApprove = isApprove;
    _salaryMonth = salaryMonth;
    _salaryYear = salaryYear;
    _idCardNo = idCardNo;
    _grade = grade;
    _joiningDate = joiningDate;
    _totalWorkingDays = totalWorkingDays;
    _lateDays = lateDays;
    _cMLCount = cMLCount;
    _casualLeave = casualLeave;
    _sickLeave = sickLeave;
    _weekEndDays = weekEndDays;
    _presentDays = presentDays;
    _earnLeave = earnLeave;
    _holidays = holidays;
    _maternityLeave = maternityLeave;
    _lw = lw;
    _otRate = otRate;
    _totalOTHour = totalOTHour;
    _totalOTHourICS = totalOTHourICS;
    _absentDays = absentDays;
    _tds = tds;
    _grossAbsentDays = grossAbsentDays;
    _totalLateHour = totalLateHour;
    _totalLateDeductionSal = totalLateDeductionSal;
    _actOTHour = actOTHour;
    _otherOtHour = otherOtHour;
    _semiComplinceOtHour = semiComplinceOtHour;
    _accountNo = accountNo;
}

  PayslipModel.fromJson(dynamic json) {
    _fullName = json['FullName'];
    _contactNo = json['ContactNo'];
    _email = json['Email'];
    _company = json['Company'];
    _addressLine1 = json['AddressLine1'];
    _addressLine2 = json['AddressLine2'];
    _departmentName = json['DepartmentName'];
    _sectionName = json['SectionName'];
    _lineName = json['LineName'];
    _designationName = json['DesignationName'];
    _salaryMonthName = json['SalaryMonthName'];
    _salaryYearName = json['SalaryYearName'];
    _netIncomeTotal = json['NetIncomeTotal'];
    _maternityDeduction = json['MaternityDeduction'];
    _absent = json['Absent'];
    _late = json['Late'];
    _netDeduction = json['NetDeduction'];
    _ait = json['AIT'];
    _leaveWithoutPay = json['LeaveWithoutPay'];
    _othersDeduction = json['OthersDeduction'];
    _advance = json['Advance'];
    _stamp = json['Stamp'];
    _outAttendance = json['OutAttendance'];
    _pf = json['PF'];
    _loan = json['Loan'];
    _noticeDeduction = json['NoticeDeduction'];
    _pFCompanys = json['PFCompanys'];
    _netPeyable = json['NetPeyable'];
    _grossAbsent = json['GrossAbsent'];
    _allowanceDeduction = json['AllowanceDeduction'];
    _attnBonusDeduct = json['AttnBonusDeduct'];
    _convenceDeduct = json['ConvenceDeduct'];
    _foodDeduct = json['FoodDeduct'];
    _mobileBill = json['MobileBill'];
    _arear = json['Arear'];
    _oTAmount = json['OTAmount'];
    _holidayAllowance = json['HolidayAllowance'];
    _salaryId = json['SalaryId'];
    _employeeId = json['EmployeeId'];
    _formDate = json['FormDate'];
    _toDate = json['ToDate'];
    _grossSalary = json['GrossSalary'];
    _medical = json['Medical'];
    _basicSalary = json['BasicSalary'];
    _houseRent = json['HouseRent'];
    _conveyance = json['Conveyance'];
    _allowence = json['Allowence'];
    _attendanceBonus = json['AttendanceBonus'];
    _foodAllowence = json['FoodAllowence'];
    _bankPay = json['BankPay'];
    _cashPay = json['CashPay'];
    _companyAccount = json['CompanyAccount'];
    _absentFee = json['AbsentFee'];
    _lateFee = json['LateFee'];
    _providentFund = json['ProvidentFund'];
    _stampFees = json['StampFees'];
    _otherDeduction = json['OtherDeduction'];
    _otherDeduction1 = json['OtherDeduction1'];
    _otherDeduction2 = json['OtherDeduction2'];
    _otherAllowence = json['OtherAllowence'];
    _otherAllowence2 = json['OtherAllowence2'];
    _isPaid = json['IsPaid'];
    _isApprove = json['IsApprove'];
    _salaryMonth = json['SalaryMonth'];
    _salaryYear = json['SalaryYear'];
    _idCardNo = json['IdCardNo'];
    _grade = json['Grade'];
    _joiningDate = json['JoiningDate'];
    _totalWorkingDays = json['TotalWorkingDays'];
    _lateDays = json['LateDays'];
    _cMLCount = json['CMLCount'];
    _casualLeave = json['CasualLeave'];
    _sickLeave = json['SickLeave'];
    _weekEndDays = json['WeekEndDays'];
    _presentDays = json['PresentDays'];
    _earnLeave = json['EarnLeave'];
    _holidays = json['Holidays'];
    _maternityLeave = json['MaternityLeave'];
    _lw = json['LW'];
    _otRate = json['OtRate'];
    _totalOTHour = json['TotalOTHour'];
    _totalOTHourICS = json['TotalOTHourICS'];
    _absentDays = json['AbsentDays'];
    _tds = json['TDS'];
    _grossAbsentDays = json['GrossAbsentDays'];
    _totalLateHour = json['TotalLateHour'];
    _totalLateDeductionSal = json['TotalLateDeductionSal'];
    _actOTHour = json['ActOTHour'];
    _otherOtHour = json['OtherOtHour'];
    _semiComplinceOtHour = json['SemiComplinceOtHour'];
    _accountNo = json['AccountNo'];
  }
  String? _fullName;
  dynamic _contactNo;
  dynamic _email;
  String? _company;
  String? _addressLine1;
  String? _addressLine2;
  String? _departmentName;
  String? _sectionName;
  String? _lineName;
  String? _designationName;
  String? _salaryMonthName;
  String? _salaryYearName;
  num? _netIncomeTotal;
  num? _maternityDeduction;
  num? _absent;
  num? _late;
  num? _netDeduction;
  num? _ait;
  num? _leaveWithoutPay;
  num? _othersDeduction;
  num? _advance;
  num? _stamp;
  num? _outAttendance;
  num? _pf;
  num? _loan;
  num? _noticeDeduction;
  num? _pFCompanys;
  num? _netPeyable;
  num? _grossAbsent;
  num? _allowanceDeduction;
  num? _attnBonusDeduct;
  num? _convenceDeduct;
  num? _foodDeduct;
  num? _mobileBill;
  num? _arear;
  num? _oTAmount;
  num? _holidayAllowance;
  num? _salaryId;
  num? _employeeId;
  String? _formDate;
  String? _toDate;
  num? _grossSalary;
  num? _medical;
  num? _basicSalary;
  num? _houseRent;
  num? _conveyance;
  num? _allowence;
  num? _attendanceBonus;
  num? _foodAllowence;
  num? _bankPay;
  num? _cashPay;
  String? _companyAccount;
  num? _absentFee;
  num? _lateFee;
  num? _providentFund;
  num? _stampFees;
  num? _otherDeduction;
  num? _otherDeduction1;
  num? _otherDeduction2;
  num? _otherAllowence;
  num? _otherAllowence2;
  bool? _isPaid;
  bool? _isApprove;
  String? _salaryMonth;
  String? _salaryYear;
  String? _idCardNo;
  String? _grade;
  String? _joiningDate;
  num? _totalWorkingDays;
  num? _lateDays;
  num? _cMLCount;
  num? _casualLeave;
  num? _sickLeave;
  num? _weekEndDays;
  num? _presentDays;
  num? _earnLeave;
  num? _holidays;
  num? _maternityLeave;
  num? _lw;
  num? _otRate;
  num? _totalOTHour;
  num? _totalOTHourICS;
  num? _absentDays;
  num? _tds;
  num? _grossAbsentDays;
  String? _totalLateHour;
  num? _totalLateDeductionSal;
  num? _actOTHour;
  num? _otherOtHour;
  num? _semiComplinceOtHour;
  dynamic _accountNo;
PayslipModel copyWith({  String? fullName,
  dynamic contactNo,
  dynamic email,
  String? company,
  String? addressLine1,
  String? addressLine2,
  String? departmentName,
  String? sectionName,
  String? lineName,
  String? designationName,
  String? salaryMonthName,
  String? salaryYearName,
  num? netIncomeTotal,
  num? maternityDeduction,
  num? absent,
  num? late,
  num? netDeduction,
  num? ait,
  num? leaveWithoutPay,
  num? othersDeduction,
  num? advance,
  num? stamp,
  num? outAttendance,
  num? pf,
  num? loan,
  num? noticeDeduction,
  num? pFCompanys,
  num? netPeyable,
  num? grossAbsent,
  num? allowanceDeduction,
  num? attnBonusDeduct,
  num? convenceDeduct,
  num? foodDeduct,
  num? mobileBill,
  num? arear,
  num? oTAmount,
  num? holidayAllowance,
  num? salaryId,
  num? employeeId,
  String? formDate,
  String? toDate,
  num? grossSalary,
  num? medical,
  num? basicSalary,
  num? houseRent,
  num? conveyance,
  num? allowence,
  num? attendanceBonus,
  num? foodAllowence,
  num? bankPay,
  num? cashPay,
  String? companyAccount,
  num? absentFee,
  num? lateFee,
  num? providentFund,
  num? stampFees,
  num? otherDeduction,
  num? otherDeduction1,
  num? otherDeduction2,
  num? otherAllowence,
  num? otherAllowence2,
  bool? isPaid,
  bool? isApprove,
  String? salaryMonth,
  String? salaryYear,
  String? idCardNo,
  String? grade,
  String? joiningDate,
  num? totalWorkingDays,
  num? lateDays,
  num? cMLCount,
  num? casualLeave,
  num? sickLeave,
  num? weekEndDays,
  num? presentDays,
  num? earnLeave,
  num? holidays,
  num? maternityLeave,
  num? lw,
  num? otRate,
  num? totalOTHour,
  num? totalOTHourICS,
  num? absentDays,
  num? tds,
  num? grossAbsentDays,
  String? totalLateHour,
  num? totalLateDeductionSal,
  num? actOTHour,
  num? otherOtHour,
  num? semiComplinceOtHour,
  dynamic accountNo,
}) => PayslipModel(  fullName: fullName ?? _fullName,
  contactNo: contactNo ?? _contactNo,
  email: email ?? _email,
  company: company ?? _company,
  addressLine1: addressLine1 ?? _addressLine1,
  addressLine2: addressLine2 ?? _addressLine2,
  departmentName: departmentName ?? _departmentName,
  sectionName: sectionName ?? _sectionName,
  lineName: lineName ?? _lineName,
  designationName: designationName ?? _designationName,
  salaryMonthName: salaryMonthName ?? _salaryMonthName,
  salaryYearName: salaryYearName ?? _salaryYearName,
  netIncomeTotal: netIncomeTotal ?? _netIncomeTotal,
  maternityDeduction: maternityDeduction ?? _maternityDeduction,
  absent: absent ?? _absent,
  late: late ?? _late,
  netDeduction: netDeduction ?? _netDeduction,
  ait: ait ?? _ait,
  leaveWithoutPay: leaveWithoutPay ?? _leaveWithoutPay,
  othersDeduction: othersDeduction ?? _othersDeduction,
  advance: advance ?? _advance,
  stamp: stamp ?? _stamp,
  outAttendance: outAttendance ?? _outAttendance,
  pf: pf ?? _pf,
  loan: loan ?? _loan,
  noticeDeduction: noticeDeduction ?? _noticeDeduction,
  pFCompanys: pFCompanys ?? _pFCompanys,
  netPeyable: netPeyable ?? _netPeyable,
  grossAbsent: grossAbsent ?? _grossAbsent,
  allowanceDeduction: allowanceDeduction ?? _allowanceDeduction,
  attnBonusDeduct: attnBonusDeduct ?? _attnBonusDeduct,
  convenceDeduct: convenceDeduct ?? _convenceDeduct,
  foodDeduct: foodDeduct ?? _foodDeduct,
  mobileBill: mobileBill ?? _mobileBill,
  arear: arear ?? _arear,
  oTAmount: oTAmount ?? _oTAmount,
  holidayAllowance: holidayAllowance ?? _holidayAllowance,
  salaryId: salaryId ?? _salaryId,
  employeeId: employeeId ?? _employeeId,
  formDate: formDate ?? _formDate,
  toDate: toDate ?? _toDate,
  grossSalary: grossSalary ?? _grossSalary,
  medical: medical ?? _medical,
  basicSalary: basicSalary ?? _basicSalary,
  houseRent: houseRent ?? _houseRent,
  conveyance: conveyance ?? _conveyance,
  allowence: allowence ?? _allowence,
  attendanceBonus: attendanceBonus ?? _attendanceBonus,
  foodAllowence: foodAllowence ?? _foodAllowence,
  bankPay: bankPay ?? _bankPay,
  cashPay: cashPay ?? _cashPay,
  companyAccount: companyAccount ?? _companyAccount,
  absentFee: absentFee ?? _absentFee,
  lateFee: lateFee ?? _lateFee,
  providentFund: providentFund ?? _providentFund,
  stampFees: stampFees ?? _stampFees,
  otherDeduction: otherDeduction ?? _otherDeduction,
  otherDeduction1: otherDeduction1 ?? _otherDeduction1,
  otherDeduction2: otherDeduction2 ?? _otherDeduction2,
  otherAllowence: otherAllowence ?? _otherAllowence,
  otherAllowence2: otherAllowence2 ?? _otherAllowence2,
  isPaid: isPaid ?? _isPaid,
  isApprove: isApprove ?? _isApprove,
  salaryMonth: salaryMonth ?? _salaryMonth,
  salaryYear: salaryYear ?? _salaryYear,
  idCardNo: idCardNo ?? _idCardNo,
  grade: grade ?? _grade,
  joiningDate: joiningDate ?? _joiningDate,
  totalWorkingDays: totalWorkingDays ?? _totalWorkingDays,
  lateDays: lateDays ?? _lateDays,
  cMLCount: cMLCount ?? _cMLCount,
  casualLeave: casualLeave ?? _casualLeave,
  sickLeave: sickLeave ?? _sickLeave,
  weekEndDays: weekEndDays ?? _weekEndDays,
  presentDays: presentDays ?? _presentDays,
  earnLeave: earnLeave ?? _earnLeave,
  holidays: holidays ?? _holidays,
  maternityLeave: maternityLeave ?? _maternityLeave,
  lw: lw ?? _lw,
  otRate: otRate ?? _otRate,
  totalOTHour: totalOTHour ?? _totalOTHour,
  totalOTHourICS: totalOTHourICS ?? _totalOTHourICS,
  absentDays: absentDays ?? _absentDays,
  tds: tds ?? _tds,
  grossAbsentDays: grossAbsentDays ?? _grossAbsentDays,
  totalLateHour: totalLateHour ?? _totalLateHour,
  totalLateDeductionSal: totalLateDeductionSal ?? _totalLateDeductionSal,
  actOTHour: actOTHour ?? _actOTHour,
  otherOtHour: otherOtHour ?? _otherOtHour,
  semiComplinceOtHour: semiComplinceOtHour ?? _semiComplinceOtHour,
  accountNo: accountNo ?? _accountNo,
);
  String? get fullName => _fullName;
  dynamic get contactNo => _contactNo;
  dynamic get email => _email;
  String? get company => _company;
  String? get addressLine1 => _addressLine1;
  String? get addressLine2 => _addressLine2;
  String? get departmentName => _departmentName;
  String? get sectionName => _sectionName;
  String? get lineName => _lineName;
  String? get designationName => _designationName;
  String? get salaryMonthName => _salaryMonthName;
  String? get salaryYearName => _salaryYearName;
  num? get netIncomeTotal => _netIncomeTotal;
  num? get maternityDeduction => _maternityDeduction;
  num? get absent => _absent;
  num? get late => _late;
  num? get netDeduction => _netDeduction;
  num? get ait => _ait;
  num? get leaveWithoutPay => _leaveWithoutPay;
  num? get othersDeduction => _othersDeduction;
  num? get advance => _advance;
  num? get stamp => _stamp;
  num? get outAttendance => _outAttendance;
  num? get pf => _pf;
  num? get loan => _loan;
  num? get noticeDeduction => _noticeDeduction;
  num? get pFCompanys => _pFCompanys;
  num? get netPeyable => _netPeyable;
  num? get grossAbsent => _grossAbsent;
  num? get allowanceDeduction => _allowanceDeduction;
  num? get attnBonusDeduct => _attnBonusDeduct;
  num? get convenceDeduct => _convenceDeduct;
  num? get foodDeduct => _foodDeduct;
  num? get mobileBill => _mobileBill;
  num? get arear => _arear;
  num? get oTAmount => _oTAmount;
  num? get holidayAllowance => _holidayAllowance;
  num? get salaryId => _salaryId;
  num? get employeeId => _employeeId;
  String? get formDate => _formDate;
  String? get toDate => _toDate;
  num? get grossSalary => _grossSalary;
  num? get medical => _medical;
  num? get basicSalary => _basicSalary;
  num? get houseRent => _houseRent;
  num? get conveyance => _conveyance;
  num? get allowence => _allowence;
  num? get attendanceBonus => _attendanceBonus;
  num? get foodAllowence => _foodAllowence;
  num? get bankPay => _bankPay;
  num? get cashPay => _cashPay;
  String? get companyAccount => _companyAccount;
  num? get absentFee => _absentFee;
  num? get lateFee => _lateFee;
  num? get providentFund => _providentFund;
  num? get stampFees => _stampFees;
  num? get otherDeduction => _otherDeduction;
  num? get otherDeduction1 => _otherDeduction1;
  num? get otherDeduction2 => _otherDeduction2;
  num? get otherAllowence => _otherAllowence;
  num? get otherAllowence2 => _otherAllowence2;
  bool? get isPaid => _isPaid;
  bool? get isApprove => _isApprove;
  String? get salaryMonth => _salaryMonth;
  String? get salaryYear => _salaryYear;
  String? get idCardNo => _idCardNo;
  String? get grade => _grade;
  String? get joiningDate => _joiningDate;
  num? get totalWorkingDays => _totalWorkingDays;
  num? get lateDays => _lateDays;
  num? get cMLCount => _cMLCount;
  num? get casualLeave => _casualLeave;
  num? get sickLeave => _sickLeave;
  num? get weekEndDays => _weekEndDays;
  num? get presentDays => _presentDays;
  num? get earnLeave => _earnLeave;
  num? get holidays => _holidays;
  num? get maternityLeave => _maternityLeave;
  num? get lw => _lw;
  num? get otRate => _otRate;
  num? get totalOTHour => _totalOTHour;
  num? get totalOTHourICS => _totalOTHourICS;
  num? get absentDays => _absentDays;
  num? get tds => _tds;
  num? get grossAbsentDays => _grossAbsentDays;
  String? get totalLateHour => _totalLateHour;
  num? get totalLateDeductionSal => _totalLateDeductionSal;
  num? get actOTHour => _actOTHour;
  num? get otherOtHour => _otherOtHour;
  num? get semiComplinceOtHour => _semiComplinceOtHour;
  dynamic get accountNo => _accountNo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['FullName'] = _fullName;
    map['ContactNo'] = _contactNo;
    map['Email'] = _email;
    map['Company'] = _company;
    map['AddressLine1'] = _addressLine1;
    map['AddressLine2'] = _addressLine2;
    map['DepartmentName'] = _departmentName;
    map['SectionName'] = _sectionName;
    map['LineName'] = _lineName;
    map['DesignationName'] = _designationName;
    map['SalaryMonthName'] = _salaryMonthName;
    map['SalaryYearName'] = _salaryYearName;
    map['NetIncomeTotal'] = _netIncomeTotal;
    map['MaternityDeduction'] = _maternityDeduction;
    map['Absent'] = _absent;
    map['Late'] = _late;
    map['NetDeduction'] = _netDeduction;
    map['AIT'] = _ait;
    map['LeaveWithoutPay'] = _leaveWithoutPay;
    map['OthersDeduction'] = _othersDeduction;
    map['Advance'] = _advance;
    map['Stamp'] = _stamp;
    map['OutAttendance'] = _outAttendance;
    map['PF'] = _pf;
    map['Loan'] = _loan;
    map['NoticeDeduction'] = _noticeDeduction;
    map['PFCompanys'] = _pFCompanys;
    map['NetPeyable'] = _netPeyable;
    map['GrossAbsent'] = _grossAbsent;
    map['AllowanceDeduction'] = _allowanceDeduction;
    map['AttnBonusDeduct'] = _attnBonusDeduct;
    map['ConvenceDeduct'] = _convenceDeduct;
    map['FoodDeduct'] = _foodDeduct;
    map['MobileBill'] = _mobileBill;
    map['Arear'] = _arear;
    map['OTAmount'] = _oTAmount;
    map['HolidayAllowance'] = _holidayAllowance;
    map['SalaryId'] = _salaryId;
    map['EmployeeId'] = _employeeId;
    map['FormDate'] = _formDate;
    map['ToDate'] = _toDate;
    map['GrossSalary'] = _grossSalary;
    map['Medical'] = _medical;
    map['BasicSalary'] = _basicSalary;
    map['HouseRent'] = _houseRent;
    map['Conveyance'] = _conveyance;
    map['Allowence'] = _allowence;
    map['AttendanceBonus'] = _attendanceBonus;
    map['FoodAllowence'] = _foodAllowence;
    map['BankPay'] = _bankPay;
    map['CashPay'] = _cashPay;
    map['CompanyAccount'] = _companyAccount;
    map['AbsentFee'] = _absentFee;
    map['LateFee'] = _lateFee;
    map['ProvidentFund'] = _providentFund;
    map['StampFees'] = _stampFees;
    map['OtherDeduction'] = _otherDeduction;
    map['OtherDeduction1'] = _otherDeduction1;
    map['OtherDeduction2'] = _otherDeduction2;
    map['OtherAllowence'] = _otherAllowence;
    map['OtherAllowence2'] = _otherAllowence2;
    map['IsPaid'] = _isPaid;
    map['IsApprove'] = _isApprove;
    map['SalaryMonth'] = _salaryMonth;
    map['SalaryYear'] = _salaryYear;
    map['IdCardNo'] = _idCardNo;
    map['Grade'] = _grade;
    map['JoiningDate'] = _joiningDate;
    map['TotalWorkingDays'] = _totalWorkingDays;
    map['LateDays'] = _lateDays;
    map['CMLCount'] = _cMLCount;
    map['CasualLeave'] = _casualLeave;
    map['SickLeave'] = _sickLeave;
    map['WeekEndDays'] = _weekEndDays;
    map['PresentDays'] = _presentDays;
    map['EarnLeave'] = _earnLeave;
    map['Holidays'] = _holidays;
    map['MaternityLeave'] = _maternityLeave;
    map['LW'] = _lw;
    map['OtRate'] = _otRate;
    map['TotalOTHour'] = _totalOTHour;
    map['TotalOTHourICS'] = _totalOTHourICS;
    map['AbsentDays'] = _absentDays;
    map['TDS'] = _tds;
    map['GrossAbsentDays'] = _grossAbsentDays;
    map['TotalLateHour'] = _totalLateHour;
    map['TotalLateDeductionSal'] = _totalLateDeductionSal;
    map['ActOTHour'] = _actOTHour;
    map['OtherOtHour'] = _otherOtHour;
    map['SemiComplinceOtHour'] = _semiComplinceOtHour;
    map['AccountNo'] = _accountNo;
    return map;
  }

}