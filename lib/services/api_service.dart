import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'YOUR_BACKEND_URL'; // TODO: Replace with actual backend URL

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode} ${response.body}');
    }
  }

  Future<Map<String, dynamic>> get(String endpoint, {String? authToken}) async {
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    if (authToken != null) {
      headers['Authorization'] = authToken;
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode} ${response.body}');
    }
  }
}


