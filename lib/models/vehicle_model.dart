class VehicleModel {
  VehicleModel({
      num? vehicleReqId, 
      String? idCardNo, 
      String? destinationFrom, 
      String? destinationTo, 
      String? distance, 
      String? purpose, 
      String? requiredDate, 
      String? requiredTime, 
      String? duration, 
      String? employeeId, 
      String? carryGoods, 
      num? vehicletypeId, 
      String? vehicleNo, 
      String? driverMobileNo, 
      String? driverName, 
      dynamic userName, 
      String? departmentName, 
      String? sectionName, 
      String? designationName, 
      String? fullName, 
      num? status,}){
    _vehicleReqId = vehicleReqId;
    _idCardNo = idCardNo;
    _destinationFrom = destinationFrom;
    _destinationTo = destinationTo;
    _distance = distance;
    _purpose = purpose;
    _requiredDate = requiredDate;
    _requiredTime = requiredTime;
    _duration = duration;
    _employeeId = employeeId;
    _carryGoods = carryGoods;
    _vehicletypeId = vehicletypeId;
    _vehicleNo = vehicleNo;
    _driverMobileNo = driverMobileNo;
    _driverName = driverName;
    _userName = userName;
    _departmentName = departmentName;
    _sectionName = sectionName;
    _designationName = designationName;
    _fullName = fullName;
    _status = status;
}

  VehicleModel.fromJson(dynamic json) {
    _vehicleReqId = json['VehicleReqId'];
    _idCardNo = json['IdCardNo'];
    _destinationFrom = json['DestinationFrom'];
    _destinationTo = json['DestinationTo'];
    _distance = json['Distance'];
    _purpose = json['Purpose'];
    _requiredDate = json['RequiredDate'];
    _requiredTime = json['RequiredTime'];
    _duration = json['Duration'];
    _employeeId = json['EmployeeId'];
    _carryGoods = json['CarryGoods'];
    _vehicletypeId = json['VehicletypeId'];
    _vehicleNo = json['VehicleNo'];
    _driverMobileNo = json['DriverMobileNo'];
    _driverName = json['DriverName'];
    _userName = json['UserName'];
    _departmentName = json['DepartmentName'];
    _sectionName = json['SectionName'];
    _designationName = json['DesignationName'];
    _fullName = json['FullName'];
    _status = json['Status'];
  }
  num? _vehicleReqId;
  String? _idCardNo;
  String? _destinationFrom;
  String? _destinationTo;
  String? _distance;
  String? _purpose;
  String? _requiredDate;
  String? _requiredTime;
  String? _duration;
  String? _employeeId;
  String? _carryGoods;
  num? _vehicletypeId;
  String? _vehicleNo;
  String? _driverMobileNo;
  String? _driverName;
  dynamic _userName;
  String? _departmentName;
  String? _sectionName;
  String? _designationName;
  String? _fullName;
  num? _status;
VehicleModel copyWith({  num? vehicleReqId,
  String? idCardNo,
  String? destinationFrom,
  String? destinationTo,
  String? distance,
  String? purpose,
  String? requiredDate,
  String? requiredTime,
  String? duration,
  String? employeeId,
  String? carryGoods,
  num? vehicletypeId,
  String? vehicleNo,
  String? driverMobileNo,
  String? driverName,
  dynamic userName,
  String? departmentName,
  String? sectionName,
  String? designationName,
  String? fullName,
  num? status,
}) => VehicleModel(  vehicleReqId: vehicleReqId ?? _vehicleReqId,
  idCardNo: idCardNo ?? _idCardNo,
  destinationFrom: destinationFrom ?? _destinationFrom,
  destinationTo: destinationTo ?? _destinationTo,
  distance: distance ?? _distance,
  purpose: purpose ?? _purpose,
  requiredDate: requiredDate ?? _requiredDate,
  requiredTime: requiredTime ?? _requiredTime,
  duration: duration ?? _duration,
  employeeId: employeeId ?? _employeeId,
  carryGoods: carryGoods ?? _carryGoods,
  vehicletypeId: vehicletypeId ?? _vehicletypeId,
  vehicleNo: vehicleNo ?? _vehicleNo,
  driverMobileNo: driverMobileNo ?? _driverMobileNo,
  driverName: driverName ?? _driverName,
  userName: userName ?? _userName,
  departmentName: departmentName ?? _departmentName,
  sectionName: sectionName ?? _sectionName,
  designationName: designationName ?? _designationName,
  fullName: fullName ?? _fullName,
  status: status ?? _status,
);
  num? get vehicleReqId => _vehicleReqId;
  String? get idCardNo => _idCardNo;
  String? get destinationFrom => _destinationFrom;
  String? get destinationTo => _destinationTo;
  String? get distance => _distance;
  String? get purpose => _purpose;
  String? get requiredDate => _requiredDate;
  String? get requiredTime => _requiredTime;
  String? get duration => _duration;
  String? get employeeId => _employeeId;
  String? get carryGoods => _carryGoods;
  num? get vehicletypeId => _vehicletypeId;
  String? get vehicleNo => _vehicleNo;
  String? get driverMobileNo => _driverMobileNo;
  String? get driverName => _driverName;
  dynamic get userName => _userName;
  String? get departmentName => _departmentName;
  String? get sectionName => _sectionName;
  String? get designationName => _designationName;
  String? get fullName => _fullName;
  num? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['VehicleReqId'] = _vehicleReqId;
    map['IdCardNo'] = _idCardNo;
    map['DestinationFrom'] = _destinationFrom;
    map['DestinationTo'] = _destinationTo;
    map['Distance'] = _distance;
    map['Purpose'] = _purpose;
    map['RequiredDate'] = _requiredDate;
    map['RequiredTime'] = _requiredTime;
    map['Duration'] = _duration;
    map['EmployeeId'] = _employeeId;
    map['CarryGoods'] = _carryGoods;
    map['VehicletypeId'] = _vehicletypeId;
    map['VehicleNo'] = _vehicleNo;
    map['DriverMobileNo'] = _driverMobileNo;
    map['DriverName'] = _driverName;
    map['UserName'] = _userName;
    map['DepartmentName'] = _departmentName;
    map['SectionName'] = _sectionName;
    map['DesignationName'] = _designationName;
    map['FullName'] = _fullName;
    map['Status'] = _status;
    return map;
  }

}