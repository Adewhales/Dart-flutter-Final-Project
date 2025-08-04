import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sajomainventory/features/dashboard/dashboard_page.dart';
import 'package:sajomainventory/features/user_management/add_user_to_account_page.dart';
import 'package:sajomainventory/features/user_management/create_user_page.dart';
import 'package:sajomainventory/features/user_management/reset_password_page.dart';
import 'package:sajomainventory/models/item.dart';
import 'package:sajomainventory/models/stock_record.dart';
import 'package:sajomainventory/screens/login.dart';
import 'package:sajomainventory/screens/pages/endofday.dart';
import 'package:sajomainventory/screens/pages/inboundstock.dart';
import 'package:sajomainventory/screens/pages/outboundstock.dart';
import 'package:sajomainventory/screens/pages/checkstocks.dart';
import 'package:sajomainventory/screens/pages/startofday.dart';
import 'package:sajomainventory/database/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajomainventory/screens/pages/reports_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sajomainventory/screens/pages/create_account_page.dart';
import 'package:sajomainventory/screens/pages/reset_password_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sajomainventory/utils/auth_utils.dart';
import 'package:sajomainventory/main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit(); // Initialize FFI
    databaseFactory = databaseFactoryFfi; // Set the FFI database factory
  }

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    print('Caught Flutter error: ${details.exception}');
  };

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

  const MyApp({super.key, this.accountName});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sajoma Inventory',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
      ),
      home: accountName == null
          ? const CreateAccountPage()
          : LoginPage(accountName: accountName!, isSuperUser: true),
      debugShowCheckedModeBanner: false,
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

  Future<bool> showPasswordDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final storedCode = prefs.getString('start_of_day_code') ?? '';

    final controller = TextEditingController();
    String? error;

    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Enter Start of Day Code'),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Code',
                errorText: error,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.trim() == storedCode) {
                    prefs.setBool('start_of_day_enabled', true); // ✅ activate
                    Navigator.pop(context, true);
                  } else {
                    setState(() => error = 'Incorrect password');
                  }
                },
                child: const Text('Confirm'),
              ),
            ],
          );
        });
      },
    ).then((value) => value ?? false);
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
            MaterialPageRoute(builder: (context) => const OutboundStockPage()),
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

  Future showPasswordDialog(BuildContext context) async {}
}

// ------------------ PASSWORD PROMPT ------------------
Future<bool> showStartOfDayDialog(BuildContext context) async {
  final TextEditingController codeController = TextEditingController();
  String? error;

  final prefs = await SharedPreferences.getInstance();

  final storedCode = prefs.getString('start_of_day_code');

  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Enter Start Code'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: codeController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '4-digit Code',
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
                onPressed: () async {
                  if (codeController.text == storedCode) {
                    await prefs.setBool('start_of_day_enabled', true);
                    Navigator.pop(context, true);
                  } else {
                    setState(() => error = 'Incorrect code');
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
