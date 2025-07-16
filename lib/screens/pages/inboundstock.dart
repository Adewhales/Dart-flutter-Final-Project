import 'package:flutter/material.dart';

class InboundStockPage extends StatefulWidget {
  const InboundStockPage({super.key});

  @override
  State<InboundStockPage> createState() => _InboundStockPageState();
}

class _InboundStockPageState extends State<InboundStockPage> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _sourceController = TextEditingController();

  void _submitIncomingStock() {
    final item = _itemNameController.text.trim();
    final quantity = _quantityController.text.trim();
    final source = _sourceController.text.trim();

    if (item.isEmpty || quantity.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item and quantity are required.')),
      );
      return;
    }

    final result =
        "Received $quantity x $item from ${source.isEmpty ? "N/A" : source}";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stock Received'),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
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
}
