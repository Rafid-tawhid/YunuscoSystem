class UserAccessType {
  UserAccessType({
      num? id, 
      num? userId, 
      String? role, 
      num? accessTypeId, 
      String? createdBy, 
      String? createdDate, 
      dynamic accessType,}){
    _id = id;
    _userId = userId;
    _role = role;
    _accessTypeId = accessTypeId;
    _createdBy = createdBy;
    _createdDate = createdDate;
    _accessType = accessType;
}

  UserAccessType.fromJson(dynamic json) {
    _id = json['Id'];
    _userId = json['UserId'];
    _role = json['Role'];
    _accessTypeId = json['AccessTypeId'];
    _createdBy = json['CreatedBy'];
    _createdDate = json['CreatedDate'];
    _accessType = json['AccessType'];
  }
  num? _id;
  num? _userId;
  String? _role;
  num? _accessTypeId;
  String? _createdBy;
  String? _createdDate;
  dynamic _accessType;
UserAccessType copyWith({  num? id,
  num? userId,
  String? role,
  num? accessTypeId,
  String? createdBy,
  String? createdDate,
  dynamic accessType,
}) => UserAccessType(  id: id ?? _id,
  userId: userId ?? _userId,
  role: role ?? _role,
  accessTypeId: accessTypeId ?? _accessTypeId,
  createdBy: createdBy ?? _createdBy,
  createdDate: createdDate ?? _createdDate,
  accessType: accessType ?? _accessType,
);
  num? get id => _id;
  num? get userId => _userId;
  String? get role => _role;
  num? get accessTypeId => _accessTypeId;
  String? get createdBy => _createdBy;
  String? get createdDate => _createdDate;
  dynamic get accessType => _accessType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = _id;
    map['UserId'] = _userId;
    map['Role'] = _role;
    map['AccessTypeId'] = _accessTypeId;
    map['CreatedBy'] = _createdBy;
    map['CreatedDate'] = _createdDate;
    map['AccessType'] = _accessType;
    return map;
  }

}