class RequisitionDetailsModel {
  RequisitionDetailsModel({
      num? sl, 
      String? requisitionCode, 
      String? requisitionDate, 
      String? section, 
      String? department, 
      String? employeeName, 
      String? product, 
      String? imagePathString, 
      num? productId, 
      dynamic productDescription, 
      String? unit, 
      num? actualReqQty, 
      num? excessForStock, 
      num? totalReqQty, 
      num? iNHandQty, 
      String? mRNNo, 
      String? version, 
      String? note, 
      dynamic brand, 
      num? durability, 
      num? unitId, 
      num? stockQty, 
      num? approvedQty, 
      String? approvedBy, 
      String? approvalType, 
      String? requiredDate, 
      String? divisionName, 
      String? lastPurchaseDate, 
      num? lastPurchaseRate, 
      String? supplierName, 
      num? totalPurchaseAmount,}){
    _sl = sl;
    _requisitionCode = requisitionCode;
    _requisitionDate = requisitionDate;
    _section = section;
    _department = department;
    _employeeName = employeeName;
    _product = product;
    _imagePathString = imagePathString;
    _productId = productId;
    _productDescription = productDescription;
    _unit = unit;
    _actualReqQty = actualReqQty;
    _excessForStock = excessForStock;
    _totalReqQty = totalReqQty;
    _iNHandQty = iNHandQty;
    _mRNNo = mRNNo;
    _version = version;
    _note = note;
    _brand = brand;
    _durability = durability;
    _unitId = unitId;
    _stockQty = stockQty;
    _approvedQty = approvedQty;
    _approvedBy = approvedBy;
    _approvalType = approvalType;
    _requiredDate = requiredDate;
    _divisionName = divisionName;
    _lastPurchaseDate = lastPurchaseDate;
    _lastPurchaseRate = lastPurchaseRate;
    _supplierName = supplierName;
    _totalPurchaseAmount = totalPurchaseAmount;
}

