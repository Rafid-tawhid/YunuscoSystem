class MaintananceTypeModel {
  MaintananceTypeModel({
      num? maintenanceTypeId, 
      String? maintenanceName,}){
    _maintenanceTypeId = maintenanceTypeId;
    _maintenanceName = maintenanceName;
}

  MaintananceTypeModel.fromJson(dynamic json) {
    _maintenanceTypeId = json['MaintenanceTypeId'];
    _maintenanceName = json['MaintenanceName'];
  }
  num? _maintenanceTypeId;
  String? _maintenanceName;
MaintananceTypeModel copyWith({  num? maintenanceTypeId,
  String? maintenanceName,
}) => MaintananceTypeModel(  maintenanceTypeId: maintenanceTypeId ?? _maintenanceTypeId,
  maintenanceName: maintenanceName ?? _maintenanceName,
);
  num? get maintenanceTypeId => _maintenanceTypeId;
  String? get maintenanceName => _maintenanceName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['MaintenanceTypeId'] = _maintenanceTypeId;
    map['MaintenanceName'] = _maintenanceName;
    return map;
  }

}