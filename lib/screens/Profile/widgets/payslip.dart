import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common_widgets/custom_button.dart';
import '../../../models/payslip_model.dart';

class PayslipScreen extends StatelessWidget {
  final PayslipModel payslip;

  const PayslipScreen({Key? key, required this.payslip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '৳');
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Payslip - ${payslip.salaryMonth}/${payslip.salaryYear}'),
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () {
              // Implement print functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Company Header
            _buildHeaderSection(context),
            const SizedBox(height: 24),

            // Employee Information
            _buildEmployeeInfoSection(),
            const SizedBox(height: 24),

            // Salary Summary
            _buildSalarySummarySection(currencyFormat),
            const SizedBox(height: 24),

            // Attendance Summary
            if (payslip.presentDays != null || payslip.absentDays != null)
              _buildAttendanceSection(),

            // Footer
            const SizedBox(height: 32),
            _buildFooterSection(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomElevatedButton(
          text: 'Download Payslip',
          onPressed: () {
            // Implement download functionality
          },
          icon: Icon(Icons.download),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              payslip.company ?? 'Company Name',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (payslip.companyBang != null)
              Text(
                payslip.companyBang!,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            const SizedBox(height: 8),
            Text(
              'PAYSLIP',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'For the month of ${_getMonthName(payslip.salaryMonth)} ${payslip.salaryYear}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeInfoSection() {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(2),
          },
          children: [
            _buildTableRow('Employee ID', payslip.idCardNo ?? 'N/A', 'Name', payslip.fullName ?? 'N/A'),
            if (payslip.fullNameBang != null)
              _buildTableRow('', '', 'Name (Bangla)', payslip.fullNameBang ?? 'N/A'),
            _buildTableRow('Designation', payslip.designationName ?? 'N/A', 'Department', payslip.departmentName ?? 'N/A'),
            if (payslip.designationNameBang != null || payslip.departmentNameBang != null)
              _buildTableRow('', payslip.designationNameBang ?? '', '', payslip.departmentNameBang ?? ''),
            _buildTableRow('Grade', payslip.gradeName ?? 'N/A', 'Joining Date', payslip.joiningDate ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildSalarySummarySection(NumberFormat currencyFormat) {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Salary Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 16),
            _buildAmountRow('Gross Salary', payslip.grossSalary, currencyFormat),
            _buildAmountRow('Total Deductions', payslip.netDeduction, currencyFormat, isDeduction: true),
            const Divider(thickness: 1.5),
            _buildAmountRow('Net Payable', payslip.netPayable, currencyFormat, isTotal: true),
            if (payslip.otHour != null && payslip.oTRate != null)
              Column(
                children: [
                  const Divider(thickness: 1.5),
                  _buildAmountRow('Overtime Hours', payslip.otHour, null),
                  _buildAmountRow('Overtime Rate', payslip.oTRate, null),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceSection() {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Attendance Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 16),
            Table(
              children: [
                _buildAttendanceRow('Total Working Days', payslip.totalWorkingDays),
                _buildAttendanceRow('Present Days', payslip.presentDays),
                _buildAttendanceRow('Absent Days', payslip.absentDays),
                if (payslip.lateDays != null)
                  _buildAttendanceRow('Late Days', payslip.lateDays),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterSection() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Generated on: ${DateFormat('dd MMM yyyy').format(DateTime.now())}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            Text(
              'ID: ${payslip.id ?? 'N/A'}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'This is a computer generated payslip and does not require signature.',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  TableRow _buildTableRow(String label1, String? value1, String label2, String? value2) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(label1, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(value1 ?? 'N/A'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(label2, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(value2 ?? 'N/A'),
        ),
      ],
    );
  }

  Widget _buildAmountRow(String label, dynamic value, NumberFormat? format,
      {bool isDeduction = false, bool isTotal = false}) {
    final amount = value?.toString() ?? 'N/A';
    final formattedAmount = format != null && value != null
        ? format.format(value is String ? double.tryParse(value) ?? 0 : value)
        : amount;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            formattedAmount,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDeduction ? Colors.red : (isTotal ? Colors.green : Colors.black),
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildAttendanceRow(String label, String? value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Text(value ?? 'N/A', textAlign: TextAlign.end),
        ),
      ],
    );
  }

  String _getMonthName(String? monthNumber) {
    if (monthNumber == null) return 'N/A';
    final month = int.tryParse(monthNumber);
    if (month == null || month < 1 || month > 12) return 'N/A';
    return DateFormat('MMMM').format(DateTime(2023, month));
  }
}