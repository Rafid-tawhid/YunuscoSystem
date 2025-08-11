import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import 'package:yunusco_group/screens/HR&PayRoll/widgets/doctor_appointment_list_screen.dart';
import '../../common_widgets/custom_button.dart';
import '../../utils/colors.dart';

class DocAppoinmentReq extends StatefulWidget {
  const DocAppoinmentReq({super.key});

  @override
  _DocAppoinmentReqState createState() => _DocAppoinmentReqState();
}

class _DocAppoinmentReqState extends State<DocAppoinmentReq> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _idCardController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  int? _urgencyType;
  final Map<String, int> _urgencyOptions = {
    'High': 1,
    'Medium': 2,
    'Low': 3,
  };

  @override
  void dispose() {
    _idCardController.dispose();
    _remarksController.dispose();
    super.dispose();
  }


  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_urgencyType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select urgency type')),
        );
        return;
      }

      final requestData = {
        "idCardNo": _idCardController.text,
        "remarks": _remarksController.text,
        "urgencyType": _urgencyType,
        "requestDate": DashboardHelpers.convertDateTime2(DateTime.now()),
        "status": 1,
      };

      var hp=context.read<HrProvider>();
      if(await hp.saveDocAppoinment(requestData)){
        //clear field
        _idCardController.clear();
        _remarksController.clear();
        if(mounted)DashboardHelpers.showSnakBar(context: context, message: 'Doctor Appointment Success!',bgColor: myColors.green);
        if(mounted)Navigator.pop(context);
      }
    }
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Doc-Appointment'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(onPressed: () async{

            //get all appointment list
              var hp=context.read<HrProvider>();
              await hp.getAllDocAppointment();
              Navigator.push(context,MaterialPageRoute(builder: (context)=>AppointmentListScreen(appointments: hp.docAppointmentList)));

          }, icon: Icon(Icons.accessibility_new))
        ],
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ID Card Number Field

              TextFormField(
                controller: _idCardController,
                decoration: const InputDecoration(
                  labelText: "ID Card No",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value == null || value.isEmpty ? 'ID is required' : null,
              ),
              const SizedBox(height: 16),

              // Remarks Field
              TextFormField(
                controller: _remarksController,
                decoration: const InputDecoration(
                  labelText: "Remarks",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (value) =>
                value == null || value.isEmpty ? 'Remarks required' : null,
              ),
              const SizedBox(height: 16),

              // Urgency Dropdown
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Urgency Type',
                  border: OutlineInputBorder(),
                ),
                items: _urgencyOptions.entries
                    .map(
                      (entry) => DropdownMenuItem<int>(
                    value: entry.value,
                    child: Text(entry.key),
                  ),
                )
                    .toList(),
                value: _urgencyType,
                onChanged: (value) => setState(() => _urgencyType = value),
                validator: (_) =>
                _urgencyType == null ? 'Urgency type is required' : null,
              ),
              const SizedBox(height: 24),

              // Submit Button
              Consumer<HrProvider>(
                builder: (context,pro,_)=>CustomElevatedButton(
                  isLoading: pro.isLoading,
                  text: 'Submit Request',
                  onPressed: _submitForm,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

