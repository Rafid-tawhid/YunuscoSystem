class InventoryStockModel {
  InventoryStockModel({
      String? storeType, 
      String? currency, 
      num? goodsINQty, 
      num? goodsOutQty, 
      num? balanceQty, 
      num? balanceValue,}){
    _storeType = storeType;
    _currency = currency;
    _goodsINQty = goodsINQty;
    _goodsOutQty = goodsOutQty;
    _balanceQty = balanceQty;
    _balanceValue = balanceValue;
}

  InventoryStockModel.fromJson(dynamic json) {
    _storeType = json['storeType'];
    _currency = json['currency'];
    _goodsINQty = json['goodsINQty'];
    _goodsOutQty = json['goodsOutQty'];
    _balanceQty = json['balanceQty'];
    _balanceValue = json['balanceValue'];
  }
  String? _storeType;
  String? _currency;
  num? _goodsINQty;
  num? _goodsOutQty;
  num? _balanceQty;
  num? _balanceValue;
InventoryStockModel copyWith({  String? storeType,
  String? currency,
  num? goodsINQty,
  num? goodsOutQty,
  num? balanceQty,
  num? balanceValue,
}) => InventoryStockModel(  storeType: storeType ?? _storeType,
  currency: currency ?? _currency,
  goodsINQty: goodsINQty ?? _goodsINQty,
  goodsOutQty: goodsOutQty ?? _goodsOutQty,
  balanceQty: balanceQty ?? _balanceQty,
  balanceValue: balanceValue ?? _balanceValue,
);
  String? get storeType => _storeType;
  String? get currency => _currency;
  num? get goodsINQty => _goodsINQty;
  num? get goodsOutQty => _goodsOutQty;
  num? get balanceQty => _balanceQty;
  num? get balanceValue => _balanceValue;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['storeType'] = _storeType;
    map['currency'] = _currency;
    map['goodsINQty'] = _goodsINQty;
    map['goodsOutQty'] = _goodsOutQty;
    map['balanceQty'] = _balanceQty;
    map['balanceValue'] = _balanceValue;
    return map;
  }

}