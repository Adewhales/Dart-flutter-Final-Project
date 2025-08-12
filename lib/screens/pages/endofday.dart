import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajomainventory/screens/pages/endofday_summary.dart';
import 'package:sajomainventory/screens/login.dart';
import 'package:sajomainventory/services/account_service.dart';

class EndofDayPage extends StatefulWidget {
  const EndofDayPage({super.key});

  @override
  State<EndofDayPage> createState() => _EndofDayPageState();
}

class _EndofDayPageState extends State<EndofDayPage> {
  final TextEditingController _summaryController = TextEditingController();
  late DateTime _endTime;
  String _accountName = '';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _endTime = DateTime.now();
    _loadAccountName();
  }

  Future<void> _loadAccountName() async {
    final name = await AccountService.getActiveAccountName('');
    setState(() {
      _accountName = name;
    });
  }

  Future<void> _confirmEndOfDay() async {
    final shouldEnd = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm End of Day'),
        content: const Text('Are you sure you want to end the day?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (shouldEnd == true) {
      _submitEndOfDay();
    }
  }

  Future<void> _submitEndOfDay() async {
    setState(() => _isSubmitting = true);

    final summary = _summaryController.text.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('end_of_day_completed', true);

    setState(() => _isSubmitting = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EndOfDaySummaryPage(
          summary: summary,
          endTime: _endTime,
          onComplete: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => LoginPage(
                  accountName: _accountName,
                  isSuperUser: false,
                ),
              ),
              (route) => false,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('yyyy-MM-dd – HH:mm').format(_endTime);

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
              'Closing Time: $formattedTime',
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
              child: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : ElevatedButton.icon(
                      onPressed: _confirmEndOfDay,
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
