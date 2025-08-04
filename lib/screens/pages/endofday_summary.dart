import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:sajomainventory/utils/pdf_generator.dart';

class EndOfDaySummaryPage extends StatelessWidget {
  final String summary;
  final DateTime endTime;
  final VoidCallback onComplete;

  const EndOfDaySummaryPage({
    super.key,
    required this.summary,
    required this.endTime,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTime = endTime.toLocal().toString().split('.')[0];

    return Scaffold(
      appBar: AppBar(
        title: const Text('End of Day Summary'),
        backgroundColor: Colors.yellow.shade800,
      ),
      body: Column(
        children: [
          Expanded(
            child: PdfPreview(
              build: (format) => PDFGenerator.generateEndOfDaySummary(
                summary: summary,
                endTime: endTime,
              ).then((doc) => doc.save()),
              allowPrinting: true,
              allowSharing: true,
              canChangePageFormat: false,
              canChangeOrientation: false,
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Summary:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(summary),
                const SizedBox(height: 12),
                Text('Closed at: $formattedTime'),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: onComplete,
                  icon: const Icon(Icons.logout),
                  label: const Text('Return to Login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
