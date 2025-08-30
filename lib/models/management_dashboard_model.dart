class ManagementDashboardModel {
  ManagementDashboardModel({
    List<ProductionData>? productionData,
    List<UnitWiseSewing>? unitWiseSewing,
    List<SewingProduction>? sewingProduction,
    List<MorrisLine>? morrisLine,
    List<FinishProduction>? finishProduction,
    List<UnitWiseSewingY>? unitWiseSewingY,
    List<FinishFifteen>? finishFifteen,
  }) {
    _productionData = productionData;
    _unitWiseSewing = unitWiseSewing;
    _sewingProduction = sewingProduction;
    _morrisLine = morrisLine;
    _finishProduction = finishProduction;
    _unitWiseSewingY = unitWiseSewingY;
    _finishFifteen = finishFifteen;
  }

  ManagementDashboardModel.fromJson(dynamic json) {
    if (json['ProductionData'] != null) {
      _productionData = [];
      json['ProductionData'].forEach((v) {
        _productionData?.add(ProductionData.fromJson(v));
      });
    }
    if (json['UnitWiseSewing'] != null) {
      _unitWiseSewing = [];
      json['UnitWiseSewing'].forEach((v) {
        _unitWiseSewing?.add(UnitWiseSewing.fromJson(v));
      });
    }
    if (json['SewingProduction'] != null) {
      _sewingProduction = [];
      json['SewingProduction'].forEach((v) {
        _sewingProduction?.add(SewingProduction.fromJson(v));
      });
    }
    if (json['MorrisLine'] != null) {
      _morrisLine = [];
      json['MorrisLine'].forEach((v) {
        _morrisLine?.add(MorrisLine.fromJson(v));
      });
    }
    if (json['FinishProduction'] != null) {
      _finishProduction = [];
      json['FinishProduction'].forEach((v) {
        _finishProduction?.add(FinishProduction.fromJson(v));
      });
    }
    if (json['UnitWiseSewingY'] != null) {
      _unitWiseSewingY = [];
      json['UnitWiseSewingY'].forEach((v) {
        _unitWiseSewingY?.add(UnitWiseSewingY.fromJson(v));
      });
    }
    if (json['FinishFifteen'] != null) {
      _finishFifteen = [];
      json['FinishFifteen'].forEach((v) {
        _finishFifteen?.add(FinishFifteen.fromJson(v));
      });
    }
  }
  List<ProductionData>? _productionData;
  List<UnitWiseSewing>? _unitWiseSewing;
  List<SewingProduction>? _sewingProduction;
  List<MorrisLine>? _morrisLine;
  List<FinishProduction>? _finishProduction;
  List<UnitWiseSewingY>? _unitWiseSewingY;
  List<FinishFifteen>? _finishFifteen;
  ManagementDashboardModel copyWith({
    List<ProductionData>? productionData,
    List<UnitWiseSewing>? unitWiseSewing,
    List<SewingProduction>? sewingProduction,
    List<MorrisLine>? morrisLine,
    List<FinishProduction>? finishProduction,
    List<UnitWiseSewingY>? unitWiseSewingY,
    List<FinishFifteen>? finishFifteen,
  }) =>
      ManagementDashboardModel(
        productionData: productionData ?? _productionData,
        unitWiseSewing: unitWiseSewing ?? _unitWiseSewing,
        sewingProduction: sewingProduction ?? _sewingProduction,
        morrisLine: morrisLine ?? _morrisLine,
        finishProduction: finishProduction ?? _finishProduction,
        unitWiseSewingY: unitWiseSewingY ?? _unitWiseSewingY,
        finishFifteen: finishFifteen ?? _finishFifteen,
      );
  List<ProductionData>? get productionData => _productionData;
  List<UnitWiseSewing>? get unitWiseSewing => _unitWiseSewing;
  List<SewingProduction>? get sewingProduction => _sewingProduction;
  List<MorrisLine>? get morrisLine => _morrisLine;
  List<FinishProduction>? get finishProduction => _finishProduction;
  List<UnitWiseSewingY>? get unitWiseSewingY => _unitWiseSewingY;
  List<FinishFifteen>? get finishFifteen => _finishFifteen;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_productionData != null) {
      map['ProductionData'] = _productionData?.map((v) => v.toJson()).toList();
    }
    if (_unitWiseSewing != null) {
      map['UnitWiseSewing'] = _unitWiseSewing?.map((v) => v.toJson()).toList();
    }
    if (_sewingProduction != null) {
      map['SewingProduction'] =
          _sewingProduction?.map((v) => v.toJson()).toList();
    }
    if (_morrisLine != null) {
      map['MorrisLine'] = _morrisLine?.map((v) => v.toJson()).toList();
    }
    if (_finishProduction != null) {
      map['FinishProduction'] =
          _finishProduction?.map((v) => v.toJson()).toList();
    }
    if (_unitWiseSewingY != null) {
      map['UnitWiseSewingY'] =
          _unitWiseSewingY?.map((v) => v.toJson()).toList();
    }
    if (_finishFifteen != null) {
      map['FinishFifteen'] = _finishFifteen?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class FinishFifteen {
  FinishFifteen({
    String? name,
    num? targetQty,
    num? acheiveQty,
  }) {
    _name = name;
    _targetQty = targetQty;
    _acheiveQty = acheiveQty;
  }

  FinishFifteen.fromJson(dynamic json) {
    _name = json['Name'];
    _targetQty = json['TargetQty'];
    _acheiveQty = json['AcheiveQty'];
  }
  String? _name;
  num? _targetQty;
  num? _acheiveQty;
  FinishFifteen copyWith({
    String? name,
    num? targetQty,
    num? acheiveQty,
  }) =>
      FinishFifteen(
        name: name ?? _name,
        targetQty: targetQty ?? _targetQty,
        acheiveQty: acheiveQty ?? _acheiveQty,
      );
  String? get name => _name;
  num? get targetQty => _targetQty;
  num? get acheiveQty => _acheiveQty;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Name'] = _name;
    map['TargetQty'] = _targetQty;
    map['AcheiveQty'] = _acheiveQty;
    return map;
  }
}

