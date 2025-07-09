import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import 'package:yunusco_group/screens/HR&PayRoll/widgets/selected_peoples.dart';

import '../../models/booking_model.dart';
import 'members_screen.dart';

class BoardRoomBookingScreen extends StatefulWidget {
  @override
  _BoardRoomBookingScreenState createState() => _BoardRoomBookingScreenState();
}

class _BoardRoomBookingScreenState extends State<BoardRoomBookingScreen> {
  DateTime _selectedDate = DateTime.now();
  List<TimeSlot> _timeSlots = [];
  List<TimeSlot> _selectedSlots = [];
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeTimeSlots();
  }

  void _initializeTimeSlots() {
    // Create time slots from 8am to 6pm in 30-minute increments
    _timeSlots = [];
    DateTime startTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      8,
      0,
    );
    DateTime endTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      18,
      0,
    );

    while (startTime.isBefore(endTime)) {
      DateTime slotEnd = startTime.add(Duration(minutes: 30));
      _timeSlots.add(TimeSlot(start: startTime, end: slotEnd, isBooked: false));
      startTime = slotEnd;
    }
    _loadExistingBookings();
  }

  Future<void> _loadExistingBookings() async {
    // Get existing bookings for the selected date
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    final bookings = await FirebaseFirestore.instance
        .collection('bookings')
        .where('startTime',
            isGreaterThanOrEqualTo: DateTime(
              _selectedDate.year,
              _selectedDate.month,
              _selectedDate.day,
              0,
              0,
            ))
        .where('startTime',
            isLessThan: DateTime(
              _selectedDate.year,
              _selectedDate.month,
              _selectedDate.day + 1,
              0,
              0,
            ))
        .get();

    // Mark booked slots
    for (var booking in bookings.docs) {
      final bookingData = booking.data();
      DateTime start = (bookingData['startTime'] as Timestamp).toDate();
      DateTime end = (bookingData['endTime'] as Timestamp).toDate();

      for (var slot in _timeSlots) {
        if ((slot.start.isAfter(start) || slot.start.isAtSameMomentAs(start)) && (slot.end.isBefore(end) || slot.end.isAtSameMomentAs(end))) {
          slot.isBooked = true;
        }
      }
    }

    EasyLoading.dismiss();
    setState(() {});
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectedSlots.clear();
        _initializeTimeSlots();
      });
    }
  }

  void _toggleSlotSelection(TimeSlot slot,HrProvider provider) async {
    if (slot.isBooked) {
      EasyLoading.show(maskType: EasyLoadingMaskType.black);
      final bookingDetails = await _getBookingDetails(slot);
      EasyLoading.dismiss();
      if (bookingDetails != null) {

        _showBookingDetailsDialog(context, bookingDetails,provider);
      }
      return;
    }

    setState(() {
      if (_selectedSlots.contains(slot)) {
        _selectedSlots.remove(slot);
      } else {
        // Only allow selecting consecutive slots
        if (_selectedSlots.isEmpty || slot.start == _selectedSlots.last.end || slot.end == _selectedSlots.first.start) {
          _selectedSlots.add(slot);
          _selectedSlots.sort((a, b) => a.start.compareTo(b.start));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please select consecutive time slots')),
          );
        }
      }
    });
  }

  void _showBookingDetailsDialog(BuildContext context, Map<String, dynamic> booking,HrProvider pro) {

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Container(
          padding: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[300]!,
                width: 1.0,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Booking Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ),
             // TextButton(onPressed: (){}, child: Icon(Icons.message_outlined)),
              IconButton(onPressed: (){

               var selectedMembers= pro.member_list.where((m) => m.isSelected).toList();
                var data=jsonEncode(BookingRef.fromMap(booking).toString());
                debugPrint('Meeting Details : ${data.toString()}');
                debugPrint('Selected Member : $selectedMembers');
              }, icon: Icon(Icons.message_outlined)),
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(Icons.title, 'Title', booking['title']),
              SizedBox(height: 12),
              _buildDetailRow(Icons.person, 'Booked by', booking['userName']),
              SizedBox(height: 12),
              _buildDetailRow(
                  Icons.access_time,
                  'Time',
                  '${DateFormat('h:mm a').format((booking['startTime'] as Timestamp).toDate())} - '
                      '${DateFormat('h:mm a').format((booking['endTime'] as Timestamp).toDate())}'
              ),
              if (booking['description'] != null && booking['description'].isNotEmpty)
                Column(
                  children: [
                    SizedBox(height: 12),
                    _buildDetailRow(Icons.description, 'Description', booking['description']),
                  ],
                ),
            ],
          ),
        ),
        actions: [
          if (booking['userId'] == DashboardHelpers.currentUser!.userId)
            TextButton(
              onPressed: () => _cancelBooking(booking['id']),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red[600],
                padding: EdgeInsets.symmetric(horizontal: 16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cancel, size: 18),
                  SizedBox(width: 4),
                  Text('Cancel Booking'),
                ],
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.green[700],
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check, size: 18),
                SizedBox(width: 4),
                Text('Close'),
              ],
            ),
          ),
        ],
      )
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Future<void> _cancelBooking(String bookingId) async {
    try {
      // First get the booking to verify ownership
      EasyLoading.show(maskType: EasyLoadingMaskType.black);
      final bookingDoc = await FirebaseFirestore.instance.collection('bookings').doc(bookingId).get();
      EasyLoading.dismiss();
      if (!bookingDoc.exists) {
        throw Exception('Booking not found');
      }

      final bookingData = bookingDoc.data()!;

      // Check if current user is the owner or an admin
      if (bookingData['userId'] != DashboardHelpers.currentUser!.userId) {
        throw Exception('You can only cancel your own bookings');
      }

      // Delete the booking
      await FirebaseFirestore.instance.collection('bookings').doc(bookingId).delete();

      // Refresh the slots
      _initializeTimeSlots();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking cancelled successfully')),
      );

      Navigator.pop(context); // Close the details dialog
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel booking: $e')),
      );
    }
  }

  Future<void> _saveBooking() async {
    if (_selectedSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one time slot')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    try {
      // final user = FirebaseAuth.instance.currentUser;
      // if (user == null) throw Exception('User not logged in');

      var hp=context.read<HrProvider>();
      final selectedMembers = hp.member_list.where((m) => m.isSelected).toList();

      final bookingRef = FirebaseFirestore.instance.collection('bookings').doc();
      final membersRef = FirebaseFirestore.instance.collection('members').doc();

      await bookingRef.set({
        'id': bookingRef.id,
        'userId': DashboardHelpers.currentUser!.userId,
        'userName': DashboardHelpers.currentUser!.userName,
        'title': _titleController.text,
        'description': _descriptionController.text,
        'startTime': _selectedSlots.first.start,
        'endTime': _selectedSlots.last.end,
        'createdAt': DateTime.now(),
      });



      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking successful!')),
      );

      Navigator.pop(context);
    } catch (e) {
      debugPrint('ERROR :$e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving booking: $e')),
      );
    }
  }

  Future<Map<String, dynamic>?> _getBookingDetails(TimeSlot slot) async {
    try {
      final query = await FirebaseFirestore.instance.collection('bookings').where('startTime', isLessThanOrEqualTo: slot.end).where('endTime', isGreaterThanOrEqualTo: slot.start).limit(1).get();

      if (query.docs.isNotEmpty) {
        return query.docs.first.data();
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching booking details: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Book Conference'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Selection
              Row(
                children: [
                  Text(
                    'Selected Date:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Text(
                    DateFormat('MMMM d, y').format(_selectedDate),
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                  Spacer(),
                  IconButton(onPressed: (){
                    Navigator.push(context, CupertinoPageRoute(builder: (context)=>PersonSelectionScreen())).then((persons){
                      if(persons!=null){
                        debugPrint('person $persons');
                      }
                    });
                  }, icon: Icon(Icons.person_add_alt_rounded))
                ],
              ),
              SelectedPeopleWidget(),
              // Time Slots Grid
              Text(
                'Available Time Slots (8am - 6pm):',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _timeSlots.map((slot) {
                  final isSelected = _selectedSlots.contains(slot);
                  return GestureDetector(
                    onTap: () {
                      var pro=Provider.of<HrProvider>(context,listen: false);
                      _toggleSlotSelection(slot,pro);
                    },
                    child: Tooltip(
                      message: slot.isBooked ? 'View booking details' : 'Select time slot',
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: slot.isBooked
                              ? Colors.grey[400]
                              : isSelected
                                  ? Colors.blue
                                  : Colors.blue[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: slot.isBooked
                                ? Colors.grey
                                : isSelected
                                    ? Colors.blue[800]!
                                    : Colors.blue[300]!,
                          ),
                        ),
                        child: Text(
                          DateFormat('h:mm a').format(slot.start),
                          style: TextStyle(
                            color: slot.isBooked || isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),

              // Selected Slots Summary
              if (_selectedSlots.isNotEmpty) ...[
                Text(
                  'Selected Time: ${DateFormat('h:mm a').format(_selectedSlots.first.start)} - ${DateFormat('h:mm a').format(_selectedSlots.last.end)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
              ],

              // Booking Details Form
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Meeting Title',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1.4),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                style: TextStyle(fontSize: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a meeting title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description (Optional)',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1.4),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                style: TextStyle(fontSize: 16),
                maxLines: 3,
              ),
              SizedBox(height: 24),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'Booked by ${DashboardHelpers.currentUser!.userName}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                    shadowColor: Colors.green.withOpacity(0.3),
                  ),
                  child: Text(
                    'Confirm Booking',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimeSlot {
  final DateTime start;
  final DateTime end;
  bool isBooked;

  TimeSlot({
    required this.start,
    required this.end,
    this.isBooked = false,
  });

  @override
  bool operator ==(Object other) => identical(this, other) || other is TimeSlot && runtimeType == other.runtimeType && start == other.start && end == other.end;

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}
