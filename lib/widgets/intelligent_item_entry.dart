import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sajomainventory/models/stock_record.dart';
import 'package:sajomainventory/models/item.dart';

class IntelligentItemEntry extends StatefulWidget {
  final StockRecord entry;
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
        widget.entry.unit = 'Units'; // Provide a default fallback
      });
    } else {
      final selected = itemList.firstWhere((item) => item.name == value);
      setState(() {
        isCustomInput = false;
        widget.entry.item = selected.name;
        widget.entry.unit =
            selected.defaultUnit ?? 'Units'; // Null-safe assignment
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
          value: isCustomInput
              ? null
              : widget.entry.item.isEmpty
                  ? null
                  : widget.entry.item,
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
          initialValue: widget.entry.quantity.toString(),
          onChanged: (val) {
            widget.entry.quantity = int.tryParse(val) ?? 0;
            widget.onChanged();
          },
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Unit'),
          value: widget.entry.unit.isEmpty ? null : widget.entry.unit,
          items: [
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
          ]
              .map((unit) => DropdownMenuItem(
                    value: unit,
                    child: Text(unit),
                  ))
              .toList(),
          onChanged: (val) {
            widget.entry.unit = val ?? 'Units'; // Null-safe fallback
            widget.onChanged();
          },
        ),
      ],
    );
  }
}
