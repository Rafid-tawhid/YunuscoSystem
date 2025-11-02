import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class PdfService {
  static Future<File> generateComparativeStatementPDF(
      List<Map<String, dynamic>> selectedData, String code, double grandTotal) async {
    final pdf = pw.Document();

// Company Header Widget
    pw.Widget _buildCompanyHeader() {
      return pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Company Logo Placeholder
          pw.Container(
            width: 60,
            height: 60,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Center(
              child: pw.Text(
                "LOGO",
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey500,
                ),
              ),
            ),
          ),
          pw.SizedBox(width: 15),

          // Company Details
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "YUNUSCO BD LTD",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue900,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  "Adamji EPZ, Narayanganj",
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.Text(
                  "Dhaka, Bangladesh",
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  "Phone: +880 XXXX-XXXXXX | Email: info@yunusco.com",
                  style: pw.TextStyle(
                    fontSize: 8,
                    color: PdfColors.grey600,
                  ),
                ),
              ],
            ),
          ),

          // Document Info
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                "Date: ${DateTime.now().toString().split(' ')[0]}",
                style: pw.TextStyle(fontSize: 9),
              ),
              pw.Text(
                "Document: CS Report",
                style: pw.TextStyle(fontSize: 9),
              ),
            ],
          ),
        ],
      );
    }
    pw.Widget _buildSummaryItem(String title, String value) {
      return pw.Column(
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 9,
              color: PdfColors.grey600,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
        ],
      );
    }

// Summary Section Widget
    pw.Widget _buildSummarySection(int productCount, double grandTotal) {
      return pw.Container(
        padding: pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          color: PdfColors.blue50,
          border: pw.Border.all(color: PdfColors.blue200),
          borderRadius: pw.BorderRadius.circular(8),
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem("Total Products", productCount.toString()),
            _buildSummaryItem("Total Value", "BDT ${grandTotal.toStringAsFixed(2)}"),
            _buildSummaryItem("Generated On", DateTime.now().toString().split(' ')[0]),
          ],
        ),
      );
    }



// Products Table Widget
    pw.Widget _buildProductsTable(List<Map<String, dynamic>> selectedData) {
      return pw.Table.fromTextArray(
        border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
        headers: [
          '#',
          'Product Name',
          'Qty',
          'Category',
          'Supplier',
          'Rate',
          'Total',
          'Warranty',
          'Credit',
          'Payment'
        ],
        data: List<List<dynamic>>.generate(selectedData.length, (i) {
          final item = selectedData[i];
          return [
            i + 1,
            item['ProductName'] ?? '',
            '${item['CsQty']} ${item['UomName']}',
            item['ProductCategoryName'] ?? '',
            item['SelectedSupplierName'] ?? '',
            '${item['CurrencyName']} ${(item['SelectedRate'] ?? 0).toStringAsFixed(2)}',
            '${item['CurrencyName']} ${(item['SelectedTotal'] ?? 0).toStringAsFixed(2)}',
            item['WarrantyFirst'] ?? 'N/A',
            item['CreditPeriod'] ?? 'N/A',
            item['PayMode'] ?? 'N/A',
          ];
        }),
        cellStyle: pw.TextStyle(fontSize: 7),
        headerStyle: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 8,
          color: PdfColors.white,
        ),
        headerDecoration: pw.BoxDecoration(color: PdfColors.blue700),
        cellAlignment: pw.Alignment.centerLeft,
        cellPadding: pw.EdgeInsets.all(4),
        columnWidths: {
          0: pw.FlexColumnWidth(0.3),  // #
          1: pw.FlexColumnWidth(1.5),  // Product Name
          2: pw.FlexColumnWidth(0.5),  // Qty
          3: pw.FlexColumnWidth(1.0),  // Category
          4: pw.FlexColumnWidth(1.2),  // Supplier
          5: pw.FlexColumnWidth(0.7),  // Rate
          6: pw.FlexColumnWidth(0.8),  // Total
          7: pw.FlexColumnWidth(0.6),  // Warranty
          8: pw.FlexColumnWidth(0.6),  // Credit
          9: pw.FlexColumnWidth(0.6),  // Payment
        },
      );
    }

// Grand Total Widget
    pw.Widget _buildGrandTotal(double grandTotal) {
      return pw.Container(
        padding: pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          color: PdfColors.grey50,
          border: pw.Border.all(color: PdfColors.grey400),
          borderRadius: pw.BorderRadius.circular(6),
        ),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              "GRAND TOTAL:",
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              "BDT ${grandTotal.toStringAsFixed(2)}",
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.green700,
              ),
            ),
          ],
        ),
      );
    }

    pw.Widget _buildSignatureBox(String title, String label) {
      return pw.Column(
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
          pw.SizedBox(height: 25),
          pw.Container(
            width: 120,
            height: 1,
            color: PdfColors.black,
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            "Date: ___________",
            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
        ],
      );
    }
// Approval Signatures Widget
    pw.Widget _buildApprovalSignatures() {
      return pw.Container(
        margin: pw.EdgeInsets.only(top: 20),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            _buildSignatureBox("Department Head", "Approved By"),
            _buildSignatureBox("Management", "Approved By"),
            _buildSignatureBox("Audit", "Verified By"),
          ],
        ),
      );
    }



    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          // Company Header
          _buildCompanyHeader(),
          pw.SizedBox(height: 15),

          // Document Title
          pw.Center(
            child: pw.Text(
              "COMPARATIVE STATEMENT",
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800,
              ),
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Center(
            child: pw.Text(
              "Code: $code",
              style: pw.TextStyle(
                fontSize: 12,
                color: PdfColors.grey600,
              ),
            ),
          ),
          pw.SizedBox(height: 15),

          // Summary Information
          _buildSummarySection(selectedData.length, grandTotal),
          pw.SizedBox(height: 20),

          // Products Table
          pw.Text(
            "Selected Products & Suppliers",
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          _buildProductsTable(selectedData),
          pw.SizedBox(height: 20),

          // Grand Total
          _buildGrandTotal(grandTotal),
          pw.SizedBox(height: 30),

          // Approval Signatures
          _buildApprovalSignatures(),
        ],
      ),
    );



    final output = await getTemporaryDirectory();
    final file = File("${output.path}/Comparative_Statement_$code.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }


  static Future<void> generateAndDownloadPDF(
      List<Map<String, dynamic>> selectedData,
      String code,
      double grandTotal,BuildContext context) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Downloading PDF...')),
      );

      final file = await PdfService.generateComparativeStatementPDF(
          selectedData, code, grandTotal);

      // 🔹 Get "Documents" directory
      final documentsDir = await getApplicationDocumentsDirectory();
      final newPath = '${documentsDir.path}/Comparative_Statement_$code.pdf';

      final savedFile = await file.copy(newPath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved to: ${savedFile.path}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading PDF: $e')),
      );
    }
  }

}




class PdfPreviewScreen extends StatelessWidget {
  final List<Map<String, dynamic>> selectedData;
  final String code;
  final double grandTotal;

  const PdfPreviewScreen({
    super.key,
    required this.selectedData,
    required this.code,
    required this.grandTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview PDF'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () async {
              await PdfService.generateAndDownloadPDF(selectedData, code, grandTotal,context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PDF downloaded to app directory')),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<File>(
        future: PdfService.generateComparativeStatementPDF(selectedData, code, grandTotal),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error generating PDF'));
          }
          return PdfPreview(
            build: (format) async => snapshot.data!.readAsBytes(),
            allowPrinting: true,
            allowSharing: true,
          );
        },
      ),
    );
  }
}
