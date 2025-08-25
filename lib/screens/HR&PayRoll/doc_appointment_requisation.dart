import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import 'package:yunusco_group/screens/HR&PayRoll/widgets/doc_bottom_sheet.dart';
import 'package:yunusco_group/screens/HR&PayRoll/widgets/doctor_appointment_list_screen.dart';
import '../../common_widgets/custom_button.dart';
import '../../models/doc_appoinment_list_model.dart';
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
    'Regular': 1,
    'Emergency': 2,
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

      var hp = context.read<HrProvider>();
      if (await hp.saveDocAppoinment(requestData)) {
        //clear field
        _idCardController.clear();
        _remarksController.clear();
        if (mounted) DashboardHelpers.showSnakBar(context: context, message: 'Doctor Appointment Success!', bgColor: myColors.green);
        if (mounted) Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Dr. Appointment'),
        centerTitle: true,
        elevation: 0,
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 8,
              ),
             if(DashboardHelpers.currentUser!.iDnum!='37068') Consumer<HrProvider>(
                  builder: (context, pro, _) => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.zero, // Set minimum size to zero
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: Colors.green.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6), // ← Adjust this value
                        ),
                      ),
                      onPressed: () {
                        pro.showHideDocForm();
                      },
                      child: Text(
                        pro.showForm ? 'Requisition List' : 'Create +',
                        style: TextStyle(color: Colors.white),
                      ))),
              SizedBox(
                height: 8,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Consumer<HrProvider>(
                        builder: (context, pro, _) => pro.showForm ? DocReqForm() : SizedBox.shrink(),
                      ),
                      // ID Card Number Field
                      Consumer<HrProvider>(
                        builder: (context, pro, _) {
                          return pro.showForm
                              ? SizedBox.shrink()
                              : ListView.builder(
                                  padding: const EdgeInsets.all(8),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: pro.docAppointmentList.length,
                                  itemBuilder: (context, index) {
                                    final appointment = pro.docAppointmentList[index];
                                    return Stack(
                                      children: [
                                        Card(
                                          color: Colors.white,
                                          child: ListTile(
                                            title: Text(
                                              'Serial: ${appointment.serialNo ?? 'N/A'}',
                                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('ID: ${appointment.idCardNo ?? 'N/A'}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                                                Text('Date: ${DashboardHelpers.convertDateTime(appointment.createdDate ?? '')}'),
                                                if (appointment.remarks?.isNotEmpty ?? false) Text('Remarks: ${appointment.remarks}'),
                                              ],
                                            ),
                                            onTap: () async{

                                             if(appointment.status==2){
                                               var hp=context.read<HrProvider>();
                                               var data=await hp.gatePassDetailsInfo(appointment);
                                               if(data!=null){
                                                 showAppointmentBottomSheet(
                                                   context: context,
                                                   appointment: appointment, // Your DocAppoinmentListModel instance
                                                   medicineName: data['FullName']??"No Name",
                                                   doctorAdvice: data['Advice']??"None",
                                                   medicineTime: data["PrescriptionDate"],
                                                   leaveNotes: data['Remarks']??"None",
                                                 );
                                               }
                                             }
                                            },
                                          ),
                                        ),
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: _buildUrgencyChip(appointment.urgencyType!.toInt(), appointment.gatePassStatus),
                                        )
                                      ],
                                    );
                                  },
                                );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget DocReqForm() {
    return Column(
      children: [
        TextFormField(
          controller: _idCardController,
          decoration: const InputDecoration(
            labelText: "ID Card No",
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) => value == null || value.isEmpty ? 'ID is required' : null,
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
          validator: (value) => value == null || value.isEmpty ? 'Remarks required' : null,
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
          validator: (_) => _urgencyType == null ? 'Urgency type is required' : null,
        ),
        const SizedBox(height: 24),

        // Submit Button
        Consumer<HrProvider>(
          builder: (context, pro, _) => CustomElevatedButton(
            isLoading: pro.isLoading,
            text: 'Submit',
            onPressed: _submitForm,
          ),
        ),
      ],
    );
  }

  Widget _buildUrgencyChip(int? urgency,bool? gatePass) {
    if (urgency == null) return const SizedBox();

    return Container(
      decoration: BoxDecoration(
        color:gatePass==true?Colors.green: urgency == 1 ?Colors.orangeAccent
            : Colors.red,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 2),
        child: Text(gatePass==true?'Approved':
        urgency==1?'Regular':'Emergency',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
      ),
    );
  }
}

class StatusInfo {
  final String text;
  final Color color;

  StatusInfo(this.text, this.color);
}

