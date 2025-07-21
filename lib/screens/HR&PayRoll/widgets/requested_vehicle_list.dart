import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RequisitionListScreen extends StatelessWidget {
  const RequisitionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Vehicle Requisitions'),
        actions: [

        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('vehicle_requisitions')
            .orderBy('submittedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No requisitions found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return RequisitionCard(
                docId: doc.id,
                data: data,
              );
            },
          );
        },
      ),
    );
  }
}

class RequisitionCard extends StatelessWidget {
  final String docId;
  final Map<String, dynamic> data;

  const RequisitionCard({
    super.key,
    required this.docId,
    required this.data,
  });

  Future<void> _updateStatus(String status) async {
    await FirebaseFirestore.instance
        .collection('vehicle_requisitions')
        .doc(docId)
        .update({
      'status': status,
      'processedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd-MM-yyyy hh:mm a');
    final travelDate = (data['travelDateTime'] as Timestamp).toDate();
    final submittedAt = (data['submittedAt'] as Timestamp).toDate();

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Chip(
                  label: Text(
                    data['status'] ?? 'pending',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: _getStatusColor(data['status']),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Designation: ${data['designation']}'),
            Text('Section: ${data['section']}'),
            const SizedBox(height: 8),
            Text('Destination: ${data['destination']}'),
            Text('Distance: ${data['distance']}'),
            Text('Purpose: ${data['purpose']}'),
            const SizedBox(height: 8),
            Text('Travel Date: ${dateFormat.format(travelDate)}'),
            Text('Submitted: ${dateFormat.format(submittedAt)}'),
            const SizedBox(height: 16),
            if (data['status'] == 'pending')
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => _updateStatus('rejected'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text('Reject'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _updateStatus('approved'),
                    child: const Text('Approve'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}