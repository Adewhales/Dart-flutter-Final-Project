import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sajomainventory/features/user_management/add_user_to_account_page.dart';
import 'package:sajomainventory/features/user_management/create_user_page.dart';
import 'package:sajomainventory/features/user_management/reset_password_page.dart';
import 'package:sajomainventory/models/item.dart';
import 'package:sajomainventory/models/stock_record.dart';
import 'package:sajomainventory/screens/pages/endofday.dart';
import 'package:sajomainventory/screens/pages/inboundstock.dart';
import 'package:sajomainventory/screens/pages/outboundstock.dart';
import 'package:sajomainventory/screens/pages/checkstocks.dart';
import 'package:sajomainventory/screens/pages/startofday.dart';
import 'package:sajomainventory/database/db_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajomainventory/screens/pages/reports_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await Hive.initFlutter();
  Hive.registerAdapter(ItemAdapter());
  Hive.registerAdapter(StockRecordAdapter());

  await Hive.openBox<Item>('item_catalog');
  await Hive.openBox<StockRecord>('inbound_stock');
  await Hive.openBox<StockRecord>('outbound_stock');

  final prefs = await SharedPreferences.getInstance();
  final accountName = prefs.getString('inventory_account_name');

  runApp(MyApp(accountName: accountName));
}

class MyApp extends StatelessWidget {
  final String? accountName;
  const MyApp({super.key, required this.accountName});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: accountName == null
          ? const CreateAccountPage()
          : LoginPage(accountName: accountName!),
    );
  }
}

// ------------------ CREATE ACCOUNT PAGE ------------------

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;

  Future<void> _saveAccount() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _error = "All fields are required.");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('inventory_account_name', name);
    await prefs.setString('account_email', email);
    await prefs.setString('account_password', password);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(accountName: name)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 246, 231),
      body: Center(
        child: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Create Inventory Account',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 37, 33, 243)),
                ),
                const SizedBox(height: 28),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: 'Inventory Name',
                      border: const OutlineInputBorder()),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: 'Email', border: const OutlineInputBorder()),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder()),
                ),
                const SizedBox(height: 18),
                if (_error != null)
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color.fromARGB(255, 58, 183, 177),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _saveAccount,
                    child: const Text('Create Account',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------ LOGIN PAGE ------------------

class LoginPage extends StatefulWidget {
  final String accountName;
  const LoginPage({super.key, required this.accountName});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString('account_email');
    final storedPassword = prefs.getString('account_password');

    if (email == storedEmail && password == storedPassword) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LandingPage(
                    accountName: 'MyAccount',
                    isSuperUser: true, // or false depending on the user role
                  )));
    } else {
      setState(() {
        _errorMessage = 'Invalid email or password.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 246, 231),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${widget.accountName} Login',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 28),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 164, 183, 58),
                        ),
                        onPressed: _login,
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------ LANDING PAGE ------------------
// ------------------ LANDING PAGE ------------------
class LandingPage extends StatelessWidget {
  final String accountName;
  final bool isSuperUser;

  const LandingPage({
    super.key,
    required this.accountName,
    required this.isSuperUser,
  });

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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inventory_2_rounded,
                    size: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    accountName,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Small Business. Big Control. Manage your Stock with ease',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'lib/assets/images/pexels-photo-4483610.jpeg',
                      width: 350,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor:
                            const Color.fromARGB(255, 175, 183, 58),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DashboardPage(
                              accountName: accountName,
                              isSuperUser: isSuperUser,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Get Started",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------ DASHBOARD PAGE ------------------
class DashboardPage extends StatelessWidget {
  final String accountName;
  final bool isSuperUser;

  const DashboardPage({
    super.key,
    required this.accountName,
    required this.isSuperUser,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$accountName Inventory Management System",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: Container(
        color: Colors.deepPurple.shade50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Text(
                "Welcome to $accountName Inventory Management System",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  const StartOfDayWidget(),
                  const SizedBox(height: 12),
                  const InboundStockWidget(),
                  const SizedBox(height: 12),
                  const OutboundStockWidget(),
                  const SizedBox(height: 12),
                  const StockCheckerWidget(),
                  const SizedBox(height: 12),
                  const EndOfDayWidget(),
                  const SizedBox(height: 12),
                  if (isSuperUser) const AdminSettingsCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reports")),
      body: const Center(child: Text("Reports Page")),
    );
  }
}

class AdminSettingsCard extends StatelessWidget {
  const AdminSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.shade100,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Admin Settings",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.lock_reset),
              label: const Text("Reset User Password"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ResetPasswordPage()));
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.bar_chart),
              label: const Text("Run Customized Reports"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ReportsPage()));
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.group_add),
              label: const Text("Add Users to Accounts"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AddUserToAccountPage()));
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.person_add),
              label: const Text("Create Users & Assign Roles"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const CreateUserPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------ CARD WIDGETS ------------------
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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        tileColor: Colors.green.shade50,
        leading: const Icon(Icons.play_arrow, color: Colors.green, size: 32),
        title: const Text(
          "Start of Day",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          note.isEmpty ? "Tap to Start the Day" : note,
          style: const TextStyle(fontSize: 15),
        ),
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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        tileColor: Colors.orange.shade50,
        leading: const Icon(Icons.arrow_circle_down_rounded,
            color: Colors.orange, size: 32),
        title: const Text(
          "Incoming Stock",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          note.isEmpty ? "Tap to Receive Stock" : note,
          style: const TextStyle(fontSize: 15),
        ),
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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        tileColor: Colors.orange.shade50,
        leading: const Icon(Icons.arrow_circle_up_rounded,
            color: Colors.orange, size: 32),
        title: const Text(
          "Outbound Stock",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          note.isEmpty ? "Tap to Record Outgoing Stocks" : note,
          style: const TextStyle(fontSize: 15),
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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        tileColor: Colors.blue.shade50,
        leading: const Icon(Icons.search, color: Colors.blue, size: 32),
        title: const Text(
          "Stock Checker",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          note.isEmpty ? "Tap to Check Availability of Items" : note,
          style: const TextStyle(fontSize: 15),
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
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        tileColor: Colors.red.shade50,
        leading: const Icon(Icons.stop_circle, color: Colors.red, size: 32),
        title: const Text(
          "End of Day",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          note.isEmpty ? "Tap to End the Day" : note,
          style: const TextStyle(fontSize: 15),
        ),
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

// ------------------ PASSWORD PROMPT ------------------
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

// ------------------ INVENTORY LIST PAGE ------------------
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
