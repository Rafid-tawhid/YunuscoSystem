class QcDifferenceModel {
  QcDifferenceModel({
      String? lineName, 
      String? sectionName, 
      String? buyerName, 
      num? totalPassDate1, 
      num? totalDefectDate1, 
      num? totalRejectDate1, 
      num? totalPassDate2, 
      num? totalDefectDate2, 
      num? totalRejectDate2, 
      num? passDifference, 
      num? defectDifference, 
      num? rejectDifference,}){
    _lineName = lineName;
    _sectionName = sectionName;
    _buyerName = buyerName;
    _totalPassDate1 = totalPassDate1;
    _totalDefectDate1 = totalDefectDate1;
    _totalRejectDate1 = totalRejectDate1;
    _totalPassDate2 = totalPassDate2;
    _totalDefectDate2 = totalDefectDate2;
    _totalRejectDate2 = totalRejectDate2;
    _passDifference = passDifference;
    _defectDifference = defectDifference;
    _rejectDifference = rejectDifference;
}

  QcDifferenceModel.fromJson(dynamic json) {
    _lineName = json['LineName'];
    _sectionName = json['SectionName'];
    _buyerName = json['BuyerName'];
    _totalPassDate1 = json['TotalPass_Date1'];
    _totalDefectDate1 = json['TotalDefect_Date1'];
    _totalRejectDate1 = json['TotalReject_Date1'];
    _totalPassDate2 = json['TotalPass_Date2'];
    _totalDefectDate2 = json['TotalDefect_Date2'];
    _totalRejectDate2 = json['TotalReject_Date2'];
    _passDifference = json['Pass_Difference']??0;
    _defectDifference = json['Defect_Difference']??0;
    _rejectDifference = json['Reject_Difference']??0;
  }
  String? _lineName;
  String? _sectionName;
  String? _buyerName;
  num? _totalPassDate1;
  num? _totalDefectDate1;
  num? _totalRejectDate1;
  num? _totalPassDate2;
  num? _totalDefectDate2;
  num? _totalRejectDate2;
  num? _passDifference;
  num? _defectDifference;
  num? _rejectDifference;
QcDifferenceModel copyWith({  String? lineName,
  String? sectionName,
  String? buyerName,
  num? totalPassDate1,
  num? totalDefectDate1,
  num? totalRejectDate1,
  num? totalPassDate2,
  num? totalDefectDate2,
  num? totalRejectDate2,
  num? passDifference,
  num? defectDifference,
  num? rejectDifference,
}) => QcDifferenceModel(  lineName: lineName ?? _lineName,
  sectionName: sectionName ?? _sectionName,
  buyerName: buyerName ?? _buyerName,
  totalPassDate1: totalPassDate1 ?? _totalPassDate1,
  totalDefectDate1: totalDefectDate1 ?? _totalDefectDate1,
  totalRejectDate1: totalRejectDate1 ?? _totalRejectDate1,
  totalPassDate2: totalPassDate2 ?? _totalPassDate2,
  totalDefectDate2: totalDefectDate2 ?? _totalDefectDate2,
  totalRejectDate2: totalRejectDate2 ?? _totalRejectDate2,
  passDifference: passDifference ?? _passDifference,
  defectDifference: defectDifference ?? _defectDifference,
  rejectDifference: rejectDifference ?? _rejectDifference,
);
  String? get lineName => _lineName;
  String? get sectionName => _sectionName;
  String? get buyerName => _buyerName;
  num? get totalPassDate1 => _totalPassDate1;
  num? get totalDefectDate1 => _totalDefectDate1;
  num? get totalRejectDate1 => _totalRejectDate1;
  num? get totalPassDate2 => _totalPassDate2;
  num? get totalDefectDate2 => _totalDefectDate2;
  num? get totalRejectDate2 => _totalRejectDate2;
  num? get passDifference => _passDifference;
  num? get defectDifference => _defectDifference;
  num? get rejectDifference => _rejectDifference;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['LineName'] = _lineName;
    map['SectionName'] = _sectionName;
    map['BuyerName'] = _buyerName;
    map['TotalPass_Date1'] = _totalPassDate1;
    map['TotalDefect_Date1'] = _totalDefectDate1;
    map['TotalReject_Date1'] = _totalRejectDate1;
    map['TotalPass_Date2'] = _totalPassDate2;
    map['TotalDefect_Date2'] = _totalDefectDate2;
    map['TotalReject_Date2'] = _totalRejectDate2;
    map['Pass_Difference'] = _passDifference;
    map['Defect_Difference'] = _defectDifference;
    map['Reject_Difference'] = _rejectDifference;
    return map;
  }

}