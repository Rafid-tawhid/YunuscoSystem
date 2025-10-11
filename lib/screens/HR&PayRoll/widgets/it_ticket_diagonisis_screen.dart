import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:yunusco_group/common_widgets/multiple_images_preview_widgets.dart';

import '../../../common_widgets/multiple_image_picker.dart';
import '../../../helper_class/dashboard_helpers.dart';

class TicketDetailsScreen extends StatefulWidget {
  final String ticketId;
  final Map<String, dynamic> ticketData;

  const TicketDetailsScreen({
    Key? key,
    required this.ticketId,
    required this.ticketData,
  }) : super(key: key);

  @override
  _TicketDetailsScreenState createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();
  List<File> _diagnosisImages = [];
  String _selectedStatus = 'pending';
  String _selectedPriority = 'medium';

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.ticketData['status'] ?? 'pending';
    _selectedPriority = widget.ticketData['priority'] ?? 'medium';
  }

  void _updateTicket() async {
    try {
      await _firestore.collection('tickets').doc(widget.ticketId).update({
        'status': _selectedStatus,
        'priority': _selectedPriority,
        'diagnosis': _diagnosisController.text,
        'stepsTaken': _stepsController.text,
        'technicianComments': _commentsController.text,
        'diagnosisImages': _diagnosisImages.map((file) => file.path).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
        'technicianId': DashboardHelpers.currentUser!.userId,
        'technicianName': DashboardHelpers.currentUser!.userName,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ticket updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating ticket: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Ticket Details - ${widget.ticketData['token']}',
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: myColors.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _updateTicket,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Gallery Section
            _buildImageGallery(),

            SizedBox(height: 24),

            // Ticket Information
            _buildTicketInfo(),

            SizedBox(height: 24),

            // Diagnostic Section
            _buildDiagnosticSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery() {
    List<String> allImages = [
      'https://res.cloudinary.com/dbi5dzmhz/images/f_auto,q_auto/v1729382683/Safemode/hardware-3509898_1920-min/hardware-3509898_1920-min.jpg?_i=AA',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQyvl5Iks--rDz8uG2oKPs1FiB8KvloRnznFA&s',
      'https://techadvice.ie/wp-content/uploads/2021/04/service-428540_640.jpg',
      'https://res.cloudinary.com/dbi5dzmhz/images/f_auto,q_auto/v1729382683/Safemode/hardware-3509898_1920-min/hardware-3509898_1920-min.jpg?_i=AA',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQyvl5Iks--rDz8uG2oKPs1FiB8KvloRnznFA&s',
      'https://techadvice.ie/wp-content/uploads/2021/04/service-428540_640.jpg',
    ];

    // Add state variable to track selected image index
    int _selectedImageIndex = 0;

    if (allImages.isEmpty) {
      return Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library, size: 50, color: Colors.grey[400]),
            SizedBox(height: 8),
            Text('No images available', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      );
    }

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Large Image
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[100],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  allImages[_selectedImageIndex],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error, size: 50, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Failed to load image', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: 12),

            // Image counter
            Text(
              'Image ${_selectedImageIndex + 1} of ${allImages.length}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: 8),

            // Thumbnail List
            if (allImages.length > 1)
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: allImages.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImageIndex = index;
                        });
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _selectedImageIndex == index
                                ? myColors.primaryColor
                                : Colors.grey[300]!,
                            width: _selectedImageIndex == index ? 3 : 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Stack(
                            children: [
                              Image.network(
                                allImages[index],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[200],
                                    child: Icon(Icons.broken_image, color: Colors.grey),
                                  );
                                },
                              ),
                              if (_selectedImageIndex == index)
                                Container(
                                  decoration: BoxDecoration(
                                    color: myColors.primaryColor.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTicketInfo() {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ticket Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoItem('Token', widget.ticketData['token']),
                      _buildInfoItem('User ID', widget.ticketData['uId']),
                      _buildInfoItem('Name', widget.ticketData['name']),
                      _buildInfoItem('Email', widget.ticketData['email']),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoItem('Department', widget.ticketData['department']),
                      _buildInfoItem('Subject', widget.ticketData['subject']),
                      _buildInfoItem('Types', widget.ticketData['types']),
                      _buildInfoItem('Created', _formatTimestamp(widget.ticketData['createdAt'])),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Status and Priority Selection
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    decoration: InputDecoration(labelText: 'Status'),
                    items: ['pending', 'in progress', 'resolved']
                        .map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status.toUpperCase()),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value!;
                      });
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedPriority,
                    decoration: InputDecoration(labelText: 'Priority'),
                    items: ['Low', 'Medium', 'High']
                        .map((priority) => DropdownMenuItem(
                      value: priority,
                      child: Text(priority.toUpperCase()),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPriority = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosticSection() {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Diagnostic Report',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Diagnosis
            TextFormField(
              controller: _diagnosisController,
              decoration: InputDecoration(
                labelText: 'Problem Diagnosis',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              maxLength: 500,
            ),

            SizedBox(height: 16),

            // Steps Taken
            TextFormField(
              controller: _stepsController,
              decoration: InputDecoration(
                labelText: 'Steps Taken',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              maxLength: 500,
            ),

            SizedBox(height: 16),

            // Comments
            TextFormField(
              controller: _commentsController,
              decoration: InputDecoration(
                labelText: 'Technician Comments',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              maxLength: 300,
            ),

            SizedBox(height: 16),

            // Image Attachments
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Diagnostic Images',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text(
                  'Add images related to diagnosis and repair',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                SizedBox(height: 12),
                ImagePickerWidget(
                  onImagesChanged: (images) {
                    setState(() {
                      _diagnosisImages = images;
                    });
                  },
                ),
                SizedBox(height: 8),
                if (_diagnosisImages.isNotEmpty)
                  Text(
                    '${_diagnosisImages.length} image(s) selected',
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
              ],
            ),

            SizedBox(height: 24),

            // Update Button
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateTicket,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: myColors.primaryColor,
                ),
                child: Text(
                  'UPDATE TICKET',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, dynamic value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.blueGrey),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? 'N/A',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'N/A';
    if (timestamp is Timestamp) {
      return '${timestamp.toDate()}';
    }
    return 'Invalid date';
  }
}