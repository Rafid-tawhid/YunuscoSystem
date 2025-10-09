import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/utils/colors.dart';

class TicketsScreen extends StatefulWidget {
  @override
  _TicketsScreenState createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('All Tickets',style: TextStyle(color: Colors.white),),foregroundColor: Colors.white,backgroundColor: myColors.primaryColor,),
      body: StreamBuilder<QuerySnapshot>(
        stream: DashboardHelpers.currentUser!.department=='17'?_firestore.collection('tickets').snapshots():
        _firestore.collection('tickets').where('uId',isEqualTo: DashboardHelpers.currentUser!.userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No tickets found'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var ticket = snapshot.data!.docs[index];
              var data = ticket.data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Token: ${data['token']}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Chip(
                            label: Text(data['status'] ?? 'pending',
                                style: TextStyle(color: Colors.white)),
                            backgroundColor: _getStatusColor(data['status']),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text('User ID: ${data['uId'] ?? 'N/A'}'),
                      SizedBox(height: 8),
                      Text('Subject: ${data['subject']}'),
                      SizedBox(height: 8),
                      Text('Types: ${data['types'] ?? 'N/A'}'),
                      SizedBox(height: 8),
                      Text('Department: ${data['department']}'),
                      SizedBox(height: 8),
                      Text('Message: ${data['message']}'),
                      SizedBox(height: 8),
                      Text('Mobile: ${data['mobile']}'),
                      SizedBox(height: 8),
                      Text('Name: ${data['name']}'),
                      SizedBox(height: 8),
                      Text('Email: ${data['email']}'),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text('Priority: '),
                          Text(data['priority'],
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text('Created: ${_formatTimestamp(data['createdAt'])}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'resolved': return Colors.green;
      case 'in progress': return Colors.blue;
      default: return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High': return Colors.red;
      case 'Medium': return Colors.orange;
      case 'Low': return Colors.green;
      default: return Colors.grey;
    }
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'N/A';
    if (timestamp is Timestamp) {
      return '${timestamp.toDate()}';
    }
    return 'Invalid date';
  }
}