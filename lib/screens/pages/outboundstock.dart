import 'package:flutter/material.dart';

class OutgoingPage extends StatefulWidget {
  const OutgoingPage({super.key});

  @override
  State<OutgoingPage> createState() => _OutgoingPageState();
}

class _OutgoingPageState extends State<OutgoingPage> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _recipientController = TextEditingController();

  void _submitOutgoingStock() {
    final item = _itemNameController.text.trim();
    final quantity = _quantityController.text.trim();
    final recipient = _recipientController.text.trim();

    if (item.isEmpty || quantity.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item name and quantity are required.')),
      );
      return;
    }

    // Simulated confirmation (replace with actual data save logic)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stock Out Entry'),
        content: Text(
          'Item: $item\nQuantity: $quantity\nTo: ${recipient.isEmpty ? "N/A" : recipient}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Return to dashboard
            },
            child: const Text('OK'),
          ),
        ],
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
          children: [
            _buildTextField(
              controller: _itemNameController,
              label: 'Item Name',
              icon: Icons.inventory_outlined,
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
              controller: _recipientController,
              label: 'Recipient / Department',
              icon: Icons.assignment_ind,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _submitOutgoingStock,
              icon: const Icon(Icons.arrow_upward),
              label: const Text('Log Outgoing Stock'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
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
}
