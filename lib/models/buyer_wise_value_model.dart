class BuyerWiseValueModel {
  BuyerWiseValueModel({
      List<BuyerWise>? buyerWise, 
      List<Summary>? summary, 
      List<ItemWiseWise>? itemWiseWise, 
      List<MorrisLine>? morrisLine, 
      List<BuyerWiseQty>? buyerWiseQty, 
      List<ItemWiseValue>? itemWiseValue,}){
    _buyerWise = buyerWise;
    _summary = summary;
    _itemWiseWise = itemWiseWise;
    _morrisLine = morrisLine;
    _buyerWiseQty = buyerWiseQty;
    _itemWiseValue = itemWiseValue;
}

  BuyerWiseValueModel.fromJson(dynamic json) {
    if (json['BuyerWise'] != null) {
      _buyerWise = [];
      json['BuyerWise'].forEach((v) {
        _buyerWise?.add(BuyerWise.fromJson(v));
      });
    }
    if (json['Summary'] != null) {
      _summary = [];
      json['Summary'].forEach((v) {
        _summary?.add(Summary.fromJson(v));
      });
    }
    if (json['ItemWiseWise'] != null) {
      _itemWiseWise = [];
      json['ItemWiseWise'].forEach((v) {
        _itemWiseWise?.add(ItemWiseWise.fromJson(v));
      });
    }
    if (json['MorrisLine'] != null) {
      _morrisLine = [];
      json['MorrisLine'].forEach((v) {
        _morrisLine?.add(MorrisLine.fromJson(v));
      });
    }
    if (json['BuyerWiseQty'] != null) {
      _buyerWiseQty = [];
      json['BuyerWiseQty'].forEach((v) {
        _buyerWiseQty?.add(BuyerWiseQty.fromJson(v));
      });
    }
    if (json['ItemWiseValue'] != null) {
      _itemWiseValue = [];
      json['ItemWiseValue'].forEach((v) {
        _itemWiseValue?.add(ItemWiseValue.fromJson(v));
      });
    }
  }
  List<BuyerWise>? _buyerWise;
  List<Summary>? _summary;
  List<ItemWiseWise>? _itemWiseWise;
  List<MorrisLine>? _morrisLine;
  List<BuyerWiseQty>? _buyerWiseQty;
  List<ItemWiseValue>? _itemWiseValue;
BuyerWiseValueModel copyWith({  List<BuyerWise>? buyerWise,
  List<Summary>? summary,
  List<ItemWiseWise>? itemWiseWise,
  List<MorrisLine>? morrisLine,
  List<BuyerWiseQty>? buyerWiseQty,
  List<ItemWiseValue>? itemWiseValue,
}) => BuyerWiseValueModel(  buyerWise: buyerWise ?? _buyerWise,
  summary: summary ?? _summary,
  itemWiseWise: itemWiseWise ?? _itemWiseWise,
  morrisLine: morrisLine ?? _morrisLine,
  buyerWiseQty: buyerWiseQty ?? _buyerWiseQty,
  itemWiseValue: itemWiseValue ?? _itemWiseValue,
);
  List<BuyerWise>? get buyerWise => _buyerWise;
  List<Summary>? get summary => _summary;
  List<ItemWiseWise>? get itemWiseWise => _itemWiseWise;
  List<MorrisLine>? get morrisLine => _morrisLine;
  List<BuyerWiseQty>? get buyerWiseQty => _buyerWiseQty;
  List<ItemWiseValue>? get itemWiseValue => _itemWiseValue;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_buyerWise != null) {
      map['BuyerWise'] = _buyerWise?.map((v) => v.toJson()).toList();
    }
    if (_summary != null) {
      map['Summary'] = _summary?.map((v) => v.toJson()).toList();
    }
    if (_itemWiseWise != null) {
      map['ItemWiseWise'] = _itemWiseWise?.map((v) => v.toJson()).toList();
    }
    if (_morrisLine != null) {
      map['MorrisLine'] = _morrisLine?.map((v) => v.toJson()).toList();
    }
    if (_buyerWiseQty != null) {
      map['BuyerWiseQty'] = _buyerWiseQty?.map((v) => v.toJson()).toList();
    }
    if (_itemWiseValue != null) {
      map['ItemWiseValue'] = _itemWiseValue?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class ItemWiseValue {
  ItemWiseValue({
      String? label, 
      num? value,}){
    _label = label;
    _value = value;
}

  ItemWiseValue.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }
  String? _label;
  num? _value;
ItemWiseValue copyWith({  String? label,
  num? value,
}) => ItemWiseValue(  label: label ?? _label,
  value: value ?? _value,
);
  String? get label => _label;
  num? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }

}

