class LinewiseManpowerModel {
  LinewiseManpowerModel({
      num? lineId, 
      String? lineNo, 
      num? operator, 
      num? helper, 
      num? total,}){
    _lineId = lineId;
    _lineNo = lineNo;
    _operator = operator;
    _helper = helper;
    _total = total;
}

  LinewiseManpowerModel.fromJson(dynamic json) {
    _lineId = json['LineId'];
    _lineNo = json['LineNo'];
    _operator = json['Operator'];
    _helper = json['Helper'];
    _total = json['Total'];
  }
  num? _lineId;
  String? _lineNo;
  num? _operator;
  num? _helper;
  num? _total;
LinewiseManpowerModel copyWith({  num? lineId,
  String? lineNo,
  num? operator,
  num? helper,
  num? total,
}) => LinewiseManpowerModel(  lineId: lineId ?? _lineId,
  lineNo: lineNo ?? _lineNo,
  operator: operator ?? _operator,
  helper: helper ?? _helper,
  total: total ?? _total,
);
  num? get lineId => _lineId;
  String? get lineNo => _lineNo;
  num? get operator => _operator;
  num? get helper => _helper;
  num? get total => _total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['LineId'] = _lineId;
    map['LineNo'] = _lineNo;
    map['Operator'] = _operator;
    map['Helper'] = _helper;
    map['Total'] = _total;
    return map;
  }

}