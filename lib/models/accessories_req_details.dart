class AccessoriesReqDetails {
  AccessoriesReqDetails({
      num? issueId, 
      String? issueCode, 
      num? requisitionId, 
      String? requisitionCode, 
      String? issueDate, 
      num? issuedById, 
      String? issuedBy, 
      dynamic slipNo, 
      num? issueToDepartment, 
      num? issueToSection, 
      num? issueBySection, 
      num? productId, 
      String? productName, 
      String? binCode, 
      String? jobNo, 
      num? client, 
      String? batchNo, 
      String? clientName, 
      num? currencyId, 
      num? currencyRateId, 
      String? poCode, 
      String? challanNo, 
      num? quantity, 
      num? reqQty, 
      num? price, 
      num? unitId, 
      String? unitName, 
      String? baseUnit, 
      dynamic alterUnit, 
      num? alterUnitId, 
      String? materialType, 
      dynamic buyerName, 
      num? altQuantity, 
      num? altStockBalance, 
      num? stockBalance, 
      String? remarks,}){
    _issueId = issueId;
    _issueCode = issueCode;
    _requisitionId = requisitionId;
    _requisitionCode = requisitionCode;
    _issueDate = issueDate;
    _issuedById = issuedById;
    _issuedBy = issuedBy;
    _slipNo = slipNo;
    _issueToDepartment = issueToDepartment;
    _issueToSection = issueToSection;
    _issueBySection = issueBySection;
    _productId = productId;
    _productName = productName;
    _binCode = binCode;
    _jobNo = jobNo;
    _client = client;
    _batchNo = batchNo;
    _clientName = clientName;
    _currencyId = currencyId;
    _currencyRateId = currencyRateId;
    _poCode = poCode;
    _challanNo = challanNo;
    _quantity = quantity;
    _reqQty = reqQty;
    _price = price;
    _unitId = unitId;
    _unitName = unitName;
    _baseUnit = baseUnit;
    _alterUnit = alterUnit;
    _alterUnitId = alterUnitId;
    _materialType = materialType;
    _buyerName = buyerName;
    _altQuantity = altQuantity;
    _altStockBalance = altStockBalance;
    _stockBalance = stockBalance;
    _remarks = remarks;
}

  AccessoriesReqDetails.fromJson(dynamic json) {
    _issueId = json['IssueId'];
    _issueCode = json['IssueCode'];
    _requisitionId = json['RequisitionId'];
    _requisitionCode = json['RequisitionCode'];
    _issueDate = json['IssueDate'];
    _issuedById = json['IssuedById'];
    _issuedBy = json['IssuedBy'];
    _slipNo = json['SlipNo'];
    _issueToDepartment = json['IssueToDepartment'];
    _issueToSection = json['IssueToSection'];
    _issueBySection = json['IssueBySection'];
    _productId = json['ProductId'];
    _productName = json['ProductName'];
    _binCode = json['BinCode'];
    _jobNo = json['JobNo'];
    _client = json['Client'];
    _batchNo = json['BatchNo'];
    _clientName = json['ClientName'];
    _currencyId = json['CurrencyId'];
    _currencyRateId = json['CurrencyRateId'];
    _poCode = json['PoCode'];
    _challanNo = json['ChallanNo'];
    _quantity = json['Quantity'];
    _reqQty = json['ReqQty'];
    _price = json['Price'];
    _unitId = json['UnitId'];
    _unitName = json['UnitName'];
    _baseUnit = json['BaseUnit'];
    _alterUnit = json['AlterUnit'];
    _alterUnitId = json['AlterUnitId'];
    _materialType = json['MaterialType'];
    _buyerName = json['BuyerName'];
    _altQuantity = json['AltQuantity'];
    _altStockBalance = json['AltStockBalance'];
    _stockBalance = json['StockBalance'];
    _remarks = json['Remarks'];
  }
  num? _issueId;
  String? _issueCode;
  num? _requisitionId;
  String? _requisitionCode;
  String? _issueDate;
  num? _issuedById;
  String? _issuedBy;
  dynamic _slipNo;
  num? _issueToDepartment;
  num? _issueToSection;
  num? _issueBySection;
  num? _productId;
  String? _productName;
  String? _binCode;
  String? _jobNo;
  num? _client;
  String? _batchNo;
  String? _clientName;
  num? _currencyId;
  num? _currencyRateId;
  String? _poCode;
  String? _challanNo;
  num? _quantity;
  num? _reqQty;
  num? _price;
  num? _unitId;
  String? _unitName;
  String? _baseUnit;
  dynamic _alterUnit;
  num? _alterUnitId;
  String? _materialType;
  dynamic _buyerName;
  num? _altQuantity;
  num? _altStockBalance;
  num? _stockBalance;
  String? _remarks;
AccessoriesReqDetails copyWith({  num? issueId,
  String? issueCode,
  num? requisitionId,
  String? requisitionCode,
  String? issueDate,
  num? issuedById,
  String? issuedBy,
  dynamic slipNo,
  num? issueToDepartment,
  num? issueToSection,
  num? issueBySection,
  num? productId,
  String? productName,
  String? binCode,
  String? jobNo,
  num? client,
  String? batchNo,
  String? clientName,
  num? currencyId,
  num? currencyRateId,
  String? poCode,
  String? challanNo,
  num? quantity,
  num? reqQty,
  num? price,
  num? unitId,
  String? unitName,
  String? baseUnit,
  dynamic alterUnit,
  num? alterUnitId,
  String? materialType,
  dynamic buyerName,
  num? altQuantity,
  num? altStockBalance,
  num? stockBalance,
  String? remarks,
}) => AccessoriesReqDetails(  issueId: issueId ?? _issueId,
  issueCode: issueCode ?? _issueCode,
  requisitionId: requisitionId ?? _requisitionId,
  requisitionCode: requisitionCode ?? _requisitionCode,
  issueDate: issueDate ?? _issueDate,
  issuedById: issuedById ?? _issuedById,
  issuedBy: issuedBy ?? _issuedBy,
  slipNo: slipNo ?? _slipNo,
  issueToDepartment: issueToDepartment ?? _issueToDepartment,
  issueToSection: issueToSection ?? _issueToSection,
  issueBySection: issueBySection ?? _issueBySection,
  productId: productId ?? _productId,
  productName: productName ?? _productName,
  binCode: binCode ?? _binCode,
  jobNo: jobNo ?? _jobNo,
  client: client ?? _client,
  batchNo: batchNo ?? _batchNo,
  clientName: clientName ?? _clientName,
  currencyId: currencyId ?? _currencyId,
  currencyRateId: currencyRateId ?? _currencyRateId,
  poCode: poCode ?? _poCode,
  challanNo: challanNo ?? _challanNo,
  quantity: quantity ?? _quantity,
  reqQty: reqQty ?? _reqQty,
  price: price ?? _price,
  unitId: unitId ?? _unitId,
  unitName: unitName ?? _unitName,
  baseUnit: baseUnit ?? _baseUnit,
  alterUnit: alterUnit ?? _alterUnit,
  alterUnitId: alterUnitId ?? _alterUnitId,
  materialType: materialType ?? _materialType,
  buyerName: buyerName ?? _buyerName,
  altQuantity: altQuantity ?? _altQuantity,
  altStockBalance: altStockBalance ?? _altStockBalance,
  stockBalance: stockBalance ?? _stockBalance,
  remarks: remarks ?? _remarks,
);
  num? get issueId => _issueId;
  String? get issueCode => _issueCode;
  num? get requisitionId => _requisitionId;
  String? get requisitionCode => _requisitionCode;
  String? get issueDate => _issueDate;
  num? get issuedById => _issuedById;
  String? get issuedBy => _issuedBy;
  dynamic get slipNo => _slipNo;
  num? get issueToDepartment => _issueToDepartment;
  num? get issueToSection => _issueToSection;
  num? get issueBySection => _issueBySection;
  num? get productId => _productId;
  String? get productName => _productName;
  String? get binCode => _binCode;
  String? get jobNo => _jobNo;
  num? get client => _client;
  String? get batchNo => _batchNo;
  String? get clientName => _clientName;
  num? get currencyId => _currencyId;
  num? get currencyRateId => _currencyRateId;
  String? get poCode => _poCode;
  String? get challanNo => _challanNo;
  num? get quantity => _quantity;
  num? get reqQty => _reqQty;
  num? get price => _price;
  num? get unitId => _unitId;
  String? get unitName => _unitName;
  String? get baseUnit => _baseUnit;
  dynamic get alterUnit => _alterUnit;
  num? get alterUnitId => _alterUnitId;
  String? get materialType => _materialType;
  dynamic get buyerName => _buyerName;
  num? get altQuantity => _altQuantity;
  num? get altStockBalance => _altStockBalance;
  num? get stockBalance => _stockBalance;
  String? get remarks => _remarks;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['IssueId'] = _issueId;
    map['IssueCode'] = _issueCode;
    map['RequisitionId'] = _requisitionId;
    map['RequisitionCode'] = _requisitionCode;
    map['IssueDate'] = _issueDate;
    map['IssuedById'] = _issuedById;
    map['IssuedBy'] = _issuedBy;
    map['SlipNo'] = _slipNo;
    map['IssueToDepartment'] = _issueToDepartment;
    map['IssueToSection'] = _issueToSection;
    map['IssueBySection'] = _issueBySection;
    map['ProductId'] = _productId;
    map['ProductName'] = _productName;
    map['BinCode'] = _binCode;
    map['JobNo'] = _jobNo;
    map['Client'] = _client;
    map['BatchNo'] = _batchNo;
    map['ClientName'] = _clientName;
    map['CurrencyId'] = _currencyId;
    map['CurrencyRateId'] = _currencyRateId;
    map['PoCode'] = _poCode;
    map['ChallanNo'] = _challanNo;
    map['Quantity'] = _quantity;
    map['ReqQty'] = _reqQty;
    map['Price'] = _price;
    map['UnitId'] = _unitId;
    map['UnitName'] = _unitName;
    map['BaseUnit'] = _baseUnit;
    map['AlterUnit'] = _alterUnit;
    map['AlterUnitId'] = _alterUnitId;
    map['MaterialType'] = _materialType;
    map['BuyerName'] = _buyerName;
    map['AltQuantity'] = _altQuantity;
    map['AltStockBalance'] = _altStockBalance;
    map['StockBalance'] = _stockBalance;
    map['Remarks'] = _remarks;
    return map;
  }

}