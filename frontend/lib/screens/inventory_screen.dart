import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../widgets/app_top_bar.dart';
import '../services/database_helper.dart';
import 'add_item_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String selectedLocation = 'all';
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    if (kIsWeb) {
      // Use mock data on web
      setState(() {
        _items = [
          {'name': 'Washing Up Liquid', 'quantity': 2, 'location': 'Kitchen'},
          {'name': 'Bleach', 'quantity': 1, 'location': 'Bathroom'},
        ];
      });
    } else {
      final data = await DatabaseHelper.instance.getAllItems();
      if (mounted) {
        setState(() => _items = data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems =
        _items.where((item) {
          final matchesLocation =
              selectedLocation == 'all' || item['location'] == selectedLocation;
          final matchesSearch = item['name'].toString().toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );
          return matchesLocation && matchesSearch;
        }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppTopBar(showBack: true, context: context),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    'Inventory',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF515254),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Filter
                  _buildDropdownFilter(),

                  const SizedBox(height: 16),

                  // Search
                  _buildSearchBar(),

                  const SizedBox(height: 24),

                  // Item Grid
                  filteredItems.isEmpty
                      ? const Text(
                        'No items found',
                        style: TextStyle(color: Color(0xFFBDBECB)),
                      )
                      : Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children:
                            filteredItems
                                .map(
                                  (item) => ItemCard(
                                    name: item['name'],
                                    qty: item['quantity'],
                                    location: item['location'],
                                  ),
                                )
                                .toList(),
                      ),
                  const SizedBox(height: 32),

                  // Add Manually
                  SizedBox(
                    width: 342,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddItemScreen(),
                          ),
                        );
                        if (result == 'new_item_added') {
                          _loadItems();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF634A8A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Add Manually',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownFilter() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DropdownButtonFormField<String>(
        value: selectedLocation,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          filled: true,
          fillColor: Colors.white,
          hintText: 'Filter',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        items: const [
          DropdownMenuItem(value: 'all', child: Text('All Locations')),
          DropdownMenuItem(value: 'Kitchen', child: Text('Kitchen')),
          DropdownMenuItem(value: 'Bathroom', child: Text('Bathroom')),
          DropdownMenuItem(value: 'Hallway', child: Text('Hallway')),
        ],
        onChanged: (value) => setState(() => selectedLocation = value!),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          hintText: 'Search items',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final String name;
  final int qty;
  final String location;

  const ItemCard({
    required this.name,
    required this.qty,
    required this.location,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 140, maxWidth: 160),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFEFEFE),
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                offset: Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.inventory_2, size: 48, color: Color(0xFFBDBECB)),
              const SizedBox(height: 12),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF515254),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _pill('x$qty', const Color(0xFFFFF3C7)),
                  const SizedBox(width: 8),
                  _pill(location, const Color(0xFFF7F7F7)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }
}
