import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/inventory_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/add_item_screen.dart';
import 'screens/barcode_scanner_screen.dart';

void main() {
  runApp(const DomiApp());
}

class DomiApp extends StatelessWidget {
  const DomiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Domï',
      theme: ThemeData(primarySwatch: Colors.deepPurple, fontFamily: 'Inter'),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/inventory': (context) => const InventoryScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/add': (context) => const AddItemScreen(),
        '/barcode-scan': (context) => const BarcodeScannerScreen(),
      },
    );
  }
}
