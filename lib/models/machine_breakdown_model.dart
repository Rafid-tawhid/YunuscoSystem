class MachineBreakdownModel {
  MachineBreakdownModel({
      num? maintenanceId, 
      String? maintenanceName, 
      dynamic maintenanceDate, 
      String? idCardNo, 
      String? fullName, 
      String? operationName, 
      String? lineName, 
      String? machineType, 
      String? machineNo, 
      String? taskCode, 
      String? reportedTime, 
      dynamic mechanicInfoTime, 
      dynamic workStartTime, 
      dynamic delayTime, 
      dynamic workEndTime, 
      dynamic mechanicWorkTime, 
      dynamic breakdownDescription, 
      dynamic breakdownDateTime, 
      String? status, 
      String? createdDate, 
      String? updatedDate,}){
    _maintenanceId = maintenanceId;
    _maintenanceName = maintenanceName;
    _maintenanceDate = maintenanceDate;
    _idCardNo = idCardNo;
    _fullName = fullName;
    _operationName = operationName;
    _lineName = lineName;
    _machineType = machineType;
    _machineNo = machineNo;
    _taskCode = taskCode;
    _reportedTime = reportedTime;
    _mechanicInfoTime = mechanicInfoTime;
    _workStartTime = workStartTime;
    _delayTime = delayTime;
    _workEndTime = workEndTime;
    _mechanicWorkTime = mechanicWorkTime;
    _breakdownDescription = breakdownDescription;
    _breakdownDateTime = breakdownDateTime;
    _status = status;
    _createdDate = createdDate;
    _updatedDate = updatedDate;
}

  MachineBreakdownModel.fromJson(dynamic json) {
    _maintenanceId = json['MaintenanceId'];
    _maintenanceName = json['MaintenanceName'];
    _maintenanceDate = json['MaintenanceDate'];
    _idCardNo = json['IdCardNo'];
    _fullName = json['FullName'];
    _operationName = json['OperationName'];
    _lineName = json['LineName'];
    _machineType = json['MachineType'];
    _machineNo = json['MachineNo'];
    _taskCode = json['TaskCode'];
    _reportedTime = json['ReportedTime'];
    _mechanicInfoTime = json['MechanicInfoTime'];
    _workStartTime = json['WorkStartTime'];
    _delayTime = json['DelayTime'];
    _workEndTime = json['WorkEndTime'];
    _mechanicWorkTime = json['MechanicWorkTime'];
    _breakdownDescription = json['BreakdownDescription'];
    _breakdownDateTime = json['BreakdownDateTime'];
    _status = json['Status'];
    _createdDate = json['CreatedDate'];
    _updatedDate = json['UpdatedDate'];
  }
  num? _maintenanceId;
  String? _maintenanceName;
  dynamic _maintenanceDate;
  String? _idCardNo;
  String? _fullName;
  String? _operationName;
  String? _lineName;
  String? _machineType;
  String? _machineNo;
  String? _taskCode;
  String? _reportedTime;
  dynamic _mechanicInfoTime;
  dynamic _workStartTime;
  dynamic _delayTime;
  dynamic _workEndTime;
  dynamic _mechanicWorkTime;
  dynamic _breakdownDescription;
  dynamic _breakdownDateTime;
  String? _status;
  String? _createdDate;
  String? _updatedDate;
MachineBreakdownModel copyWith({  num? maintenanceId,
  String? maintenanceName,
  dynamic maintenanceDate,
  String? idCardNo,
  String? fullName,
  String? operationName,
  String? lineName,
  String? machineType,
  String? machineNo,
  String? taskCode,
  String? reportedTime,
  dynamic mechanicInfoTime,
  dynamic workStartTime,
  dynamic delayTime,
  dynamic workEndTime,
  dynamic mechanicWorkTime,
  dynamic breakdownDescription,
  dynamic breakdownDateTime,
  String? status,
  String? createdDate,
  String? updatedDate,
}) => MachineBreakdownModel(  maintenanceId: maintenanceId ?? _maintenanceId,
  maintenanceName: maintenanceName ?? _maintenanceName,
  maintenanceDate: maintenanceDate ?? _maintenanceDate,
  idCardNo: idCardNo ?? _idCardNo,
  fullName: fullName ?? _fullName,
  operationName: operationName ?? _operationName,
  lineName: lineName ?? _lineName,
  machineType: machineType ?? _machineType,
  machineNo: machineNo ?? _machineNo,
  taskCode: taskCode ?? _taskCode,
  reportedTime: reportedTime ?? _reportedTime,
  mechanicInfoTime: mechanicInfoTime ?? _mechanicInfoTime,
  workStartTime: workStartTime ?? _workStartTime,
  delayTime: delayTime ?? _delayTime,
  workEndTime: workEndTime ?? _workEndTime,
  mechanicWorkTime: mechanicWorkTime ?? _mechanicWorkTime,
  breakdownDescription: breakdownDescription ?? _breakdownDescription,
  breakdownDateTime: breakdownDateTime ?? _breakdownDateTime,
  status: status ?? _status,
  createdDate: createdDate ?? _createdDate,
  updatedDate: updatedDate ?? _updatedDate,
);
  num? get maintenanceId => _maintenanceId;
  String? get maintenanceName => _maintenanceName;
  dynamic get maintenanceDate => _maintenanceDate;
  String? get idCardNo => _idCardNo;
  String? get fullName => _fullName;
  String? get operationName => _operationName;
  String? get lineName => _lineName;
  String? get machineType => _machineType;
  String? get machineNo => _machineNo;
  String? get taskCode => _taskCode;
  String? get reportedTime => _reportedTime;
  dynamic get mechanicInfoTime => _mechanicInfoTime;
  dynamic get workStartTime => _workStartTime;
  dynamic get delayTime => _delayTime;
  dynamic get workEndTime => _workEndTime;
  dynamic get mechanicWorkTime => _mechanicWorkTime;
  dynamic get breakdownDescription => _breakdownDescription;
  dynamic get breakdownDateTime => _breakdownDateTime;
  String? get status => _status;
  String? get createdDate => _createdDate;
  String? get updatedDate => _updatedDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['MaintenanceId'] = _maintenanceId;
    map['MaintenanceName'] = _maintenanceName;
    map['MaintenanceDate'] = _maintenanceDate;
    map['IdCardNo'] = _idCardNo;
    map['FullName'] = _fullName;
    map['OperationName'] = _operationName;
    map['LineName'] = _lineName;
    map['MachineType'] = _machineType;
    map['MachineNo'] = _machineNo;
    map['TaskCode'] = _taskCode;
    map['ReportedTime'] = _reportedTime;
    map['MechanicInfoTime'] = _mechanicInfoTime;
    map['WorkStartTime'] = _workStartTime;
    map['DelayTime'] = _delayTime;
    map['WorkEndTime'] = _workEndTime;
    map['MechanicWorkTime'] = _mechanicWorkTime;
    map['BreakdownDescription'] = _breakdownDescription;
    map['BreakdownDateTime'] = _breakdownDateTime;
    map['Status'] = _status;
    map['CreatedDate'] = _createdDate;
    map['UpdatedDate'] = _updatedDate;
    return map;
  }

}