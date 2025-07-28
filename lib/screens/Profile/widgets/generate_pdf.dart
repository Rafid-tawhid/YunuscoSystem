import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import '../../../models/payslip_model.dart';

class PayslipPDFGenerator {
  static Future<File> generatePayslipPDF(PayslipModel payslip) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Center(
                child: pw.Text('PAYSLIP',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 20),

              // Employee Information
              pw.Text('Employee Information',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              _buildInfoRow('Name', payslip.fullName ?? ''),
              _buildInfoRow('ID Card No', payslip.idCardNo ?? ''),
              _buildInfoRow('Designation', payslip.designationName ?? ''),
              _buildInfoRow('Department', payslip.departmentName ?? ''),
              _buildInfoRow('Company', payslip.company ?? ''),
              _buildInfoRow('Joining Date', payslip.joiningDate ?? ''),
              pw.SizedBox(height: 20),

              // Salary Period
              pw.Text('Salary Period',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              _buildInfoRow('Month', payslip.salaryMonth ?? ''),
              _buildInfoRow('Year', payslip.salaryYear ?? ''),
              pw.SizedBox(height: 20),

              // Attendance Summary
              pw.Text('Attendance Summary',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              _buildInfoRow('Total Working Days', payslip.totalWorkingDays.toString() ?? ''),
              _buildInfoRow('Present Days', payslip.presentDays.toString()  ?? ''),
              _buildInfoRow('Absent Days', payslip.absentDays.toString() ?? ''),
              _buildInfoRow('Late Days', payslip.lateDays.toString()  ?? ''),
              pw.SizedBox(height: 20),

              // Salary Details
              pw.Text('Salary Details',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Divider(),
              _buildInfoRow('Gross Salary', '${payslip.grossSalary?.toStringAsFixed(2) ?? '0.00'}'),
              _buildInfoRow('Net Income', '${payslip.netPeyable?.toStringAsFixed(2) ?? '0.00'}'),
              _buildInfoRow('Deductions', '${payslip.netDeduction?.toStringAsFixed(2) ?? '0.00'}'),
              pw.SizedBox(height: 10),

              // Net Payable
              pw.Container(
                width: double.infinity,
                padding: pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  color: PdfColors.grey300,
                ),
                child: pw.Text('Net Payable: ${payslip.netPeyable?.toStringAsFixed(2) ?? '0.00'}',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );

    // Get directory for saving
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/Payslip_${payslip.idCardNo}_${payslip.salaryMonth}_${payslip.salaryYear}.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  static pw.Row _buildInfoRow(String label, String value) {
    return pw.Row(
      children: [
        pw.Text('$label: ',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text(value),
      ],
    );
  }

  static Future<bool> savePDFToGallery(File pdfFile) async {
    try {
      // Request storage permission
      if (await Permission.storage.request().isGranted) {
        // For Android, we'll save to downloads directory
        final directory = await getExternalStorageDirectory();
        final downloadsDirectory = Directory('${directory?.path}/Download');

        if (!await downloadsDirectory.exists()) {
          await downloadsDirectory.create(recursive: true);
        }

        final newPath = '${downloadsDirectory.path}/${pdfFile.path.split('/').last}';
        await pdfFile.copy(newPath);
        return true;
      }
      return false;
    } catch (e) {
      print('Error saving PDF: $e');
      return false;
    }
  }
}
