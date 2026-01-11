// models/appointment_model.dart
class AppointmentModelNew {
  final String appointmentId;
  final String bookedByUserId;
  final String bookedByUserName;
  final String targetUserId;
  final String targetUserName;
  final String appointmentType;
  final String purpose;
  final DateTime appointmentDate;
  final String status;

  AppointmentModelNew({
    required this.appointmentId,
    required this.bookedByUserId,
    required this.bookedByUserName,
    required this.targetUserId,
    required this.targetUserName,
    required this.appointmentType,
    required this.purpose,
    required this.appointmentDate,
    required this.status,
  });

  // Convert to Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'appointmentId': appointmentId,
      'bookedByUserId': bookedByUserId,
      'bookedByUserName': bookedByUserName,
      'targetUserId': targetUserId,
      'targetUserName': targetUserName,
      'appointmentType': appointmentType,
      'purpose': purpose,
      'appointmentDate': appointmentDate,
      'status': status,
    };
  }

  // Create from Firebase data
  factory AppointmentModelNew.fromMap(Map<String, dynamic> map) {
    return AppointmentModelNew(
      appointmentId: map['appointmentId'],
      bookedByUserId: map['bookedByUserId'],
      bookedByUserName: map['bookedByUserName'],
      targetUserId: map['targetUserId'],
      targetUserName: map['targetUserName'],
      appointmentType: map['appointmentType'],
      purpose: map['purpose'],
      appointmentDate: map['appointmentDate'].toDate(),
      status: map['status'],
    );
  }
}