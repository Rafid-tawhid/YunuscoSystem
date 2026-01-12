class MachineScanModel {
  MachineScanModel({
    num? machineId,
    num? machineModelId,
      String? machineCode, 
      String? machineName,}){
    _machineId = machineId;
    _machineModelId = machineModelId;
    _machineCode = machineCode;
    _machineName = machineName;
}

  MachineScanModel.fromJson(dynamic json) {
    _machineId = json['MachineId']??'';
    _machineModelId = json['MachineModelId'];
    _machineCode = json['MachineCode'];
    _machineName = json['MachineName'];
  }
  num? _machineId;
  num? _machineModelId;
  String? _machineCode;
  String? _machineName;
MachineScanModel copyWith({  num? machineId,
  num? machineModelId,
  String? machineCode,
  String? machineName,
}) => MachineScanModel(  machineId: machineId ?? _machineId,
  machineModelId: machineModelId ?? _machineModelId,
  machineCode: machineCode ?? _machineCode,
  machineName: machineName ?? _machineName,
);
  num? get machineId => _machineId;
  num? get machineModelId => _machineModelId;
  String? get machineCode => _machineCode;
  String? get machineName => _machineName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['MachineId'] = _machineId;
    map['MachineModelId'] = _machineModelId;
    map['MachineCode'] = _machineCode;
    map['MachineName'] = _machineName;
    return map;
  }

}