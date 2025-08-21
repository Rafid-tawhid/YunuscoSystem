
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/hr_provider.dart';

import '../../../models/doc_appoinment_list_model.dart';
import 'doc_emp_prescription.dart';


class AppointmentListScreen extends StatelessWidget {
  // final List<DocAppoinmentListModel> appointments;
  //
  // const AppointmentListScreen({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Doctor Appointments'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending', icon: Icon(Icons.access_time)),
              Tab(text: 'Completed', icon: Icon(Icons.check_circle)),
            ],
          ),
          actions: [
            IconButton(onPressed: () async {
              var hp=context.read<HrProvider>();
              await hp.getAllDocAppointment();
            }, icon: Icon(Icons.refresh))
          ],
        ),
        body: Consumer<HrProvider>(
          builder: (context,pro,_)=>pro.docAppointmentList.isEmpty?Center(child: Text('No data Found'),):TabBarView(
            children: [
              _buildStatusList(pro.docAppointmentList.where((a) => a.status == 1).toList()),
              _buildStatusList(pro.docAppointmentList.where((a) => a.status == 2).toList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusList(List<DocAppoinmentListModel> appointments) {

    if (appointments.isEmpty) {
      return const Center(child: Text('No appointments found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          color: Colors.white,
          child: ListTile(
            leading: appointment.status==1?CircleAvatar(
              backgroundColor: _getStatusColor(appointment.status!.toInt()).withOpacity(0.2),
              child: Icon(
                _getStatusIcon(appointment.status!.toInt()),
                color: _getStatusColor(appointment.status!.toInt()),
              ),
            ):null,
            title: Text('Serial: ${appointment.serialNo ?? 'N/A'}',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${appointment.idCardNo ?? 'N/A'}',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500)),
                Text('Date: ${_formatDate(appointment.createdDate)}'),
                if (appointment.remarks?.isNotEmpty ?? false)
                  Text('Remarks: ${appointment.remarks}'),
              ],
            ),
            trailing: _buildUrgencyChip(appointment.urgencyType!.toInt()),
            onTap: () => _showDetails(context, appointment),
          ),
        );
      },
    );
  }

  // Helper methods
  Color _getStatusColor(int? status) {
    switch (status) {
      case 1: return Colors.orange; // Pending
      case 2: return Colors.blue;   // Working
      case 3: return Colors.green;  // Done
      default: return Colors.grey;
    }
  }

  IconData _getStatusIcon(int? status) {
    switch (status) {
      case 1: return Icons.access_time;
      case 2: return Icons.work;
      case 3: return Icons.check_circle;
      default: return Icons.help_outline;
    }
  }

  Widget _buildUrgencyChip(int? urgency) {
    if (urgency == null) return const SizedBox();

    return Chip(
      label: Text(urgency==1?'Regular':'Emergency',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
      backgroundColor: urgency == 1 ?Colors.green
          : Colors.red,
    );
  }

  String _formatDate(String? date) {
    if (date == null) return 'N/A';
    try {
      final parsed = DateTime.parse(date);
      return '${parsed.day}/${parsed.month}/${parsed.year} ${parsed.hour}:${parsed.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return date;
    }
  }

  Future<void> _showDetails(BuildContext context, DocAppoinmentListModel appointment) async {
    if(appointment.status==1)//pending
      {
      var hp=context.read<HrProvider>();
      if(await hp.getEmployeeInfo(appointment)){
        if(hp.employeeInfo!=null) Navigator.push(context, CupertinoPageRoute(builder: (context)=>DoctorPrescriptionScreen(employee: hp.employeeInfo!,listInfo: appointment,)));
      }
    }
  }

}
