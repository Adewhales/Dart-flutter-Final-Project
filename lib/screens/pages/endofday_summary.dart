import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:sajomainventory/utils/pdf_generator.dart';
import 'package:sajomainventory/services/account_service.dart';

class EndOfDaySummaryPage extends StatefulWidget {
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
  State<EndOfDaySummaryPage> createState() => _EndOfDaySummaryPageState();
}

class _EndOfDaySummaryPageState extends State<EndOfDaySummaryPage> {
  String _accountName = '';

  @override
  void initState() {
    super.initState();
    _loadAccountName();
  }

  Future<void> _loadAccountName() async {
    final name = await AccountService.getActiveAccountName('');
    setState(() {
      _accountName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime =
        DateFormat('yyyy-MM-dd – HH:mm').format(widget.endTime);

    return Scaffold(
      appBar: AppBar(
        title: const Text('End of Day Summary'),
        backgroundColor: Colors.yellow.shade800,
      ),
      body: Column(
        children: [
          Expanded(
            child: PdfPreview(
              build: (format) => PDFGenerator.buildEndOfDayDocument(
                summary: widget.summary,
                endTime: widget.endTime,
                accountName: _accountName,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account: $_accountName',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  'Summary:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(widget.summary),
                const SizedBox(height: 12),
                Text('Closed at: $formattedTime'),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: widget.onComplete,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
