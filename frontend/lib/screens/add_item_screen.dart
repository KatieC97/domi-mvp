import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../widgets/app_top_bar.dart';
import '../services/database_helper.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  String selectedLocation = 'Kitchen';
  int quantity = 1;
  bool isEditable = false;
  bool isLoading = true;
  String? scannedBarcode;
  final List<String> locationOptions = ['Kitchen', 'Bathroom', 'Hallway'];
  final TextEditingController _productNameController = TextEditingController();
  final logger = Logger();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scannedBarcode = ModalRoute.of(context)?.settings.arguments as String?;

    if (kIsWeb) {
      setState(() {
        _productNameController.text = 'Flash Wipes';
        isLoading = false;
      });
    } else if (scannedBarcode != null) {
      fetchProductData(scannedBarcode!);
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchProductData(String barcode) async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/product/$barcode'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (!mounted) return;
        setState(() {
          _productNameController.text = data['name'] ?? 'Unknown Product';
          isLoading = false;
        });
      } else {
        throw Exception('Product not found');
      }
    } catch (e) {
      logger.e("Error fetching product: $e");
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Product not found')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFEFEFE),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      appBar: AppTopBar(showBack: true, context: context),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 342),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    'Add Item',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF515254),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 56,
                    child: TextField(
                      controller: _productNameController,
                      readOnly: !isEditable,
                      style: const TextStyle(color: Color(0xFF515254)),
                      decoration: InputDecoration(
                        hintText: 'Product name',
                        hintStyle: const TextStyle(color: Color(0xFFBDBECB)),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Color(0xFF515254),
                          ),
                          onPressed: () {
                            setState(() {
                              isEditable = !isEditable;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Color(0xFFBDBECB),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Color(0xFFBDBECB),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 56,
                    child: DropdownButtonFormField<String>(
                      value: selectedLocation,
                      icon: const Icon(Icons.arrow_drop_down),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        prefixIcon: const Icon(
                          Icons.location_on_outlined,
                          color: Color(0xFF515254),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Color(0xFFBDBECB),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Color(0xFFBDBECB),
                            width: 1,
                          ),
                        ),
                      ),
                      onChanged:
                          (value) => setState(() => selectedLocation = value!),
                      items:
                          locationOptions
                              .map(
                                (location) => DropdownMenuItem(
                                  value: location,
                                  child: Text(location),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 56,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: const Color(0xFFBDBECB),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.remove,
                              color: Color(0xFF515254),
                            ),
                            onPressed: () {
                              if (quantity > 1) setState(() => quantity--);
                            },
                          ),
                          Text(
                            quantity.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF515254),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: Color(0xFF515254),
                            ),
                            onPressed: () => setState(() => quantity++),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                        final name = _productNameController.text.trim();
                        if (name.isEmpty) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a product name'),
                            ),
                          );
                          return;
                        }

                        try {
                          await DatabaseHelper.instance.insertItem({
                            'name': name,
                            'location': selectedLocation,
                            'quantity': quantity,
                          });

                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Item saved successfully'),
                            ),
                          );
                          Navigator.pop(context, 'new_item_added');
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to save item'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF634A8A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white, fontSize: 16),
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
