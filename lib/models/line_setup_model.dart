class LineSetupModel {
  LineSetupModel({
      num? lineId, 
      String? name1, 
      String? name2, 
      String? name3, 
      String? allocationDate, 
      num? code, 
      num? targetValueIE, 
      num? targetValue, 
      num? wip, 
      bool? isActive, 
      bool? isPlanRunning, 
      num? workingHour, 
      num? allocatedManPower, 
      num? smv,}){
    _lineId = lineId;
    _name1 = name1;
    _name2 = name2;
    _name3 = name3;
    _allocationDate = allocationDate;
    _code = code;
    _targetValueIE = targetValueIE;
    _targetValue = targetValue;
    _wip = wip;
    _isActive = isActive;
    _isPlanRunning = isPlanRunning;
    _workingHour = workingHour;
    _allocatedManPower = allocatedManPower;
    _smv = smv;
}

  LineSetupModel.fromJson(dynamic json) {
    _lineId = json['LineId'];
    _name1 = json['Name1'];
    _name2 = json['Name2'];
    _name3 = json['Name3'];
    _allocationDate = json['AllocationDate'];
    _code = json['Code'];
    _targetValueIE = json['TargetValue_IE'];
    _targetValue = json['TargetValue'];
    _wip = json['Wip'];
    _isActive = json['IsActive'];
    _isPlanRunning = json['isPlanRunning'];
    _workingHour = json['WorkingHour'];
    _allocatedManPower = json['AllocatedManPower'];
    _smv = json['SMV'];
  }
  num? _lineId;
  String? _name1;
  String? _name2;
  String? _name3;
  String? _allocationDate;
  num? _code;
  num? _targetValueIE;
  num? _targetValue;
  num? _wip;
  bool? _isActive;
  bool? _isPlanRunning;
  num? _workingHour;
  num? _allocatedManPower;
  num? _smv;
LineSetupModel copyWith({  num? lineId,
  String? name1,
  String? name2,
  String? name3,
  String? allocationDate,
  num? code,
  num? targetValueIE,
  num? targetValue,
  num? wip,
  bool? isActive,
  bool? isPlanRunning,
  num? workingHour,
  num? allocatedManPower,
  num? smv,
}) => LineSetupModel(  lineId: lineId ?? _lineId,
  name1: name1 ?? _name1,
  name2: name2 ?? _name2,
  name3: name3 ?? _name3,
  allocationDate: allocationDate ?? _allocationDate,
  code: code ?? _code,
  targetValueIE: targetValueIE ?? _targetValueIE,
  targetValue: targetValue ?? _targetValue,
  wip: wip ?? _wip,
  isActive: isActive ?? _isActive,
  isPlanRunning: isPlanRunning ?? _isPlanRunning,
  workingHour: workingHour ?? _workingHour,
  allocatedManPower: allocatedManPower ?? _allocatedManPower,
  smv: smv ?? _smv,
);
  num? get lineId => _lineId;
  String? get name1 => _name1;
  String? get name2 => _name2;
  String? get name3 => _name3;
  String? get allocationDate => _allocationDate;
  num? get code => _code;
  num? get targetValueIE => _targetValueIE;
  num? get targetValue => _targetValue;
  num? get wip => _wip;
  bool? get isActive => _isActive;
  bool? get isPlanRunning => _isPlanRunning;
  num? get workingHour => _workingHour;
  num? get allocatedManPower => _allocatedManPower;
  num? get smv => _smv;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['LineId'] = _lineId;
    map['Name1'] = _name1;
    map['Name2'] = _name2;
    map['Name3'] = _name3;
    map['AllocationDate'] = _allocationDate;
    map['Code'] = _code;
    map['TargetValue_IE'] = _targetValueIE;
    map['TargetValue'] = _targetValue;
    map['Wip'] = _wip;
    map['IsActive'] = _isActive;
    map['isPlanRunning'] = _isPlanRunning;
    map['WorkingHour'] = _workingHour;
    map['AllocatedManPower'] = _allocatedManPower;
    map['SMV'] = _smv;
    return map;
  }

}