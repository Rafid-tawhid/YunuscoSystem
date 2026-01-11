class AnnouncementModel {
  AnnouncementModel({
      num? announcementId, 
      String? title, 
      String? description, 
      String? category, 
      String? publishDate, 
      String? createdBy, 
      String? createdAt, 
      num? commentCount, 
      num? reactionCount,}){
    _announcementId = announcementId;
    _title = title;
    _description = description;
    _category = category;
    _publishDate = publishDate;
    _createdBy = createdBy;
    _createdAt = createdAt;
    _commentCount = commentCount;
    _reactionCount = reactionCount;
}

  AnnouncementModel.fromJson(dynamic json) {
    _announcementId = json['AnnouncementId'];
    _title = json['Title'];
    _description = json['Description'];
    _category = json['Category'];
    _publishDate = json['PublishDate'];
    _createdBy = json['CreatedBy'];
    _createdAt = json['CreatedAt'];
    _commentCount = json['CommentCount'];
    _reactionCount = json['ReactionCount'];
  }
  num? _announcementId;
  String? _title;
  String? _description;
  String? _category;
  String? _publishDate;
  String? _createdBy;
  String? _createdAt;
  num? _commentCount;
  num? _reactionCount;
AnnouncementModel copyWith({  num? announcementId,
  String? title,
  String? description,
  String? category,
  String? publishDate,
  String? createdBy,
  String? createdAt,
  num? commentCount,
  num? reactionCount,
}) => AnnouncementModel(  announcementId: announcementId ?? _announcementId,
  title: title ?? _title,
  description: description ?? _description,
  category: category ?? _category,
  publishDate: publishDate ?? _publishDate,
  createdBy: createdBy ?? _createdBy,
  createdAt: createdAt ?? _createdAt,
  commentCount: commentCount ?? _commentCount,
  reactionCount: reactionCount ?? _reactionCount,
);
  num? get announcementId => _announcementId;
  String? get title => _title;
  String? get description => _description;
  String? get category => _category;
  String? get publishDate => _publishDate;
  String? get createdBy => _createdBy;
  String? get createdAt => _createdAt;
  num? get commentCount => _commentCount;
  num? get reactionCount => _reactionCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['AnnouncementId'] = _announcementId;
    map['Title'] = _title;
    map['Description'] = _description;
    map['Category'] = _category;
    map['PublishDate'] = _publishDate;
    map['CreatedBy'] = _createdBy;
    map['CreatedAt'] = _createdAt;
    map['CommentCount'] = _commentCount;
    map['ReactionCount'] = _reactionCount;
    return map;
  }

}