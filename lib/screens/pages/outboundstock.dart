import 'package:flutter/material.dart';
import 'package:sajomainventory/database/hive_stock_helper.dart';

class StockEntry {
  String item = '';
  String? unit;
  int quantity = 0;

  StockEntry({this.item = '', this.unit, this.quantity = 0});
}

class OutgoingPage extends StatefulWidget {
  const OutgoingPage({super.key});

  @override
  State<OutgoingPage> createState() => _OutgoingPageState();
}

class _OutgoingPageState extends State<OutgoingPage> {
  List<StockEntry> entries = [StockEntry()];
  final TextEditingController _recipientController = TextEditingController();

  final List<String> _units = [
    'Dericas',
    'Bottles',
    'Bags',
    'Packs',
    'Units',
    'Boxes',
    'Sachets',
    'Dozen',
    'Kilogram',
    'Litre',
    'Crates'
  ];

  Future<void> _submitAllEntries() async {
    for (var entry in entries) {
      // ✅ Validate entry
      if (entry.item.isEmpty || entry.unit == null || entry.quantity <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Invalid entry at row ${entries.indexOf(entry) + 1}. Please review all fields.',
            ),
          ),
        );
        return;
      }

      // ✅ Insert into Hive outbound_stock box
      await HiveStockHelper.insertOutboundStock(
        item: entry.item,
        quantity: entry.quantity,
        unit: entry.unit!,
        recipient: _recipientController.text.trim().isEmpty
            ? 'N/A'
            : _recipientController.text.trim(),
      );
    }

    // ✅ Show success dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stock Out Logged'),
        content: const Text('All outgoing stock entries have been saved.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );

    // ✅ Reset form
    setState(() => entries = [StockEntry()]);
    _recipientController.clear();
  }

  @override
  void dispose() {
    _recipientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade900,
      appBar: AppBar(
        title: const Text('Outgoing Stock'),
        backgroundColor: Colors.yellow.shade800,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Stock Out Entries',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: Colors.yellow.shade800,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        TextField(
                          decoration:
                              const InputDecoration(labelText: 'Item Name'),
                          style: const TextStyle(color: Colors.white),
                          onChanged: (val) => entry.item = val.trim(),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          decoration:
                              const InputDecoration(labelText: 'Quantity'),
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          onChanged: (val) =>
                              entry.quantity = int.tryParse(val) ?? 0,
                        ),
                        const SizedBox(height: 10),
                        DropdownButton<String>(
                          hint: const Text('Select Unit'),
                          value: entry.unit,
                          dropdownColor: Colors.yellow.shade700,
                          items: _units.map((unit) {
                            return DropdownMenuItem(
                              value: unit,
                              child: Text(unit,
                                  style: const TextStyle(color: Colors.white)),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => entry.unit = val),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () => setState(() => entries.add(StockEntry())),
              icon: const Icon(Icons.add),
              label: const Text('Add Another Item'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _recipientController,
              decoration: const InputDecoration(
                labelText: 'Recipient / Department',
                labelStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.assignment_ind, color: Colors.white),
                filled: true,
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _submitAllEntries,
              icon: const Icon(Icons.check),
              label: const Text('Log All Entries'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
