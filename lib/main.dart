import 'package:flutter/material.dart';
import 'package:sajomainventory/screens/pages/endofday.dart';
import 'package:sajomainventory/screens/pages/inboundstock.dart';
import 'package:sajomainventory/screens/pages/outboundstock.dart';
import 'package:sajomainventory/screens/pages/checkstocks.dart';
import 'package:sajomainventory/screens/pages/startofday.dart';
import 'package:sajomainventory/database/db_helper.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'main.dart'; // Replace with your actual app import

void main() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // Start from login
    );
  }
}

// ------------------ LOGIN PAGE ------------------

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  void _login() {
    final email = _emailController.text;
    final password = _passwordController.text;

    // Simple hardcoded check
    if (email == 'admin@sajoma.com' && password == 'admin123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LandingPage()),
      );
    } else {
      setState(() {
        _errorMessage = 'Invalid email or password.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'SAJOMA Login',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  const SizedBox(height: 20),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ElevatedButton(onPressed: _login, child: const Text('Login')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purpleAccent, Colors.deepOrangeAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.inventory_2_rounded,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 40),
              const Text(
                "Sajoma Inventory System",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Text(
                '''Small Business. Big Control. Manage your Stock with ease''',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Image.asset(
                'lib/assets/images/pexels-photo-4483610.jpeg',
                width: 500,
                height: 400,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardPage()),
                  );
                },
                child: const Text(
                  "Get Started",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StartOfDayWidget extends StatefulWidget {
  const StartOfDayWidget({super.key});
  @override
  _StartOfDayWidgetState createState() => _StartOfDayWidgetState();
}

class _StartOfDayWidgetState extends State<StartOfDayWidget> {
  String note = "";

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        tileColor: const Color.fromARGB(255, 177, 244, 54),
        leading: const Icon(Icons.play_arrow, color: Colors.green),
        title: const Text("Start of Day"),
        subtitle: Text(note.isEmpty ? "Tap to Start the Day" : note),
        onTap: () async {
          final isAuthenticated = await showPasswordDialog(context);
          if (!isAuthenticated) return;

          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StartofdayPage()),
          );
          if (result != null && result is String) {
            setState(() {
              note = result;
            });
          }
        },
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(14.0),
          child: const Text("Dashboard"),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: const Color.fromARGB(255, 255, 252, 64),
      ),
      body: Container(
        color: const Color.fromARGB(255, 76, 175, 167),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Welcome to SAJOMA INVENTORY MANAGEMENT SYSTEM",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Expanded needs to be inside the Column's children
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: const [
                  StartOfDayWidget(),
                  InboundStockWidget(),
                  OutboundStockWidget(),
                  StockCheckerWidget(),
                  EndOfDayWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InboundStockWidget extends StatefulWidget {
  const InboundStockWidget({super.key});

  @override
  _InboundStockWidgetState createState() => _InboundStockWidgetState();
}

class _InboundStockWidgetState extends State<InboundStockWidget> {
  String note = "";

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        tileColor: const Color.fromARGB(255, 244, 162, 54),
        leading: const Icon(Icons.arrow_circle_down_rounded),
        title: const Text("Incoming Stock"),
        subtitle: Text(note.isEmpty ? "Tap to Receive Stock" : note),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InboundStockPage()),
          );

          if (result != null && result is String) {
            setState(() {
              note = result;
            });
          }
        },
      ),
    );
  }
}

class OutboundStockWidget extends StatefulWidget {
  const OutboundStockWidget({super.key});

  @override
  _OutboundStockWidgetState createState() => _OutboundStockWidgetState();
}

class _OutboundStockWidgetState extends State<OutboundStockWidget> {
  String note = "";

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        tileColor: const Color.fromARGB(255, 244, 162, 54),
        leading: const Icon(Icons.arrow_circle_up_rounded),
        title: const Text("Outbound Stock"),
        subtitle: Text(
          note.isEmpty ? "Tap to Record Out Goinging Stocks" : note,
        ),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OutgoingPage()),
          );
          if (result != null && result is String) {
            setState(() {
              note = result;
            });
          }
        },
      ),
    );
  }
}

class StockCheckerWidget extends StatefulWidget {
  const StockCheckerWidget({super.key});

  @override
  _StockCheckerWidgetState createState() => _StockCheckerWidgetState();
}

class _StockCheckerWidgetState extends State<StockCheckerWidget> {
  String note = "";

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        tileColor: const Color.fromARGB(255, 244, 162, 54),
        leading: const Icon(Icons.play_arrow),
        title: const Text("StockChecker"),
        subtitle: Text(
          note.isEmpty ? "Tap to Check Availability of Items" : note,
        ),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CheckstockPage()),
          );
          if (result != null && result is String) {
            setState(() {
              note = result;
            });
          }
        },
      ),
    );
  }
}

class EndOfDayWidget extends StatefulWidget {
  const EndOfDayWidget({super.key});

  @override
  _EndOfDayWidgetState createState() => _EndOfDayWidgetState();
}

class _EndOfDayWidgetState extends State<EndOfDayWidget> {
  String note = "";

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        tileColor: const Color.fromARGB(255, 244, 108, 54),
        leading: const Icon(Icons.play_arrow, color: Colors.red),
        title: const Text("End of Day"),
        subtitle: Text(note.isEmpty ? "Tap to End the Day" : note),
        onTap: () async {
          final isAuthenticated = await showPasswordDialog(context);
          if (!isAuthenticated) return;

          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EndofDayPage()),
          );
          if (result != null && result is String) {
            setState(() {
              note = result;
            });
          }
        },
      ),
    );
  }
}

// 🔒 Reusable Password Prompt Function
Future<bool> showPasswordDialog(BuildContext context) async {
  final TextEditingController passwordController = TextEditingController();
  String? error;

  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Enter Password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: error,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final password = passwordController.text;
                  if (password == 'secure123') {
                    Navigator.pop(context, true);
                  } else {
                    setState(() {
                      error = 'Incorrect password';
                    });
                  }
                },
                child: const Text('Confirm'),
              ),
            ],
          );
        },
      );
    },
  ).then((value) => value ?? false);
}

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
      appBar: AppBar(title: const Text("Inbound Inventory")),
      body: items.isEmpty
          ? const Center(child: Text("No stock entries yet"))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, index) {
                final item = items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    title: Text(item['item']),
                    subtitle: Text(
                      "Qty: ${item['quantity']} ${item['unit']}\nSource: ${item['source']}",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
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
