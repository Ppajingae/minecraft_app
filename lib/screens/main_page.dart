import 'package:flutter/material.dart';
import 'package:minecraft/screens/server_properties_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

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
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Minecraft Server', // TODO: 내 서버 이름 가져오기
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
                              'ONLINE',
                              style: TextStyle(color: Colors.black38)
                          ),
                          backgroundColor: Colors.lightGreen,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Version: 1.21.80.3',
                      style: TextStyle(color: textColor),
                    ),
                    Text(
                      'Last Backup: Yesterday at 22:00',
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
                _serverButton(Icons.refresh, 'Restart', () {
                  // call /restart
                }),
                _serverButton(Icons.stop, 'Stop', () {
                  // call /stop
                }),
                _serverButton(Icons.play_arrow, 'Start', () {
                  // call /start
                }),
                _serverButton(Icons.download, 'Backup', () {
                  // call /backup
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
}