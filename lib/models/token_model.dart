import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TokenModel {
  TokenModel({
      String? token, 
      String? uId,
      String? subject, 
      String? types, 
      String? department, 
      String? message, 
      String? mobile, 
      String? name, 
      String? email, 
      String? priority, 
      String? status,
      Timestamp? appointment,
      String? note,
      String? createdAt,}){
    _token = token;
    _uId = uId;
    _subject = subject;
    _types = types;
    _department = department;
    _message = message;
    _mobile = mobile;
    _name = name;
    _email = email;
    _priority = priority;
    _status = status;
    _appointment = appointment;
    _note = note;
    _createdAt = createdAt;
}

  TokenModel.fromJson(dynamic json) {
    _token = json['token'];
    _uId = json['uId'].toString();
    _subject = json['subject'];
    _types = json['types'];
    _department = json['department'];
    _message = json['message'];
    _mobile = json['mobile'];
    _name = json['name'];
    _email = json['email'];
    _priority = json['priority'];
    _status = json['status'];
    _appointment = json['appointment'];
    _note = json['note'];
    _createdAt = json['createdAt'].toString();
  }
  String? _token;
  String? _uId;
  String? _subject;
  String? _types;
  String? _department;
  String? _message;
  String? _mobile;
  String? _name;
  String? _email;
  String? _priority;
  String? _status;
  Timestamp? _appointment;
  String? _note;
  String? _createdAt;
TokenModel copyWith({  String? token,
  String? uId,
  String? subject,
  String? types,
  String? department,
  String? message,
  String? mobile,
  String? name,
  String? email,
  String? priority,
  String? status,
  Timestamp? appointment,
  String? note,
  String? createdAt,
}) => TokenModel(  token: token ?? _token,
  uId: uId ?? _uId,
  subject: subject ?? _subject,
  types: types ?? _types,
  department: department ?? _department,
  message: message ?? _message,
  mobile: mobile ?? _mobile,
  name: name ?? _name,
  email: email ?? _email,
  priority: priority ?? _priority,
  status: status ?? _status,
  appointment: appointment ?? _appointment,
  note: note ?? _note,
  createdAt: createdAt ?? _createdAt,
);
  String? get token => _token;
  String? get uId => _uId;
  String? get subject => _subject;
  String? get types => _types;
  String? get department => _department;
  String? get message => _message;
  String? get mobile => _mobile;
  String? get name => _name;
  String? get email => _email;
  String? get priority => _priority;
  String? get status => _status;
  Timestamp? get appointment => _appointment;
  String? get note => _note;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = _token;
    map['uId'] = _uId;
    map['subject'] = _subject;
    map['types'] = _types;
    map['department'] = _department;
    map['message'] = _message;
    map['mobile'] = _mobile;
    map['name'] = _name;
    map['email'] = _email;
    map['priority'] = _priority;
    map['status'] = _status;
    map['appointment'] = _appointment;
    map['note'] = _note;
    map['createdAt'] = _createdAt;
    return map;
  }

}