import 'package:flutter/material.dart';

import '../../../models/employee_appointment_info_model.dart';

class EmployeeProfileScreen extends StatelessWidget {
  final EmployeeAppointmentInfoModel employee;

  const EmployeeProfileScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(employee.fullName ?? 'Employee Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildSectionTitle('Personal Information'),
            _buildInfoCard([
              _buildInfoRow('ID Card Number', employee.idCardNo),
              _buildInfoRow('Gender', employee.gender),
              _buildInfoRow('Date of Birth', _formatDate(employee.dateOfBirth)),
              _buildInfoRow('Age', employee.ageYears?.toString()),
            ]),

            const SizedBox(height: 16),
            _buildSectionTitle('Employment Details'),
            _buildInfoCard([
              _buildInfoRow('Joining Date', _formatDate(employee.joiningDate)),
              _buildInfoRow('Department', employee.departmentName),
              _buildInfoRow('Designation', employee.designationName),
              _buildInfoRow('Section', employee.sectionName),
            ]),

            const SizedBox(height: 16),
            _buildSectionTitle('Production Unit'),
            _buildInfoCard([
              _buildInfoRow('Production Line', employee.productionLineName),
              _buildInfoRow('Production Unit', employee.productionUnitName),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue.shade100,
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            employee.fullName ?? 'No Name',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (employee.designationName != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                employee.designationName!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}