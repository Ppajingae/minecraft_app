import 'package:flutter/material.dart';
import '../main_page.dart';

class ServerPage extends StatelessWidget {
  const ServerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PJG')),
      body: MainPage(), // ← 기존 UI 넣기
    );
  }
}