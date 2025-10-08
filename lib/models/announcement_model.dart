// models/AnnouncementModel_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementModel {
   String id;
  final String userId;
  final String userName;
  final String content;
  final DateTime timestamp;
  final List<String> likes;
  final int likesCount;
  final int commentsCount;
  final bool isActive;

  AnnouncementModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.content,
    required this.timestamp,
    required this.likes,
    required this.likesCount,
    required this.commentsCount,
    required this.isActive,
  });

  factory AnnouncementModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AnnouncementModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      content: data['content'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      likes: List<String>.from(data['likes'] ?? []),
      likesCount: data['likesCount'] ?? 0,
      commentsCount: data['commentsCount'] ?? 0,
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'likes': likes,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'isActive': isActive,
    };
  }
}


class Comment {
   String id;
  final String userId;
  final String userName;
  final String content;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.content,
    required this.timestamp,
  });

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Comment(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      content: data['content'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}