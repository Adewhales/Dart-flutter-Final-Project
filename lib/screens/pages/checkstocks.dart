import 'package:flutter/material.dart';

class CheckstockPage extends StatefulWidget {
  const CheckstockPage({super.key});

  @override
  State<CheckstockPage> createState() => _CheckstockPageState();
}

class _CheckstockPageState extends State<CheckstockPage> {
  // Sample incoming and outgoing stock data
  final List<Map<String, dynamic>> incomingItems = [
    {"item": "Rice", "quantity": 120},
    {"item": "Tomatoes", "quantity": 45},
    {"item": "Vegetable Oil", "quantity": 80},
    {"item": "Sugar", "quantity": 60},
    {"item": "Flour", "quantity": 100},
  ];

  final List<Map<String, dynamic>> outgoingItems = [
    {"item": "Rice", "quantity": 30},
    {"item": "Tomatoes", "quantity": 10},
    {"item": "Vegetable Oil", "quantity": 20},
    {"item": "Sugar", "quantity": 15},
    {"item": "Flour", "quantity": 40},
  ];

  String? selectedItem;
  int balance = 0;

  void calculateBalance(String itemName) {
    final incoming = incomingItems
        .where((item) => item['item'] == itemName)
        .fold(0, (sum, item) => sum + (item['quantity'] as int));

    final outgoing = outgoingItems
        .where((item) => item['item'] == itemName)
        .fold(0, (sum, item) => sum + (item['quantity'] as int));

    setState(() {
      balance = incoming - outgoing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade900,
      appBar: AppBar(
        title: const Text('Check Stock Balance'),
        backgroundColor: Colors.yellow.shade800,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for selecting item
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.yellow.shade700,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: selectedItem,
                hint: const Text('Select Item',
                    style: TextStyle(color: Colors.white)),
                dropdownColor: Colors.yellow.shade700,
                iconEnabledColor: Colors.white,
                isExpanded: true,
                underline: const SizedBox(),
                items: incomingItems.map((item) {
                  return DropdownMenuItem<String>(
                    value: item['item'],
                    child: Text(item['item'],
                        style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedItem = value;
                  });
                  calculateBalance(value!);
                },
              ),
            ),
            const SizedBox(height: 20),

            // TextField to show balance
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.yellow.shade800,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                selectedItem == null
                    ? 'Select an item to view balance'
                    : 'Balance for $selectedItem: $balance units',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
