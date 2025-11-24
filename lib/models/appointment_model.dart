class AppointmentModel {
  AppointmentModel({
      num? appointmentId, 
      String? appointmentNumber, 
      String? employeeName, 
      String? employeeId, 
      String? department, 
      String? designation, 
      String? appointmentWith, 
      String? preferredDate, 
      String? preferredTime, 
      String? purpose, 
      String? status, 
      dynamic managerScheduledDate, 
      dynamic managerScheduledTime, 
      String? createdDate, 
      String? createdBy, 
      dynamic updatedDate, 
      dynamic updatedBy,}){
    _appointmentId = appointmentId;
    _appointmentNumber = appointmentNumber;
    _employeeName = employeeName;
    _employeeId = employeeId;
    _department = department;
    _designation = designation;
    _appointmentWith = appointmentWith;
    _preferredDate = preferredDate;
    _preferredTime = preferredTime;
    _purpose = purpose;
    _status = status;
    _managerScheduledDate = managerScheduledDate;
    _managerScheduledTime = managerScheduledTime;
    _createdDate = createdDate;
    _createdBy = createdBy;
    _updatedDate = updatedDate;
    _updatedBy = updatedBy;
}

  AppointmentModel.fromJson(dynamic json) {
    _appointmentId = json['AppointmentId'];
    _appointmentNumber = json['AppointmentNumber'];
    _employeeName = json['EmployeeName'];
    _employeeId = json['EmployeeId'];
    _department = json['Department'];
    _designation = json['Designation'];
    _appointmentWith = json['AppointmentWith'];
    _preferredDate = json['PreferredDate'];
    _preferredTime = json['PreferredTime'];
    _purpose = json['Purpose'];
    _status = json['Status'];
    _managerScheduledDate = json['ManagerScheduledDate'];
    _managerScheduledTime = json['ManagerScheduledTime'];
    _createdDate = json['CreatedDate'];
    _createdBy = json['CreatedBy'];
    _updatedDate = json['UpdatedDate'];
    _updatedBy = json['UpdatedBy'];
  }
  num? _appointmentId;
  String? _appointmentNumber;
  String? _employeeName;
  String? _employeeId;
  String? _department;
  String? _designation;
  String? _appointmentWith;
  String? _preferredDate;
  String? _preferredTime;
  String? _purpose;
  String? _status;
  dynamic _managerScheduledDate;
  dynamic _managerScheduledTime;
  String? _createdDate;
  String? _createdBy;
  dynamic _updatedDate;
  dynamic _updatedBy;
AppointmentModel copyWith({  num? appointmentId,
  String? appointmentNumber,
  String? employeeName,
  String? employeeId,
  String? department,
  String? designation,
  String? appointmentWith,
  String? preferredDate,
  String? preferredTime,
  String? purpose,
  String? status,
  dynamic managerScheduledDate,
  dynamic managerScheduledTime,
  String? createdDate,
  String? createdBy,
  dynamic updatedDate,
  dynamic updatedBy,
}) => AppointmentModel(  appointmentId: appointmentId ?? _appointmentId,
  appointmentNumber: appointmentNumber ?? _appointmentNumber,
  employeeName: employeeName ?? _employeeName,
  employeeId: employeeId ?? _employeeId,
  department: department ?? _department,
  designation: designation ?? _designation,
  appointmentWith: appointmentWith ?? _appointmentWith,
  preferredDate: preferredDate ?? _preferredDate,
  preferredTime: preferredTime ?? _preferredTime,
  purpose: purpose ?? _purpose,
  status: status ?? _status,
  managerScheduledDate: managerScheduledDate ?? _managerScheduledDate,
  managerScheduledTime: managerScheduledTime ?? _managerScheduledTime,
  createdDate: createdDate ?? _createdDate,
  createdBy: createdBy ?? _createdBy,
  updatedDate: updatedDate ?? _updatedDate,
  updatedBy: updatedBy ?? _updatedBy,
);
  num? get appointmentId => _appointmentId;
  String? get appointmentNumber => _appointmentNumber;
  String? get employeeName => _employeeName;
  String? get employeeId => _employeeId;
  String? get department => _department;
  String? get designation => _designation;
  String? get appointmentWith => _appointmentWith;
  String? get preferredDate => _preferredDate;
  String? get preferredTime => _preferredTime;
  String? get purpose => _purpose;
  String? get status => _status;
  dynamic get managerScheduledDate => _managerScheduledDate;
  dynamic get managerScheduledTime => _managerScheduledTime;
  String? get createdDate => _createdDate;
  String? get createdBy => _createdBy;
  dynamic get updatedDate => _updatedDate;
  dynamic get updatedBy => _updatedBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['AppointmentId'] = _appointmentId;
    map['AppointmentNumber'] = _appointmentNumber;
    map['EmployeeName'] = _employeeName;
    map['EmployeeId'] = _employeeId;
    map['Department'] = _department;
    map['Designation'] = _designation;
    map['AppointmentWith'] = _appointmentWith;
    map['PreferredDate'] = _preferredDate;
    map['PreferredTime'] = _preferredTime;
    map['Purpose'] = _purpose;
    map['Status'] = _status;
    map['ManagerScheduledDate'] = _managerScheduledDate;
    map['ManagerScheduledTime'] = _managerScheduledTime;
    map['CreatedDate'] = _createdDate;
    map['CreatedBy'] = _createdBy;
    map['UpdatedDate'] = _updatedDate;
    map['UpdatedBy'] = _updatedBy;
    return map;
  }

}