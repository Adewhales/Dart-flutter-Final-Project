import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:sajomainventory/models/stock_record.dart';
import 'package:sajomainventory/screens/pages/account_details.dart'; // Ensure this model is imported

class PDFGenerator {
  /// Builds the PDF document for preview or manual saving
  static Future<pw.Document> buildEndOfDayDocument({
    required String accountName,
    required String summary,
    required DateTime endTime,
    String? optionalEmail,
  }) async {
    final inboundBox = Hive.box<StockRecord>('inbound_stock');
    final outboundBox = Hive.box<StockRecord>('outbound_stock');
    final accountBox = Hive.box<AccountDetails>('account_details');

    final accountDetails = accountBox.get(accountName);
    final accountEmail = accountDetails?.email ?? 'unknown@example.com';

    final allItems = {
      ...inboundBox.values.map((e) => e.item),
      ...outboundBox.values.map((e) => e.item),
    };

    final formattedDate =
        '${endTime.year}-${endTime.month.toString().padLeft(2, '0')}-${endTime.day.toString().padLeft(2, '0')}';

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, text: 'End of Day Stock Summary'),
          pw.Paragraph(text: 'Account: $accountName'),
          pw.Paragraph(text: 'Email: $accountEmail'),
          pw.Paragraph(text: 'Date: $formattedDate'),
          pw.Paragraph(text: 'Summary: $summary'),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: ['Item', 'Unit', 'Inbound', 'Outbound', 'Balance'],
            data: allItems.map((itemName) {
              final inboundRecords =
                  inboundBox.values.where((e) => e.item == itemName);
              final outboundRecords =
                  outboundBox.values.where((e) => e.item == itemName);

              final inbound =
                  inboundRecords.fold(0, (sum, e) => sum + e.quantity);
              final outbound =
                  outboundRecords.fold(0, (sum, e) => sum + e.quantity);
              final unit = inboundRecords.isNotEmpty
                  ? inboundRecords.first.unit
                  : outboundRecords.isNotEmpty
                      ? outboundRecords.first.unit
                      : 'Units';

              return [
                itemName,
                unit,
                '$inbound',
                '$outbound',
                '${inbound - outbound}'
              ];
            }).toList(),
          ),
        ],
      ),
    );

    return pdf;
  }

  /// Saves the PDF and sends it via email
  static Future<File> generateAndEmailEndOfDaySummary({
    required String accountName,
    required String summary,
    required DateTime endTime,
    String? optionalEmail,
  }) async {
    final pdf = await buildEndOfDayDocument(
      accountName: accountName,
      summary: summary,
      endTime: endTime,
      optionalEmail: optionalEmail,
    );

    final formattedDate =
        '${endTime.year}-${endTime.month.toString().padLeft(2, '0')}-${endTime.day.toString().padLeft(2, '0')}';
    final outputDir = await getApplicationDocumentsDirectory();
    final filePath =
        '${outputDir.path}/EndOfDay_$accountName$formattedDate.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    final accountBox = Hive.box<AccountDetails>('account_details');
    final accountDetails = accountBox.get(accountName);
    final accountEmail = accountDetails?.email ?? 'unknown@example.com';

    final email = Email(
      body: 'Attached is the End of Day summary for $accountName.',
      subject: 'End of Day Summary - $formattedDate',
      recipients: [accountEmail, if (optionalEmail != null) optionalEmail],
      attachmentPaths: [filePath],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (e) {
      print('Email sending failed: $e');
    }

    return file;
  }
}
