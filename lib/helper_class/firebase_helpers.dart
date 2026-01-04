// services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/models/appointment_model_new.dart';
import '../models/announcement_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;




  // Reference to the presence document collection

  // Update presence status
  Future<void> updatePresence(String userId,String name, bool isActive) async {
    await FirebaseFirestore.instance
        .collection('presence')
        .doc(userId) // This ensures only one document per user
        .set({
      'isActive': isActive,
      'name': name,
      'lastUpdated': FieldValue.serverTimestamp(),
      'userId': userId, // Keep user ID for reference
    }, SetOptions(merge: true)); // This merges with existing document
  }



  Stream<List<AppointmentModelNew>> getAllAppointmentRequest(String userId) {
    try {
      return _firestore
          .collection('appointments')
          .where('targetUserId', isEqualTo: userId)
          .orderBy('createdAt', descending: false)
          .snapshots()
          .handleError((error) {
        print('Firestore stream error: $error');
        // Return an empty list when error occurs to keep the stream alive
        return [];
      })
          .map((snapshot) {
        try {
          final appointments = snapshot.docs
              .map((doc) => AppointmentModelNew.fromMap(doc.data()))
              .where((appointment) => (appointment.status == 'pending')||(appointment.status == 'in_progress'))
              .toList();
          return appointments;
        } catch (e) {
          print('Error processing documents: $e');
          return [];
        }
      });
    } catch (e) {
      print('Error creating stream: $e');
      // Return an empty stream if initial setup fails
      return Stream.value([]);
    }
  }

  void updateStatusAppointment(String s,AppointmentModelNew data) {
    _firestore.collection('appointments').doc(data.appointmentId).update({
      'status': s,
    });
  }



  Future<String?> fetchUserRole(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('roles')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data();
        return data['role'] as String?; // Assuming 'role' field exists
      }
      return null;
    } catch (e) {
      print('Error fetching user role: $e');
      return null;
    }
  }

}