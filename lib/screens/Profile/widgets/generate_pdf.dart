import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

Future<File> createAndSavePdf() async {
  // Create a PDF document
  final pdf = pw.Document();

  // Add a page with simple content
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text('Hello, PDF World!',
              style: pw.TextStyle(fontSize: 40)),
        );
      },
    ),
  );

  // Get the application documents directory
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/simple_page.pdf';

  // Save the PDF file
  final file = File(path);
  await file.writeAsBytes(await pdf.save());

  return file;
}