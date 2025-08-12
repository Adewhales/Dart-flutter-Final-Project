import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sajomainventory/models/item.dart';
import 'package:sajomainventory/database/hive_stock_helper.dart';

class StockEntry {
  String item = '';
  String? unit;
  int quantity = 0;
  bool isNewItem = false;

  StockEntry({
    this.item = '',
    this.unit,
    this.quantity = 0,
    this.isNewItem = false,
  });
}

class InboundStockPage extends StatefulWidget {
  const InboundStockPage({super.key});

  @override
  State<InboundStockPage> createState() => _InboundStockPageState();
}

class _InboundStockPageState extends State<InboundStockPage> {
  List<StockEntry> entries = [StockEntry()];
  final TextEditingController _sourceController = TextEditingController();
  late Box<Item> itemBox;
  List<String> itemNames = [];

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

  @override
  void initState() {
    super.initState();
    itemBox = Hive.box<Item>('item_catalog');
    itemNames = itemBox.values.map((e) => e.name).toList();
  }

  Future<void> _submitAllEntries() async {
    final existingNames = itemBox.values.map((e) => e.name).toList();

    for (var entry in entries) {
      if (entry.item.isEmpty || entry.unit == null || entry.quantity <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Invalid entry at row ${entries.indexOf(entry) + 1}. Please review all fields.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (!existingNames.contains(entry.item)) {
        await itemBox.add(Item(name: entry.item, defaultUnit: entry.unit!));
      }

      await HiveStockHelper.insertInboundStock(
        item: entry.item,
        quantity: entry.quantity,
        unit: entry.unit!,
        source: _sourceController.text.trim().isEmpty
            ? 'N/A'
            : _sourceController.text.trim(),
      );
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('All stock entries have been saved.'),
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

    setState(() {
      entries = [StockEntry()];
      itemNames = itemBox.values.map((e) => e.name).toList();
    });
    _sourceController.clear();
  }

  Widget _buildItemEntryCard(int index) {
    final entry = entries[index];
    final itemController = TextEditingController(text: entry.item);

    return Card(
      color: Colors.yellow.shade800,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue value) {
                return itemNames.where((name) =>
                    name.toLowerCase().contains(value.text.toLowerCase()));
              },
              onSelected: (val) {
                setState(() {
                  entry.item = val;
                  entry.isNewItem = false;
                  final matchedItem =
                      itemBox.values.firstWhere((e) => e.name == val);
                  entry.unit = matchedItem.defaultUnit;
                });
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(labelText: 'Item Name'),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (val) {
                    entry.item = val.trim();
                    entry.isNewItem = !itemNames.contains(val.trim());
                    entry.unit = null; // Reset unit for new item
                  },
                );
              },
            ),
            if (entry.isNewItem)
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(
                  'New item detected. Please select unit to save.',
                  style: TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
              ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              onChanged: (val) => entry.quantity = int.tryParse(val) ?? 0,
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              hint: const Text('Select Unit'),
              value: entry.unit,
              dropdownColor: Colors.yellow.shade700,
              items: _units.map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child:
                      Text(unit, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (val) => setState(() => entry.unit = val),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _sourceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade900,
      appBar: AppBar(
        title: const Text('Incoming Stock'),
        backgroundColor: Colors.yellow.shade800,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Stock Entries',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: entries.length,
              itemBuilder: (context, index) => _buildItemEntryCard(index),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () => setState(() => entries.add(StockEntry())),
              icon: const Icon(Icons.add),
              label: const Text('Add Another Item'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _sourceController,
              decoration: const InputDecoration(
                labelText: 'Source / Supplier (Optional)',
                labelStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.local_shipping, color: Colors.white),
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
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
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
