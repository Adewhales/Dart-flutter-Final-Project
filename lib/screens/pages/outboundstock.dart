import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sajomainventory/database/hive_stock_helper.dart';
import 'package:sajomainventory/models/item.dart';

/// Represents a single outbound stock entry.
class StockEntry {
  String? item;
  String? unit;
  int quantity;

  StockEntry({this.item, this.unit, this.quantity = 0});
}

/// Main page for logging outbound stock.
class OutboundStockPage extends StatefulWidget {
  const OutboundStockPage({super.key});

  @override
  State<OutboundStockPage> createState() => _OutboundStockPageState();
}

class _OutboundStockPageState extends State<OutboundStockPage> {
  final List<StockEntry> entries = [StockEntry()];
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

  late List<String> _itemCatalog;

  @override
  void initState() {
    super.initState();
    _loadItemCatalog();
  }

  void _loadItemCatalog() {
    final itemBox = Hive.box<Item>('item_catalog');
    final items = itemBox.values.map((item) => item.name).toList();

    setState(() {
      _itemCatalog = items.isNotEmpty ? items : ['No items available'];
    });
  }

  Future<void> _submitAllEntries() async {
    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      if (entry.item == null || entry.unit == null || entry.quantity <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Invalid entry at row ${i + 1}. Please review all fields.',
            ),
          ),
        );
        return;
      }

      await HiveStockHelper.insertOutboundStock(
        item: entry.item!,
        quantity: entry.quantity,
        unit: entry.unit!,
        recipient: _recipientController.text.trim().isEmpty
            ? 'N/A'
            : _recipientController.text.trim(),
      );
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Stock Out Logged'),
        content: const Text('All outgoing stock entries have been saved.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );

    setState(() {
      entries.clear();
      entries.add(StockEntry());
      _recipientController.clear();
    });
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
        padding: const EdgeInsets.all(20),
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
              itemBuilder: (_, index) {
                final entry = entries[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: Colors.yellow.shade800,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: _itemCatalog.contains(entry.item)
                              ? entry.item
                              : null,
                          hint: const Text('Select Item Name'),
                          dropdownColor: Colors.yellow.shade700,
                          items: _itemCatalog.map((itemName) {
                            return DropdownMenuItem(
                              value: itemName,
                              child: Text(itemName),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => entry.item = val),
                          decoration: const InputDecoration(
                            labelText: 'Item Name',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Quantity',
                            labelStyle: TextStyle(color: Colors.white70),
                          ),
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          onChanged: (val) =>
                              entry.quantity = int.tryParse(val) ?? 0,
                        ),
                        const SizedBox(height: 10),
                        DropdownButton<String>(
                          hint: const Text('Select Unit',
                              style: TextStyle(color: Colors.white70)),
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
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add Another Item',
                  style: TextStyle(color: Colors.white)),
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
