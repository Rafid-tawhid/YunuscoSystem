import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/models/members_model.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import 'package:yunusco_group/screens/HR&PayRoll/requested_car_list.dart';
import 'package:yunusco_group/screens/HR&PayRoll/widgets/selected_peoples.dart';
import 'package:yunusco_group/screens/HR&PayRoll/widgets/vehicle_req_dropdown.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:yunusco_group/utils/constants.dart';

import '../../common_widgets/search_field.dart';
import 'members_screen.dart';

class VehicleRequisitionForm extends StatefulWidget {
  const VehicleRequisitionForm({super.key});

  @override
  State<VehicleRequisitionForm> createState() => _VehicleRequisitionFormState();
}

class _VehicleRequisitionFormState extends State<VehicleRequisitionForm> {
  final _formKey = GlobalKey<FormState>();
  final _distanceController = TextEditingController();
  final _durationController = TextEditingController();
  final _travelStartFromController = TextEditingController();
  final _destinationController = TextEditingController();
  MembersModel? _selectedThirdPerson;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int? _selectedVehicleType; // Will store 1 or 2

  // Vehicle type options
  final List<Map<String, dynamic>> _vehicleTypes = [
    {'name': 'Sedan Car', 'value': 1},
      {'name': 'Hiace', 'value': 2},
  ];
  String placeId1='';
  String placeId2='';
  String purpouse='';

  @override
  void dispose() {
    _distanceController.dispose();
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
      "IdCardNo": _selectedThirdPerson==null?DashboardHelpers.currentUser!.iDnum:_selectedThirdPerson!.idCardNo,
      "Distance": _distanceController.text,
      "CarryGoods": '',
      "Purpose": purpouse,
      "CreatedBy": DashboardHelpers.currentUser!.iDnum,
      "DestinationTo": _destinationController.text,
      "DestinationFrom": _travelStartFromController.text,
      "RequiredDate": DashboardHelpers.convertDateTime(_selectedDate.toString(), pattern: 'yyyy-MM-dd'),
      "RequiredTime": getTimeDate(_selectedTime),
      "Duration": _durationController.text,
      "EmployeeId": members.join(", "),
      "DepartmentName": _selectedThirdPerson==null?DashboardHelpers.currentUser!.department:_selectedThirdPerson!.departmentName,
      "VehicletypeId": _selectedVehicleType ?? 1,
      "Status": 1, //pending
      "CreatedDate": DashboardHelpers.convertDateTime(DateTime.now().toString(), pattern: 'yyyy-MM-dd'),
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
        padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              Row(
                children: [
                  _selectedThirdPerson!=null?Text('Requested for: ${_selectedThirdPerson!.fullName}'):
                  Text('Requested by: ${DashboardHelpers.currentUser!.userName}'),
                  Spacer(),
                  IconButton(onPressed: (){
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => PersonSelectionScreen(forSomeOnesVehicleReq: true,))).then((persons) {
                      if (persons != null) {
                        debugPrint('SELECT THIRD PERSON FOR VEHICLE $persons');
                         setState(() {
                           _selectedThirdPerson=persons;
                         });
                      }
                    });
                  }, icon: Icon(Icons.alternate_email))
                ],
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

              //change
              //
              LocationSearchField(
                apiKey: 'AIzaSyAwpFYRk4i1gCEXqDepia2LXtsNuuMHkEY',
                lable: 'Travel starts form*',
                initialValue: _travelStartFromController.text,
                onSuggestionSelected: (suggestion) async {
                  // Handle selected location
                  print('Selected: ${suggestion['description']}');
                  print('Place ID: ${suggestion['place_id']}');

                  setState(() {
                    _travelStartFromController.text=suggestion['description'];
                    placeId1=suggestion['place_id'];
                  });

                },
              ),
              const SizedBox(height: 20),

              // Destination Field
              LocationSearchField(
                apiKey: 'AIzaSyAwpFYRk4i1gCEXqDepia2LXtsNuuMHkEY',
                lable: 'Destination*',
                initialValue: _destinationController.text,
                onSuggestionSelected: (suggestion) async {
                  // Handle selected location
                  print('Selected: ${suggestion['description']}');
                  print('Place ID: ${suggestion['place_id']}');

                  setState(() {
                    _destinationController.text=suggestion['description'];
                    placeId2=suggestion['place_id'];
                  });

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
              VehiclePurposeDropdown(
                onPurposeSelected: (String value) {
                  purpouse=value;
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
              Consumer<HrProvider>(
                builder: (context,pro,_)=>ElevatedButton(
                  onPressed: pro.isLoading?null: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: myColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: pro.isLoading?CircularProgressIndicator():
                  Text(
                    'Submit Requisition',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              )
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


  Future<Map<String, dynamic>> getRoadDistanceRoutesAPI({
    required String originPlaceId,
    required String destinationPlaceId,
    required String apiKey,
  }) async {
    try {
      final url = Uri.parse(
        'https://routes.googleapis.com/directions/v2:computeRoutes',
      );

      final headers = {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': apiKey,
        'X-Goog-FieldMask': 'routes.distanceMeters,routes.duration,routes.polyline.encodedPolyline',
      };

      final body = json.encode({
        'origin': {
          'placeId': originPlaceId,
        },
        'destination': {
          'placeId': destinationPlaceId,
        },
        'travelMode': 'DRIVE',
        'routingPreference': 'TRAFFIC_AWARE',
        'computeAlternativeRoutes': false,
        'routeModifiers': {
          'avoidTolls': false,
          'avoidHighways': false,
          'avoidFerries': false,
        },
        'languageCode': 'en-US',
        'units': 'METRIC',
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('routes') && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final distanceMeters = route['distanceMeters'];
          final duration = route['duration'];

          // Convert duration from ISO 8601 format to seconds
          final durationSeconds = _parseDurationToSeconds(duration);

          return {
            'success': true,
            'distance_meters': distanceMeters,
            'duration_seconds': durationSeconds,
            'distance_text': _formatDistance(distanceMeters),
            'duration_text': _formatDuration(durationSeconds),
            'polyline': route['polyline']['encodedPolyline'],
          };
        } else {
          return {
            'success': false,
            'error': 'No routes found',
          };
        }
      } else {
        return {
          'success': false,
          'error': 'HTTP error: ${response.statusCode} - ${response.body}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Exception: $e',
      };
    }
  }

  int _parseDurationToSeconds(String duration) {
    // Parse ISO 8601 duration format (e.g., "3600s", "1h30m")
    if (duration.endsWith('s')) {
      return int.parse(duration.substring(0, duration.length - 1));
    }

    // Handle other formats if needed
    return 0;
  }

  String _formatDistance(int meters) {
    if (meters < 1000) {
      return '$meters m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) {
      return '$seconds seconds';
    } else if (seconds < 3600) {
      return '${(seconds / 60).round()} minutes';
    } else {
      final hours = seconds ~/ 3600;
      final minutes = (seconds % 3600) ~/ 60;
      return minutes > 0 ? '$hours h $minutes min' : '$hours hours';
    }
  }
}
