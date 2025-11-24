import 'package:flutter/material.dart';
import 'package:yunusco_group/utils/colors.dart';

import '../../models/appointment_model.dart';
import 'appointment_create_screen.dart';


class AppointmentListScreen extends StatelessWidget {
  AppointmentListScreen({super.key});

  // Dummy data list
  final List<AppointmentModel> appointments = [
    AppointmentModel(
      appointmentId: 1,
      appointmentNumber: "APT-001",
      employeeName: "John Doe",
      employeeId: "EMP001",
      department: "Engineering",
      designation: "Software Engineer",
      appointmentWith: "HR Manager",
      preferredDate: "2024-01-15",
      preferredTime: "10:00 AM",
      purpose: "Performance Review",
      status: "Pending",
      managerScheduledDate: null,
      managerScheduledTime: null,
      createdDate: "2024-01-10",
      createdBy: "John Doe",
      updatedDate: null,
      updatedBy: null,
    ),
    AppointmentModel(
      appointmentId: 2,
      appointmentNumber: "APT-002",
      employeeName: "Jane Smith",
      employeeId: "EMP002",
      department: "Marketing",
      designation: "Marketing Manager",
      appointmentWith: "CEO",
      preferredDate: "2024-01-16",
      preferredTime: "02:30 PM",
      purpose: "Budget Discussion",
      status: "Approved",
      managerScheduledDate: "2024-01-16",
      managerScheduledTime: "03:00 PM",
      createdDate: "2024-01-11",
      createdBy: "Jane Smith",
      updatedDate: "2024-01-12",
      updatedBy: "Manager",
    ),
    AppointmentModel(
      appointmentId: 3,
      appointmentNumber: "APT-003",
      employeeName: "Mike Johnson",
      employeeId: "EMP003",
      department: "Sales",
      designation: "Sales Executive",
      appointmentWith: "Sales Director",
      preferredDate: "2024-01-17",
      preferredTime: "11:00 AM",
      purpose: "Sales Strategy",
      status: "Rejected",
      managerScheduledDate: null,
      managerScheduledTime: null,
      createdDate: "2024-01-12",
      createdBy: "Mike Johnson",
      updatedDate: "2024-01-13",
      updatedBy: "Sales Director",
    ),
    AppointmentModel(
      appointmentId: 4,
      appointmentNumber: "APT-004",
      employeeName: "Sarah Wilson",
      employeeId: "EMP004",
      department: "Finance",
      designation: "Financial Analyst",
      appointmentWith: "CFO",
      preferredDate: "2024-01-18",
      preferredTime: "09:00 AM",
      purpose: "Quarterly Report Review",
      status: "Pending",
      managerScheduledDate: null,
      managerScheduledTime: null,
      createdDate: "2024-01-13",
      createdBy: "Sarah Wilson",
      updatedDate: null,
      updatedBy: null,
    ),
    AppointmentModel(
      appointmentId: 5,
      appointmentNumber: "APT-005",
      employeeName: "David Brown",
      employeeId: "EMP005",
      department: "Operations",
      designation: "Operations Manager",
      appointmentWith: "COO",
      preferredDate: "2024-01-19",
      preferredTime: "04:00 PM",
      purpose: "Process Improvement",
      status: "Approved",
      managerScheduledDate: "2024-01-19",
      managerScheduledTime: "04:30 PM",
      createdDate: "2024-01-14",
      createdBy: "David Brown",
      updatedDate: "2024-01-15",
      updatedBy: "COO",
    ),
  ];

  // Helper method to get status color
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Appointments'),
        backgroundColor: myColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateAppointmentScreen()));
          }, icon: Icon(Icons.add,color: Colors.white,))
        ],
      ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return Card(
            color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 2,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    // Header with Appointment Number and Status
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        appointment.appointmentNumber ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: getStatusColor(appointment.status ?? '')
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: getStatusColor(appointment.status ?? ''),
                          ),
                        ),
                        child: Text(
                          appointment.status ?? 'N/A',
                          style: TextStyle(
                            color: getStatusColor(appointment.status ?? ''),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Employee Information
                  _buildInfoRow('Employee', appointment.employeeName ?? 'N/A'),
                  _buildInfoRow('ID', appointment.employeeId ?? 'N/A'),
                  _buildInfoRow('Department', appointment.department ?? 'N/A'),
                  _buildInfoRow('Designation', appointment.designation ?? 'N/A'),

                  const SizedBox(height: 8),

                  // Appointment Details
                  _buildInfoRow('Appointment With',
                      appointment.appointmentWith ?? 'N/A'),
                  _buildInfoRow('Purpose', appointment.purpose ?? 'N/A'),

                  const SizedBox(height: 8),

                  // Date and Time Information
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoRow('Preferred Date',
                            appointment.preferredDate ?? 'N/A'),
                      ),
                      Expanded(
                        child: _buildInfoRow('Preferred Time',
                            appointment.preferredTime ?? 'N/A'),
                      ),
                    ],
                  ),

                  // Manager Scheduled Date/Time (if available)
                  if (appointment.managerScheduledDate != null &&
              appointment.managerScheduledDate.toString().isNotEmpty)
          Row(
            children: [
              Expanded(
                child: _buildInfoRow('Scheduled Date',
                    appointment.managerScheduledDate.toString()),
              ),
              Expanded(
                child: _buildInfoRow('Scheduled Time',
                    appointment.managerScheduledTime?.toString() ?? 'N/A'),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Footer with creation info
          Container(
          padding: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade300),)
          ),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Text(
          'Created: ${appointment.createdDate ?? 'N/A'}',
          style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
          ),
          ),
          Text(
          'By: ${appointment.createdBy ?? 'N/A'}',
          style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
          ),
          ),
          ],
          ),
          ),
          ],
          ),
          ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}