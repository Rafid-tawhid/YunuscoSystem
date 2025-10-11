import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/utils/colors.dart';

import 'it_ticket_diagonisis_screen.dart';


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
      appBar: AppBar(
        title: Text(
          'All Tickets',
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: myColors.primaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: DashboardHelpers.currentUser!.department == '17'
            ? _firestore.collection('tickets').snapshots()
            : _firestore.collection('tickets').where('uId', isEqualTo: DashboardHelpers.currentUser!.userId).snapshots(),
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
              String ticketId = ticket.id; // Get the document ID

              return GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketDetailsScreen(
                        ticketId: ticketId,
                        ticketData: data,
                      ),
                    ),
                  );
                },
                child: Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header section with token and status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Token: ${data['token']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blueGrey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Chip(
                              label: Text(
                                (data['status'] ?? 'pending').toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: _getStatusColor(data['status']),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Main content in two columns for better space utilization
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left column - User details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInfoRow('User ID', data['uId'] ?? 'N/A'),
                                  const SizedBox(height: 6),
                                  _buildInfoRow('Name', data['name'] ?? 'N/A'),
                                  const SizedBox(height: 6),
                                  _buildInfoRow('Email', data['email'] ?? 'N/A'),
                                  const SizedBox(height: 6),
                                  _buildInfoRow('Mobile', data['mobile'] ?? 'N/A'),
                                ],
                              ),
                            ),

                            const SizedBox(width: 16),

                            // Right column - Ticket details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInfoRow('Department', data['department'] ?? 'N/A'),
                                  const SizedBox(height: 6),
                                  _buildInfoRow('Subject', data['subject'] ?? 'N/A'),
                                  const SizedBox(height: 6),
                                  _buildInfoRow('Types', data['types'] ?? 'N/A'),
                                  const SizedBox(height: 6),
                                  _buildPriorityRow(data['priority'] ?? 'N/A'),
                                  // const SizedBox(height: 6),
                                  // ImagePreviewWidget(
                                  //   imageUrls: [
                                  //     'https://res.cloudinary.com/dbi5dzmhz/images/f_auto,q_auto/v1729382683/Safemode/hardware-3509898_1920-min/hardware-3509898_1920-min.jpg?_i=AA',
                                  //     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQyvl5Iks--rDz8uG2oKPs1FiB8KvloRnznFA&s',
                                  //     'https://techadvice.ie/wp-content/uploads/2021/04/service-428540_640.jpg',
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Message section
                        if (data['message'] != null && data['message'].toString().isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Message:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: Text(
                                  data['message']!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 12),

                        // Footer with creation date
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                              border: Border(
                            top: BorderSide(color: Colors.grey[300]!, width: 1),
                          )),
                          child: Text(
                            'Created: ${_formatTimestamp(data['createdAt'])}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Helper widget for consistent info rows
  Widget _buildInfoRow(dynamic label, dynamic value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            '$value',
            style: const TextStyle(
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

// Helper widget for priority with color coding
  Widget _buildPriorityRow(String priority) {
    Color priorityColor = Colors.grey;

    switch (priority.toLowerCase()) {
      case 'high':
        priorityColor = Colors.red;
        break;
      case 'medium':
        priorityColor = Colors.orange;
        break;
      case 'low':
        priorityColor = Colors.green;
        break;
    }

    return Row(
      children: [
        const Text(
          'Priority: ',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey,
            fontSize: 14,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: priorityColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: priorityColor.withOpacity(0.3)),
          ),
          child: Text(
            priority.toUpperCase(),
            style: TextStyle(
              color: priorityColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      case 'in progress':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
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
