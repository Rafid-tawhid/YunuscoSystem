class AccessTypeModel {
  AccessTypeModel({
      num? accessTypeId, 
      String? accessTypeName, 
      String? createdBy, 
      String? createdDate, 
      List<String>? userAccessRoles,}){
    _accessTypeId = accessTypeId;
    _accessTypeName = accessTypeName;
    _createdBy = createdBy;
    _createdDate = createdDate;
    _userAccessRoles = userAccessRoles;
}

  AccessTypeModel.fromJson(dynamic json) {
    _accessTypeId = json['AccessTypeId'];
    _accessTypeName = json['AccessTypeName'];
    _createdBy = json['CreatedBy'];
    _createdDate = json['CreatedDate'];
    if (json['UserAccessRoles'] != null) {
      _userAccessRoles = [];
      json['UserAccessRoles'].forEach((v) {
        _userAccessRoles?.add(v);
      });
    }
  }
  num? _accessTypeId;
  String? _accessTypeName;
  String? _createdBy;
  String? _createdDate;
  List<String>? _userAccessRoles;
AccessTypeModel copyWith({  num? accessTypeId,
  String? accessTypeName,
  String? createdBy,
  String? createdDate,
  List<String>? userAccessRoles,
}) => AccessTypeModel(  accessTypeId: accessTypeId ?? _accessTypeId,
  accessTypeName: accessTypeName ?? _accessTypeName,
  createdBy: createdBy ?? _createdBy,
  createdDate: createdDate ?? _createdDate,
  userAccessRoles: userAccessRoles ?? _userAccessRoles,
);
  num? get accessTypeId => _accessTypeId;
  String? get accessTypeName => _accessTypeName;
  String? get createdBy => _createdBy;
  String? get createdDate => _createdDate;
  List<String>? get userAccessRoles => _userAccessRoles;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['AccessTypeId'] = _accessTypeId;
    map['AccessTypeName'] = _accessTypeName;
    map['CreatedBy'] = _createdBy;
    map['CreatedDate'] = _createdDate;
    if (_userAccessRoles != null) {
      map['UserAccessRoles'] = _userAccessRoles?.map((v) => v).toList();
    }
    return map;
  }

}