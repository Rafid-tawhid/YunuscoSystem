class CsRequisationModel {
  CsRequisationModel({
      String? code, 
      String? purchaseRequisitionCode, 
      dynamic purReqCode, 
      String? brandName, 
      dynamic createdDate, 
      String? storeType, 
      dynamic typeName, 
      String? productCategoryName, 
      String? userName, 
      String? currencyName, 
      num? cRate, 
      String? purchaseType, 
      String? productName, 
      String? uomName, 
      num? cStock, 
      num? lastPurQty, 
      num? lastPurRate, 
      String? lastPurDate, 
      dynamic supplierFirst, 
      dynamic supplierSecond, 
      dynamic supplierThird, 
      dynamic supplierFour, 
      dynamic supplierFive, 
      dynamic vatFirst, 
      dynamic vatSecond, 
      dynamic vatThird, 
      dynamic vatFour, 
      dynamic vatFive, 
      dynamic taxFirst, 
      dynamic taxSecond, 
      dynamic taxThird, 
      dynamic taxFour, 
      dynamic taxFive, 
      dynamic brandFirst, 
      dynamic brandSecond, 
      dynamic brandThird, 
      dynamic brandFour, 
      dynamic brandFive, 
      num? rateFirst, 
      num? rateSecond, 
      num? rateThird, 
      num? rateFour, 
      num? oldRateFirst, 
      num? oldRateSecond, 
      num? oldRateThird, 
      num? oldRateFour, 
      num? adiRateFirst, 
      num? adiRateSecond, 
      num? adiRateThird, 
      num? adiRateFour, 
      num? fcRateFirst, 
      num? fcRateSecond, 
      num? fcRateThird, 
      num? fcRateFour, 
      num? mgRateFirst, 
      num? mgRateSecond, 
      num? mgRateThird, 
      num? mgRateFour, 
      dynamic adCommentFirst, 
      dynamic adCommentSecond, 
      dynamic adCommentThird, 
      dynamic adCommentFour, 
      dynamic fcCommentFirst, 
      dynamic fcCommentSecond, 
      dynamic fcCommentThird, 
      dynamic fcCommentFour, 
      dynamic mgCommentFirst, 
      dynamic mgCommentSecond, 
      dynamic mgCommentThird, 
      dynamic mgCommentFour, 
      num? rateFive, 
      dynamic commentFirst, 
      dynamic commentSecond, 
      dynamic commentThird, 
      dynamic commentFour, 
      dynamic commentFive, 
      dynamic mRFirst, 
      dynamic mRSecond, 
      dynamic mRThird, 
      dynamic mRFour, 
      num? csQty, 
      num? mTFirst, 
      num? mTSecond, 
      num? mTThird, 
      num? mTFour, 
      num? mGTFirst, 
      num? mGTSecond, 
      num? mGTThird, 
      num? mGTFour, 
      num? vFirst, 
      num? vSecond, 
      num? vTThird, 
      num? vFour, 
      num? tFirst, 
      num? tSecond, 
      num? tTThird, 
      num? tFour, 
      num? cSGTFirst, 
      num? cSGTSecond, 
      num? cSGTThird, 
      num? cSGTFour, 
      dynamic caringCostFirst, 
      dynamic caringCostSecond, 
      dynamic caringCostThird, 
      dynamic caringCostFour, 
      dynamic gateCostFirst, 
      dynamic gateCostSecond, 
      dynamic gateCostThird, 
      dynamic gateCostFour, 
      dynamic warrantyFirst, 
      dynamic warrantySecond, 
      dynamic warrantyThird, 
      dynamic warrantyFour, 
      num? taxPFirst, 
      num? taxPSecond, 
      num? taxPThird, 
      num? taxPFour, 
      num? vatPFirst, 
      num? vatPSecond, 
      num? vatPThird, 
      num? vatPFour, 
      dynamic vatType, 
      dynamic taxType, 
      String? creditPeriod, 
      String? payMode, 
      num? discountFirst, 
      num? discountSecond, 
      num? discountThird, 
      num? discountFour, 
      num? dFValue, 
      num? dSValue, 
      num? dTValue, 
      num? dFoValue, 
      dynamic inTax1, 
      dynamic inTax2, 
      dynamic inTax3, 
      dynamic inTax4, 
      dynamic inVat1, 
      dynamic inVat2, 
      dynamic inVat3, 
      dynamic inVat4, 
      bool? supplierChose,}){
    _code = code;
    _purchaseRequisitionCode = purchaseRequisitionCode;
    _purReqCode = purReqCode;
    _brandName = brandName;
    _createdDate = createdDate;
    _storeType = storeType;
    _typeName = typeName;
    _productCategoryName = productCategoryName;
    _userName = userName;
    _currencyName = currencyName;
    _cRate = cRate;
    _purchaseType = purchaseType;
    _productName = productName;
    _uomName = uomName;
    _cStock = cStock;
    _lastPurQty = lastPurQty;
    _lastPurRate = lastPurRate;
    _lastPurDate = lastPurDate;
    _supplierFirst = supplierFirst;
    _supplierSecond = supplierSecond;
    _supplierThird = supplierThird;
    _supplierFour = supplierFour;
    _supplierFive = supplierFive;
    _vatFirst = vatFirst;
    _vatSecond = vatSecond;
    _vatThird = vatThird;
    _vatFour = vatFour;
    _vatFive = vatFive;
    _taxFirst = taxFirst;
    _taxSecond = taxSecond;
    _taxThird = taxThird;
    _taxFour = taxFour;
    _taxFive = taxFive;
    _brandFirst = brandFirst;
    _brandSecond = brandSecond;
    _brandThird = brandThird;
    _brandFour = brandFour;
    _brandFive = brandFive;
    _rateFirst = rateFirst;
    _rateSecond = rateSecond;
    _rateThird = rateThird;
    _rateFour = rateFour;
    _oldRateFirst = oldRateFirst;
    _oldRateSecond = oldRateSecond;
    _oldRateThird = oldRateThird;
    _oldRateFour = oldRateFour;
    _adiRateFirst = adiRateFirst;
    _adiRateSecond = adiRateSecond;
    _adiRateThird = adiRateThird;
    _adiRateFour = adiRateFour;
    _fcRateFirst = fcRateFirst;
    _fcRateSecond = fcRateSecond;
    _fcRateThird = fcRateThird;
    _fcRateFour = fcRateFour;
    _mgRateFirst = mgRateFirst;
    _mgRateSecond = mgRateSecond;
    _mgRateThird = mgRateThird;
    _mgRateFour = mgRateFour;
    _adCommentFirst = adCommentFirst;
    _adCommentSecond = adCommentSecond;
    _adCommentThird = adCommentThird;
    _adCommentFour = adCommentFour;
    _fcCommentFirst = fcCommentFirst;
    _fcCommentSecond = fcCommentSecond;
    _fcCommentThird = fcCommentThird;
    _fcCommentFour = fcCommentFour;
    _mgCommentFirst = mgCommentFirst;
    _mgCommentSecond = mgCommentSecond;
    _mgCommentThird = mgCommentThird;
    _mgCommentFour = mgCommentFour;
    _rateFive = rateFive;
    _commentFirst = commentFirst;
    _commentSecond = commentSecond;
    _commentThird = commentThird;
    _commentFour = commentFour;
    _commentFive = commentFive;
    _mRFirst = mRFirst;
    _mRSecond = mRSecond;
    _mRThird = mRThird;
    _mRFour = mRFour;
    _csQty = csQty;
    _mTFirst = mTFirst;
    _mTSecond = mTSecond;
    _mTThird = mTThird;
    _mTFour = mTFour;
    _mGTFirst = mGTFirst;
    _mGTSecond = mGTSecond;
    _mGTThird = mGTThird;
    _mGTFour = mGTFour;
    _vFirst = vFirst;
    _vSecond = vSecond;
    _vTThird = vTThird;
    _vFour = vFour;
    _tFirst = tFirst;
    _tSecond = tSecond;
    _tTThird = tTThird;
    _tFour = tFour;
    _cSGTFirst = cSGTFirst;
    _cSGTSecond = cSGTSecond;
    _cSGTThird = cSGTThird;
    _cSGTFour = cSGTFour;
    _caringCostFirst = caringCostFirst;
    _caringCostSecond = caringCostSecond;
    _caringCostThird = caringCostThird;
    _caringCostFour = caringCostFour;
    _gateCostFirst = gateCostFirst;
    _gateCostSecond = gateCostSecond;
    _gateCostThird = gateCostThird;
    _gateCostFour = gateCostFour;
    _warrantyFirst = warrantyFirst;
    _warrantySecond = warrantySecond;
    _warrantyThird = warrantyThird;
    _warrantyFour = warrantyFour;
    _taxPFirst = taxPFirst;
    _taxPSecond = taxPSecond;
    _taxPThird = taxPThird;
    _taxPFour = taxPFour;
    _vatPFirst = vatPFirst;
    _vatPSecond = vatPSecond;
    _vatPThird = vatPThird;
    _vatPFour = vatPFour;
    _vatType = vatType;
    _taxType = taxType;
    _creditPeriod = creditPeriod;
    _payMode = payMode;
    _discountFirst = discountFirst;
    _discountSecond = discountSecond;
    _discountThird = discountThird;
    _discountFour = discountFour;
    _dFValue = dFValue;
    _dSValue = dSValue;
    _dTValue = dTValue;
    _dFoValue = dFoValue;
    _inTax1 = inTax1;
    _inTax2 = inTax2;
    _inTax3 = inTax3;
    _inTax4 = inTax4;
    _inVat1 = inVat1;
    _inVat2 = inVat2;
    _inVat3 = inVat3;
    _inVat4 = inVat4;
    _supplierChose = supplierChose;
}

  CsRequisationModel.fromJson(dynamic json) {
    _code = json['Code'];
    _purchaseRequisitionCode = json['PurchaseRequisitionCode'];
    _purReqCode = json['PurReqCode'];
    _brandName = json['BrandName'];
    _createdDate = json['CreatedDate'];
    _storeType = json['StoreType'];
    _typeName = json['TypeName'];
    _productCategoryName = json['ProductCategoryName'];
    _userName = json['UserName'];
    _currencyName = json['CurrencyName'];
    _cRate = json['CRate'];
    _purchaseType = json['PurchaseType'];
    _productName = json['ProductName'];
    _uomName = json['UomName'];
    _cStock = json['CStock'];
    _lastPurQty = json['LastPurQty'];
    _lastPurRate = json['LastPurRate'];
    _lastPurDate = json['LastPurDate'];
    _supplierFirst = json['SupplierFirst'];
    _supplierSecond = json['SupplierSecond'];
    _supplierThird = json['SupplierThird'];
    _supplierFour = json['SupplierFour'];
    _supplierFive = json['SupplierFive'];
    _vatFirst = json['VatFirst'];
    _vatSecond = json['VatSecond'];
    _vatThird = json['VatThird'];
    _vatFour = json['VatFour'];
    _vatFive = json['VatFive'];
    _taxFirst = json['TaxFirst'];
    _taxSecond = json['TaxSecond'];
    _taxThird = json['TaxThird'];
    _taxFour = json['TaxFour'];
    _taxFive = json['TaxFive'];
    _brandFirst = json['BrandFirst'];
    _brandSecond = json['BrandSecond'];
    _brandThird = json['BrandThird'];
    _brandFour = json['BrandFour'];
    _brandFive = json['BrandFive'];
    _rateFirst = json['RateFirst'];
    _rateSecond = json['RateSecond'];
    _rateThird = json['RateThird'];
    _rateFour = json['RateFour'];
    _oldRateFirst = json['OldRateFirst'];
    _oldRateSecond = json['OldRateSecond'];
    _oldRateThird = json['OldRateThird'];
    _oldRateFour = json['OldRateFour'];
    _adiRateFirst = json['AdiRateFirst'];
    _adiRateSecond = json['AdiRateSecond'];
    _adiRateThird = json['AdiRateThird'];
    _adiRateFour = json['AdiRateFour'];
    _fcRateFirst = json['FcRateFirst'];
    _fcRateSecond = json['FcRateSecond'];
    _fcRateThird = json['FcRateThird'];
    _fcRateFour = json['FcRateFour'];
    _mgRateFirst = json['MgRateFirst'];
    _mgRateSecond = json['MgRateSecond'];
    _mgRateThird = json['MgRateThird'];
    _mgRateFour = json['MgRateFour'];
    _adCommentFirst = json['AdCommentFirst'];
    _adCommentSecond = json['AdCommentSecond'];
    _adCommentThird = json['AdCommentThird'];
    _adCommentFour = json['AdCommentFour'];
    _fcCommentFirst = json['FcCommentFirst'];
    _fcCommentSecond = json['FcCommentSecond'];
    _fcCommentThird = json['FcCommentThird'];
    _fcCommentFour = json['FcCommentFour'];
    _mgCommentFirst = json['MgCommentFirst'];
    _mgCommentSecond = json['MgCommentSecond'];
    _mgCommentThird = json['MgCommentThird'];
    _mgCommentFour = json['MgCommentFour'];
    _rateFive = json['RateFive'];
    _commentFirst = json['CommentFirst'];
    _commentSecond = json['CommentSecond'];
    _commentThird = json['CommentThird'];
    _commentFour = json['CommentFour'];
    _commentFive = json['CommentFive'];
    _mRFirst = json['MRFirst'];
    _mRSecond = json['MRSecond'];
    _mRThird = json['MRThird'];
    _mRFour = json['MRFour'];
    _csQty = json['CsQty'];
    _mTFirst = json['MTFirst'];
    _mTSecond = json['MTSecond'];
    _mTThird = json['MTThird'];
    _mTFour = json['MTFour'];
    _mGTFirst = json['MGTFirst'];
    _mGTSecond = json['MGTSecond'];
    _mGTThird = json['MGTThird'];
    _mGTFour = json['MGTFour'];
    _vFirst = json['VFirst'];
    _vSecond = json['VSecond'];
    _vTThird = json['VTThird'];
    _vFour = json['VFour'];
    _tFirst = json['TFirst'];
    _tSecond = json['TSecond'];
    _tTThird = json['TTThird'];
    _tFour = json['TFour'];
    _cSGTFirst = json['CSGTFirst'];
    _cSGTSecond = json['CSGTSecond'];
    _cSGTThird = json['CSGTThird'];
    _cSGTFour = json['CSGTFour'];
    _caringCostFirst = json['CaringCostFirst'];
    _caringCostSecond = json['CaringCostSecond'];
    _caringCostThird = json['CaringCostThird'];
    _caringCostFour = json['CaringCostFour'];
    _gateCostFirst = json['GateCostFirst'];
    _gateCostSecond = json['GateCostSecond'];
    _gateCostThird = json['GateCostThird'];
    _gateCostFour = json['GateCostFour'];
    _warrantyFirst = json['WarrantyFirst'];
    _warrantySecond = json['WarrantySecond'];
    _warrantyThird = json['WarrantyThird'];
    _warrantyFour = json['WarrantyFour'];
    _taxPFirst = json['TaxPFirst'];
    _taxPSecond = json['TaxPSecond'];
    _taxPThird = json['TaxPThird'];
    _taxPFour = json['TaxPFour'];
    _vatPFirst = json['VatPFirst'];
    _vatPSecond = json['VatPSecond'];
    _vatPThird = json['VatPThird'];
    _vatPFour = json['VatPFour'];
    _vatType = json['VatType'];
    _taxType = json['TaxType'];
    _creditPeriod = json['CreditPeriod'];
    _payMode = json['PayMode'];
    _discountFirst = json['DiscountFirst'];
    _discountSecond = json['DiscountSecond'];
    _discountThird = json['DiscountThird'];
    _discountFour = json['DiscountFour'];
    _dFValue = json['DFValue'];
    _dSValue = json['DSValue'];
    _dTValue = json['DTValue'];
    _dFoValue = json['DFoValue'];
    _inTax1 = json['InTax1'];
    _inTax2 = json['InTax2'];
    _inTax3 = json['InTax3'];
    _inTax4 = json['InTax4'];
    _inVat1 = json['InVat1'];
    _inVat2 = json['InVat2'];
    _inVat3 = json['InVat3'];
    _inVat4 = json['InVat4'];
    _supplierChose = json['SupplierChose'];
  }
  String? _code;
  String? _purchaseRequisitionCode;
  dynamic _purReqCode;
  String? _brandName;
  dynamic _createdDate;
  String? _storeType;
  dynamic _typeName;
  String? _productCategoryName;
  String? _userName;
  String? _currencyName;
  num? _cRate;
  String? _purchaseType;
  String? _productName;
  String? _uomName;
  num? _cStock;
  num? _lastPurQty;
  num? _lastPurRate;
  String? _lastPurDate;
  dynamic _supplierFirst;
  dynamic _supplierSecond;
  dynamic _supplierThird;
  dynamic _supplierFour;
  dynamic _supplierFive;
  dynamic _vatFirst;
  dynamic _vatSecond;
  dynamic _vatThird;
  dynamic _vatFour;
  dynamic _vatFive;
  dynamic _taxFirst;
  dynamic _taxSecond;
  dynamic _taxThird;
  dynamic _taxFour;
  dynamic _taxFive;
  dynamic _brandFirst;
  dynamic _brandSecond;
  dynamic _brandThird;
  dynamic _brandFour;
  dynamic _brandFive;
  num? _rateFirst;
  num? _rateSecond;
  num? _rateThird;
  num? _rateFour;
  num? _oldRateFirst;
  num? _oldRateSecond;
  num? _oldRateThird;
  num? _oldRateFour;
  num? _adiRateFirst;
  num? _adiRateSecond;
  num? _adiRateThird;
  num? _adiRateFour;
  num? _fcRateFirst;
  num? _fcRateSecond;
  num? _fcRateThird;
  num? _fcRateFour;
  num? _mgRateFirst;
  num? _mgRateSecond;
  num? _mgRateThird;
  num? _mgRateFour;
  dynamic _adCommentFirst;
  dynamic _adCommentSecond;
  dynamic _adCommentThird;
  dynamic _adCommentFour;
  dynamic _fcCommentFirst;
  dynamic _fcCommentSecond;
  dynamic _fcCommentThird;
  dynamic _fcCommentFour;
  dynamic _mgCommentFirst;
  dynamic _mgCommentSecond;
  dynamic _mgCommentThird;
  dynamic _mgCommentFour;
  num? _rateFive;
  dynamic _commentFirst;
  dynamic _commentSecond;
  dynamic _commentThird;
  dynamic _commentFour;
  dynamic _commentFive;
  dynamic _mRFirst;
  dynamic _mRSecond;
  dynamic _mRThird;
  dynamic _mRFour;
  num? _csQty;
  num? _mTFirst;
  num? _mTSecond;
  num? _mTThird;
  num? _mTFour;
  num? _mGTFirst;
  num? _mGTSecond;
  num? _mGTThird;
  num? _mGTFour;
  num? _vFirst;
  num? _vSecond;
  num? _vTThird;
  num? _vFour;
  num? _tFirst;
  num? _tSecond;
  num? _tTThird;
  num? _tFour;
  num? _cSGTFirst;
  num? _cSGTSecond;
  num? _cSGTThird;
  num? _cSGTFour;
  dynamic _caringCostFirst;
  dynamic _caringCostSecond;
  dynamic _caringCostThird;
  dynamic _caringCostFour;
  dynamic _gateCostFirst;
  dynamic _gateCostSecond;
  dynamic _gateCostThird;
  dynamic _gateCostFour;
  dynamic _warrantyFirst;
  dynamic _warrantySecond;
  dynamic _warrantyThird;
  dynamic _warrantyFour;
  num? _taxPFirst;
  num? _taxPSecond;
  num? _taxPThird;
  num? _taxPFour;
  num? _vatPFirst;
  num? _vatPSecond;
  num? _vatPThird;
  num? _vatPFour;
  dynamic _vatType;
  dynamic _taxType;
  String? _creditPeriod;
  String? _payMode;
  num? _discountFirst;
  num? _discountSecond;
  num? _discountThird;
  num? _discountFour;
  num? _dFValue;
  num? _dSValue;
  num? _dTValue;
  num? _dFoValue;
  dynamic _inTax1;
  dynamic _inTax2;
  dynamic _inTax3;
  dynamic _inTax4;
  dynamic _inVat1;
  dynamic _inVat2;
  dynamic _inVat3;
  dynamic _inVat4;
  bool? _supplierChose;
CsRequisationModel copyWith({  String? code,
  String? purchaseRequisitionCode,
  dynamic purReqCode,
  String? brandName,
  dynamic createdDate,
  String? storeType,
  dynamic typeName,
  String? productCategoryName,
  String? userName,
  String? currencyName,
  num? cRate,
  String? purchaseType,
  String? productName,
  String? uomName,
  num? cStock,
  num? lastPurQty,
  num? lastPurRate,
  String? lastPurDate,
  dynamic supplierFirst,
  dynamic supplierSecond,
  dynamic supplierThird,
  dynamic supplierFour,
  dynamic supplierFive,
  dynamic vatFirst,
  dynamic vatSecond,
  dynamic vatThird,
  dynamic vatFour,
  dynamic vatFive,
  dynamic taxFirst,
  dynamic taxSecond,
  dynamic taxThird,
  dynamic taxFour,
  dynamic taxFive,
  dynamic brandFirst,
  dynamic brandSecond,
  dynamic brandThird,
  dynamic brandFour,
  dynamic brandFive,
  num? rateFirst,
  num? rateSecond,
  num? rateThird,
  num? rateFour,
  num? oldRateFirst,
  num? oldRateSecond,
  num? oldRateThird,
  num? oldRateFour,
  num? adiRateFirst,
  num? adiRateSecond,
  num? adiRateThird,
  num? adiRateFour,
  num? fcRateFirst,
  num? fcRateSecond,
  num? fcRateThird,
  num? fcRateFour,
  num? mgRateFirst,
  num? mgRateSecond,
  num? mgRateThird,
  num? mgRateFour,
  dynamic adCommentFirst,
  dynamic adCommentSecond,
  dynamic adCommentThird,
  dynamic adCommentFour,
  dynamic fcCommentFirst,
  dynamic fcCommentSecond,
  dynamic fcCommentThird,
  dynamic fcCommentFour,
  dynamic mgCommentFirst,
  dynamic mgCommentSecond,
  dynamic mgCommentThird,
  dynamic mgCommentFour,
  num? rateFive,
  dynamic commentFirst,
  dynamic commentSecond,
  dynamic commentThird,
  dynamic commentFour,
  dynamic commentFive,
  dynamic mRFirst,
  dynamic mRSecond,
  dynamic mRThird,
  dynamic mRFour,
  num? csQty,
  num? mTFirst,
  num? mTSecond,
  num? mTThird,
  num? mTFour,
  num? mGTFirst,
  num? mGTSecond,
  num? mGTThird,
  num? mGTFour,
  num? vFirst,
  num? vSecond,
  num? vTThird,
  num? vFour,
  num? tFirst,
  num? tSecond,
  num? tTThird,
  num? tFour,
  num? cSGTFirst,
  num? cSGTSecond,
  num? cSGTThird,
  num? cSGTFour,
  dynamic caringCostFirst,
  dynamic caringCostSecond,
  dynamic caringCostThird,
  dynamic caringCostFour,
  dynamic gateCostFirst,
  dynamic gateCostSecond,
  dynamic gateCostThird,
  dynamic gateCostFour,
  dynamic warrantyFirst,
  dynamic warrantySecond,
  dynamic warrantyThird,
  dynamic warrantyFour,
  num? taxPFirst,
  num? taxPSecond,
  num? taxPThird,
  num? taxPFour,
  num? vatPFirst,
  num? vatPSecond,
  num? vatPThird,
  num? vatPFour,
  dynamic vatType,
  dynamic taxType,
  String? creditPeriod,
  String? payMode,
  num? discountFirst,
  num? discountSecond,
  num? discountThird,
  num? discountFour,
  num? dFValue,
  num? dSValue,
  num? dTValue,
  num? dFoValue,
  dynamic inTax1,
  dynamic inTax2,
  dynamic inTax3,
  dynamic inTax4,
  dynamic inVat1,
  dynamic inVat2,
  dynamic inVat3,
  dynamic inVat4,
  bool? supplierChose,
}) => CsRequisationModel(  code: code ?? _code,
  purchaseRequisitionCode: purchaseRequisitionCode ?? _purchaseRequisitionCode,
  purReqCode: purReqCode ?? _purReqCode,
  brandName: brandName ?? _brandName,
  createdDate: createdDate ?? _createdDate,
  storeType: storeType ?? _storeType,
  typeName: typeName ?? _typeName,
  productCategoryName: productCategoryName ?? _productCategoryName,
  userName: userName ?? _userName,
  currencyName: currencyName ?? _currencyName,
  cRate: cRate ?? _cRate,
  purchaseType: purchaseType ?? _purchaseType,
  productName: productName ?? _productName,
  uomName: uomName ?? _uomName,
  cStock: cStock ?? _cStock,
  lastPurQty: lastPurQty ?? _lastPurQty,
  lastPurRate: lastPurRate ?? _lastPurRate,
  lastPurDate: lastPurDate ?? _lastPurDate,
  supplierFirst: supplierFirst ?? _supplierFirst,
  supplierSecond: supplierSecond ?? _supplierSecond,
  supplierThird: supplierThird ?? _supplierThird,
  supplierFour: supplierFour ?? _supplierFour,
  supplierFive: supplierFive ?? _supplierFive,
  vatFirst: vatFirst ?? _vatFirst,
  vatSecond: vatSecond ?? _vatSecond,
  vatThird: vatThird ?? _vatThird,
  vatFour: vatFour ?? _vatFour,
  vatFive: vatFive ?? _vatFive,
  taxFirst: taxFirst ?? _taxFirst,
  taxSecond: taxSecond ?? _taxSecond,
  taxThird: taxThird ?? _taxThird,
  taxFour: taxFour ?? _taxFour,
  taxFive: taxFive ?? _taxFive,
  brandFirst: brandFirst ?? _brandFirst,
  brandSecond: brandSecond ?? _brandSecond,
  brandThird: brandThird ?? _brandThird,
  brandFour: brandFour ?? _brandFour,
  brandFive: brandFive ?? _brandFive,
  rateFirst: rateFirst ?? _rateFirst,
  rateSecond: rateSecond ?? _rateSecond,
  rateThird: rateThird ?? _rateThird,
  rateFour: rateFour ?? _rateFour,
  oldRateFirst: oldRateFirst ?? _oldRateFirst,
  oldRateSecond: oldRateSecond ?? _oldRateSecond,
  oldRateThird: oldRateThird ?? _oldRateThird,
  oldRateFour: oldRateFour ?? _oldRateFour,
  adiRateFirst: adiRateFirst ?? _adiRateFirst,
  adiRateSecond: adiRateSecond ?? _adiRateSecond,
  adiRateThird: adiRateThird ?? _adiRateThird,
  adiRateFour: adiRateFour ?? _adiRateFour,
  fcRateFirst: fcRateFirst ?? _fcRateFirst,
  fcRateSecond: fcRateSecond ?? _fcRateSecond,
  fcRateThird: fcRateThird ?? _fcRateThird,
  fcRateFour: fcRateFour ?? _fcRateFour,
  mgRateFirst: mgRateFirst ?? _mgRateFirst,
  mgRateSecond: mgRateSecond ?? _mgRateSecond,
  mgRateThird: mgRateThird ?? _mgRateThird,
  mgRateFour: mgRateFour ?? _mgRateFour,
  adCommentFirst: adCommentFirst ?? _adCommentFirst,
  adCommentSecond: adCommentSecond ?? _adCommentSecond,
  adCommentThird: adCommentThird ?? _adCommentThird,
  adCommentFour: adCommentFour ?? _adCommentFour,
  fcCommentFirst: fcCommentFirst ?? _fcCommentFirst,
  fcCommentSecond: fcCommentSecond ?? _fcCommentSecond,
  fcCommentThird: fcCommentThird ?? _fcCommentThird,
  fcCommentFour: fcCommentFour ?? _fcCommentFour,
  mgCommentFirst: mgCommentFirst ?? _mgCommentFirst,
  mgCommentSecond: mgCommentSecond ?? _mgCommentSecond,
  mgCommentThird: mgCommentThird ?? _mgCommentThird,
  mgCommentFour: mgCommentFour ?? _mgCommentFour,
  rateFive: rateFive ?? _rateFive,
  commentFirst: commentFirst ?? _commentFirst,
  commentSecond: commentSecond ?? _commentSecond,
  commentThird: commentThird ?? _commentThird,
  commentFour: commentFour ?? _commentFour,
  commentFive: commentFive ?? _commentFive,
  mRFirst: mRFirst ?? _mRFirst,
  mRSecond: mRSecond ?? _mRSecond,
  mRThird: mRThird ?? _mRThird,
  mRFour: mRFour ?? _mRFour,
  csQty: csQty ?? _csQty,
  mTFirst: mTFirst ?? _mTFirst,
  mTSecond: mTSecond ?? _mTSecond,
  mTThird: mTThird ?? _mTThird,
  mTFour: mTFour ?? _mTFour,
  mGTFirst: mGTFirst ?? _mGTFirst,
  mGTSecond: mGTSecond ?? _mGTSecond,
  mGTThird: mGTThird ?? _mGTThird,
  mGTFour: mGTFour ?? _mGTFour,
  vFirst: vFirst ?? _vFirst,
  vSecond: vSecond ?? _vSecond,
  vTThird: vTThird ?? _vTThird,
  vFour: vFour ?? _vFour,
  tFirst: tFirst ?? _tFirst,
  tSecond: tSecond ?? _tSecond,
  tTThird: tTThird ?? _tTThird,
  tFour: tFour ?? _tFour,
  cSGTFirst: cSGTFirst ?? _cSGTFirst,
  cSGTSecond: cSGTSecond ?? _cSGTSecond,
  cSGTThird: cSGTThird ?? _cSGTThird,
  cSGTFour: cSGTFour ?? _cSGTFour,
  caringCostFirst: caringCostFirst ?? _caringCostFirst,
  caringCostSecond: caringCostSecond ?? _caringCostSecond,
  caringCostThird: caringCostThird ?? _caringCostThird,
  caringCostFour: caringCostFour ?? _caringCostFour,
  gateCostFirst: gateCostFirst ?? _gateCostFirst,
  gateCostSecond: gateCostSecond ?? _gateCostSecond,
  gateCostThird: gateCostThird ?? _gateCostThird,
  gateCostFour: gateCostFour ?? _gateCostFour,
  warrantyFirst: warrantyFirst ?? _warrantyFirst,
  warrantySecond: warrantySecond ?? _warrantySecond,
  warrantyThird: warrantyThird ?? _warrantyThird,
  warrantyFour: warrantyFour ?? _warrantyFour,
  taxPFirst: taxPFirst ?? _taxPFirst,
  taxPSecond: taxPSecond ?? _taxPSecond,
  taxPThird: taxPThird ?? _taxPThird,
  taxPFour: taxPFour ?? _taxPFour,
  vatPFirst: vatPFirst ?? _vatPFirst,
  vatPSecond: vatPSecond ?? _vatPSecond,
  vatPThird: vatPThird ?? _vatPThird,
  vatPFour: vatPFour ?? _vatPFour,
  vatType: vatType ?? _vatType,
  taxType: taxType ?? _taxType,
  creditPeriod: creditPeriod ?? _creditPeriod,
  payMode: payMode ?? _payMode,
  discountFirst: discountFirst ?? _discountFirst,
  discountSecond: discountSecond ?? _discountSecond,
  discountThird: discountThird ?? _discountThird,
  discountFour: discountFour ?? _discountFour,
  dFValue: dFValue ?? _dFValue,
  dSValue: dSValue ?? _dSValue,
  dTValue: dTValue ?? _dTValue,
  dFoValue: dFoValue ?? _dFoValue,
  inTax1: inTax1 ?? _inTax1,
  inTax2: inTax2 ?? _inTax2,
  inTax3: inTax3 ?? _inTax3,
  inTax4: inTax4 ?? _inTax4,
  inVat1: inVat1 ?? _inVat1,
  inVat2: inVat2 ?? _inVat2,
  inVat3: inVat3 ?? _inVat3,
  inVat4: inVat4 ?? _inVat4,
  supplierChose: supplierChose ?? _supplierChose,
);
  String? get code => _code;
  String? get purchaseRequisitionCode => _purchaseRequisitionCode;
  dynamic get purReqCode => _purReqCode;
  String? get brandName => _brandName;
  dynamic get createdDate => _createdDate;
  String? get storeType => _storeType;
  dynamic get typeName => _typeName;
  String? get productCategoryName => _productCategoryName;
  String? get userName => _userName;
  String? get currencyName => _currencyName;
  num? get cRate => _cRate;
  String? get purchaseType => _purchaseType;
  String? get productName => _productName;
  String? get uomName => _uomName;
  num? get cStock => _cStock;
  num? get lastPurQty => _lastPurQty;
  num? get lastPurRate => _lastPurRate;
  String? get lastPurDate => _lastPurDate;
  dynamic get supplierFirst => _supplierFirst;
  dynamic get supplierSecond => _supplierSecond;
  dynamic get supplierThird => _supplierThird;
  dynamic get supplierFour => _supplierFour;
  dynamic get supplierFive => _supplierFive;
  dynamic get vatFirst => _vatFirst;
  dynamic get vatSecond => _vatSecond;
  dynamic get vatThird => _vatThird;
  dynamic get vatFour => _vatFour;
  dynamic get vatFive => _vatFive;
  dynamic get taxFirst => _taxFirst;
  dynamic get taxSecond => _taxSecond;
  dynamic get taxThird => _taxThird;
  dynamic get taxFour => _taxFour;
  dynamic get taxFive => _taxFive;
  dynamic get brandFirst => _brandFirst;
  dynamic get brandSecond => _brandSecond;
  dynamic get brandThird => _brandThird;
  dynamic get brandFour => _brandFour;
  dynamic get brandFive => _brandFive;
  num? get rateFirst => _rateFirst;
  num? get rateSecond => _rateSecond;
  num? get rateThird => _rateThird;
  num? get rateFour => _rateFour;
  num? get oldRateFirst => _oldRateFirst;
  num? get oldRateSecond => _oldRateSecond;
  num? get oldRateThird => _oldRateThird;
  num? get oldRateFour => _oldRateFour;
  num? get adiRateFirst => _adiRateFirst;
  num? get adiRateSecond => _adiRateSecond;
  num? get adiRateThird => _adiRateThird;
  num? get adiRateFour => _adiRateFour;
  num? get fcRateFirst => _fcRateFirst;
  num? get fcRateSecond => _fcRateSecond;
  num? get fcRateThird => _fcRateThird;
  num? get fcRateFour => _fcRateFour;
  num? get mgRateFirst => _mgRateFirst;
  num? get mgRateSecond => _mgRateSecond;
  num? get mgRateThird => _mgRateThird;
  num? get mgRateFour => _mgRateFour;
  dynamic get adCommentFirst => _adCommentFirst;
  dynamic get adCommentSecond => _adCommentSecond;
  dynamic get adCommentThird => _adCommentThird;
  dynamic get adCommentFour => _adCommentFour;
  dynamic get fcCommentFirst => _fcCommentFirst;
  dynamic get fcCommentSecond => _fcCommentSecond;
  dynamic get fcCommentThird => _fcCommentThird;
  dynamic get fcCommentFour => _fcCommentFour;
  dynamic get mgCommentFirst => _mgCommentFirst;
  dynamic get mgCommentSecond => _mgCommentSecond;
  dynamic get mgCommentThird => _mgCommentThird;
  dynamic get mgCommentFour => _mgCommentFour;
  num? get rateFive => _rateFive;
  dynamic get commentFirst => _commentFirst;
  dynamic get commentSecond => _commentSecond;
  dynamic get commentThird => _commentThird;
  dynamic get commentFour => _commentFour;
  dynamic get commentFive => _commentFive;
  dynamic get mRFirst => _mRFirst;
  dynamic get mRSecond => _mRSecond;
  dynamic get mRThird => _mRThird;
  dynamic get mRFour => _mRFour;
  num? get csQty => _csQty;
  num? get mTFirst => _mTFirst;
  num? get mTSecond => _mTSecond;
  num? get mTThird => _mTThird;
  num? get mTFour => _mTFour;
  num? get mGTFirst => _mGTFirst;
  num? get mGTSecond => _mGTSecond;
  num? get mGTThird => _mGTThird;
  num? get mGTFour => _mGTFour;
  num? get vFirst => _vFirst;
  num? get vSecond => _vSecond;
  num? get vTThird => _vTThird;
  num? get vFour => _vFour;
  num? get tFirst => _tFirst;
  num? get tSecond => _tSecond;
  num? get tTThird => _tTThird;
  num? get tFour => _tFour;
  num? get cSGTFirst => _cSGTFirst;
  num? get cSGTSecond => _cSGTSecond;
  num? get cSGTThird => _cSGTThird;
  num? get cSGTFour => _cSGTFour;
  dynamic get caringCostFirst => _caringCostFirst;
  dynamic get caringCostSecond => _caringCostSecond;
  dynamic get caringCostThird => _caringCostThird;
  dynamic get caringCostFour => _caringCostFour;
  dynamic get gateCostFirst => _gateCostFirst;
  dynamic get gateCostSecond => _gateCostSecond;
  dynamic get gateCostThird => _gateCostThird;
  dynamic get gateCostFour => _gateCostFour;
  dynamic get warrantyFirst => _warrantyFirst;
  dynamic get warrantySecond => _warrantySecond;
  dynamic get warrantyThird => _warrantyThird;
  dynamic get warrantyFour => _warrantyFour;
  num? get taxPFirst => _taxPFirst;
  num? get taxPSecond => _taxPSecond;
  num? get taxPThird => _taxPThird;
  num? get taxPFour => _taxPFour;
  num? get vatPFirst => _vatPFirst;
  num? get vatPSecond => _vatPSecond;
  num? get vatPThird => _vatPThird;
  num? get vatPFour => _vatPFour;
  dynamic get vatType => _vatType;
  dynamic get taxType => _taxType;
  String? get creditPeriod => _creditPeriod;
  String? get payMode => _payMode;
  num? get discountFirst => _discountFirst;
  num? get discountSecond => _discountSecond;
  num? get discountThird => _discountThird;
  num? get discountFour => _discountFour;
  num? get dFValue => _dFValue;
  num? get dSValue => _dSValue;
  num? get dTValue => _dTValue;
  num? get dFoValue => _dFoValue;
  dynamic get inTax1 => _inTax1;
  dynamic get inTax2 => _inTax2;
  dynamic get inTax3 => _inTax3;
  dynamic get inTax4 => _inTax4;
  dynamic get inVat1 => _inVat1;
  dynamic get inVat2 => _inVat2;
  dynamic get inVat3 => _inVat3;
  dynamic get inVat4 => _inVat4;
  bool? get supplierChose => _supplierChose;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Code'] = _code;
    map['PurchaseRequisitionCode'] = _purchaseRequisitionCode;
    map['PurReqCode'] = _purReqCode;
    map['BrandName'] = _brandName;
    map['CreatedDate'] = _createdDate;
    map['StoreType'] = _storeType;
    map['TypeName'] = _typeName;
    map['ProductCategoryName'] = _productCategoryName;
    map['UserName'] = _userName;
    map['CurrencyName'] = _currencyName;
    map['CRate'] = _cRate;
    map['PurchaseType'] = _purchaseType;
    map['ProductName'] = _productName;
    map['UomName'] = _uomName;
    map['CStock'] = _cStock;
    map['LastPurQty'] = _lastPurQty;
    map['LastPurRate'] = _lastPurRate;
    map['LastPurDate'] = _lastPurDate;
    map['SupplierFirst'] = _supplierFirst;
    map['SupplierSecond'] = _supplierSecond;
    map['SupplierThird'] = _supplierThird;
    map['SupplierFour'] = _supplierFour;
    map['SupplierFive'] = _supplierFive;
    map['VatFirst'] = _vatFirst;
    map['VatSecond'] = _vatSecond;
    map['VatThird'] = _vatThird;
    map['VatFour'] = _vatFour;
    map['VatFive'] = _vatFive;
    map['TaxFirst'] = _taxFirst;
    map['TaxSecond'] = _taxSecond;
    map['TaxThird'] = _taxThird;
    map['TaxFour'] = _taxFour;
    map['TaxFive'] = _taxFive;
    map['BrandFirst'] = _brandFirst;
    map['BrandSecond'] = _brandSecond;
    map['BrandThird'] = _brandThird;
    map['BrandFour'] = _brandFour;
    map['BrandFive'] = _brandFive;
    map['RateFirst'] = _rateFirst;
    map['RateSecond'] = _rateSecond;
    map['RateThird'] = _rateThird;
    map['RateFour'] = _rateFour;
    map['OldRateFirst'] = _oldRateFirst;
    map['OldRateSecond'] = _oldRateSecond;
    map['OldRateThird'] = _oldRateThird;
    map['OldRateFour'] = _oldRateFour;
    map['AdiRateFirst'] = _adiRateFirst;
    map['AdiRateSecond'] = _adiRateSecond;
    map['AdiRateThird'] = _adiRateThird;
    map['AdiRateFour'] = _adiRateFour;
    map['FcRateFirst'] = _fcRateFirst;
    map['FcRateSecond'] = _fcRateSecond;
    map['FcRateThird'] = _fcRateThird;
    map['FcRateFour'] = _fcRateFour;
    map['MgRateFirst'] = _mgRateFirst;
    map['MgRateSecond'] = _mgRateSecond;
    map['MgRateThird'] = _mgRateThird;
    map['MgRateFour'] = _mgRateFour;
    map['AdCommentFirst'] = _adCommentFirst;
    map['AdCommentSecond'] = _adCommentSecond;
    map['AdCommentThird'] = _adCommentThird;
    map['AdCommentFour'] = _adCommentFour;
    map['FcCommentFirst'] = _fcCommentFirst;
    map['FcCommentSecond'] = _fcCommentSecond;
    map['FcCommentThird'] = _fcCommentThird;
    map['FcCommentFour'] = _fcCommentFour;
    map['MgCommentFirst'] = _mgCommentFirst;
    map['MgCommentSecond'] = _mgCommentSecond;
    map['MgCommentThird'] = _mgCommentThird;
    map['MgCommentFour'] = _mgCommentFour;
    map['RateFive'] = _rateFive;
    map['CommentFirst'] = _commentFirst;
    map['CommentSecond'] = _commentSecond;
    map['CommentThird'] = _commentThird;
    map['CommentFour'] = _commentFour;
    map['CommentFive'] = _commentFive;
    map['MRFirst'] = _mRFirst;
    map['MRSecond'] = _mRSecond;
    map['MRThird'] = _mRThird;
    map['MRFour'] = _mRFour;
    map['CsQty'] = _csQty;
    map['MTFirst'] = _mTFirst;
    map['MTSecond'] = _mTSecond;
    map['MTThird'] = _mTThird;
    map['MTFour'] = _mTFour;
    map['MGTFirst'] = _mGTFirst;
    map['MGTSecond'] = _mGTSecond;
    map['MGTThird'] = _mGTThird;
    map['MGTFour'] = _mGTFour;
    map['VFirst'] = _vFirst;
    map['VSecond'] = _vSecond;
    map['VTThird'] = _vTThird;
    map['VFour'] = _vFour;
    map['TFirst'] = _tFirst;
    map['TSecond'] = _tSecond;
    map['TTThird'] = _tTThird;
    map['TFour'] = _tFour;
    map['CSGTFirst'] = _cSGTFirst;
    map['CSGTSecond'] = _cSGTSecond;
    map['CSGTThird'] = _cSGTThird;
    map['CSGTFour'] = _cSGTFour;
    map['CaringCostFirst'] = _caringCostFirst;
    map['CaringCostSecond'] = _caringCostSecond;
    map['CaringCostThird'] = _caringCostThird;
    map['CaringCostFour'] = _caringCostFour;
    map['GateCostFirst'] = _gateCostFirst;
    map['GateCostSecond'] = _gateCostSecond;
    map['GateCostThird'] = _gateCostThird;
    map['GateCostFour'] = _gateCostFour;
    map['WarrantyFirst'] = _warrantyFirst;
    map['WarrantySecond'] = _warrantySecond;
    map['WarrantyThird'] = _warrantyThird;
    map['WarrantyFour'] = _warrantyFour;
    map['TaxPFirst'] = _taxPFirst;
    map['TaxPSecond'] = _taxPSecond;
    map['TaxPThird'] = _taxPThird;
    map['TaxPFour'] = _taxPFour;
    map['VatPFirst'] = _vatPFirst;
    map['VatPSecond'] = _vatPSecond;
    map['VatPThird'] = _vatPThird;
    map['VatPFour'] = _vatPFour;
    map['VatType'] = _vatType;
    map['TaxType'] = _taxType;
    map['CreditPeriod'] = _creditPeriod;
    map['PayMode'] = _payMode;
    map['DiscountFirst'] = _discountFirst;
    map['DiscountSecond'] = _discountSecond;
    map['DiscountThird'] = _discountThird;
    map['DiscountFour'] = _discountFour;
    map['DFValue'] = _dFValue;
    map['DSValue'] = _dSValue;
    map['DTValue'] = _dTValue;
    map['DFoValue'] = _dFoValue;
    map['InTax1'] = _inTax1;
    map['InTax2'] = _inTax2;
    map['InTax3'] = _inTax3;
    map['InTax4'] = _inTax4;
    map['InVat1'] = _inVat1;
    map['InVat2'] = _inVat2;
    map['InVat3'] = _inVat3;
    map['InVat4'] = _inVat4;
    map['SupplierChose'] = _supplierChose;
    return map;
  }

}