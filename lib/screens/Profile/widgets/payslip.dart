import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:yunusco_group/providers/hr_provider.dart';
import 'package:yunusco_group/utils/colors.dart';
import 'package:yunusco_group/utils/constants.dart';

import '../../../helper_class/dashboard_helpers.dart';
import '../../../models/payslip_model.dart';
import 'generate_pdf.dart';

class PayslipDetailScreen extends StatelessWidget {
  PayslipModel payslip;
  PayslipDetailScreen({required this.payslip});

  @override
  Widget build(BuildContext context) {

    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Payslip Details'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _sharePayslip(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            _buildHeaderSection(payslip, currencyFormat),

            // Earnings Section
            _buildSection(
              title: 'Earnings',
              icon: Icons.attach_money,
              children: [
                _buildItemRow('Basic Salary', payslip.basicSalary, currencyFormat),
                _buildItemRow('House Rent', payslip.houseRent, currencyFormat),
                _buildItemRow('Conveyance', payslip.conveyance, currencyFormat),
                _buildItemRow('Medical', payslip.medical, currencyFormat),
                _buildItemRow('Attendance Bonus', payslip.attendanceBonus, currencyFormat),
                _buildItemRow('Food Allowance', payslip.foodAllowence, currencyFormat),
                _buildItemRow('OT Amount', payslip.oTAmount, currencyFormat),
                _buildItemRow('Holiday Allowance', payslip.holidayAllowance, currencyFormat),
                _buildItemRow('Other Allowance', payslip.otherAllowence, currencyFormat),
                _buildItemRow('Other Allowance 2', payslip.otherAllowence2, currencyFormat),
                _buildDivider(),
                _buildItemRow('Gross Salary', payslip.grossSalary, currencyFormat, isTotal: true),
              ],
            ),

            // Deductions Section
            _buildSection(
              title: 'Deductions',
              icon: Icons.money_off,
              children: [
                _buildItemRow('Provident Fund', payslip.providentFund, currencyFormat),
                _buildItemRow('Loan', payslip.loan, currencyFormat),
                _buildItemRow('Advance', payslip.advance, currencyFormat),
                _buildItemRow('Stamp Fee', payslip.stampFees, currencyFormat),
                _buildItemRow('Absent Fee', payslip.absentFee, currencyFormat),
                _buildItemRow('Late Fee', payslip.lateFee, currencyFormat),
                _buildItemRow('AIT', payslip.ait, currencyFormat),
                _buildItemRow('TDS', payslip.tds, currencyFormat),
                if(payslip.otherDeduction!>0)_buildItemRow('Other Deduction', payslip.otherDeduction, currencyFormat),
                if(payslip.otherDeduction1!>0)_buildItemRow('Other Deduction1', payslip.otherDeduction1, currencyFormat),
                _buildDivider(),
                _buildItemRow('Total Deductions', payslip.netDeduction, currencyFormat, isTotal: true),
              ],
            ),

            // Net Pay Section
            _buildNetPaySection(payslip, currencyFormat),

            // Attendance Summary
            _buildSection(
              title: 'Attendance Summary',
              icon: Icons.calendar_today,
              children: [
                _buildAttendanceRow('Total Working Days', payslip.totalWorkingDays),
                _buildAttendanceRow('Present Days', payslip.presentDays),
                _buildAttendanceRow('Absent Days', payslip.absentDays),
                _buildAttendanceRow('Late Days', payslip.lateDays),
                _buildAttendanceRow('Casual Leave', payslip.casualLeave),
                _buildAttendanceRow('Sick Leave', payslip.sickLeave),
                _buildAttendanceRow('Earn Leave', payslip.earnLeave),
                _buildAttendanceRow('Maternity Leave', payslip.maternityLeave),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => createAndSavePdf(payslip,context),
        icon: const Icon(Icons.download,color: Colors.white,),
        label: Text('Download PDF',style: customTextStyle(16, Colors.white, FontWeight.w500),),
        backgroundColor: myColors.primaryColor,
      ),
    );
  }

  Widget _buildHeaderSection(PayslipModel payslip, NumberFormat currencyFormat) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: myColors.primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Text(
              payslip.fullName?.substring(0, 1) ?? '?',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            payslip.fullName ?? 'No Name',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            payslip.designationName ?? 'No Designation',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildHeaderItem('ID', payslip.idCardNo ?? 'N/A'),
              _buildHeaderItem('Department', payslip.departmentName ?? 'N/A'),
              _buildHeaderItem('Grade', payslip.grade ?? 'N/A'),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildHeaderItem('Joining', DashboardHelpers.convertDateTime(payslip.joiningDate.toString(),pattern: 'd MMM yyyy')),
              _buildHeaderItem('Payable', currencyFormat.format(payslip.netPeyable)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderItem(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(10),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildItemRow(String label, num? value, NumberFormat currencyFormat, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.blue : Colors.black87,
            ),
          ),
          Text(
            value != null ? currencyFormat.format(value) : 'N/A',
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.blue : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceRow(String label, num? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Text(
            value?.toString() ?? 'N/A',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 20,
      thickness: 1,
      color: Colors.grey,
    );
  }

  Widget _buildNetPaySection(PayslipModel payslip, NumberFormat currencyFormat) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: payslip.netPeyable != null && payslip.netPeyable! >= 0
            ? Colors.green[50]
            : Colors.red[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: payslip.netPeyable != null && payslip.netPeyable! >= 0
              ? Colors.green
              : Colors.red,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Text(
              'NET PAYABLE AMOUNT',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              payslip.netPeyable != null ? currencyFormat.format(payslip.netPeyable) : 'N/A',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: payslip.netPeyable != null && payslip.netPeyable! >= 0
                    ? Colors.green
                    : Colors.red,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '${payslip.salaryMonthName} ${payslip.salaryYearName}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPaymentMethod('Bank', payslip.bankPay, currencyFormat),
                _buildPaymentMethod('Cash', payslip.cashPay, currencyFormat),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(String method, num? amount, NumberFormat currencyFormat) {
    return Column(
      children: [
        Text(
          method,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        Text(
          amount != null ? currencyFormat.format(amount) : 'N/A',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  void _sharePayslip(BuildContext context) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing payslip...')),
    );
  }

  Future<void> createAndSavePdf(PayslipModel payslip,BuildContext context) async {
    final pdfFile = await PayslipPDFGenerator.generatePayslipPDF(payslip);

    // Save to gallery
    var saved=  await PayslipPDFGenerator.savePDFToGallery(pdfFile);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(saved
            ? 'Payslip saved to Downloads folder'
            : 'Failed to save payslip'),
      ),
    );



    // Optional: Open the PDF for viewing
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfFile.readAsBytes(),
    );
  }



}



