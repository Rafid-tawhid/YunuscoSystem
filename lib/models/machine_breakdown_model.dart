class MachineBreakdownModel {
  MachineBreakdownModel({
      num? repairId, 
      String? requisitionCode, 
      String? maintenanceName, 
      String? sectionName, 
      String? lineName, 
      String? machineName, 
      String? createdDate, 
      String? swingMachineTypeName,}){
    _repairId = repairId;
    _requisitionCode = requisitionCode;
    _maintenanceName = maintenanceName;
    _sectionName = sectionName;
    _lineName = lineName;
    _machineName = machineName;
    _createdDate = createdDate;
    _swingMachineTypeName = swingMachineTypeName;
}

  MachineBreakdownModel.fromJson(dynamic json) {
    _repairId = json['RepairId'];
    _requisitionCode = json['RequisitionCode'];
    _maintenanceName = json['MaintenanceName'];
    _sectionName = json['SectionName'];
    _lineName = json['LineName'];
    _machineName = json['MachineName'];
    _createdDate = json['CreatedDate'];
    _swingMachineTypeName = json['SwingMachineTypeName'];
  }
  num? _repairId;
  String? _requisitionCode;
  String? _maintenanceName;
  String? _sectionName;
  String? _lineName;
  String? _machineName;
  String? _createdDate;
  String? _swingMachineTypeName;
MachineBreakdownModel copyWith({  num? repairId,
  String? requisitionCode,
  String? maintenanceName,
  String? sectionName,
  String? lineName,
  String? machineName,
  String? createdDate,
  String? swingMachineTypeName,
}) => MachineBreakdownModel(  repairId: repairId ?? _repairId,
  requisitionCode: requisitionCode ?? _requisitionCode,
  maintenanceName: maintenanceName ?? _maintenanceName,
  sectionName: sectionName ?? _sectionName,
  lineName: lineName ?? _lineName,
  machineName: machineName ?? _machineName,
  createdDate: createdDate ?? _createdDate,
  swingMachineTypeName: swingMachineTypeName ?? _swingMachineTypeName,
);
  num? get repairId => _repairId;
  String? get requisitionCode => _requisitionCode;
  String? get maintenanceName => _maintenanceName;
  String? get sectionName => _sectionName;
  String? get lineName => _lineName;
  String? get machineName => _machineName;
  String? get createdDate => _createdDate;
  String? get swingMachineTypeName => _swingMachineTypeName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['RepairId'] = _repairId;
    map['RequisitionCode'] = _requisitionCode;
    map['MaintenanceName'] = _maintenanceName;
    map['SectionName'] = _sectionName;
    map['LineName'] = _lineName;
    map['MachineName'] = _machineName;
    map['CreatedDate'] = _createdDate;
    map['SwingMachineTypeName'] = _swingMachineTypeName;
    return map;
  }

}