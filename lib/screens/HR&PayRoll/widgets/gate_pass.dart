import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:yunusco_group/helper_class/dashboard_helpers.dart';

class GatePassDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> gatePassData;

  const GatePassDetailsScreen({super.key, required this.gatePassData});

  @override
  Widget build(BuildContext context) {
    // Format dates

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Gate Pass Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header Card
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.medical_services, size: 50, color: Colors.red),
                    const SizedBox(height: 10),
                    const Text(
                      'MEDICAL GATE PASS',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      gatePassData['gatePassCode'] ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Employee Information
            _buildSectionCard(
              title: 'EMPLOYEE INFORMATION',
              children: [
                _buildDetailRow('Employee ID', gatePassData['employeeId']),
                _buildDetailRow('Approved By', gatePassData['approvedBy']),
                _buildDetailRow('Issued At', gatePassData['generatedAt'].toString()??''),
              ],
            ),

            // Pass Validity
            _buildSectionCard(
              title: 'PASS VALIDITY',
              children: [
                _buildDetailRow('Valid Until', DashboardHelpers.convertDateTime2(DateTime.now())),
                _buildDetailRow('Status', gatePassData['status']),
                _buildDetailRow('Used', gatePassData['used'] == true ? 'Yes' : 'No'),
              ],
            ),

            // Medical Information
            if (gatePassData['prescription'] != null ||
                gatePassData['medicine'] != null ||
                gatePassData['instructions'] != null)
              _buildSectionCard(
                title: 'MEDICAL DETAILS',
                children: [
                  if (gatePassData['prescription'] != null)
                    _buildDetailRow('Prescription', gatePassData['prescription'], isMultiLine: true),
                  if (gatePassData['medicine'] != null)
                    _buildDetailRow('Medicine', gatePassData['medicine'], isMultiLine: true),
                  if (gatePassData['instructions'] != null)
                    _buildDetailRow('Instructions', gatePassData['instructions'], isMultiLine: true),
                ],
              ),

            // Gate Pass Reason
            if (gatePassData['gatePassReason'] != null)
              _buildSectionCard(
                title: 'GATE PASS REASON',
                children: [
                  _buildDetailRow('Reason', gatePassData['gatePassReason'], isMultiLine: true),
                ],
              ),

            // QR Code Display
            const SizedBox(height: 20),
            buildQrCode(gatePassData),
            ElevatedButton(
              onPressed: () => generateAndSavePdf(gatePassData, context),
              child: Text('Save as PDF'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> generateAndSavePdf(Map<String, dynamic> data, BuildContext context) async {
    try {
      // Create a sanitized copy of the data
      final sanitizedData = Map<String, dynamic>.from(data);

      // Convert Firestore-specific objects
      sanitizedData.forEach((key, value) {
        if (value is FieldValue) {
          sanitizedData[key] = '[FieldValue]';
        } else if (value is Timestamp) {
          sanitizedData[key] = value.toDate().toIso8601String();
        } else if (value is DateTime) {
          sanitizedData[key] = value.toIso8601String();
        }
      });

      // Generate QR code image
      final qrImage = await QrPainter(
        data: jsonEncode(sanitizedData),
        version: QrVersions.auto,
        gapless: false,
      ).toImage(300);

      final qrBytes = await qrImage.toByteData(format: ImageByteFormat.png);
      final qrPngBytes = qrBytes!.buffer.asUint8List();

      // Create PDF document
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Text('Gate Pass',
                      style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                ),
                pw.SizedBox(height: 20),
                pw.Center(
                  child: pw.Image(
                    pw.MemoryImage(qrPngBytes),
                    width: 200,
                    height: 200,
                  ),
                ),
                pw.SizedBox(height: 30),
                pw.Text('Pass Details:',
                    style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                _buildPdfDetailRow('Employee ID:', data['employeeId']?.toString() ?? 'N/A'),
               // _buildPdfDetailRow('Employee Name:', data['employeeName']?.toString() ?? 'N/A'),
                _buildPdfDetailRow('Passcode:', data['gatePassCode']?.toString() ?? 'N/A'),
                _buildPdfDetailRow('Valid Until:', DashboardHelpers.convertDateTime2(DateTime.now()),),
                pw.SizedBox(height: 20),
                pw.Text('Issued by: ${data['approvedBy'] ?? 'System'}'),
                pw.Text('Issued on: ${DateFormat('MMM dd, yyyy').format(DateTime.now())}'),
              ],
            );
          },
        ),
      );

      // Save PDF to device
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/gate_pass_${data['employeeId']}.pdf');
      await file.writeAsBytes(await pdf.save());

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved to ${file.path}')),
      );

      // Optionally open the PDF preview
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating PDF: $e')),
      );
    }
  }

  pw.Widget _buildPdfDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        children: [
          pw.Text(label,),
          pw.SizedBox(width: 10),
          pw.Text(value),
        ],
      ),
    );
  }


  Widget buildQrCode(Map<String, dynamic> data) {
    // Create a sanitized copy of the data
    final sanitizedData = Map<String, dynamic>.from(data);

    // Convert Firestore-specific objects
    sanitizedData.forEach((key, value) {
      if (value is FieldValue) {
        // Replace FieldValue with a string representation
        sanitizedData[key] = '[FieldValue]';
      } else if (value is Timestamp) {
        // Convert Timestamp to ISO string
        sanitizedData[key] = value.toDate().toIso8601String();
      } else if (value is DateTime) {
        // Convert DateTime to ISO string
        sanitizedData[key] = value.toIso8601String();
      }
      // Add other type conversions if needed
    });

    // Convert to JSON string
    final jsonData = jsonEncode(sanitizedData);

    return Column(
      children: [
        QrImageView(
          data: jsonData,
          version: QrVersions.auto,
          size: 200.0,
          gapless: false,
          embeddedImage: AssetImage('assets/logo.png'),
          embeddedImageStyle: QrEmbeddedImageStyle(size: Size(40, 40)),
        ),
        SizedBox(height: 20),
        Text('Scan this code for verification',
            style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value, {bool isMultiLine = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(
                fontSize: 15,
              ),
              maxLines: isMultiLine ? null : 1,
              overflow: isMultiLine ? null : TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}