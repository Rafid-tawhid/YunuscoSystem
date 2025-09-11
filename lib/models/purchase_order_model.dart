class PurchaseOrderModel {
  PurchaseOrderModel({
      num? purchaseOrderId, 
      String? purchaseOrderCode, 
      String? orderDate, 
      String? orderType, 
      String? purchaseType, 
      bool? isConfirmed, 
      dynamic approvalFieldCode, 
      String? remarks, 
      String? approve, 
      String? supplierName,}){
    _purchaseOrderId = purchaseOrderId;
    _purchaseOrderCode = purchaseOrderCode;
    _orderDate = orderDate;
    _orderType = orderType;
    _purchaseType = purchaseType;
    _isConfirmed = isConfirmed;
    _approvalFieldCode = approvalFieldCode;
    _remarks = remarks;
    _approve = approve;
    _supplierName = supplierName;
}

  PurchaseOrderModel.fromJson(dynamic json) {
    _purchaseOrderId = json['PurchaseOrderId'];
    _purchaseOrderCode = json['PurchaseOrderCode'];
    _orderDate = json['OrderDate'];
    _orderType = json['OrderType'];
    _purchaseType = json['PurchaseType'];
    _isConfirmed = json['IsConfirmed'];
    _approvalFieldCode = json['ApprovalFieldCode'];
    _remarks = json['Remarks'];
    _approve = json['Approve'];
    _supplierName = json['SupplierName'];
  }
  num? _purchaseOrderId;
  String? _purchaseOrderCode;
  String? _orderDate;
  String? _orderType;
  String? _purchaseType;
  bool? _isConfirmed;
  dynamic _approvalFieldCode;
  String? _remarks;
  String? _approve;
  String? _supplierName;
PurchaseOrderModel copyWith({  num? purchaseOrderId,
  String? purchaseOrderCode,
  String? orderDate,
  String? orderType,
  String? purchaseType,
  bool? isConfirmed,
  dynamic approvalFieldCode,
  String? remarks,
  String? approve,
  String? supplierName,
}) => PurchaseOrderModel(  purchaseOrderId: purchaseOrderId ?? _purchaseOrderId,
  purchaseOrderCode: purchaseOrderCode ?? _purchaseOrderCode,
  orderDate: orderDate ?? _orderDate,
  orderType: orderType ?? _orderType,
  purchaseType: purchaseType ?? _purchaseType,
  isConfirmed: isConfirmed ?? _isConfirmed,
  approvalFieldCode: approvalFieldCode ?? _approvalFieldCode,
  remarks: remarks ?? _remarks,
  approve: approve ?? _approve,
  supplierName: supplierName ?? _supplierName,
);
  num? get purchaseOrderId => _purchaseOrderId;
  String? get purchaseOrderCode => _purchaseOrderCode;
  String? get orderDate => _orderDate;
  String? get orderType => _orderType;
  String? get purchaseType => _purchaseType;
  bool? get isConfirmed => _isConfirmed;
  dynamic get approvalFieldCode => _approvalFieldCode;
  String? get remarks => _remarks;
  String? get approve => _approve;
  String? get supplierName => _supplierName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['PurchaseOrderId'] = _purchaseOrderId;
    map['PurchaseOrderCode'] = _purchaseOrderCode;
    map['OrderDate'] = _orderDate;
    map['OrderType'] = _orderType;
    map['PurchaseType'] = _purchaseType;
    map['IsConfirmed'] = _isConfirmed;
    map['ApprovalFieldCode'] = _approvalFieldCode;
    map['Remarks'] = _remarks;
    map['Approve'] = _approve;
    map['SupplierName'] = _supplierName;
    return map;
  }

}