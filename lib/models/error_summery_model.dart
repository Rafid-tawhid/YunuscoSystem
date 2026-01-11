class ErrorSummaryModel {
  ErrorSummaryModel({
      String? day, 
      String? errorName, 
      num? totalDefects,}){
    _day = day;
    _errorName = errorName;
    _totalDefects = totalDefects;
}

  ErrorSummaryModel.fromJson(dynamic json) {
    _day = json['Day'];
    _errorName = json['ErrorName'];
    _totalDefects = json['TotalDefects'];
  }
  String? _day;
  String? _errorName;
  num? _totalDefects;
ErrorSummaryModel copyWith({  String? day,
  String? errorName,
  num? totalDefects,
}) => ErrorSummaryModel(  day: day ?? _day,
  errorName: errorName ?? _errorName,
  totalDefects: totalDefects ?? _totalDefects,
);
  String? get day => _day;
  String? get errorName => _errorName;
  num? get totalDefects => _totalDefects;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Day'] = _day;
    map['ErrorName'] = _errorName;
    map['TotalDefects'] = _totalDefects;
    return map;
  }

}