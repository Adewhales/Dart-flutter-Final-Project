import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajomainventory/screens/login.dart';

class StartofdayPage extends StatefulWidget {
  const StartofdayPage({super.key});

  @override
  State<StartofdayPage> createState() => _StartofdayPageState();
}

class _StartofdayPageState extends State<StartofdayPage> {
  final TextEditingController _noteController = TextEditingController();
  late DateTime _startTime;
  String _accountName = '';

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _loadAccountName();
  }

  Future<void> _loadAccountName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _accountName = prefs.getString('account_name') ?? '';
    });
  }

  Future<void> _submitStartOfDay() async {
    final note = _noteController.text.trim();

    // Optional: Validate input
    if (note.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note is empty. You can still proceed.')),
      );
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('start_of_day_enabled', true);
    await prefs.setBool('end_of_day_completed', false);

    final formattedTime = DateFormat('yyyy-MM-dd – HH:mm').format(_startTime);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start of Day Logged'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 48),
            const SizedBox(height: 12),
            Text('Time: $formattedTime\nNote: $note'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => LoginPage(
                    accountName: _accountName,
                    isSuperUser: false,
                  ),
                ),
                (route) => false,
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('yyyy-MM-dd – HH:mm').format(_startTime);

    return Scaffold(
      backgroundColor: Colors.yellow.shade900,
      appBar: AppBar(
        title: const Text('Start of Day'),
        backgroundColor: Colors.yellow.shade800,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Starting Time: $formattedTime',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _noteController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter optional notes...',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.yellow.shade800,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: _submitStartOfDay,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Day'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
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