  RequisitionDetailsModel.fromJson(dynamic json) {
    _sl = json['SL'];
    _requisitionCode = json['RequisitionCode'];
    _requisitionDate = json['RequisitionDate'];
    _section = json['Section'];
    _department = json['Department'];
    _employeeName = json['EmployeeName'];
    _product = json['Product'];
    _imagePathString = json['ImagePathString'];
    _productId = json['ProductId'];
    _productDescription = json['ProductDescription'];
    _unit = json['Unit'];
    _actualReqQty = json['ActualReqQty'];
    _excessForStock = json['ExcessForStock'];
    _totalReqQty = json['TotalReqQty'];
    _iNHandQty = json['INHandQty'];
    _mRNNo = json['MRNNo'];
    _version = json['Version'];
    _note = json['Note'];
    _brand = json['Brand'];
    _durability = json['Durability'];
    _unitId = json['UnitId'];
    _stockQty = json['StockQty'];
    _approvedQty = json['ApprovedQty'];
    _approvedBy = json['ApprovedBy'];
    _approvalType = json['ApprovalType'];
    _requiredDate = json['RequiredDate'];
    _divisionName = json['DivisionName'];
    _lastPurchaseDate = json['LastPurchaseDate'];
    _lastPurchaseRate = json['LastPurchaseRate'];
    _supplierName = json['SupplierName'];
    _totalPurchaseAmount = json['TotalPurchaseAmount'];
  }
  num? _sl;
  String? _requisitionCode;
  String? _requisitionDate;
  String? _section;
  String? _department;
  String? _employeeName;
  String? _product;
  String? _imagePathString;
  num? _productId;
  dynamic _productDescription;
  String? _unit;
  num? _actualReqQty;
  num? _excessForStock;
  num? _totalReqQty;
  num? _iNHandQty;
  String? _mRNNo;
  String? _version;
  String? _note;
  dynamic _brand;
  num? _durability;
  num? _unitId;
  num? _stockQty;
  num? _approvedQty;
  String? _approvedBy;
  String? _approvalType;
  String? _requiredDate;
  String? _divisionName;
  String? _lastPurchaseDate;
  num? _lastPurchaseRate;
  String? _supplierName;
  num? _totalPurchaseAmount;
RequisitionDetailsModel copyWith({  num? sl,
  String? requisitionCode,
  String? requisitionDate,
  String? section,
  String? department,
  String? employeeName,
  String? product,
  String? imagePathString,
  num? productId,
  dynamic productDescription,
  String? unit,
  num? actualReqQty,
  num? excessForStock,
  num? totalReqQty,
  num? iNHandQty,
  String? mRNNo,
  String? version,
  String? note,
  dynamic brand,
  num? durability,
  num? unitId,
  num? stockQty,
  num? approvedQty,
  String? approvedBy,
  String? approvalType,
  String? requiredDate,
  String? divisionName,
  String? lastPurchaseDate,
  num? lastPurchaseRate,
  String? supplierName,
  num? totalPurchaseAmount,
}) => RequisitionDetailsModel(  sl: sl ?? _sl,
  requisitionCode: requisitionCode ?? _requisitionCode,
  requisitionDate: requisitionDate ?? _requisitionDate,
  section: section ?? _section,
  department: department ?? _department,
  employeeName: employeeName ?? _employeeName,
  product: product ?? _product,
  imagePathString: imagePathString ?? _imagePathString,
  productId: productId ?? _productId,
  productDescription: productDescription ?? _productDescription,
  unit: unit ?? _unit,
  actualReqQty: actualReqQty ?? _actualReqQty,
  excessForStock: excessForStock ?? _excessForStock,
  totalReqQty: totalReqQty ?? _totalReqQty,
  iNHandQty: iNHandQty ?? _iNHandQty,
  mRNNo: mRNNo ?? _mRNNo,
  version: version ?? _version,
  note: note ?? _note,
  brand: brand ?? _brand,
  durability: durability ?? _durability,
  unitId: unitId ?? _unitId,
  stockQty: stockQty ?? _stockQty,
  approvedQty: approvedQty ?? _approvedQty,
  approvedBy: approvedBy ?? _approvedBy,
  approvalType: approvalType ?? _approvalType,
  requiredDate: requiredDate ?? _requiredDate,
  divisionName: divisionName ?? _divisionName,
  lastPurchaseDate: lastPurchaseDate ?? _lastPurchaseDate,
  lastPurchaseRate: lastPurchaseRate ?? _lastPurchaseRate,
  supplierName: supplierName ?? _supplierName,
  totalPurchaseAmount: totalPurchaseAmount ?? _totalPurchaseAmount,
);
  num? get sl => _sl;
  String? get requisitionCode => _requisitionCode;
  String? get requisitionDate => _requisitionDate;
  String? get section => _section;
  String? get department => _department;
  String? get employeeName => _employeeName;
  String? get product => _product;
  String? get imagePathString => _imagePathString;
  num? get productId => _productId;
  dynamic get productDescription => _productDescription;
  String? get unit => _unit;
  num? get actualReqQty => _actualReqQty;
  num? get excessForStock => _excessForStock;
  num? get totalReqQty => _totalReqQty;
  num? get iNHandQty => _iNHandQty;
  String? get mRNNo => _mRNNo;
  String? get version => _version;
  String? get note => _note;
  dynamic get brand => _brand;
  num? get durability => _durability;
  num? get unitId => _unitId;
  num? get stockQty => _stockQty;
  num? get approvedQty => _approvedQty;
  String? get approvedBy => _approvedBy;
  String? get approvalType => _approvalType;
  String? get requiredDate => _requiredDate;
  String? get divisionName => _divisionName;
  String? get lastPurchaseDate => _lastPurchaseDate;
  num? get lastPurchaseRate => _lastPurchaseRate;
  String? get supplierName => _supplierName;
  num? get totalPurchaseAmount => _totalPurchaseAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['SL'] = _sl;
    map['RequisitionCode'] = _requisitionCode;
    map['RequisitionDate'] = _requisitionDate;
    map['Section'] = _section;
    map['Department'] = _department;
    map['EmployeeName'] = _employeeName;
    map['Product'] = _product;
    map['ImagePathString'] = _imagePathString;
    map['ProductId'] = _productId;
    map['ProductDescription'] = _productDescription;
    map['Unit'] = _unit;
    map['ActualReqQty'] = _actualReqQty;
    map['ExcessForStock'] = _excessForStock;
    map['TotalReqQty'] = _totalReqQty;
    map['INHandQty'] = _iNHandQty;
    map['MRNNo'] = _mRNNo;
    map['Version'] = _version;
    map['Note'] = _note;
    map['Brand'] = _brand;
    map['Durability'] = _durability;
    map['UnitId'] = _unitId;
    map['StockQty'] = _stockQty;
    map['ApprovedQty'] = _approvedQty;
    map['ApprovedBy'] = _approvedBy;
    map['ApprovalType'] = _approvalType;
    map['RequiredDate'] = _requiredDate;
    map['DivisionName'] = _divisionName;
    map['LastPurchaseDate'] = _lastPurchaseDate;
    map['LastPurchaseRate'] = _lastPurchaseRate;
    map['SupplierName'] = _supplierName;
    map['TotalPurchaseAmount'] = _totalPurchaseAmount;
    return map;
  }

}