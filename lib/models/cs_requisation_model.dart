class CsRequisationModel {
  CsRequisationModel({
      String? code, 
      num? productId, 
      String? productName,
      String? currencyName, 
      String? creditPeriod, 
      String? payMode, 
      String? purchaseRequisitionCode, 
      String? cSDate, 
      String? userName, 
      String? purchaseType, 
      String? productCategoryName, 
      String? uomName, 
      String? brandName, 
      String? storeType, 
      num? lastPurQty, 
      num? lastPurRate, 
      String? lastPurDate, 
      num? csQty, 
      String? supplierName, 
      num? rate, 
      num? csg, 
      num? discount, 
      String? tax, 
      String? vat, 
      num? caringCost, 
      String? inTax, 
      String? inVat, 
      num? oldRate, 
      num? adiRate, 
      num? fcRate, 
      num? mgRate, 
      String? comment, 
      String? adComment, 
      String? fcComment, 
      String? mgComment, 
      num? mtf, 
      num? mgt, 
      num? v, 
      num? t, 
      num? gateCost, 
      String? warranty, 
      String? supplierId,
      num? taxP,
      num? vatP, 
      num? supplierChose,}){
    _code = code;
    _productId = productId;
    _productName = productName;
    _currencyName = currencyName;
    _creditPeriod = creditPeriod;
    _payMode = payMode;
    _purchaseRequisitionCode = purchaseRequisitionCode;
    _cSDate = cSDate;
    _userName = userName;
    _purchaseType = purchaseType;
    _productCategoryName = productCategoryName;
    _uomName = uomName;
    _brandName = brandName;
    _storeType = storeType;
    _lastPurQty = lastPurQty;
    _lastPurRate = lastPurRate;
    _lastPurDate = lastPurDate;
    _csQty = csQty;
    _supplierName = supplierName;
    _rate = rate;
    _csg = csg;
    _discount = discount;
    _tax = tax;
    _vat = vat;
    _caringCost = caringCost;
    _inTax = inTax;
    _inVat = inVat;
    _oldRate = oldRate;
    _adiRate = adiRate;
    _fcRate = fcRate;
    _mgRate = mgRate;
    _comment = comment;
    _adComment = adComment;
    _fcComment = fcComment;
    _mgComment = mgComment;
    _mtf = mtf;
    _mgt = mgt;
    _v = v;
    _t = t;
    _gateCost = gateCost;
    _warranty = warranty;
    _taxP = taxP;
    _vatP = vatP;
    _supplierChose = supplierChose;
    _supplierId=supplierId;
}

  CsRequisationModel.fromJson(dynamic json) {
    _code = json['Code'];
    _productId = json['ProductId'];
    _productName = json['ProductName'];
    _currencyName = json['CurrencyName'];
    _creditPeriod = json['CreditPeriod'];
    _payMode = json['PayMode'];
    _purchaseRequisitionCode = json['PurchaseRequisitionCode'];
    _cSDate = json['CSDate'];
    _userName = json['UserName'];
    _purchaseType = json['PurchaseType'];
    _productCategoryName = json['ProductCategoryName'];
    _uomName = json['UomName'];
    _brandName = json['BrandName'];
    _storeType = json['StoreType'];
    _lastPurQty = json['LastPurQty'];
    _lastPurRate = json['LastPurRate'];
    _lastPurDate = json['LastPurDate'];
    _csQty = json['CsQty'];
    _supplierName = json['SupplierName'];
    _rate = json['Rate'];
    _csg = json['CSG'];
    _discount = json['Discount'];
    _tax = json['Tax'];
    _vat = json['Vat'];
    _caringCost = json['CaringCost'];
    _inTax = json['InTax'];
    _inVat = json['InVat'];
    _oldRate = json['OldRate'];
    _adiRate = json['AdiRate'];
    _fcRate = json['FcRate'];
    _mgRate = json['MgRate'];
    _comment = json['Comment'];
    _adComment = json['AdComment'];
    _fcComment = json['FcComment'];
    _mgComment = json['MgComment'];
    _mtf = json['MTF'];
    _mgt = json['MGT'];
    _v = json['V'];
    _t = json['T'];
    _gateCost = json['GateCost'];
    _warranty = json['Warranty'];
    _taxP = json['TaxP'];
    _vatP = json['VatP'];
    _supplierChose = json['SupplierChose'];
    _supplierId = json['SupplierId'].toString();
  }
  String? _code;
  num? _productId;
  String? _productName;
  String? _currencyName;
  String? _creditPeriod;
  String? _payMode;
  String? _purchaseRequisitionCode;
  String? _cSDate;
  String? _userName;
  String? _purchaseType;
  String? _productCategoryName;
  String? _uomName;
  String? _brandName;
  String? _storeType;
  num? _lastPurQty;
  num? _lastPurRate;
  String? _lastPurDate;
  num? _csQty;
  String? _supplierName;
  num? _rate;
  num? _csg;
  num? _discount;
  String? _tax;
  String? _vat;
  num? _caringCost;
  String? _inTax;
  String? _inVat;
  num? _oldRate;
  num? _adiRate;
  num? _fcRate;
  num? _mgRate;
  String? _comment;
  String? _adComment;
  String? _fcComment;
  String? _mgComment;
  String? _supplierId;
  num? _mtf;
  num? _mgt;
  num? _v;
  num? _t;
  num? _gateCost;
  String? _warranty;
  num? _taxP;
  num? _vatP;
  num? _supplierChose;
CsRequisationModel copyWith({  String? code,
  num? productId,
  String? productName,
  String? currencyName,
  String? creditPeriod,
  String? payMode,
  String? purchaseRequisitionCode,
  String? cSDate,
  String? userName,
  String? purchaseType,
  String? productCategoryName,
  String? uomName,
  String? brandName,
  String? storeType,
  String? supplierId,
  num? lastPurQty,
  num? lastPurRate,
  String? lastPurDate,
  num? csQty,
  String? supplierName,
  num? rate,
  num? csg,
  num? discount,
  String? tax,
  String? vat,
  num? caringCost,
  String? inTax,
  String? inVat,
  num? oldRate,
  num? adiRate,
  num? fcRate,
  num? mgRate,
  String? comment,
  String? adComment,
  String? fcComment,
  String? mgComment,
  num? mtf,
  num? mgt,
  num? v,
  num? t,
  num? gateCost,
  String? warranty,
  num? taxP,
  num? vatP,
  num? supplierChose,
}) => CsRequisationModel(  code: code ?? _code,
  productId: productId ?? _productId,
  productName: productName ?? _productName,
  currencyName: currencyName ?? _currencyName,
  creditPeriod: creditPeriod ?? _creditPeriod,
  payMode: payMode ?? _payMode,
  purchaseRequisitionCode: purchaseRequisitionCode ?? _purchaseRequisitionCode,
  cSDate: cSDate ?? _cSDate,
  userName: userName ?? _userName,
  purchaseType: purchaseType ?? _purchaseType,
  productCategoryName: productCategoryName ?? _productCategoryName,
  uomName: uomName ?? _uomName,
  brandName: brandName ?? _brandName,
  storeType: storeType ?? _storeType,
  lastPurQty: lastPurQty ?? _lastPurQty,
  lastPurRate: lastPurRate ?? _lastPurRate,
  lastPurDate: lastPurDate ?? _lastPurDate,
  csQty: csQty ?? _csQty,
  supplierName: supplierName ?? _supplierName,
  rate: rate ?? _rate,
  csg: csg ?? _csg,
  discount: discount ?? _discount,
  tax: tax ?? _tax,
  vat: vat ?? _vat,
  caringCost: caringCost ?? _caringCost,
  inTax: inTax ?? _inTax,
  inVat: inVat ?? _inVat,
  oldRate: oldRate ?? _oldRate,
  adiRate: adiRate ?? _adiRate,
  fcRate: fcRate ?? _fcRate,
  mgRate: mgRate ?? _mgRate,
  comment: comment ?? _comment,
  adComment: adComment ?? _adComment,
  fcComment: fcComment ?? _fcComment,
  mgComment: mgComment ?? _mgComment,
  mtf: mtf ?? _mtf,
  mgt: mgt ?? _mgt,
  v: v ?? _v,
  t: t ?? _t,
  gateCost: gateCost ?? _gateCost,
  warranty: warranty ?? _warranty,
  taxP: taxP ?? _taxP,
  vatP: vatP ?? _vatP,
  supplierChose: supplierChose ?? _supplierChose,
  supplierId: supplierId ?? _supplierId,
);
  String? get code => _code;
  num? get productId => _productId;
  String? get productName => _productName;
  String? get supplierId => _supplierId;
  String? get currencyName => _currencyName;
  String? get creditPeriod => _creditPeriod;
  String? get payMode => _payMode;
  String? get purchaseRequisitionCode => _purchaseRequisitionCode;
  String? get cSDate => _cSDate;
  String? get userName => _userName;
  String? get purchaseType => _purchaseType;
  String? get productCategoryName => _productCategoryName;
  String? get uomName => _uomName;
  String? get brandName => _brandName;
  String? get storeType => _storeType;
  num? get lastPurQty => _lastPurQty;
  num? get lastPurRate => _lastPurRate;
  String? get lastPurDate => _lastPurDate;
  num? get csQty => _csQty;
  String? get supplierName => _supplierName;
  num? get rate => _rate;
  num? get csg => _csg;
  num? get discount => _discount;
  String? get tax => _tax;
  String? get vat => _vat;
  num? get caringCost => _caringCost;
  String? get inTax => _inTax;
  String? get inVat => _inVat;
  num? get oldRate => _oldRate;
  num? get adiRate => _adiRate;
  num? get fcRate => _fcRate;
  num? get mgRate => _mgRate;
  String? get comment => _comment;
  String? get adComment => _adComment;
  String? get fcComment => _fcComment;
  String? get mgComment => _mgComment;
  num? get mtf => _mtf;
  num? get mgt => _mgt;
  num? get v => _v;
  num? get t => _t;
  num? get gateCost => _gateCost;
  String? get warranty => _warranty;
  num? get taxP => _taxP;
  num? get vatP => _vatP;
  num? get supplierChose => _supplierChose;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Code'] = _code;
    map['ProductId'] = _productId;
    map['ProductName'] = _productName;
    map['CurrencyName'] = _currencyName;
    map['CreditPeriod'] = _creditPeriod;
    map['PayMode'] = _payMode;
    map['PurchaseRequisitionCode'] = _purchaseRequisitionCode;
    map['CSDate'] = _cSDate;
    map['UserName'] = _userName;
    map['PurchaseType'] = _purchaseType;
    map['ProductCategoryName'] = _productCategoryName;
    map['UomName'] = _uomName;
    map['BrandName'] = _brandName;
    map['StoreType'] = _storeType;
    map['LastPurQty'] = _lastPurQty;
    map['LastPurRate'] = _lastPurRate;
    map['LastPurDate'] = _lastPurDate;
    map['CsQty'] = _csQty;
    map['SupplierName'] = _supplierName;
    map['Rate'] = _rate;
    map['CSG'] = _csg;
    map['Discount'] = _discount;
    map['Tax'] = _tax;
    map['Vat'] = _vat;
    map['CaringCost'] = _caringCost;
    map['InTax'] = _inTax;
    map['InVat'] = _inVat;
    map['OldRate'] = _oldRate;
    map['AdiRate'] = _adiRate;
    map['FcRate'] = _fcRate;
    map['MgRate'] = _mgRate;
    map['Comment'] = _comment;
    map['AdComment'] = _adComment;
    map['FcComment'] = _fcComment;
    map['MgComment'] = _mgComment;
    map['MTF'] = _mtf;
    map['MGT'] = _mgt;
    map['V'] = _v;
    map['T'] = _t;
    map['GateCost'] = _gateCost;
    map['Warranty'] = _warranty;
    map['TaxP'] = _taxP;
    map['VatP'] = _vatP;
    map['SupplierChose'] = _supplierChose;
    return map;
  }

  @override
  String toString() {
    return 'CsRequisationModel{_code: $_code, _productId: $_productId, _productName: $_productName, _currencyName: $_currencyName, _creditPeriod: $_creditPeriod, _payMode: $_payMode, _purchaseRequisitionCode: $_purchaseRequisitionCode, _cSDate: $_cSDate, _userName: $_userName, _purchaseType: $_purchaseType, _productCategoryName: $_productCategoryName, _uomName: $_uomName, _brandName: $_brandName, _storeType: $_storeType, _lastPurQty: $_lastPurQty, _lastPurRate: $_lastPurRate, _lastPurDate: $_lastPurDate, _csQty: $_csQty, _supplierName: $_supplierName, _rate: $_rate, _csg: $_csg, _discount: $_discount, _tax: $_tax, _vat: $_vat, _caringCost: $_caringCost, _inTax: $_inTax, _inVat: $_inVat, _oldRate: $_oldRate, _adiRate: $_adiRate, _fcRate: $_fcRate, _mgRate: $_mgRate, _comment: $_comment, _adComment: $_adComment, _fcComment: $_fcComment, _mgComment: $_mgComment, _supplierId: $_supplierId, _mtf: $_mtf, _mgt: $_mgt, _v: $_v, _t: $_t, _gateCost: $_gateCost, _warranty: $_warranty, _taxP: $_taxP, _vatP: $_vatP, _supplierChose: $_supplierChose}';
  }


}