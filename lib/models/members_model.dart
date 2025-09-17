class MembersModel {
  MembersModel({
    String? idCardNo,
    String? fullName,
    String? designationName,
    String? departmentName,
    num? gradeId,
    String? ddlItemName,
    num? userId, // New field added here
    bool isSelected = false,
  }) {
    _idCardNo = idCardNo;
    _fullName = fullName;
    _designationName = designationName;
    _departmentName = departmentName;
    _gradeId = gradeId;
    _ddlItemName = ddlItemName;
    _userId = userId; // Initialize new field
    _isSelected = isSelected;
  }

  MembersModel.fromJson(dynamic json) {
    _idCardNo = json['IdCardNo'];
    _fullName = json['FullName'];
    _designationName = json['DesignationName'];
    _departmentName = json['DepartmentName'];
    _gradeId = json['GradeId'];
    _ddlItemName = json['DdlItemName'];
    _userId = json['UserId']; // New field from JSON
    _isSelected = false;
  }

  set isSelected(bool value) {
    _isSelected = value;
  }

  String? _idCardNo;
  String? _fullName;
  String? _designationName;
  String? _departmentName;
  num? _gradeId;
  String? _ddlItemName;
  num? _userId; // New private field declaration
  bool _isSelected = false;

  MembersModel copyWith({
    String? idCardNo,
    String? fullName,
    String? designationName,
    String? departmentName,
    num? gradeId,
    String? ddlItemName,
    num? userId, // Added to copyWith
    bool? isSelected,
  }) =>
      MembersModel(
        idCardNo: idCardNo ?? _idCardNo,
        fullName: fullName ?? _fullName,
        designationName: designationName ?? _designationName,
        departmentName: departmentName ?? _departmentName,
        gradeId: gradeId ?? _gradeId,
        ddlItemName: ddlItemName ?? _ddlItemName,
        userId: userId ?? _userId, // Include in copy
        isSelected: isSelected ?? _isSelected,
      );

  // Getters
  String? get idCardNo => _idCardNo;
  String? get fullName => _fullName;
  String? get designationName => _designationName;
  String? get departmentName => _departmentName;
  num? get gradeId => _gradeId;
  String? get ddlItemName => _ddlItemName;
  num? get userId => _userId; // New getter
  bool get isSelected => _isSelected;

  // Convenience method to toggle selection
  MembersModel toggleSelection() => copyWith(isSelected: !_isSelected);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['IdCardNo'] = _idCardNo;
    map['FullName'] = _fullName;
    map['DesignationName'] = _designationName;
    map['DepartmentName'] = _departmentName;
    map['GradeId'] = _gradeId;
    map['DdlItemName'] = _ddlItemName;
    map['UserId'] = _userId; // New field added to JSON
    // Note: isSelected is typically not serialized to JSON
    return map;
  }

  @override
  String toString() {
    return 'MembersModel{_idCardNo: $_idCardNo, _fullName: $_fullName, _designationName: $_designationName, _departmentName: $_departmentName, _gradeId: $_gradeId, _ddlItemName: $_ddlItemName, _userId: $_userId, _isSelected: $_isSelected}';
  }
}