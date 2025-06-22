class MembersModel {
  MembersModel({
    String? idCardNo,
    String? fullName,
    String? designationName,
    String? departmentName,
    num? gradeId,
    String? ddlItemName,
    bool isSelected = false,  // Added with default value
  }) {
    _idCardNo = idCardNo;
    _fullName = fullName;
    _designationName = designationName;
    _departmentName = departmentName;
    _gradeId = gradeId;
    _ddlItemName = ddlItemName;
    _isSelected = isSelected;  // Initialize new field
  }

  MembersModel.fromJson(dynamic json) {
    _idCardNo = json['IdCardNo'];
    _fullName = json['FullName'];
    _designationName = json['DesignationName'];
    _departmentName = json['DepartmentName'];
    _gradeId = json['GradeId'];
    _ddlItemName = json['DdlItemName'];
    _isSelected = false;  // Default value when creating from JSON
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
  bool _isSelected = false;  // Field declaration with default

  MembersModel copyWith({
    String? idCardNo,
    String? fullName,
    String? designationName,
    String? departmentName,
    num? gradeId,
    String? ddlItemName,
    bool? isSelected,  // Added to copyWith
  }) => MembersModel(
    idCardNo: idCardNo ?? _idCardNo,
    fullName: fullName ?? _fullName,
    designationName: designationName ?? _designationName,
    departmentName: departmentName ?? _departmentName,
    gradeId: gradeId ?? _gradeId,
    ddlItemName: ddlItemName ?? _ddlItemName,
    isSelected: isSelected ?? _isSelected,  // Include in copy
  );

  // Getters
  String? get idCardNo => _idCardNo;
  String? get fullName => _fullName;
  String? get designationName => _designationName;
  String? get departmentName => _departmentName;
  num? get gradeId => _gradeId;
  String? get ddlItemName => _ddlItemName;
  bool get isSelected => _isSelected;  // New getter

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
    // Note: isSelected is typically not serialized to JSON
    return map;
  }

  @override
  String toString() {
    return 'MembersModel{idCardNo: $_idCardNo, fullName: $_fullName, isSelected: $_isSelected}';
  }
}