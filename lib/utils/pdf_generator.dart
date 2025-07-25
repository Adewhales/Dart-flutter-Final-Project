import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sajomainventory/models/stock_record.dart';
import 'package:hive/hive.dart';

class PDFGenerator {
  static Future<pw.Document> generateEndOfDaySummary({
    required String summary,
    required DateTime endTime,
  }) async {
    final inboundBox = Hive.box<StockRecord>('inbound_stock');
    final outboundBox = Hive.box<StockRecord>('outbound_stock');

    final allItems = {
      ...inboundBox.values.map((e) => e.item),
      ...outboundBox.values.map((e) => e.item),
    };

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, text: 'End of Day Stock Summary'),
          pw.Paragraph(text: 'Date: ${endTime.toLocal()}'),
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
}