class BuyerWiseQty {
  BuyerWiseQty({
      String? label, 
      num? value,}){
    _label = label;
    _value = value;
}

  BuyerWiseQty.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
  }
  String? _label;
  num? _value;
BuyerWiseQty copyWith({  String? label,
  num? value,
}) => BuyerWiseQty(  label: label ?? _label,
  value: value ?? _value,
);
  String? get label => _label;
  num? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    return map;
  }

}

class MorrisLine {
  MorrisLine({
      String? monthName,
      num? orderValue,
      num? shipmentValue,}){
    _monthName = monthName;
    _orderValue = orderValue;
    _shipmentValue = shipmentValue;
}

  MorrisLine.fromJson(dynamic json) {
    _monthName = json['MonthName'];
    _orderValue = json['OrderValue'];
    _shipmentValue = json['ShipmentValue'];
  }
  String? _monthName;
  num? _orderValue;
  num? _shipmentValue;
MorrisLine copyWith({  String? monthName,
  num? orderValue,
  num? shipmentValue,
}) => MorrisLine(  monthName: monthName ?? _monthName,
  orderValue: orderValue ?? _orderValue,
  shipmentValue: shipmentValue ?? _shipmentValue,
);
  String? get monthName => _monthName;
  num? get orderValue => _orderValue;
  num? get shipmentValue => _shipmentValue;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['MonthName'] = _monthName;
    map['OrderValue'] = _orderValue;
    map['ShipmentValue'] = _shipmentValue;
    return map;
  }

}

class ItemWiseWise {
  ItemWiseWise({
      String? item, 
      num? quantity,}){
    _item = item;
    _quantity = quantity;
}

  ItemWiseWise.fromJson(dynamic json) {
    _item = json['Item'];
    _quantity = json['Quantity'];
  }
  String? _item;
  num? _quantity;
ItemWiseWise copyWith({  String? item,
  num? quantity,
}) => ItemWiseWise(  item: item ?? _item,
  quantity: quantity ?? _quantity,
);
  String? get item => _item;
  num? get quantity => _quantity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Item'] = _item;
    map['Quantity'] = _quantity;
    return map;
  }

}

class Summary {
  Summary({
      num? costingCount, 
      num? orderQuantity, 
      num? orderValue, 
      num? purchaseValue,}){
    _costingCount = costingCount;
    _orderQuantity = orderQuantity;
    _orderValue = orderValue;
    _purchaseValue = purchaseValue;
}

  Summary.fromJson(dynamic json) {
    _costingCount = json['CostingCount'];
    _orderQuantity = json['OrderQuantity'];
    _orderValue = json['OrderValue'];
    _purchaseValue = json['PurchaseValue'];
  }
  num? _costingCount;
  num? _orderQuantity;
  num? _orderValue;
  num? _purchaseValue;
Summary copyWith({  num? costingCount,
  num? orderQuantity,
  num? orderValue,
  num? purchaseValue,
}) => Summary(  costingCount: costingCount ?? _costingCount,
  orderQuantity: orderQuantity ?? _orderQuantity,
  orderValue: orderValue ?? _orderValue,
  purchaseValue: purchaseValue ?? _purchaseValue,
);
  num? get costingCount => _costingCount;
  num? get orderQuantity => _orderQuantity;
  num? get orderValue => _orderValue;
  num? get purchaseValue => _purchaseValue;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CostingCount'] = _costingCount;
    map['OrderQuantity'] = _orderQuantity;
    map['OrderValue'] = _orderValue;
    map['PurchaseValue'] = _purchaseValue;
    return map;
  }

}

class BuyerWise {
  BuyerWise({
      String? buyerName, 
      num? orderValue,}){
    _buyerName = buyerName;
    _orderValue = orderValue;
}

  BuyerWise.fromJson(dynamic json) {
    _buyerName = json['BuyerName'];
    _orderValue = json['OrderValue'];
  }
  String? _buyerName;
  num? _orderValue;
BuyerWise copyWith({  String? buyerName,
  num? orderValue,
}) => BuyerWise(  buyerName: buyerName ?? _buyerName,
  orderValue: orderValue ?? _orderValue,
);
  String? get buyerName => _buyerName;
  num? get orderValue => _orderValue;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['BuyerName'] = _buyerName;
    map['OrderValue'] = _orderValue;
    return map;
  }

}