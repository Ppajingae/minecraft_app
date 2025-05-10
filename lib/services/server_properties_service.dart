import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ServerPropertiesService {
  final String _baseUrl = dotenv.env['BASE_URL']!;

  Future<Map<String, String>> fetchProperties() async {
    final response = await http.get(Uri.parse('$_baseUrl/api/v1/server/properties'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data.map((key, value) => MapEntry(key, value.toString()));
    } else {
      throw Exception('Failed to load server properties');
    }
  }

  Future<void> updateProperties(Map<String, String> properties) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/api/v1/server/properties'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(properties),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update server properties');
    }
  }
}