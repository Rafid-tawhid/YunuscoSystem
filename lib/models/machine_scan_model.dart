class MachineScanModel {
  MachineScanModel({
    num? machineId,
    num? machineTypeId,
      String? machineCode, 
      String? machineName,}){
    _machineId = machineId;
    _machineTypeId = machineTypeId;
    _machineCode = machineCode;
    _machineName = machineName;
}

  MachineScanModel.fromJson(dynamic json) {
    _machineId = json['MachineId']??'';
    _machineTypeId = json['MachineTypeId'];
    _machineCode = json['MachineCode'];
    _machineName = json['MachineName'];
  }
  num? _machineId;
  num? _machineTypeId;
  String? _machineCode;
  String? _machineName;
MachineScanModel copyWith({  num? machineId,
  num? machineModelId,
  String? machineCode,
  String? machineName,
}) => MachineScanModel(  machineId: machineId ?? _machineId,
  machineTypeId: machineModelId ?? _machineTypeId,
  machineCode: machineCode ?? _machineCode,
  machineName: machineName ?? _machineName,
);
  num? get machineId => _machineId;
  num? get machineTypeId => _machineTypeId;
  String? get machineCode => _machineCode;
  String? get machineName => _machineName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['MachineId'] = _machineId;
    map['MachineTypeId'] = _machineTypeId;
    map['MachineCode'] = _machineCode;
    map['MachineName'] = _machineName;
    return map;
  }

}