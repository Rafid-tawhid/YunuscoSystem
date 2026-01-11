class ProductionQcModel {
  ProductionQcModel({
      String? sectionName, 
      String? name, 
      String? buyerName, 
      num? qmsId, 
      String? date, 
      num? productionTimeId, 
      num? sectionId, 
      num? lineId, 
      num? buyerId, 
      String? style, 
      String? po, 
      num? itemId, 
      dynamic sizeId, 
      dynamic colorId, 
      dynamic operationId, 
      dynamic defectId, 
      num? totalPass, 
      num? totalDefect, 
      num? totalDefectiveGarments, 
      num? totalReject, 
      num? totalAlterCheck, 
      num? brokenStitch, 
      num? pleat, 
      num? openSeam, 
      num? skipStitch, 
      num? puckering, 
      dynamic upDown, 
      dynamic uneven, 
      num? uncutThread, 
      num? incorrectMeasurement, 
      dynamic colorShade, 
      dynamic dirtyspot, 
      num? oilSpot, 
      dynamic wavy, 
      dynamic labelSizeMistake, 
      dynamic insecureHookEyeButton, 
      dynamic incompliteMissingTuck, 
      dynamic slanted, 
      dynamic joinGatheringStitch, 
      dynamic rawEdge, 
      dynamic wrongPlacement, 
      dynamic badTension, 
      dynamic needleMark, 
      dynamic twisting, 
      dynamic poorPressing, 
      dynamic pressingMark, 
      dynamic sewingReject, 
      dynamic fabricReject, 
      num? othersDefects, 
      String? createdDate, 
      String? createdBy, 
      dynamic updatedDate, 
      dynamic updatedBy,}){
    _sectionName = sectionName;
    _name = name;
    _buyerName = buyerName;
    _qmsId = qmsId;
    _date = date;
    _productionTimeId = productionTimeId;
    _sectionId = sectionId;
    _lineId = lineId;
    _buyerId = buyerId;
    _style = style;
    _po = po;
    _itemId = itemId;
    _sizeId = sizeId;
    _colorId = colorId;
    _operationId = operationId;
    _defectId = defectId;
    _totalPass = totalPass;
    _totalDefect = totalDefect;
    _totalDefectiveGarments = totalDefectiveGarments;
    _totalReject = totalReject;
    _totalAlterCheck = totalAlterCheck;
    _brokenStitch = brokenStitch;
    _pleat = pleat;
    _openSeam = openSeam;
    _skipStitch = skipStitch;
    _puckering = puckering;
    _upDown = upDown;
    _uneven = uneven;
    _uncutThread = uncutThread;
    _incorrectMeasurement = incorrectMeasurement;
    _colorShade = colorShade;
    _dirtyspot = dirtyspot;
    _oilSpot = oilSpot;
    _wavy = wavy;
    _labelSizeMistake = labelSizeMistake;
    _insecureHookEyeButton = insecureHookEyeButton;
    _incompliteMissingTuck = incompliteMissingTuck;
    _slanted = slanted;
    _joinGatheringStitch = joinGatheringStitch;
    _rawEdge = rawEdge;
    _wrongPlacement = wrongPlacement;
    _badTension = badTension;
    _needleMark = needleMark;
    _twisting = twisting;
    _poorPressing = poorPressing;
    _pressingMark = pressingMark;
    _sewingReject = sewingReject;
    _fabricReject = fabricReject;
    _othersDefects = othersDefects;
    _createdDate = createdDate;
    _createdBy = createdBy;
    _updatedDate = updatedDate;
    _updatedBy = updatedBy;
}

  ProductionQcModel.fromJson(dynamic json) {
    _sectionName = json['SectionName'];
    _name = json['Name'];
    _buyerName = json['BuyerName'];
    _qmsId = json['QmsId'];
    _date = json['Date'];
    _productionTimeId = json['ProductionTimeId'];
    _sectionId = json['SectionId'];
    _lineId = json['LineId'];
    _buyerId = json['BuyerId'];
    _style = json['Style'];
    _po = json['PO'];
    _itemId = json['ItemId'];
    _sizeId = json['SizeId'];
    _colorId = json['ColorId'];
    _operationId = json['OperationId'];
    _defectId = json['DefectId'];
    _totalPass = json['TotalPass'];
    _totalDefect = json['TotalDefect'];
    _totalDefectiveGarments = json['TotalDefectiveGarments'];
    _totalReject = json['TotalReject'];
    _totalAlterCheck = json['TotalAlterCheck'];
    _brokenStitch = json['BrokenStitch'];
    _pleat = json['Pleat'];
    _openSeam = json['OpenSeam'];
    _skipStitch = json['SkipStitch'];
    _puckering = json['Puckering'];
    _upDown = json['UpDown'];
    _uneven = json['Uneven'];
    _uncutThread = json['UncutThread'];
    _incorrectMeasurement = json['IncorrectMeasurement'];
    _colorShade = json['ColorShade'];
    _dirtyspot = json['Dirtyspot'];
    _oilSpot = json['OilSpot'];
    _wavy = json['Wavy'];
    _labelSizeMistake = json['LabelSizeMistake'];
    _insecureHookEyeButton = json['InsecureHookEyeButton'];
    _incompliteMissingTuck = json['IncompliteMissingTuck'];
    _slanted = json['Slanted'];
    _joinGatheringStitch = json['JoinGatheringStitch'];
    _rawEdge = json['RawEdge'];
    _wrongPlacement = json['WrongPlacement'];
    _badTension = json['BadTension'];
    _needleMark = json['NeedleMark'];
    _twisting = json['Twisting'];
    _poorPressing = json['PoorPressing'];
    _pressingMark = json['PressingMark'];
    _sewingReject = json['SewingReject'];
    _fabricReject = json['FabricReject'];
    _othersDefects = json['OthersDefects'];
    _createdDate = json['CreatedDate'];
    _createdBy = json['CreatedBy'];
    _updatedDate = json['UpdatedDate'];
    _updatedBy = json['UpdatedBy'];
  }
  String? _sectionName;
  String? _name;
  String? _buyerName;
  num? _qmsId;
  String? _date;
  num? _productionTimeId;
  num? _sectionId;
  num? _lineId;
  num? _buyerId;
  String? _style;
  String? _po;
  num? _itemId;
  dynamic _sizeId;
  dynamic _colorId;
  dynamic _operationId;
  dynamic _defectId;
  num? _totalPass;
  num? _totalDefect;
  num? _totalDefectiveGarments;
  num? _totalReject;
  num? _totalAlterCheck;
  num? _brokenStitch;
  num? _pleat;
  num? _openSeam;
  num? _skipStitch;
  num? _puckering;
  dynamic _upDown;
  dynamic _uneven;
  num? _uncutThread;
  num? _incorrectMeasurement;
  dynamic _colorShade;
  dynamic _dirtyspot;
  num? _oilSpot;
  dynamic _wavy;
  dynamic _labelSizeMistake;
  dynamic _insecureHookEyeButton;
  dynamic _incompliteMissingTuck;
  dynamic _slanted;
  dynamic _joinGatheringStitch;
  dynamic _rawEdge;
  dynamic _wrongPlacement;
  dynamic _badTension;
  dynamic _needleMark;
  dynamic _twisting;
  dynamic _poorPressing;
  dynamic _pressingMark;
  dynamic _sewingReject;
  dynamic _fabricReject;
  num? _othersDefects;
  String? _createdDate;
  String? _createdBy;
  dynamic _updatedDate;
  dynamic _updatedBy;
ProductionQcModel copyWith({  String? sectionName,
  String? name,
  String? buyerName,
  num? qmsId,
  String? date,
  num? productionTimeId,
  num? sectionId,
  num? lineId,
  num? buyerId,
  String? style,
  String? po,
  num? itemId,
  dynamic sizeId,
  dynamic colorId,
  dynamic operationId,
  dynamic defectId,
  num? totalPass,
  num? totalDefect,
  num? totalDefectiveGarments,
  num? totalReject,
  num? totalAlterCheck,
  num? brokenStitch,
  num? pleat,
  num? openSeam,
  num? skipStitch,
  num? puckering,
  dynamic upDown,
  dynamic uneven,
  num? uncutThread,
  num? incorrectMeasurement,
  dynamic colorShade,
  dynamic dirtyspot,
  num? oilSpot,
  dynamic wavy,
  dynamic labelSizeMistake,
  dynamic insecureHookEyeButton,
  dynamic incompliteMissingTuck,
  dynamic slanted,
  dynamic joinGatheringStitch,
  dynamic rawEdge,
  dynamic wrongPlacement,
  dynamic badTension,
  dynamic needleMark,
  dynamic twisting,
  dynamic poorPressing,
  dynamic pressingMark,
  dynamic sewingReject,
  dynamic fabricReject,
  num? othersDefects,
  String? createdDate,
  String? createdBy,
  dynamic updatedDate,
  dynamic updatedBy,
}) => ProductionQcModel(  sectionName: sectionName ?? _sectionName,
  name: name ?? _name,
  buyerName: buyerName ?? _buyerName,
  qmsId: qmsId ?? _qmsId,
  date: date ?? _date,
  productionTimeId: productionTimeId ?? _productionTimeId,
  sectionId: sectionId ?? _sectionId,
  lineId: lineId ?? _lineId,
  buyerId: buyerId ?? _buyerId,
  style: style ?? _style,
  po: po ?? _po,
  itemId: itemId ?? _itemId,
  sizeId: sizeId ?? _sizeId,
  colorId: colorId ?? _colorId,
  operationId: operationId ?? _operationId,
  defectId: defectId ?? _defectId,
  totalPass: totalPass ?? _totalPass,
  totalDefect: totalDefect ?? _totalDefect,
  totalDefectiveGarments: totalDefectiveGarments ?? _totalDefectiveGarments,
  totalReject: totalReject ?? _totalReject,
  totalAlterCheck: totalAlterCheck ?? _totalAlterCheck,
  brokenStitch: brokenStitch ?? _brokenStitch,
  pleat: pleat ?? _pleat,
  openSeam: openSeam ?? _openSeam,
  skipStitch: skipStitch ?? _skipStitch,
  puckering: puckering ?? _puckering,
  upDown: upDown ?? _upDown,
  uneven: uneven ?? _uneven,
  uncutThread: uncutThread ?? _uncutThread,
  incorrectMeasurement: incorrectMeasurement ?? _incorrectMeasurement,
  colorShade: colorShade ?? _colorShade,
  dirtyspot: dirtyspot ?? _dirtyspot,
  oilSpot: oilSpot ?? _oilSpot,
  wavy: wavy ?? _wavy,
  labelSizeMistake: labelSizeMistake ?? _labelSizeMistake,
  insecureHookEyeButton: insecureHookEyeButton ?? _insecureHookEyeButton,
  incompliteMissingTuck: incompliteMissingTuck ?? _incompliteMissingTuck,
  slanted: slanted ?? _slanted,
  joinGatheringStitch: joinGatheringStitch ?? _joinGatheringStitch,
  rawEdge: rawEdge ?? _rawEdge,
  wrongPlacement: wrongPlacement ?? _wrongPlacement,
  badTension: badTension ?? _badTension,
  needleMark: needleMark ?? _needleMark,
  twisting: twisting ?? _twisting,
  poorPressing: poorPressing ?? _poorPressing,
  pressingMark: pressingMark ?? _pressingMark,
  sewingReject: sewingReject ?? _sewingReject,
  fabricReject: fabricReject ?? _fabricReject,
  othersDefects: othersDefects ?? _othersDefects,
  createdDate: createdDate ?? _createdDate,
  createdBy: createdBy ?? _createdBy,
  updatedDate: updatedDate ?? _updatedDate,
  updatedBy: updatedBy ?? _updatedBy,
);
  String? get sectionName => _sectionName;
  String? get name => _name;
  String? get buyerName => _buyerName;
  num? get qmsId => _qmsId;
  String? get date => _date;
  num? get productionTimeId => _productionTimeId;
  num? get sectionId => _sectionId;
  num? get lineId => _lineId;
  num? get buyerId => _buyerId;
  String? get style => _style;
  String? get po => _po;
  num? get itemId => _itemId;
  dynamic get sizeId => _sizeId;
  dynamic get colorId => _colorId;
  dynamic get operationId => _operationId;
  dynamic get defectId => _defectId;
  num? get totalPass => _totalPass;
  num? get totalDefect => _totalDefect;
  num? get totalDefectiveGarments => _totalDefectiveGarments;
  num? get totalReject => _totalReject;
  num? get totalAlterCheck => _totalAlterCheck;
  num? get brokenStitch => _brokenStitch;
  num? get pleat => _pleat;
  num? get openSeam => _openSeam;
  num? get skipStitch => _skipStitch;
  num? get puckering => _puckering;
  dynamic get upDown => _upDown;
  dynamic get uneven => _uneven;
  num? get uncutThread => _uncutThread;
  num? get incorrectMeasurement => _incorrectMeasurement;
  dynamic get colorShade => _colorShade;
  dynamic get dirtyspot => _dirtyspot;
  num? get oilSpot => _oilSpot;
  dynamic get wavy => _wavy;
  dynamic get labelSizeMistake => _labelSizeMistake;
  dynamic get insecureHookEyeButton => _insecureHookEyeButton;
  dynamic get incompliteMissingTuck => _incompliteMissingTuck;
  dynamic get slanted => _slanted;
  dynamic get joinGatheringStitch => _joinGatheringStitch;
  dynamic get rawEdge => _rawEdge;
  dynamic get wrongPlacement => _wrongPlacement;
  dynamic get badTension => _badTension;
  dynamic get needleMark => _needleMark;
  dynamic get twisting => _twisting;
  dynamic get poorPressing => _poorPressing;
  dynamic get pressingMark => _pressingMark;
  dynamic get sewingReject => _sewingReject;
  dynamic get fabricReject => _fabricReject;
  num? get othersDefects => _othersDefects;
  String? get createdDate => _createdDate;
  String? get createdBy => _createdBy;
  dynamic get updatedDate => _updatedDate;
  dynamic get updatedBy => _updatedBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['SectionName'] = _sectionName;
    map['Name'] = _name;
    map['BuyerName'] = _buyerName;
    map['QmsId'] = _qmsId;
    map['Date'] = _date;
    map['ProductionTimeId'] = _productionTimeId;
    map['SectionId'] = _sectionId;
    map['LineId'] = _lineId;
    map['BuyerId'] = _buyerId;
    map['Style'] = _style;
    map['PO'] = _po;
    map['ItemId'] = _itemId;
    map['SizeId'] = _sizeId;
    map['ColorId'] = _colorId;
    map['OperationId'] = _operationId;
    map['DefectId'] = _defectId;
    map['TotalPass'] = _totalPass;
    map['TotalDefect'] = _totalDefect;
    map['TotalDefectiveGarments'] = _totalDefectiveGarments;
    map['TotalReject'] = _totalReject;
    map['TotalAlterCheck'] = _totalAlterCheck;
    map['BrokenStitch'] = _brokenStitch;
    map['Pleat'] = _pleat;
    map['OpenSeam'] = _openSeam;
    map['SkipStitch'] = _skipStitch;
    map['Puckering'] = _puckering;
    map['UpDown'] = _upDown;
    map['Uneven'] = _uneven;
    map['UncutThread'] = _uncutThread;
    map['IncorrectMeasurement'] = _incorrectMeasurement;
    map['ColorShade'] = _colorShade;
    map['Dirtyspot'] = _dirtyspot;
    map['OilSpot'] = _oilSpot;
    map['Wavy'] = _wavy;
    map['LabelSizeMistake'] = _labelSizeMistake;
    map['InsecureHookEyeButton'] = _insecureHookEyeButton;
    map['IncompliteMissingTuck'] = _incompliteMissingTuck;
    map['Slanted'] = _slanted;
    map['JoinGatheringStitch'] = _joinGatheringStitch;
    map['RawEdge'] = _rawEdge;
    map['WrongPlacement'] = _wrongPlacement;
    map['BadTension'] = _badTension;
    map['NeedleMark'] = _needleMark;
    map['Twisting'] = _twisting;
    map['PoorPressing'] = _poorPressing;
    map['PressingMark'] = _pressingMark;
    map['SewingReject'] = _sewingReject;
    map['FabricReject'] = _fabricReject;
    map['OthersDefects'] = _othersDefects;
    map['CreatedDate'] = _createdDate;
    map['CreatedBy'] = _createdBy;
    map['UpdatedDate'] = _updatedDate;
    map['UpdatedBy'] = _updatedBy;
    return map;
  }

}