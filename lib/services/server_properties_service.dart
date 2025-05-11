import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ServerPropertiesService {
  static final String _baseUrl = dotenv.env['BASE_URL']!;

  static Future<Map<String, String>> fetchProperties() async {
    final response = await http.get(Uri.parse('$_baseUrl/api/v1/server/properties'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final Map<String, dynamic> properties = data['content']['serverProperties'];

      final filtered = {
        '게임 모드': properties['gamemode'] ?? '',
        '난이도': properties['difficulty'] ?? '',
        '치트 명령어 허용 여부':properties['allow-cheats'] ?? '',
        '최대 인원': properties['max-players'] ?? '',
        '온라인 모드': properties['online-mode'] ?? '',
        '서버 포트': properties['server-port'] ?? '',
        'IPV6 서버 포트': properties['server-portv6'] ?? '',
        '플레이어 시야 거리': properties['view-distance'] ?? '',
        '서버가 처리하는 거리': properties['tick-distance'] ?? '',
        '월드 이름': properties['level-name'] ?? '',
        '기본 플레이어 권한': properties['default-player-permission-level'] ?? '',
        '채팅 제한': properties['chat-restriction'] ?? '',
      };

      return filtered.map((key, value) => MapEntry(key, value.toString()));
    } else {
      throw Exception('서버 설정 정보를 불러오는데 실패했습니다');
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