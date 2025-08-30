class BookingRef {
  final String id;
  final String userId;
  final String userName;
  final String title;
  final String description;
  final String startTime;
  final String endTime;
  final String createdAt;

  BookingRef({
    required this.id,
    required this.userId,
    required this.userName,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
  });

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'title': title,
      'description': description,
      'startTime': startTime,
      'endTime': endTime,
      'createdAt': createdAt,
    };
  }

  // Create from Map
  factory BookingRef.fromMap(Map<String, dynamic> map) {
    return BookingRef(
      id: map['id'].toString(),
      userId: map['userId'].toString(),
      userName: map['userName'].toString(),
      title: map['title'].toString(),
      description: map['description'].toString(),
      startTime: map['startTime'].toString(),
      endTime: map['endTime'].toString(),
      createdAt: map['createdAt'].toString(),
    );
  }

  // Copy with method for immutability
  BookingRef copyWith({
    String? id,
    String? userId,
    String? userName,
    String? title,
    String? description,
    String? startTime,
    String? endTime,
    String? createdAt,
  }) {
    return BookingRef(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'BookingRef(id: $id, userId: $userId, userName: $userName, title: $title, description: $description, startTime: $startTime, endTime: $endTime, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BookingRef &&
        other.id == id &&
        other.userId == userId &&
        other.userName == userName &&
        other.title == title &&
        other.description == description &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        userName.hashCode ^
        title.hashCode ^
        description.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        createdAt.hashCode;
  }
}
