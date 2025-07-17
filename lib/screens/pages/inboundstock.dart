import 'package:flutter/material.dart';
import 'package:sajomainventory/database/db_helper.dart'; // Make sure this path is correct

class InboundStockPage extends StatefulWidget {
  const InboundStockPage({super.key});

  @override
  State<InboundStockPage> createState() => _InboundStockPageState();
}

class _InboundStockPageState extends State<InboundStockPage> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _sourceController = TextEditingController();

  final List<String> _units = [
    'Dericas',
    'Bottles',
    'Bags',
    'Packs',
    'Units',
    'Boxes'
  ];
  String? _selectedUnit;

  void _submitIncomingStock() async {
    final item = _itemNameController.text.trim();
    final quantityText = _quantityController.text.trim();
    final source = _sourceController.text.trim();
    final quantity = int.tryParse(quantityText);

    if (item.isEmpty ||
        quantity == null ||
        quantity <= 0 ||
        _selectedUnit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please enter valid item, quantity, and select a unit.')),
      );
      return;
    }

    await DBHelper.insertStock(
      item: item,
      quantity: quantity,
      unit: _selectedUnit!,
      source: source.isEmpty ? 'N/A' : source,
    );

    final result =
        "Saved: $quantity $_selectedUnit of $item from ${source.isEmpty ? "N/A" : source}";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stock Logged'),
        content: Text(result),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // close dialog
              Navigator.of(context).pop(result); // return to dashboard
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );

    _itemNameController.clear();
    _quantityController.clear();
    _sourceController.clear();
    setState(() => _selectedUnit = null);
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _quantityController.dispose();
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
          children: [
            _buildTextField(
              controller: _itemNameController,
              label: 'Item Name',
              icon: Icons.inventory,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _quantityController,
              label: 'Quantity',
              icon: Icons.format_list_numbered,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            _buildUnitSelector(),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _sourceController,
              label: 'Source / Supplier (Optional)',
              icon: Icons.local_shipping,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _submitIncomingStock,
              icon: const Icon(Icons.add_box),
              label: const Text('Log Incoming Stock'),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: Colors.yellow.shade800,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildUnitSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Quantity Unit',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: _units.map((unit) {
            final isSelected = _selectedUnit == unit;
            return ChoiceChip(
              label: Text(unit),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedUnit = unit),
              selectedColor: Colors.greenAccent,
              backgroundColor: Colors.yellow.shade800,
              labelStyle: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
