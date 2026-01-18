class AnnouncementCommentModel {
  AnnouncementCommentModel({
      num? commentId, 
      String? userId, 
      String? userName, 
      String? commentText, 
      dynamic parentCommentId, 
      String? createdAt,}){
    _commentId = commentId;
    _userId = userId;
    _userName = userName;
    _commentText = commentText;
    _parentCommentId = parentCommentId;
    _createdAt = createdAt;
}

  AnnouncementCommentModel.fromJson(dynamic json) {
    _commentId = json['CommentId'];
    _userId = json['UserId'];
    _userName = json['UserName'];
    _commentText = json['CommentText'];
    _parentCommentId = json['ParentCommentId'];
    _createdAt = json['CreatedAt'];
  }
  num? _commentId;
  String? _userId;
  String? _userName;
  String? _commentText;
  dynamic _parentCommentId;
  String? _createdAt;
AnnouncementCommentModel copyWith({  num? commentId,
  String? userId,
  String? userName,
  String? commentText,
  dynamic parentCommentId,
  String? createdAt,
}) => AnnouncementCommentModel(  commentId: commentId ?? _commentId,
  userId: userId ?? _userId,
  userName: userName ?? _userName,
  commentText: commentText ?? _commentText,
  parentCommentId: parentCommentId ?? _parentCommentId,
  createdAt: createdAt ?? _createdAt,
);
  num? get commentId => _commentId;
  String? get userId => _userId;
  String? get userName => _userName;
  String? get commentText => _commentText;
  dynamic get parentCommentId => _parentCommentId;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CommentId'] = _commentId;
    map['UserId'] = _userId;
    map['UserName'] = _userName;
    map['CommentText'] = _commentText;
    map['ParentCommentId'] = _parentCommentId;
    map['CreatedAt'] = _createdAt;
    return map;
  }

}