import 'package:flutter/material.dart';
import 'package:sajomainventory/screens/dashboard_page.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String selectedReport = 'Sales Summary';

  final List<String> reportOptions = [
    'Sales Summary',
    'Inventory Status',
    'User Activity',
    'Revenue Breakdown',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Report Type:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedReport,
              items: reportOptions.map((report) {
                return DropdownMenuItem(
                  value: report,
                  child: Text(report),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedReport = value!;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildReportContent(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportContent() {
    switch (selectedReport) {
      case 'Sales Summary':
        return const Text(
          '📊 Sales Summary Report\n\nTotal Sales: ₦1,200,000\nTop Product: Widget A\nMost Active Day: Wednesday',
          style: TextStyle(fontSize: 16),
        );
      case 'Inventory Status':
        return const Text(
          '📦 Inventory Status Report\n\nLow Stock Items: 5\nOut of Stock: 2\nTotal SKUs: 120',
          style: TextStyle(fontSize: 16),
        );
      case 'User Activity':
        return const Text(
          '👥 User Activity Report\n\nMost Active User: admin@sajo.com\nLogin Frequency: High\nLast Login: Today',
          style: TextStyle(fontSize: 16),
        );
      case 'Revenue Breakdown':
        return const Text(
          '💰 Revenue Breakdown Report\n\nMonthly Revenue: ₦450,000\nTop Region: Lagos\nGrowth Rate: 12%',
          style: TextStyle(fontSize: 16),
        );
      default:
        return const Text('Select a report to view details.');
    }
  }
}
