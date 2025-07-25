import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sajomainventory/models/item.dart';

class IntelligentItemEntry extends StatefulWidget {
  final StockEntry entry;
  final VoidCallback onChanged;

  const IntelligentItemEntry({
    super.key,
    required this.entry,
    required this.onChanged,
  });

  @override
  State<IntelligentItemEntry> createState() => _IntelligentItemEntryState();
}

class _IntelligentItemEntryState extends State<IntelligentItemEntry> {
  late Box<Item> itemBox;
  List<Item> itemList = [];
  bool isCustomInput = false;

  @override
  void initState() {
    super.initState();
    itemBox = Hive.box<Item>('item_catalog');
    itemList = itemBox.values.toList();
  }

  void _handleItemSelection(String? value) {
    if (value == 'Other') {
      setState(() {
        isCustomInput = true;
        widget.entry.item = '';
        widget.entry.unit = null;
      });
    } else {
      final selected = itemList.firstWhere((item) => item.name == value);
      setState(() {
        isCustomInput = false;
        widget.entry.item = selected.name;
        widget.entry.unit = selected.defaultUnit;
      });
    }
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final itemNames = itemList.map((e) => e.name).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Item Name'),
          value: isCustomInput ? null : widget.entry.item,
          items: [
            ...itemNames.map((name) => DropdownMenuItem(
              value: name,
              child: Text(name),
            )),
            const DropdownMenuItem(
              value: 'Other',
              child: Text('Add New Item'),
            ),
          ],
          onChanged: _handleItemSelection,
        ),
        if (isCustomInput)
          TextFormField(
            decoration: const InputDecoration(labelText: 'New Item Name'),
            onChanged: (val) {
              widget.entry.item = val.trim();
              widget.onChanged();
            },
          ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Quantity'),
          keyboardType: TextInputType.number,
          onChanged: (val) {
            widget.entry.quantity = int.tryParse(val) ?? 0;
            widget.onChanged();
          },
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Unit'),
          value: widget.entry.unit,
          items: [
            'Dericas', 'Bottles', 'Bags', 'Packs', 'Units',
            'Boxes', 'Sachets', 'Dozen', 'Kilogram', 'Litre', 'Crates'
          ].map((unit) => DropdownMenuItem(
            value: unit,
            child: Text(unit),
          )).toList(),
          onChanged: (val) {
            widget.entry.unit = val;
            widget.onChanged();
          },
        ),
      ],
    );
  }
}
🧠 In Your Inbound/Outbound Page
Replace your entry card builder with:

dart
ListView.builder(
  itemCount: entries.length,
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemBuilder: (context, index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: IntelligentItemEntry(
          entry: entries[index],
          onChanged: () => setState(() {}),
        ),
      ),
    );
  },
)
💾 Save New Items to Hive on Submit
In your _submitAllEntries() method:

dart
final itemBox = Hive.box<Item>('item_catalog');
final existingNames = itemBox.values.map((e) => e.name).toList();

for (var entry in entries) {
  if (!existingNames.contains(entry.item)) {
    await itemBox.add(Item(name: entry.item, defaultUnit: entry.unit ?? 'Units'));
  }

  await DBHelper.insertStock(
    item: entry.item,
    quantity: entry.quantity,
    unit: entry.unit!,
    source: _sourceController.text.trim().isEmpty ? 'N/A' : _sourceController.text.trim(),
  );
}
This setup gives you a smart, user-friendly item entry system that grows with your inventory. Want to add edit/delete support for the catalog or sync it across devices? I’ve got ideas for that too 💡📦🐝

Where will i place the Intelligent Item Entry Widget : import 'package:flutter/material.dart'; import 'package:hive/hive.dart'; import 'package:sajomainventory/models/item.dart'; class IntelligentItemEntry extends StatefulWidget { final StockEntry entry; final VoidCallback onChanged; const IntelligentItemEntry({ super.key, required this.entry, required this.onChanged, }); @override State<IntelligentItemEntry> createState() => _IntelligentItemEntryState(); } class _IntelligentItemEntryState extends State<IntelligentItemEntry> { late Box<Item> itemBox; List<Item> itemList = []; bool isCustomInput = false; @override void initState() { super.initState(); itemBox = Hive.box<Item>('item_catalog'); itemList = itemBox.values.toList(); } void _handleItemSelection(String? value) { if (value == 'Other') { setState(() { isCustomInput = true; widget.entry.item = ''; widget.entry.unit = null; }); } else { final selected = itemList.firstWhere((item) => item.name == value); setState(() { isCustomInput = false; widget.entry.item = selected.name; widget.entry.unit = selected.defaultUnit; }); } widget.onChanged(); } @override Widget build(BuildContext context) { final itemNames = itemList.map((e) => e.name).toList(); return Column( crossAxisAlignment: CrossAxisAlignment.start, children: [ DropdownButtonFormField<String>( decoration: const InputDecoration(labelText: 'Item Name'), value: isCustomInput ? null : widget.entry.item, items: [ ...itemNames.map((name) => DropdownMenuItem( value: name, child: Text(name), )), const DropdownMenuItem( value: 'Other', child: Text('Add New Item'), ), ], onChanged: _handleItemSelection, ), if (isCustomInput) TextFormField( decoration: const InputDecoration(labelText: 'New Item Name'), onChanged: (val) { widget.entry.item = val.trim(); widget.onChanged(); }, ), const SizedBox(height: 10), TextFormField( decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number, onChanged: (val) { widget.entry.quantity = int.tryParse(val) ?? 0; widget.onChanged(); }, ), const SizedBox(height: 10), DropdownButtonFormField<String>( decoration: const InputDecoration(labelText: 'Unit'), value: widget.entry.unit, items: [ 'Dericas', 'Bottles', 'Bags', 'Packs', 'Units', 'Boxes', 'Sachets', 'Dozen', 'Kilogram', 'Litre', 'Crates' ].map((unit) => DropdownMenuItem( value: unit, child: Text(unit), )).toList(), onChanged: (val) { widget.entry.unit = val; widget.onChanged(); }, ), ], ); } }
Great question, Adewale! You’ve got a beautifully crafted widget here—now let’s place it where it belongs in your project structure so it’s reusable and cleanly organized.

📁 Recommended Location for IntelligentItemEntry
Place the file in:

plaintext
lib/widgets/intelligent_item_entry.dart
This keeps it separate from your screens and models, and follows best practices for reusable UI components.

✅ Updated Project Tree Snapshot
plaintext
sajomainventory/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── item.dart
│   ├── database/
│   │   └── db_helper.dart
│   ├── screens/
│   │   └── pages/
│   │       ├── inboundstock.dart
│   │       └── outboundstock.dart
│   ├── widgets/
│   │   └── intelligent_item_entry.dart  ✅ ← Drop it here
🧠 How to Use It in Your Pages
In inboundstock.dart or outboundstock.dart, import it like this:

dart
import 'package:sajomainventory/widgets/intelligent_item_entry.dart';
Then inside your ListView.builder, replace the manual form fields with:

dart
IntelligentItemEntry(
  entry: entries[index],
  onChanged: () => setState(() {}),
),
This keeps your code modular, readable, and scalable. Let me know if you want to extract the unit list into a shared config or add validation to the widget itself. You’re building like a pro now, Adewale 💪📦🧱

