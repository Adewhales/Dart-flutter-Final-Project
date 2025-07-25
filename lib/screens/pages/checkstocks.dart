import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sajomainventory/models/stock_record.dart';

class CheckstockPage extends StatefulWidget {
  const CheckstockPage({super.key});

  @override
  State<CheckstockPage> createState() => _CheckstockPageState();
}

class _CheckstockPageState extends State<CheckstockPage> {
  late Box<StockRecord> inboundBox;
  late Box<StockRecord> outboundBox;

  String? selectedItem;
  int balance = 0;
  List<String> itemNames = [];

  @override
  void initState() {
    super.initState();
    inboundBox = Hive.box<StockRecord>('inbound_stock');
    outboundBox = Hive.box<StockRecord>('outbound_stock');
    _loadItemNames();
  }

  void _loadItemNames() {
    final inboundItems = inboundBox.values.map((e) => e.item);
    final outboundItems = outboundBox.values.map((e) => e.item);
    final allItems = {...inboundItems, ...outboundItems};
    setState(() {
      itemNames = allItems.toList();
    });
  }

  String selectedUnit = 'Units'; // default fallback

  void calculateBalance(String itemName) {
    final inboundRecords =
        inboundBox.values.where((record) => record.item == itemName);
    final outboundRecords =
        outboundBox.values.where((record) => record.item == itemName);

    final inbound =
        inboundRecords.fold(0, (sum, record) => sum + record.quantity);
    final outbound =
        outboundRecords.fold(0, (sum, record) => sum + record.quantity);

    // Get unit from first available record
    final unit = inboundRecords.isNotEmpty
        ? inboundRecords.first.unit
        : outboundRecords.isNotEmpty
            ? outboundRecords.first.unit
            : 'Units';

    setState(() {
      balance = inbound - outbound;
      selectedUnit = unit;
    });
  }

  List<Map<String, dynamic>> getSummary() {
    final allItems = {
      ...inboundBox.values.map((e) => e.item),
      ...outboundBox.values.map((e) => e.item),
    };

    return allItems.map((itemName) {
      final inboundRecords = inboundBox.values.where((e) => e.item == itemName);
      final outboundRecords =
          outboundBox.values.where((e) => e.item == itemName);

      final inbound = inboundRecords.fold(0, (sum, e) => sum + e.quantity);
      final outbound = outboundRecords.fold(0, (sum, e) => sum + e.quantity);

      // Get unit from first available record
      final unit = inboundRecords.isNotEmpty
          ? inboundRecords.first.unit
          : outboundRecords.isNotEmpty
              ? outboundRecords.first.unit
              : 'Units';

      return {
        'item': itemName,
        'unit': unit,
        'inbound': inbound,
        'outbound': outbound,
        'balance': inbound - outbound,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final summary = getSummary();

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
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                return itemNames.where((item) => item
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()));
              },
              onSelected: (value) {
                setState(() {
                  selectedItem = value;
                });
                calculateBalance(value);
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    labelText: 'Search Item',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.yellow,
                  ),
                  style: const TextStyle(color: Colors.black),
                );
              },
            ),
            const SizedBox(height: 20),
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
                    : 'Balance for $selectedItem: $balance $selectedUnit',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'End of Day Summary',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: summary.length,
                itemBuilder: (context, index) {
                  final item = summary[index];
                  return Card(
                    color: Colors.yellow.shade800,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(item['item'],
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Text(
                        'Inbound: ${item['inbound']} ${item['unit']} | '
                        'Outbound: ${item['outbound']} ${item['unit']} | '
                        'Balance: ${item['balance']} ${item['unit']}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
