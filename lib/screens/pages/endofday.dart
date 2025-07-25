import 'package:flutter/material.dart';
import 'package:sajomainventory/screens/pages/endofday_summary.dart';

class EndofDayPage extends StatefulWidget {
  const EndofDayPage({super.key});

  @override
  State<EndofDayPage> createState() => _EndofDayPageState();
}

class _EndofDayPageState extends State<EndofDayPage> {
  final TextEditingController _summaryController = TextEditingController();
  late DateTime _endTime;

  @override
  void initState() {
    super.initState();
    _endTime = DateTime.now();
  }

  void _submitEndOfDay() {
    final summary = _summaryController.text;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EndOfDaySummaryPage(
          summary: summary,
          endTime: _endTime,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade900,
      appBar: AppBar(
        title: const Text('End of Day'),
        backgroundColor: Colors.yellow.shade800,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Closing Time: ${_endTime.toLocal().toString().split('.')[0]}',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _summaryController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter summary of the day...',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.yellow.shade800,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: _submitEndOfDay,
                icon: const Icon(Icons.stop_circle_outlined),
                label: const Text('End Day'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