class UnitWiseSewingY {
  UnitWiseSewingY({
    String? unitName,
    num? quantity,
  }) {
    _unitName = unitName;
    _quantity = quantity;
  }

  UnitWiseSewingY.fromJson(dynamic json) {
    _unitName = json['UnitName'];
    _quantity = json['Quantity'];
  }
  String? _unitName;
  num? _quantity;
  UnitWiseSewingY copyWith({
    String? unitName,
    num? quantity,
  }) =>
      UnitWiseSewingY(
        unitName: unitName ?? _unitName,
        quantity: quantity ?? _quantity,
      );
  String? get unitName => _unitName;
  num? get quantity => _quantity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['UnitName'] = _unitName;
    map['Quantity'] = _quantity;
    return map;
  }
}

class FinishProduction {
  FinishProduction({
    String? sections,
    num? tableRunning,
    num? totalTarget,
    num? smv,
    num? achieveQty,
    num? totalHR,
    num? perHrProduction,
    num? achievePercent,
  }) {
    _sections = sections;
    _tableRunning = tableRunning;
    _totalTarget = totalTarget;
    _smv = smv;
    _achieveQty = achieveQty;
    _totalHR = totalHR;
    _perHrProduction = perHrProduction;
    _achievePercent = achievePercent;
  }

  FinishProduction.fromJson(dynamic json) {
    _sections = json['Sections'];
    _tableRunning = json['TableRunning'];
    _totalTarget = json['TotalTarget'];
    _smv = json['SMV'];
    _achieveQty = json['AchieveQty'];
    _totalHR = json['TotalHR'];
    _perHrProduction = json['PerHrProduction'];
    _achievePercent = json['AchievePercent'];
  }
  String? _sections;
  num? _tableRunning;
  num? _totalTarget;
  num? _smv;
  num? _achieveQty;
  num? _totalHR;
  num? _perHrProduction;
  num? _achievePercent;
  FinishProduction copyWith({
    String? sections,
    num? tableRunning,
    num? totalTarget,
    num? smv,
    num? achieveQty,
    num? totalHR,
    num? perHrProduction,
    num? achievePercent,
  }) =>
      FinishProduction(
        sections: sections ?? _sections,
        tableRunning: tableRunning ?? _tableRunning,
        totalTarget: totalTarget ?? _totalTarget,
        smv: smv ?? _smv,
        achieveQty: achieveQty ?? _achieveQty,
        totalHR: totalHR ?? _totalHR,
        perHrProduction: perHrProduction ?? _perHrProduction,
        achievePercent: achievePercent ?? _achievePercent,
      );
  String? get sections => _sections;
  num? get tableRunning => _tableRunning;
  num? get totalTarget => _totalTarget;
  num? get smv => _smv;
  num? get achieveQty => _achieveQty;
  num? get totalHR => _totalHR;
  num? get perHrProduction => _perHrProduction;
  num? get achievePercent => _achievePercent;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Sections'] = _sections;
    map['TableRunning'] = _tableRunning;
    map['TotalTarget'] = _totalTarget;
    map['SMV'] = _smv;
    map['AchieveQty'] = _achieveQty;
    map['TotalHR'] = _totalHR;
    map['PerHrProduction'] = _perHrProduction;
    map['AchievePercent'] = _achievePercent;
    return map;
  }
}

class MorrisLine {
  MorrisLine({
    String? name,
    num? targetQty,
    num? acheiveQty,
  }) {
    _name = name;
    _targetQty = targetQty;
    _acheiveQty = acheiveQty;
  }

  MorrisLine.fromJson(dynamic json) {
    _name = json['Name'];
    _targetQty = json['TargetQty'];
    _acheiveQty = json['AcheiveQty'];
  }
  String? _name;
  num? _targetQty;
  num? _acheiveQty;
  MorrisLine copyWith({
    String? name,
    num? targetQty,
    num? acheiveQty,
  }) =>
      MorrisLine(
        name: name ?? _name,
        targetQty: targetQty ?? _targetQty,
        acheiveQty: acheiveQty ?? _acheiveQty,
      );
  String? get name => _name;
  num? get targetQty => _targetQty;
  num? get acheiveQty => _acheiveQty;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Name'] = _name;
    map['TargetQty'] = _targetQty;
    map['AcheiveQty'] = _acheiveQty;
    return map;
  }
}

