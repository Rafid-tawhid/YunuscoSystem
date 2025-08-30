class ProductionEfficiencyModel {
  ProductionEfficiencyModel({
    String? sectionName,
    String? buyerName,
    String? lineName,
    num? buyerId,
    num? sectionId,
    num? lineId,
    String? styleNo,
    String? po,
    String? item,
    num? smv,
    num? workingHour,
    num? manpower,
    num? targetEffiency,
    num? dayTarget,
    num? todaysProduction,
    num? achievedEffiency,
    num? capacity,
    num? variance,
    String? productionDate,
  }) {
    _sectionName = sectionName;
    _buyerName = buyerName;
    _lineName = lineName;
    _buyerId = buyerId;
    _sectionId = sectionId;
    _lineId = lineId;
    _styleNo = styleNo;
    _po = po;
    _item = item;
    _smv = smv;
    _workingHour = workingHour;
    _manpower = manpower;
    _targetEffiency = targetEffiency;
    _dayTarget = dayTarget;
    _todaysProduction = todaysProduction;
    _achievedEffiency = achievedEffiency;
    _capacity = capacity;
    _variance = variance;
    _productionDate = productionDate;
  }

  ProductionEfficiencyModel.fromJson(dynamic json) {
    _sectionName = json['SectionName'];
    _buyerName = json['BuyerName'];
    _lineName = json['LineName'];
    _buyerId = json['BuyerId'];
    _sectionId = json['SectionId'];
    _lineId = json['LineId'];
    _styleNo = json['StyleNo'];
    _po = json['PO'];
    _item = json['Item'];
    _smv = json['SMV'];
    _workingHour = json['WorkingHour'];
    _manpower = json['Manpower'];
    _targetEffiency = json['TargetEffiency'];
    _dayTarget = json['DayTarget'];
    _todaysProduction = json['TodaysProduction'];
    _achievedEffiency = json['AchievedEffiency'];
    _capacity = json['Capacity'];
    _variance = json['Variance'];
    _productionDate = json['ProductionDate'];
  }
  String? _sectionName;
  String? _buyerName;
  String? _lineName;
  num? _buyerId;
  num? _sectionId;
  num? _lineId;
  String? _styleNo;
  String? _po;
  String? _item;
  num? _smv;
  num? _workingHour;
  num? _manpower;
  num? _targetEffiency;
  num? _dayTarget;
  num? _todaysProduction;
  num? _achievedEffiency;
  num? _capacity;
  num? _variance;
  String? _productionDate;
  ProductionEfficiencyModel copyWith({
    String? sectionName,
    String? buyerName,
    String? lineName,
    num? buyerId,
    num? sectionId,
    num? lineId,
    String? styleNo,
    String? po,
    String? item,
    num? smv,
    num? workingHour,
    num? manpower,
    num? targetEffiency,
    num? dayTarget,
    num? todaysProduction,
    num? achievedEffiency,
    num? capacity,
    num? variance,
    String? productionDate,
  }) =>
      ProductionEfficiencyModel(
        sectionName: sectionName ?? _sectionName,
        buyerName: buyerName ?? _buyerName,
        lineName: lineName ?? _lineName,
        buyerId: buyerId ?? _buyerId,
        sectionId: sectionId ?? _sectionId,
        lineId: lineId ?? _lineId,
        styleNo: styleNo ?? _styleNo,
        po: po ?? _po,
        item: item ?? _item,
        smv: smv ?? _smv,
        workingHour: workingHour ?? _workingHour,
        manpower: manpower ?? _manpower,
        targetEffiency: targetEffiency ?? _targetEffiency,
        dayTarget: dayTarget ?? _dayTarget,
        todaysProduction: todaysProduction ?? _todaysProduction,
        achievedEffiency: achievedEffiency ?? _achievedEffiency,
        capacity: capacity ?? _capacity,
        variance: variance ?? _variance,
        productionDate: productionDate ?? _productionDate,
      );
  String? get sectionName => _sectionName;
  String? get buyerName => _buyerName;
  String? get lineName => _lineName;
  num? get buyerId => _buyerId;
  num? get sectionId => _sectionId;
  num? get lineId => _lineId;
  String? get styleNo => _styleNo;
  String? get po => _po;
  String? get item => _item;
  num? get smv => _smv;
  num? get workingHour => _workingHour;
  num? get manpower => _manpower;
  num? get targetEffiency => _targetEffiency;
  num? get dayTarget => _dayTarget;
  num? get todaysProduction => _todaysProduction;
  num? get achievedEffiency => _achievedEffiency;
  num? get capacity => _capacity;
  num? get variance => _variance;
  String? get productionDate => _productionDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['SectionName'] = _sectionName;
    map['BuyerName'] = _buyerName;
    map['LineName'] = _lineName;
    map['BuyerId'] = _buyerId;
    map['SectionId'] = _sectionId;
    map['LineId'] = _lineId;
    map['StyleNo'] = _styleNo;
    map['PO'] = _po;
    map['Item'] = _item;
    map['SMV'] = _smv;
    map['WorkingHour'] = _workingHour;
    map['Manpower'] = _manpower;
    map['TargetEffiency'] = _targetEffiency;
    map['DayTarget'] = _dayTarget;
    map['TodaysProduction'] = _todaysProduction;
    map['AchievedEffiency'] = _achievedEffiency;
    map['Capacity'] = _capacity;
    map['Variance'] = _variance;
    map['ProductionDate'] = _productionDate;
    return map;
  }
}
