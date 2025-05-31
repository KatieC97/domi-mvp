import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/app_top_bar.dart';
import '../services/user_session.dart';

final storage = FlutterSecureStorage();

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String userName = 'there';
  List<Map<String, dynamic>> items = [];
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeName = ModalRoute.of(context)?.settings.arguments as String?;
    final name = routeName ?? UserSession.getUserName();

    if (name != null && mounted) {
      setState(() {
        userName = name;
      });
    }

    if (!kIsWeb) {
      fetchItems();
    }
  }

  Future<void> fetchItems() async {
    setState(() => isLoading = true);
    try {
      final token = await storage.read(key: 'access_token');
      if (token == null) throw Exception('No token found');

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/items'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          items = data.cast<Map<String, dynamic>>();
          isLoading = false;
        });
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorised');
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      debugPrint('Error fetching items: $e');
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to load items')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppTopBar(showBack: false, context: context),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/dashboard_background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 342),
                  child: Column(
                    children: [
                      Text(
                        'Hi, $userName!',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF515254),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      isLoading
                          ? const CircularProgressIndicator()
                          : items.isEmpty
                          ? const Text('No items yet.')
                          : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return Card(
                                color: Colors.white.withAlpha(230),
                                child: ListTile(
                                  title: Text(item['name'] ?? 'Unnamed'),
                                  subtitle: Text(item['location'] ?? 'Unknown'),
                                  trailing: Text(
                                    'Qty: ${item['quantity'] ?? '-'}',
                                  ),
                                ),
                              );
                            },
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
