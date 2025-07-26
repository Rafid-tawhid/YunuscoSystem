import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import 'package:yunusco_group/screens/HR&PayRoll/requested_car_list.dart';
import 'package:yunusco_group/screens/HR&PayRoll/widgets/selected_peoples.dart';
import 'package:yunusco_group/utils/colors.dart';

import 'members_screen.dart';

class VehicleRequisitionForm extends StatefulWidget {
  const VehicleRequisitionForm({super.key});

  @override
  State<VehicleRequisitionForm> createState() => _VehicleRequisitionFormState();
}

class _VehicleRequisitionFormState extends State<VehicleRequisitionForm> {
  final _formKey = GlobalKey<FormState>();
  final _distanceController = TextEditingController();
  final _carryGoodsController = TextEditingController();
  final _purposeController = TextEditingController();
  final _durationController = TextEditingController();
  final _travelStartFromController = TextEditingController();
  final _destinationController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int? _selectedVehicleType; // Will store 1 or 2

  // Vehicle type options
  final List<Map<String, dynamic>> _vehicleTypes = [
    {'name': 'Private', 'value': 1},
    {'name': 'Hiace', 'value': 2},
  ];

  @override
  void dispose() {
    _distanceController.dispose();
    _carryGoodsController.dispose();
    _purposeController.dispose();
    _durationController.dispose();
    _travelStartFromController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

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
    debugPrint('_selectedTime $_selectedTime');
  }

  Map<String, dynamic> _prepareFormData() {
    var hp = context.read<HrProvider>();

    final selectedMembers = hp.member_list.where((m) => m.isSelected).toList();
    List<String> members = [];
    for (var e in selectedMembers) {
      members.add(e.idCardNo ?? '');
    }
    return {
      "IdCardNo": DashboardHelpers.currentUser!.iDnum,
      "Distance": _distanceController.text,
      "CarryGoods": _carryGoodsController.text,
      "Purpose": _purposeController.text,
      "CreatedBy": DashboardHelpers.currentUser!.userId,
      "DestinationTo": _destinationController.text,
      "DestinationFrom": _travelStartFromController.text,
      "RequiredDate": DashboardHelpers.convertDateTime(_selectedDate.toString(), pattern: 'yyyy-MM-dd'),
      "RequiredTime": getTimeDate(_selectedTime),
      "Duration": _durationController.text,
      "EmployeeId": members.join(", "),
      "VehicletypeId": _selectedVehicleType ?? 1,
      "Status": 1, //pending
      "CreatedDate": DashboardHelpers.convertDateTime(DateTime.now().toString(), pattern: 'yyyy-MM-dd')
    };
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedVehicleType != null &&_selectedDate!=null&&_selectedTime!=null) {
      final formData = _prepareFormData();
      print('Form Data to Submit: $formData');
      var hp = context.read<HrProvider>();
      await hp.saveVehicleRequisation(formData);
      // Here you would typically send the data to your API
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('Requisition submitted!\nVehicle Type : ${_selectedVehicleType==1?'Private':'Hiace'}',style: TextStyle(color: Colors.white),),
          duration: const Duration(seconds: 5),
        ),
      );
      Navigator.pop(context);

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields, including vehicle type'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Car Requisition Form'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(onPressed: () async {
            var hp=context.read<HrProvider>();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VehicleRequestListScreen(),
              ),
            );
          }, icon: Icon(Icons.list))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 12,
              ),
              Align(alignment: Alignment.centerRight, child: Text('Requested by: ${DashboardHelpers.currentUser!.userName}')),
              SizedBox(
                height: 12,
              ),
              // Vehicle Type Dropdown
              DropdownButtonFormField<int>(
                value: _selectedVehicleType,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Type*',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.directions_car),
                ),
                items: _vehicleTypes.map((vehicle) {
                  return DropdownMenuItem<int>(
                    value: vehicle['value'],
                    child: Text(vehicle['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedVehicleType = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a vehicle type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Travel Start From Field
              TextFormField(
                controller: _travelStartFromController,
                decoration: const InputDecoration(
                  labelText: 'Travel Start From*',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter starting location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Destination Field
              TextFormField(
                controller: _destinationController,
                decoration: const InputDecoration(
                  labelText: 'Destination*',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter final destination';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Distance Field
              TextFormField(
                controller: _distanceController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Distance* (Km)',

                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.linear_scale),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter distance';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Carry Goods Field
              TextFormField(
                controller: _carryGoodsController,
                decoration: const InputDecoration(
                  labelText: 'Goods to Carry',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_shipping),
                ),
              ),
              const SizedBox(height: 20),

              // Purpose Field
              TextFormField(
                controller: _purposeController,
                decoration: const InputDecoration(
                  labelText: 'Purpose*',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter purpose';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Date and Time Row
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Required Date*',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          _selectedDate == null ? 'Select date' : DateFormat('dd-MM-yyyy').format(_selectedDate!),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Start Time*',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.access_time),
                        ),
                        child: Text(
                          _selectedTime == null ? 'Select time' : _selectedTime!.format(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Duration Field
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Duration* (Hour)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.timer),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter duration';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => PersonSelectionScreen())).then((persons) {
                    if (persons != null) {
                      debugPrint('person $persons');
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    children: [
                      Icon(Icons.person_add_alt_rounded),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Traveler (Fellow traveler) if any:')
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              SelectedPeopleWidget(),
              const SizedBox(height: 30),
              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: myColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Submit Requisition',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getTimeDate(TimeOfDay? selectedTime) {
    if (selectedTime == null) return '';

    final now = DateTime.now(); // Get current date
    final timeFormat = DateFormat('h:mm a'); // AM/PM format

    // Create DateTime using today's date + selected time
    final combinedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    return timeFormat.format(combinedDateTime);
  }
}
