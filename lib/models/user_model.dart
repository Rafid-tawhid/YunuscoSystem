class UserModel {
  UserModel({
      this.userId, 
      this.userName, 
      this.loginName, 
      this.roleId,});

  UserModel.fromJson(dynamic json) {
    userId = json['userId'];
    userName = json['userName'];
    loginName = json['loginName'];
    roleId = json['roleId'];
  }
  num? userId;
  String? userName;
  String? loginName;
  num? roleId;
UserModel copyWith({  num? userId,
  String? userName,
  String? loginName,
  num? roleId,
}) => UserModel(  userId: userId ?? this.userId,
  userName: userName ?? this.userName,
  loginName: loginName ?? this.loginName,
  roleId: roleId ?? this.roleId,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['userName'] = userName;
    map['loginName'] = loginName;
    map['roleId'] = roleId;
    return map;
  }

}