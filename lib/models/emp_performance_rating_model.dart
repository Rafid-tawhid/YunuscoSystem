class EmpPerformanceRatingModel {
  EmpPerformanceRatingModel({
      String? idCardNo, 
      String? fullName, 
      String? departmentName, 
      String? designationName, 
      num? totalReviews, 
      num? averageRatingPercentage,}){
    _idCardNo = idCardNo;
    _fullName = fullName;
    _departmentName = departmentName;
    _designationName = designationName;
    _totalReviews = totalReviews;
    _averageRatingPercentage = averageRatingPercentage;
}

  EmpPerformanceRatingModel.fromJson(dynamic json) {
    _idCardNo = json['IdCardNo'];
    _fullName = json['FullName'];
    _departmentName = json['DepartmentName'];
    _designationName = json['DesignationName'];
    _totalReviews = json['TotalReviews'];
    _averageRatingPercentage = json['AverageRatingPercentage'];
  }
  String? _idCardNo;
  String? _fullName;
  String? _departmentName;
  String? _designationName;
  num? _totalReviews;
  num? _averageRatingPercentage;
EmpPerformanceRatingModel copyWith({  String? idCardNo,
  String? fullName,
  String? departmentName,
  String? designationName,
  num? totalReviews,
  num? averageRatingPercentage,
}) => EmpPerformanceRatingModel(  idCardNo: idCardNo ?? _idCardNo,
  fullName: fullName ?? _fullName,
  departmentName: departmentName ?? _departmentName,
  designationName: designationName ?? _designationName,
  totalReviews: totalReviews ?? _totalReviews,
  averageRatingPercentage: averageRatingPercentage ?? _averageRatingPercentage,
);
  String? get idCardNo => _idCardNo;
  String? get fullName => _fullName;
  String? get departmentName => _departmentName;
  String? get designationName => _designationName;
  num? get totalReviews => _totalReviews;
  num? get averageRatingPercentage => _averageRatingPercentage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['IdCardNo'] = _idCardNo;
    map['FullName'] = _fullName;
    map['DepartmentName'] = _departmentName;
    map['DesignationName'] = _designationName;
    map['TotalReviews'] = _totalReviews;
    map['AverageRatingPercentage'] = _averageRatingPercentage;
    return map;
  }

}