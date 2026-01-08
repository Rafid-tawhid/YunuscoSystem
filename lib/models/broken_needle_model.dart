class BrokenNeedleModel {
  BrokenNeedleModel({
      num? year, 
      String? monthName, 
      num? monthNumber, 
      num? totalIssueQty, 
      num? missingQty, 
      num? brokenQty, 
      num? bluntQty, 
      num? balance, 
      num? used, 
      num? brokenPercentage,}){
    _year = year;
    _monthName = monthName;
    _monthNumber = monthNumber;
    _totalIssueQty = totalIssueQty;
    _missingQty = missingQty;
    _brokenQty = brokenQty;
    _bluntQty = bluntQty;
    _balance = balance;
    _used = used;
    _brokenPercentage = brokenPercentage;
}

  BrokenNeedleModel.fromJson(dynamic json) {
    _year = json['Year'];
    _monthName = json['MonthName'];
    _monthNumber = json['MonthNumber'];
    _totalIssueQty = json['TotalIssueQty'];
    _missingQty = json['MissingQty'];
    _brokenQty = json['BrokenQty'];
    _bluntQty = json['BluntQty'];
    _balance = json['Balance'];
    _used = json['Used'];
    _brokenPercentage = json['BrokenPercentage'];
  }
  num? _year;
  String? _monthName;
  num? _monthNumber;
  num? _totalIssueQty;
  num? _missingQty;
  num? _brokenQty;
  num? _bluntQty;
  num? _balance;
  num? _used;
  num? _brokenPercentage;
BrokenNeedleModel copyWith({  num? year,
  String? monthName,
  num? monthNumber,
  num? totalIssueQty,
  num? missingQty,
  num? brokenQty,
  num? bluntQty,
  num? balance,
  num? used,
  num? brokenPercentage,
}) => BrokenNeedleModel(  year: year ?? _year,
  monthName: monthName ?? _monthName,
  monthNumber: monthNumber ?? _monthNumber,
  totalIssueQty: totalIssueQty ?? _totalIssueQty,
  missingQty: missingQty ?? _missingQty,
  brokenQty: brokenQty ?? _brokenQty,
  bluntQty: bluntQty ?? _bluntQty,
  balance: balance ?? _balance,
  used: used ?? _used,
  brokenPercentage: brokenPercentage ?? _brokenPercentage,
);
  num? get year => _year;
  String? get monthName => _monthName;
  num? get monthNumber => _monthNumber;
  num? get totalIssueQty => _totalIssueQty;
  num? get missingQty => _missingQty;
  num? get brokenQty => _brokenQty;
  num? get bluntQty => _bluntQty;
  num? get balance => _balance;
  num? get used => _used;
  num? get brokenPercentage => _brokenPercentage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Year'] = _year;
    map['MonthName'] = _monthName;
    map['MonthNumber'] = _monthNumber;
    map['TotalIssueQty'] = _totalIssueQty;
    map['MissingQty'] = _missingQty;
    map['BrokenQty'] = _brokenQty;
    map['BluntQty'] = _bluntQty;
    map['Balance'] = _balance;
    map['Used'] = _used;
    map['BrokenPercentage'] = _brokenPercentage;
    return map;
  }

}