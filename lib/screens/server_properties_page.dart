import 'package:flutter/material.dart';
import '../services/server_properties_service.dart';

class ServerPropertiesPage extends StatefulWidget {
  const ServerPropertiesPage({super.key});

  @override
  State<ServerPropertiesPage> createState() => _ServerPropertiesPageState();
}

class _ServerPropertiesPageState extends State<ServerPropertiesPage> {
  Map<String, String> _properties = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    try {
      final properties = await ServerPropertiesService.fetchProperties();
      setState(() {
        _properties = properties;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching properties: $e');
    }
  }

  void _editProperty(String key, String currentValue) async {
    final controller = TextEditingController(text: currentValue);

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$key 수정'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: '새 값 입력'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('저장'),
          ),
        ],
      ),
    );

    if (result != null && result != currentValue) {
      setState(() {
        _properties[key] = result;
      });
      // TODO: 서버에 반영하는 API 호출
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(title: const Text('Properties')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _properties.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final key = _properties.keys.elementAt(index);
          final value = _properties[key]!;
          return ListTile(
            title: Text(key, style: TextStyle(color: textColor)),
            subtitle: Text(value, style: TextStyle(color: textColor.withOpacity(0.8))),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _editProperty(key, value),
            ),
          );
        },
      ),
    );
  }
}