class SewingProduction {
  SewingProduction({
    String? sections,
    num? lineRunning,
    num? totalTarget,
    num? smv,
    num? achieveQty,
    num? totalHR,
    num? perHrProduction,
    num? achievePercent,
  }) {
    _sections = sections;
    _lineRunning = lineRunning;
    _totalTarget = totalTarget;
    _smv = smv;
    _achieveQty = achieveQty;
    _totalHR = totalHR;
    _perHrProduction = perHrProduction;
    _achievePercent = achievePercent;
  }

  SewingProduction.fromJson(dynamic json) {
    _sections = json['Sections'];
    _lineRunning = json['LineRunning'];
    _totalTarget = json['TotalTarget'];
    _smv = json['SMV'];
    _achieveQty = json['AchieveQty'];
    _totalHR = json['TotalHR'];
    _perHrProduction = json['PerHrProduction'];
    _achievePercent = json['AchievePercent'];
  }
  String? _sections;
  num? _lineRunning;
  num? _totalTarget;
  num? _smv;
  num? _achieveQty;
  num? _totalHR;
  num? _perHrProduction;
  num? _achievePercent;
  SewingProduction copyWith({
    String? sections,
    num? lineRunning,
    num? totalTarget,
    num? smv,
    num? achieveQty,
    num? totalHR,
    num? perHrProduction,
    num? achievePercent,
  }) =>
      SewingProduction(
        sections: sections ?? _sections,
        lineRunning: lineRunning ?? _lineRunning,
        totalTarget: totalTarget ?? _totalTarget,
        smv: smv ?? _smv,
        achieveQty: achieveQty ?? _achieveQty,
        totalHR: totalHR ?? _totalHR,
        perHrProduction: perHrProduction ?? _perHrProduction,
        achievePercent: achievePercent ?? _achievePercent,
      );
  String? get sections => _sections;
  num? get lineRunning => _lineRunning;
  num? get totalTarget => _totalTarget;
  num? get smv => _smv;
  num? get achieveQty => _achieveQty;
  num? get totalHR => _totalHR;
  num? get perHrProduction => _perHrProduction;
  num? get achievePercent => _achievePercent;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Sections'] = _sections;
    map['LineRunning'] = _lineRunning;
    map['TotalTarget'] = _totalTarget;
    map['SMV'] = _smv;
    map['AchieveQty'] = _achieveQty;
    map['TotalHR'] = _totalHR;
    map['PerHrProduction'] = _perHrProduction;
    map['AchievePercent'] = _achievePercent;
    return map;
  }
}

class UnitWiseSewing {
  UnitWiseSewing({
    String? unitName,
    num? quantity,
  }) {
    _unitName = unitName;
    _quantity = quantity;
  }

  UnitWiseSewing.fromJson(dynamic json) {
    _unitName = json['UnitName'];
    _quantity = json['Quantity'];
  }
  String? _unitName;
  num? _quantity;
  UnitWiseSewing copyWith({
    String? unitName,
    num? quantity,
  }) =>
      UnitWiseSewing(
        unitName: unitName ?? _unitName,
        quantity: quantity ?? _quantity,
      );
  String? get unitName => _unitName;
  num? get quantity => _quantity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['UnitName'] = _unitName;
    map['Quantity'] = _quantity;
    return map;
  }
}

class ProductionData {
  ProductionData({
    num? cuttingQty,
    num? sewingQty,
    num? finishQty,
    num? moldingQty,
  }) {
    _cuttingQty = cuttingQty;
    _sewingQty = sewingQty;
    _finishQty = finishQty;
    _moldingQty = moldingQty;
  }

  ProductionData.fromJson(dynamic json) {
    _cuttingQty = json['CuttingQty'];
    _sewingQty = json['SewingQty'];
    _finishQty = json['FinishQty'];
    _moldingQty = json['MoldingQty'];
  }
  num? _cuttingQty;
  num? _sewingQty;
  num? _finishQty;
  num? _moldingQty;
  ProductionData copyWith({
    num? cuttingQty,
    num? sewingQty,
    num? finishQty,
    num? moldingQty,
  }) =>
      ProductionData(
        cuttingQty: cuttingQty ?? _cuttingQty,
        sewingQty: sewingQty ?? _sewingQty,
        finishQty: finishQty ?? _finishQty,
        moldingQty: moldingQty ?? _moldingQty,
      );
  num? get cuttingQty => _cuttingQty;
  num? get sewingQty => _sewingQty;
  num? get finishQty => _finishQty;
  num? get moldingQty => _moldingQty;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CuttingQty'] = _cuttingQty;
    map['SewingQty'] = _sewingQty;
    map['FinishQty'] = _finishQty;
    map['MoldingQty'] = _moldingQty;
    return map;
  }
}
