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
    _storeType = json['StoreType'];
    _currency = json['currency'];
    _goodsINQty = json['GoodsINQty'];
    _goodsOutQty = json['GoodsOutQty'];
    _balanceQty = json['BalanceQty'];
    _balanceValue = json['BalanceValue'];
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
    map['StoreType'] = _storeType;
    map['currency'] = _currency;
    map['GoodsINQty'] = _goodsINQty;
    map['GoodsOutQty'] = _goodsOutQty;
    map['BalanceQty'] = _balanceQty;
    map['BalanceValue'] = _balanceValue;
    return map;
  }

}