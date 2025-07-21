import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/screens/HR&PayRoll/widgets/requested_vehicle_list.dart';
import 'package:yunusco_group/screens/HR&PayRoll/widgets/selected_peoples.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../providers/hr_provider.dart';
import 'members_screen.dart';

class VehicleRequisitionForm extends StatefulWidget {
  const VehicleRequisitionForm({super.key});

  @override
  State<VehicleRequisitionForm> createState() => _VehicleRequisitionFormState();
}

class _VehicleRequisitionFormState extends State<VehicleRequisitionForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _designationController = TextEditingController();
  final _sectionController = TextEditingController();
  final _destinationController = TextEditingController();
  final _distanceController = TextEditingController();
  final _purposeController = TextEditingController();
  final String _startLocation = 'Yunusco Bd.Ltd(AEPZ)';

  String? _selectedVehicleType;
  final List<String> _vehicleTypes = ['Private', 'Hiace'];
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _designationController.dispose();
    _sectionController.dispose();
    _destinationController.dispose();
    _distanceController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Yunusco (BD) Limited'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RequisitionListScreen(),
              ),
            );

          }, icon: Icon(Icons.list_alt))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const Text(
                'Plot # 224-233, AEPZ, Shiddirganj, Narayanganj - 1431',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              const Text(
                'Vehicle Requisition Form',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Personal Information Section
              const Text(
                'Personal Information',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _designationController,
                decoration: const InputDecoration(
                  labelText: 'Designation',
                  prefixIcon: Icon(Icons.work),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your designation';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _sectionController,
                decoration: const InputDecoration(
                  labelText: 'Section',
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your section';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Travel Information Section
              const Text(
                'Travel Information',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: _destinationController,
                decoration: const InputDecoration(
                  labelText: 'Destination',
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter destination';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _distanceController,
                decoration: const InputDecoration(
                  labelText: 'Probable Distance (km)',
                  prefixIcon: Icon(Icons.directions_car),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter distance';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Travel Date',
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        child: Text(
                          _selectedDate == null ? 'Select date' : DateFormat('dd-MM-yyyy').format(_selectedDate!),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Time',
                          prefixIcon: Icon(Icons.access_time),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        child: Text(
                          _selectedTime == null ? 'Select time' : _selectedTime!.format(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _purposeController,
                decoration: const InputDecoration(
                  labelText: 'Purpose',
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter purpose';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Additional Information Section
              const Text(
                'Additional Information',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Travel starts from',
                  prefixIcon: Icon(Icons.place),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter start location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedVehicleType,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Type',
                  prefixIcon: Icon(Icons.directions_car),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: _vehicleTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedVehicleType = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select vehicle type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              InkWell(
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => PersonSelectionScreen())).then((persons) {
                    if (persons != null) {
                      debugPrint('person $persons');
                    }
                  });
                },
                child: Container(
                  decoration: const BoxDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.people),
                        SizedBox(
                          width: 12,
                        ),
                        Text('Traveler (Fellow traveler) if any'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SelectedPeopleWidget(),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Form is valid, proceed with submission

                    _submitForm();
                    // hp.saveVehicleRequisitation();
                    // showDialog(
                    //   context: context,
                    //   builder: (context) => AlertDialog(
                    //     title: const Text('Form Submitted'),
                    //     content: const Text('Your vehicle requisition has been submitted successfully.'),
                    //     actions: [
                    //       TextButton(
                    //         onPressed: () => Navigator.pop(context),
                    //         child: const Text('OK'),
                    //       ),
                    //     ],
                    //   ),
                    // );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: myColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Submit Requisition',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    List<String> selectedPersonsId=[];
    var hp = context.read<HrProvider>();
    final selectedMembers = hp.member_list.where((m) => m.isSelected).toList();
    if(selectedMembers.isNotEmpty){
      selectedMembers.forEach((e){
        selectedPersonsId.add(e.idCardNo??'');
      });
    }
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select date and time')));
      return;
    }

    try {
      // Combine date and time
      final travelDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      // Prepare data for Firestore
      final formData = {
        'name': _nameController.text,
        'designation': _designationController.text,
        'section': _sectionController.text,
        'destination': _destinationController.text,
        'distance': _distanceController.text,
        'purpose': _purposeController.text,
        'startLocation': _startLocation,
        'travelersId': selectedPersonsId,
        'vehicleType': _selectedVehicleType,
        'travelDateTime': travelDateTime,
        'submittedAt': FieldValue.serverTimestamp(),
        'status': 'pending', // You can add status tracking
      };

      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      // Save to Firestore
      await _firestore.collection('vehicle_requisitions').add(formData);

      // Show success message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Requisition submitted successfully!')));

      // Clear the form after submission
      _formKey.currentState!.reset();
      setState(() {
        _selectedDate = null;
        _selectedTime = null;
        _selectedVehicleType = null;
      });
    } catch (e) {
      if (!mounted) return;
      debugPrint('ERROR ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error submitting form: ${e.toString()}')));
    } finally {
      if (!mounted) return;
    }
  }
}
