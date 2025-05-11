import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minecraft/services/server_control_service.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String serverStatus = 'CONNECTING';

  Timer? _statusTimer;

  @override
  void initState() {
    super.initState();
    _fetchServerStatus(); // 초기 1회 조회
    _statusTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _fetchServerStatus();
    });
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  void _fetchServerStatus() async {
    try {
      final status = await ServerControlService.serverStatus();
      setState(() {
        serverStatus = status;
      });
    } catch (e) {
      setState(() {
        serverStatus = 'CONNECTING';
      });
      debugPrint('서버 상태 확인 실패: $e');
    }
  }

  void _startServer() async {
    setState(() => serverStatus = 'LOADING');
    try {
      await ServerControlService.startServer();
    } catch (e) {
      setState(() => serverStatus = 'OFFLINE');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('서버 시작 실패: $e')),
      );
    }
  }

  void _stopServer() async {
    setState(() => serverStatus = 'LOADING');
    try {
      await ServerControlService.serverStop();
    } catch (e) {
      setState(() => serverStatus = 'OFFLINE');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('서버 종료 실패: $e')),
      );
    }
  }

  void _restartServer() async {
    setState(() => serverStatus = 'LOADING');
    try {
      await ServerControlService.serverRestart();
    } catch (e) {
      setState(() => serverStatus = 'OFFLINE');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('서버 재시작 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 서버 상태 카드
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Minecraft Server',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Chip(
                          label: Text(
                            serverStatus,
                            style: const TextStyle(color: Colors.black87),
                          ),
                          backgroundColor: _statusColor(serverStatus),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Version: 1.21.80.3',
                      style: TextStyle(color: textColor),
                    ),
                    Text(
                      'Last Backup: Yesterday at 22:00 ( 구현 예정 )',
                      style: TextStyle(color: textColor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 서버 컨트롤 버튼
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _serverButton(Icons.refresh, 'Restart', _restartServer),
                _serverButton(Icons.stop, 'Stop', _stopServer),
                _serverButton(Icons.play_arrow, 'Start', _startServer),
                _serverButton(Icons.download, 'Backup', () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('업데이트 예정'),
                        content: const Text('추후 업데이트 예정 입니다.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('확인'),
                          ),
                        ],
                      );
                    },
                  );
                }),
              ],
            ),

            const SizedBox(height: 24),

            // 파일 관련
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.upload_file),
                    title: Text('Upload ZIP File', style: TextStyle(color: textColor)),
                    onTap: () {
                      // call /upload
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.download),
                    title: Text('Download World', style: TextStyle(color: textColor)),
                    onTap: () {
                      // call /download
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _serverButton(IconData icon, String label, VoidCallback onPressed) {
    return SizedBox(
      width: 140,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'ONLINE':
        return Colors.lightGreen;
      case 'LOADING':
        return Colors.amber;
      case 'CONNECTING':
        return Colors.grey;
      case 'OFFLINE':
      default:
        return Colors.redAccent;
    }
  }
}
