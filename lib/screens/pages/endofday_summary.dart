import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:sajomainventory/utils/pdf_generator.dart';

class EndOfDaySummaryPage extends StatelessWidget {
  final String summary;
  final DateTime endTime;

  const EndOfDaySummaryPage({
    super.key,
    required this.summary,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('End of Day Summary'),
        backgroundColor: Colors.yellow.shade800,
      ),
      body: PdfPreview(
        build: (format) => PDFGenerator.generateEndOfDaySummary(
          summary: summary,
          endTime: endTime,
        ).then((doc) => doc.save()),
        allowPrinting: true,
        allowSharing: true,
        canChangePageFormat: false,
        canChangeOrientation: false,
      ),
    );
  }
}
