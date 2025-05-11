import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum ServerStatus { offline, loading, online, connecting }

class ServerControlService {
  static final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

  static Future<bool> startServer() async {
    final url = Uri.parse('$_baseUrl/api/v1/server/start');
    final response = await http.post(url);
    return response.statusCode == 200;
  }

// 여기에 stop, restart 등 추가 가능
  static Future<String> serverStatus() async {
    final url = Uri.parse('$_baseUrl/api/v1/server/status');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['content']; // "ONLINE" / "OFFLINE" / "LOADING"
    } else {
      throw Exception('서버 상태를 가져오는 데 실패했습니다.');
    }
  }

  static Future<String> serverStop() async {
    final url = Uri.parse('$_baseUrl/api/v1/server/stop');

    final response = await http.post(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final content = data['content'];
      return content?.toString() ?? 'OFFLINE'; // "ONLINE" / "OFFLINE" / "LOADING"
    } else {
      throw Exception('서버 상태를 가져오는 데 실패했습니다.');
    }
  }

  static Future<String> serverRestart() async {
    final url = Uri.parse('$_baseUrl/api/v1/server/restart');

    final response = await http.post(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final content = data['content'];
      return content?.toString() ?? 'OFFLINE'; // "ONLINE" / "OFFLINE" / "LOADING"
    } else {
      throw Exception('서버 재시작 하는데 실패했습니다.');
    }
  }
}