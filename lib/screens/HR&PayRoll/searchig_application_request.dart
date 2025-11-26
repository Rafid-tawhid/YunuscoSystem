// screens/appointment_booking_screen.dart
import 'package:flutter/material.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/helper_class/firebase_helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentBookingScreen extends StatefulWidget {
  const AppointmentBookingScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentBookingScreen> createState() => _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _purposeController = TextEditingController();

  String? _selectedPerson;
  String? _selectedAppointmentType;

  List<Map<String, dynamic>> _activePersons = [];
  bool _isLoading = true;

  final List<String> _appointmentTypes = ['Regular', 'Emergency'];

  @override
  void initState() {
    super.initState();
    _loadActivePersons();
  }

  Future<void> _loadActivePersons() async {
    try {
      FirebaseFirestore.instance
          .collection('presence')
          .where('isActive', isEqualTo: true)
          .snapshots()
          .listen((snapshot) {
        if (mounted) {
          setState(() {
            _activePersons = snapshot.docs
                .map((doc) {
              final data = doc.data();
              return {
                'userId': doc.id,
                'name': data['name'] ?? 'Unknown User',
                'isActive': data['isActive'] ?? false,
                'lastUpdated': data['lastUpdated'],
              };
            })
                .toList();
            _isLoading = false;
          });
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Failed to load active persons: $e');
    }
  }

  bool _validateForm() {
    if (_selectedPerson == null) {
      _showError('Please select a person');
      return false;
    }
    if (_selectedAppointmentType == null) {
      _showError('Please select appointment type');
      return false;
    }
    if (_purposeController.text.trim().isEmpty) {
      _showError('Please enter appointment purpose');
      return false;
    }
    return true;
  }

  Future<void> _bookAppointment() async {
    if (!_validateForm()) return;

    try {
      // Find the selected person's name
      final selectedPerson = _activePersons.firstWhere(
            (person) => person['userId'] == _selectedPerson,
      );

      // Create appointment data
      final appointmentData = {
        'appointmentId': 'appt_${DateTime.now().millisecondsSinceEpoch}',
        'bookedByUserId': DashboardHelpers.currentUser!.iDnum,
        'bookedByUserName': DashboardHelpers.currentUser!.userName,
        'targetUserId': _selectedPerson,
        'targetUserName': selectedPerson['name'],
        'appointmentType': _selectedAppointmentType,
        'purpose': _purposeController.text.trim(),
        'appointmentDate': Timestamp.fromDate(DateTime.now()),
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Save to Firebase
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentData['appointmentId'])
          .set(appointmentData);

      // Show success message
      _showSuccess('Appointment booked successfully!');

      // Clear form
      _clearForm();

    } catch (e) {
      _showError('Failed to book appointment: $e');
    }
  }

  void _clearForm() {
    setState(() {
      _selectedPerson = null;
      _selectedAppointmentType = null;
      _purposeController.clear();
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Book Appointment'),
        backgroundColor: Colors.blue[700],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadActivePersons,
            tooltip: 'Refresh active persons',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Active Persons Count
            _buildActivePersonsHeader(),
            const SizedBox(height: 20),
            // Content that can scroll if needed
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Person Selection Dropdown
                    _buildPersonDropdown(),
                    const SizedBox(height: 20),
                    // Appointment Type Dropdown
                    _buildAppointmentTypeDropdown(),
                    const SizedBox(height: 20),
                    // Purpose TextField
                    _buildPurposeTextField(),
                    const SizedBox(height: 30),
                    // Book Appointment Button
                    _buildBookButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivePersonsHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.group,
            color: Colors.blue[700],
            size: 24,
          ),
          const SizedBox(width: 12),
          // FIXED: Using Flexible instead of Expanded
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Active Persons Available',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_activePersons.length} person${_activePersons.length != 1 ? 's' : ''} currently online',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue[600],
                  ),
                ),
                if (_activePersons.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    _activePersons.map((p) => p['name']).join(', '),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _activePersons.isNotEmpty ? Colors.green : Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_activePersons.length}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Person *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedPerson,
              isExpanded: true, // FIXED: Use isExpanded instead of Expanded widget
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              hint: const Text('Choose an active person'),
              items: _activePersons.map((person) {
                return DropdownMenuItem<String>(
                  value: person['userId'],
                  child: Container(
                    width: double.infinity, // FIXED: Added explicit width
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // FIXED: Removed Expanded, using Flexible with bounded constraints
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                person['name'],
                                style: const TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'ID: ${person['userId']}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPerson = value;
                });
              },
            ),
          ),
        ),
        if (_activePersons.isEmpty) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.orange[700], size: 20),
                const SizedBox(width: 8),
                // FIXED: Using Flexible instead of Expanded
                Flexible(
                  child: Text(
                    'No active persons available at the moment. Make sure other users have activated their network sharing.',
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAppointmentTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Appointment Type *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedAppointmentType,
              isExpanded: true, // FIXED: Use isExpanded instead of Expanded widget
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              hint: const Text('Select appointment type'),
              items: _appointmentTypes.map((type) {
                Color? color;
                IconData? icon;

                if (type == 'Emergency') {
                  color = Colors.red;
                  icon = Icons.warning_rounded;
                } else {
                  color = Colors.blue;
                  icon = Icons.calendar_today_rounded;
                }

                return DropdownMenuItem<String>(
                  value: type,
                  child: Container(
                    width: double.infinity, // FIXED: Added explicit width
                    child: Row(
                      children: [
                        Icon(icon, color: color, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          type,
                          style: TextStyle(
                            fontSize: 16,
                            color: color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedAppointmentType = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPurposeTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Purpose of Appointment *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _purposeController,
            maxLines: 4,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              hintText: 'Describe the purpose of your appointment...',
              hintStyle: TextStyle(color: Colors.grey),
            ),
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${_purposeController.text.length}/500',
          style: TextStyle(
            color: _purposeController.text.length > 500 ? Colors.red : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildBookButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _activePersons.isNotEmpty ? _bookAppointment : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _activePersons.isNotEmpty ? Colors.blue[700] : Colors.grey,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
        child: const Text(
          'Book Appointment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _purposeController.dispose();
    super.dispose();
  }
}