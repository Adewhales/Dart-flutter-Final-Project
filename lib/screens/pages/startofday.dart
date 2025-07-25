import 'package:flutter/material.dart';

class StartofdayPage extends StatefulWidget {
  const StartofdayPage({super.key});

  @override
  State<StartofdayPage> createState() => _StartofdayPageState();
}

class _StartofdayPageState extends State<StartofdayPage> {
  final TextEditingController _noteController = TextEditingController();
  DateTime _startTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now(); // Automatically captures current time
  }

  void _submitStartOfDay() {
    final note = _noteController.text;

    // Here you would typically save this data to a backend or local storage.
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start of Day Logged'),
        content: Text('Time: ${_startTime.toLocal()}\nNote: $note'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Return to home screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              'Starting Time: ${_startTime.toLocal().toString().split('.')[0]}',
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
