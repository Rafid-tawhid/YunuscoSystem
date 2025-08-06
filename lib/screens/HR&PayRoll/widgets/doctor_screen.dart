import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../helper_class/dashboard_helpers.dart';
import 'gate_pass.dart';

class DoctorApprovalScreen extends StatefulWidget {
  const DoctorApprovalScreen({super.key});

  @override
  _DoctorApprovalScreenState createState() => _DoctorApprovalScreenState();
}

class _DoctorApprovalScreenState extends State<DoctorApprovalScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _prescriptionController = TextEditingController();
  final TextEditingController _medicineController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _gatePassReasonController = TextEditingController();
  final bool _issueGatePass = false;

  String _generateRandomPasscode() {
    final random = Random();
    return '${random.nextInt(9)}${random.nextInt(9)}${random.nextInt(9)}${random.nextInt(9)}';
  }

  Future<void> _approveRequest(
      String docId,
      String employeeId,
      bool needsGatePass
      ) async {
    final passcode =  _generateRandomPasscode();

    try {
      // First check if document exists in leaveToken collection

      final now = DateTime.now();
      final validUntil = now.add(const Duration(hours: 24));

      var doc= await _firestore.collection('gateToken').doc();
      Map<String, dynamic> data = {
        'status': 'Approved',
        'employeeId': employeeId,
        'requestId': docId,
        'docId':doc.id,
        'generatedAt': FieldValue.serverTimestamp(),
        'validUntil': validUntil,
        'used': false,
        'generatedBy': DashboardHelpers.currentUser!.userName,
        'prescription': _prescriptionController.text,
        'medicine': _medicineController.text,
        'instructions': _instructionsController.text,
        'gatePassCode': passcode,
        'gatePassReason': _gatePassReasonController.text,
        'approvalTime': FieldValue.serverTimestamp(),
        'approvedBy': DashboardHelpers.currentUser!.userName,
      };

      // Update the leave token document
      doc.set(data);



      // Show success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request approved successfully')),
      );

      // Clear form
      _prescriptionController.clear();
      _medicineController.clear();
      _instructionsController.clear();
      _gatePassReasonController.clear();

      // Navigate to gate pass screen with all data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GatePassDetailsScreen(
            gatePassData: {
              ...data,
              'validUntil': validUntil.toString(), // Ensure DateTime is passed directly
              'generatedAt': now.toString(), // Convert server timestamp to local time
            },
          ),
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      debugPrint('Error approving request: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Medical Leave Approvals'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('leaveRequests')
            .where('status', isEqualTo: 'Pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No pending requests'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  title: Text('${data['employeeId']} - ${data['symptoms']}'),
                  subtitle: Text(DateFormat('MMM dd, yyyy - hh:mm a')
                      .format(DateTime.fromMillisecondsSinceEpoch(data['timestamp']))),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow('Employee ID', data['employeeId']),
                          _buildDetailRow('Symptoms', data['symptoms']),
                          _buildDetailRow('Urgency', data['urgency']),
                          _buildDetailRow('Reason', data['reason']),
                          const SizedBox(height: 16),

                          // Prescription Form
                          const Text('Medical Prescription',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextField(
                            controller: _prescriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Diagnosis/Prescription',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 8),

                          TextField(
                            controller: _medicineController,
                            decoration: const InputDecoration(
                              labelText: 'Medication',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 8),

                          TextField(
                            controller: _instructionsController,
                            decoration: const InputDecoration(
                              labelText: 'Instructions',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 2,
                          ),


                          const SizedBox(height: 16),

                          // Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => _rejectRequest(doc.id),
                                child: const Text('Reject'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () => _approveRequest(
                                    doc.id,
                                    data['employeeId'],
                                    _issueGatePass
                                ),
                                child: const Text('Approve'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _rejectRequest(String requestId) async {
    try {
      // Show confirmation dialog
      final shouldReject = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Reject Request'),
          content: const Text('Are you sure you want to reject this leave request?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Reject', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (shouldReject ?? false) {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator()),
        );

        // Update request status in Firestore
        await _firestore.collection('leaveRequests').doc(requestId).update({
          'status': 'Rejected',
          'rejectedBy': DashboardHelpers.currentUser!.userName,
          'rejectionTime': FieldValue.serverTimestamp(),
        });

        // Send notification to employee
        await _sendRejectionNotification(requestId);

        // Close loading indicator
        Navigator.of(context).pop();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request rejected successfully')),
        );
      }
    } catch (e) {
      // Close loading indicator if still open
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error rejecting request: ${e.toString()}')),
      );
    }
  }

  Future<void> _sendRejectionNotification(String requestId) async {
    try {
      // Get the request details
      final requestDoc = await _firestore.collection('leaveRequests').doc(requestId).get();
      final requestData = requestDoc.data() as Map<String, dynamic>;
      final employeeId = requestData['employeeId'];

      // Create notification for employee
      await _firestore.collection('notifications').add({
        'type': 'leave_rejection',
        'title': 'Leave Request Rejected',
        'message': 'Your leave request has been rejected by the doctor',
        'relatedDocId': requestId,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
        'targetUserId': employeeId,
        'rejectionReason': requestData['rejectionReason'], // Optional: add rejection reason field
      });
    } catch (e) {
      debugPrint('Error sending rejection notification: $e');
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}