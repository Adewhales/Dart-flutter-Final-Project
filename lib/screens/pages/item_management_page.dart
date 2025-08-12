import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sajomainventory/models/item.dart';

class ItemManagementPage extends StatefulWidget {
  const ItemManagementPage({super.key});

  @override
  State<ItemManagementPage> createState() => _ItemManagementPageState();
}

class _ItemManagementPageState extends State<ItemManagementPage> {
  late Box<Item> itemBox;

  @override
  void initState() {
    super.initState();
    itemBox = Hive.box<Item>('item_catalog');
  }

  void _editItem(Item item) {
    final nameController = TextEditingController(text: item.name);
    final unitController = TextEditingController(text: item.defaultUnit);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Item Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: unitController,
              decoration: const InputDecoration(labelText: 'Default Unit'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              item.name = nameController.text.trim();
              item.defaultUnit = unitController.text.trim();
              item.save();
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteItem(Item item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              item.delete();
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = itemBox.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Catalog Management'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (_, index) {
          final item = items[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(item.name),
              subtitle: Text('Unit: ${item.defaultUnit}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editItem(item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteItem(item),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
