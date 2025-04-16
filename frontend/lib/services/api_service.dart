import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchProduct(String barcode) async {
  final response = await http.get(
    Uri.parse('http://127.0.0.1:8000/product/$barcode'),
  );

  if (response.statusCode == 200) {
    // Parse the response body
    return json.decode(response.body);
  } else {
    // Handle error
    throw Exception('Failed to load product');
  }
}
