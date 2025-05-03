class SelfLeaveInfo {
  SelfLeaveInfo({
      String? idCardNo, 
      String? leaveYear, 
      num? sickLeave, 
      num? sickLeavePolicyId, 
      String? sickLeavePolicyType, 
      num? sickLeavePolicyDays, 
      num? casualLeave, 
      num? casualLeavePolicyId, 
      String? casualLeavePolicyType, 
      num? casualLeavePolicyDays, 
      num? maternityLeave, 
      num? maternityLeavePolicyId, 
      String? maternityLeavePolicyType, 
      num? maternityLeavePolicyDays, 
      num? earnLeave, 
      num? earnLeavePolicyId, 
      String? earnLeavePolicyType, 
      num? earnLeavePolicyDays, 
      num? leaveWithoutPay, 
      num? leaveWithoutPayPolicyId, 
      String? leaveWithoutPayPolicyType, 
      num? leaveWithoutPayPolicyDays,}){
    _idCardNo = idCardNo;
    _leaveYear = leaveYear;
    _sickLeave = sickLeave;
    _sickLeavePolicyId = sickLeavePolicyId;
    _sickLeavePolicyType = sickLeavePolicyType;
    _sickLeavePolicyDays = sickLeavePolicyDays;
    _casualLeave = casualLeave;
    _casualLeavePolicyId = casualLeavePolicyId;
    _casualLeavePolicyType = casualLeavePolicyType;
    _casualLeavePolicyDays = casualLeavePolicyDays;
    _maternityLeave = maternityLeave;
    _maternityLeavePolicyId = maternityLeavePolicyId;
    _maternityLeavePolicyType = maternityLeavePolicyType;
    _maternityLeavePolicyDays = maternityLeavePolicyDays;
    _earnLeave = earnLeave;
    _earnLeavePolicyId = earnLeavePolicyId;
    _earnLeavePolicyType = earnLeavePolicyType;
    _earnLeavePolicyDays = earnLeavePolicyDays;
    _leaveWithoutPay = leaveWithoutPay;
    _leaveWithoutPayPolicyId = leaveWithoutPayPolicyId;
    _leaveWithoutPayPolicyType = leaveWithoutPayPolicyType;
    _leaveWithoutPayPolicyDays = leaveWithoutPayPolicyDays;
}

  SelfLeaveInfo.fromJson(dynamic json) {
    _idCardNo = json['IdCardNo'];
    _leaveYear = json['LeaveYear'];
    _sickLeave = json['SickLeave'];
    _sickLeavePolicyId = json['SickLeavePolicyId'];
    _sickLeavePolicyType = json['SickLeavePolicyType'];
    _sickLeavePolicyDays = json['SickLeavePolicyDays'];
    _casualLeave = json['CasualLeave'];
    _casualLeavePolicyId = json['CasualLeavePolicyId'];
    _casualLeavePolicyType = json['CasualLeavePolicyType'];
    _casualLeavePolicyDays = json['CasualLeavePolicyDays'];
    _maternityLeave = json['MaternityLeave'];
    _maternityLeavePolicyId = json['MaternityLeavePolicyId'];
    _maternityLeavePolicyType = json['MaternityLeavePolicyType'];
    _maternityLeavePolicyDays = json['MaternityLeavePolicyDays'];
    _earnLeave = json['EarnLeave'];
    _earnLeavePolicyId = json['EarnLeavePolicyId'];
    _earnLeavePolicyType = json['EarnLeavePolicyType'];
    _earnLeavePolicyDays = json['EarnLeavePolicyDays'];
    _leaveWithoutPay = json['LeaveWithoutPay'];
    _leaveWithoutPayPolicyId = json['LeaveWithoutPayPolicyId'];
    _leaveWithoutPayPolicyType = json['LeaveWithoutPayPolicyType'];
    _leaveWithoutPayPolicyDays = json['LeaveWithoutPayPolicyDays'];
  }
  String? _idCardNo;
  String? _leaveYear;
  num? _sickLeave;
  num? _sickLeavePolicyId;
  String? _sickLeavePolicyType;
  num? _sickLeavePolicyDays;
  num? _casualLeave;
  num? _casualLeavePolicyId;
  String? _casualLeavePolicyType;
  num? _casualLeavePolicyDays;
  num? _maternityLeave;
  num? _maternityLeavePolicyId;
  String? _maternityLeavePolicyType;
  num? _maternityLeavePolicyDays;
  num? _earnLeave;
  num? _earnLeavePolicyId;
  String? _earnLeavePolicyType;
  num? _earnLeavePolicyDays;
  num? _leaveWithoutPay;
  num? _leaveWithoutPayPolicyId;
  String? _leaveWithoutPayPolicyType;
  num? _leaveWithoutPayPolicyDays;
SelfLeaveInfo copyWith({  String? idCardNo,
  String? leaveYear,
  num? sickLeave,
  num? sickLeavePolicyId,
  String? sickLeavePolicyType,
  num? sickLeavePolicyDays,
  num? casualLeave,
  num? casualLeavePolicyId,
  String? casualLeavePolicyType,
  num? casualLeavePolicyDays,
  num? maternityLeave,
  num? maternityLeavePolicyId,
  String? maternityLeavePolicyType,
  num? maternityLeavePolicyDays,
  num? earnLeave,
  num? earnLeavePolicyId,
  String? earnLeavePolicyType,
  num? earnLeavePolicyDays,
  num? leaveWithoutPay,
  num? leaveWithoutPayPolicyId,
  String? leaveWithoutPayPolicyType,
  num? leaveWithoutPayPolicyDays,
}) => SelfLeaveInfo(  idCardNo: idCardNo ?? _idCardNo,
  leaveYear: leaveYear ?? _leaveYear,
  sickLeave: sickLeave ?? _sickLeave,
  sickLeavePolicyId: sickLeavePolicyId ?? _sickLeavePolicyId,
  sickLeavePolicyType: sickLeavePolicyType ?? _sickLeavePolicyType,
  sickLeavePolicyDays: sickLeavePolicyDays ?? _sickLeavePolicyDays,
  casualLeave: casualLeave ?? _casualLeave,
  casualLeavePolicyId: casualLeavePolicyId ?? _casualLeavePolicyId,
  casualLeavePolicyType: casualLeavePolicyType ?? _casualLeavePolicyType,
  casualLeavePolicyDays: casualLeavePolicyDays ?? _casualLeavePolicyDays,
  maternityLeave: maternityLeave ?? _maternityLeave,
  maternityLeavePolicyId: maternityLeavePolicyId ?? _maternityLeavePolicyId,
  maternityLeavePolicyType: maternityLeavePolicyType ?? _maternityLeavePolicyType,
  maternityLeavePolicyDays: maternityLeavePolicyDays ?? _maternityLeavePolicyDays,
  earnLeave: earnLeave ?? _earnLeave,
  earnLeavePolicyId: earnLeavePolicyId ?? _earnLeavePolicyId,
  earnLeavePolicyType: earnLeavePolicyType ?? _earnLeavePolicyType,
  earnLeavePolicyDays: earnLeavePolicyDays ?? _earnLeavePolicyDays,
  leaveWithoutPay: leaveWithoutPay ?? _leaveWithoutPay,
  leaveWithoutPayPolicyId: leaveWithoutPayPolicyId ?? _leaveWithoutPayPolicyId,
  leaveWithoutPayPolicyType: leaveWithoutPayPolicyType ?? _leaveWithoutPayPolicyType,
  leaveWithoutPayPolicyDays: leaveWithoutPayPolicyDays ?? _leaveWithoutPayPolicyDays,
);
  String? get idCardNo => _idCardNo;
  String? get leaveYear => _leaveYear;
  num? get sickLeave => _sickLeave;
  num? get sickLeavePolicyId => _sickLeavePolicyId;
  String? get sickLeavePolicyType => _sickLeavePolicyType;
  num? get sickLeavePolicyDays => _sickLeavePolicyDays;
  num? get casualLeave => _casualLeave;
  num? get casualLeavePolicyId => _casualLeavePolicyId;
  String? get casualLeavePolicyType => _casualLeavePolicyType;
  num? get casualLeavePolicyDays => _casualLeavePolicyDays;
  num? get maternityLeave => _maternityLeave;
  num? get maternityLeavePolicyId => _maternityLeavePolicyId;
  String? get maternityLeavePolicyType => _maternityLeavePolicyType;
  num? get maternityLeavePolicyDays => _maternityLeavePolicyDays;
  num? get earnLeave => _earnLeave;
  num? get earnLeavePolicyId => _earnLeavePolicyId;
  String? get earnLeavePolicyType => _earnLeavePolicyType;
  num? get earnLeavePolicyDays => _earnLeavePolicyDays;
  num? get leaveWithoutPay => _leaveWithoutPay;
  num? get leaveWithoutPayPolicyId => _leaveWithoutPayPolicyId;
  String? get leaveWithoutPayPolicyType => _leaveWithoutPayPolicyType;
  num? get leaveWithoutPayPolicyDays => _leaveWithoutPayPolicyDays;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['IdCardNo'] = _idCardNo;
    map['LeaveYear'] = _leaveYear;
    map['SickLeave'] = _sickLeave;
    map['SickLeavePolicyId'] = _sickLeavePolicyId;
    map['SickLeavePolicyType'] = _sickLeavePolicyType;
    map['SickLeavePolicyDays'] = _sickLeavePolicyDays;
    map['CasualLeave'] = _casualLeave;
    map['CasualLeavePolicyId'] = _casualLeavePolicyId;
    map['CasualLeavePolicyType'] = _casualLeavePolicyType;
    map['CasualLeavePolicyDays'] = _casualLeavePolicyDays;
    map['MaternityLeave'] = _maternityLeave;
    map['MaternityLeavePolicyId'] = _maternityLeavePolicyId;
    map['MaternityLeavePolicyType'] = _maternityLeavePolicyType;
    map['MaternityLeavePolicyDays'] = _maternityLeavePolicyDays;
    map['EarnLeave'] = _earnLeave;
    map['EarnLeavePolicyId'] = _earnLeavePolicyId;
    map['EarnLeavePolicyType'] = _earnLeavePolicyType;
    map['EarnLeavePolicyDays'] = _earnLeavePolicyDays;
    map['LeaveWithoutPay'] = _leaveWithoutPay;
    map['LeaveWithoutPayPolicyId'] = _leaveWithoutPayPolicyId;
    map['LeaveWithoutPayPolicyType'] = _leaveWithoutPayPolicyType;
    map['LeaveWithoutPayPolicyDays'] = _leaveWithoutPayPolicyDays;
    return map;
  }

}