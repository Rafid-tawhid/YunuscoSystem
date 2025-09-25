// requisition_master_model.dart
class PuchaseMasterModelFirebase {
  final String productType;
  final String remarks;
  final String division;
  final String userId;
  final String approval;
  final String? approvedBy;
  final String reqId;
  final DateTime createdAt;

  PuchaseMasterModelFirebase({
    required this.productType,
    required this.remarks,
    required this.division,
    required this.approval,
    required this.userId,
    required this.reqId,
    required this.createdAt,
    this.approvedBy
  });

  Map<String, dynamic> toMap() {
    return {
      'productType': productType,
      'remarks': remarks,
      'division': division,
      'approval': approval,
      'reqId': reqId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PuchaseMasterModelFirebase.fromMap(Map<String, dynamic> map) {
    return PuchaseMasterModelFirebase(
      productType: map['productType'] ?? '',
      remarks: map['remarks'] ?? '',
      division: map['division'] ?? '',
      userId: map['userId'] ?? '',
      approval: map['approval'] ?? '',
      approvedBy: map['approvedBy'] ?? '',
      reqId: map['reqId'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

// requisition_detail_model.dart
class RequisitionDetail {
  final String productId;
  final String reqId;
  final String productName;
  final String productDescription;
  final String unitId;
  final String actualReqQty;
  final String totalReqQty;
  final String consumeDays;
  final String note;
  final String userId;
  final String? approvedBy;
  final String brand;
  final String requiredDate;

  RequisitionDetail({
    required this.productId,
    required this.reqId,
    required this.productName,
    required this.productDescription,
    required this.unitId,
    required this.userId,
    required this.actualReqQty,
    required this.totalReqQty,
    required this.consumeDays,
    required this.note,
    required this.brand,
    required this.requiredDate,
     this.approvedBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'reqId': reqId,
      'userId': userId,
      'productName': productName,
      'productDescription': productDescription,
      'unitId': unitId,
      'actualReqQty': actualReqQty,
      'totalReqQty': totalReqQty,
      'consumeDays': consumeDays,
      'note': note,
      'brand': brand,
      'requiredDate': requiredDate,
      'approvedBy': approvedBy,
    };
  }

  factory RequisitionDetail.fromMap(Map<String, dynamic> map) {
    return RequisitionDetail(
      productId: map['productId']??'',
      reqId: map['reqId'] ?? '',
      productName: map['productName'] ?? '',
      userId: map['userId'] ?? '',
      productDescription: map['productDescription'] ?? '',
      unitId: map['unitId'] ?? '',
      approvedBy: map['approvedBy'] ?? '',
      actualReqQty: map['actualReqQty'] ?? '',
      totalReqQty: map['totalReqQty'] ?? '',
      consumeDays: map['consumeDays'] ?? '',
      note: map['note'] ?? '',
      brand: map['brand'] ?? '',
      requiredDate: map['requiredDate'] ?? '',
    );
  }
}