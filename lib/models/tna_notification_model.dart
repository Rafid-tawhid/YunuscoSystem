class TnaNotificationModel {
  TnaNotificationModel({
      num? id, 
      String? notificationType, 
      num? merchanTandAid, 
      num? buyerId, 
      String? buyer, 
      String? po, 
      String? style, 
      String? notificationDate, 
      num? daysOffset, 
      String? recipientRole, 
      bool? isSent, 
      String? sentDate, 
      String? message, 
      String? createdDate,}){
    _id = id;
    _notificationType = notificationType;
    _merchanTandAid = merchanTandAid;
    _buyerId = buyerId;
    _buyer = buyer;
    _po = po;
    _style = style;
    _notificationDate = notificationDate;
    _daysOffset = daysOffset;
    _recipientRole = recipientRole;
    _isSent = isSent;
    _sentDate = sentDate;
    _message = message;
    _createdDate = createdDate;
}

  TnaNotificationModel.fromJson(dynamic json) {
    _id = json['Id'];
    _notificationType = json['NotificationType'];
    _merchanTandAid = json['MerchanTandAid'];
    _buyerId = json['BuyerId'];
    _buyer = json['Buyer'];
    _po = json['Po'];
    _style = json['Style'];
    _notificationDate = json['NotificationDate'];
    _daysOffset = json['DaysOffset'];
    _recipientRole = json['RecipientRole'];
    _isSent = json['IsSent'];
    _sentDate = json['SentDate'];
    _message = json['Message'];
    _createdDate = json['CreatedDate'];
  }
  num? _id;
  String? _notificationType;
  num? _merchanTandAid;
  num? _buyerId;
  String? _buyer;
  String? _po;
  String? _style;
  String? _notificationDate;
  num? _daysOffset;
  String? _recipientRole;
  bool? _isSent;
  String? _sentDate;
  String? _message;
  String? _createdDate;
TnaNotificationModel copyWith({  num? id,
  String? notificationType,
  num? merchanTandAid,
  num? buyerId,
  String? buyer,
  String? po,
  String? style,
  String? notificationDate,
  num? daysOffset,
  String? recipientRole,
  bool? isSent,
  String? sentDate,
  String? message,
  String? createdDate,
}) => TnaNotificationModel(  id: id ?? _id,
  notificationType: notificationType ?? _notificationType,
  merchanTandAid: merchanTandAid ?? _merchanTandAid,
  buyerId: buyerId ?? _buyerId,
  buyer: buyer ?? _buyer,
  po: po ?? _po,
  style: style ?? _style,
  notificationDate: notificationDate ?? _notificationDate,
  daysOffset: daysOffset ?? _daysOffset,
  recipientRole: recipientRole ?? _recipientRole,
  isSent: isSent ?? _isSent,
  sentDate: sentDate ?? _sentDate,
  message: message ?? _message,
  createdDate: createdDate ?? _createdDate,
);
  num? get id => _id;
  String? get notificationType => _notificationType;
  num? get merchanTandAid => _merchanTandAid;
  num? get buyerId => _buyerId;
  String? get buyer => _buyer;
  String? get po => _po;
  String? get style => _style;
  String? get notificationDate => _notificationDate;
  num? get daysOffset => _daysOffset;
  String? get recipientRole => _recipientRole;
  bool? get isSent => _isSent;
  String? get sentDate => _sentDate;
  String? get message => _message;
  String? get createdDate => _createdDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = _id;
    map['NotificationType'] = _notificationType;
    map['MerchanTandAid'] = _merchanTandAid;
    map['BuyerId'] = _buyerId;
    map['Buyer'] = _buyer;
    map['Po'] = _po;
    map['Style'] = _style;
    map['NotificationDate'] = _notificationDate;
    map['DaysOffset'] = _daysOffset;
    map['RecipientRole'] = _recipientRole;
    map['IsSent'] = _isSent;
    map['SentDate'] = _sentDate;
    map['Message'] = _message;
    map['CreatedDate'] = _createdDate;
    return map;
  }

}