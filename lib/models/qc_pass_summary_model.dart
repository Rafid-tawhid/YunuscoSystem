class QcPassSummaryModel {
  QcPassSummaryModel({
      String? day, 
      num? totalPass, 
      num? totalDefect, 
      num? totalDefectiveGarments, 
      num? totalReject, 
      num? totalAlterCheck,}){
    _day = day;
    _totalPass = totalPass;
    _totalDefect = totalDefect;
    _totalDefectiveGarments = totalDefectiveGarments;
    _totalReject = totalReject;
    _totalAlterCheck = totalAlterCheck;
}

  QcPassSummaryModel.fromJson(dynamic json) {
    _day = json['Day'];
    _totalPass = json['TotalPass'];
    _totalDefect = json['TotalDefect'];
    _totalDefectiveGarments = json['TotalDefectiveGarments'];
    _totalReject = json['TotalReject'];
    _totalAlterCheck = json['TotalAlterCheck'];
  }
  String? _day;
  num? _totalPass;
  num? _totalDefect;
  num? _totalDefectiveGarments;
  num? _totalReject;
  num? _totalAlterCheck;
QcPassSummaryModel copyWith({  String? day,
  num? totalPass,
  num? totalDefect,
  num? totalDefectiveGarments,
  num? totalReject,
  num? totalAlterCheck,
}) => QcPassSummaryModel(  day: day ?? _day,
  totalPass: totalPass ?? _totalPass,
  totalDefect: totalDefect ?? _totalDefect,
  totalDefectiveGarments: totalDefectiveGarments ?? _totalDefectiveGarments,
  totalReject: totalReject ?? _totalReject,
  totalAlterCheck: totalAlterCheck ?? _totalAlterCheck,
);
  String? get day => _day;
  num? get totalPass => _totalPass;
  num? get totalDefect => _totalDefect;
  num? get totalDefectiveGarments => _totalDefectiveGarments;
  num? get totalReject => _totalReject;
  num? get totalAlterCheck => _totalAlterCheck;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Day'] = _day;
    map['TotalPass'] = _totalPass;
    map['TotalDefect'] = _totalDefect;
    map['TotalDefectiveGarments'] = _totalDefectiveGarments;
    map['TotalReject'] = _totalReject;
    map['TotalAlterCheck'] = _totalAlterCheck;
    return map;
  }

}