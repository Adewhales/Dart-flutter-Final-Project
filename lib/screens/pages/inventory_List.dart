import 'package:flutter/material.dart';
import 'package:sajomainventory/database/db_helper.dart';

class InventoryList extends StatefulWidget {
  const InventoryList({super.key});

  @override
  State<InventoryList> createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryList> {
  List<Map<String, dynamic>> items = [];

  void loadItems() async {
    final data = await DBHelper.getItems();
    setState(() {
      items = data;
    });
  }

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inbound Inventory"),
        backgroundColor: const Color.fromARGB(255, 175, 183, 58),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        elevation: 4,
      ),
      body: items.isEmpty
          ? const Center(child: Text("No stock entries yet"))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, index) {
                final item = items[index];
                return Card(
                  elevation: 3,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 18),
                    title: Text(
                      item['item'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      "Qty: ${item['quantity']} ${item['unit']}\nSource: ${item['source']}",
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await DBHelper.deleteItem(item['id']);
                        loadItems();
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 175, 183, 58),
        onPressed: () async {
          await DBHelper.insertStock(
            item: "Test Item",
            quantity: 10,
            unit: "Units",
            source: "Test Supplier",
          );
          loadItems();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
