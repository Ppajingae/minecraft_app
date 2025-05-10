import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class ServerPropertiesPage extends StatefulWidget {
  const ServerPropertiesPage({super.key});

  @override
  State<ServerPropertiesPage> createState() => _ServerPropertiesPageState();
}

class _ServerPropertiesPageState extends State<ServerPropertiesPage> {
  bool _isEditing = false;

  final Map<String, String> _properties = {
    "max-players": "10",
    "level-name": "Project_Yoong.Ver.1.1.1.0",
    "online-mode": "true",
    "view-distance": "32",
    "chat-restriction": "None",
    "script-debugger-auto-attach": "disabled",
  };

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Server Properties'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                // TODO: 서버로 _properties 데이터 전송할 수도 있음
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _properties.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final key = _properties.keys.elementAt(index);
          final value = _properties[key]!;

          return _isEditing
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(key, style: TextStyle(color: textColor)),
              const SizedBox(height: 4),
              TextFormField(
                initialValue: value,
                style: TextStyle(color: textColor),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (newValue) {
                  setState(() {
                    _properties[key] = newValue;
                  });
                },
              ),
            ],
          )
              : ListTile(
            title: Text(key, style: TextStyle(color: textColor)),
            subtitle: Text(value, style: TextStyle(color: textColor.withOpacity(0.8))),
          );
        },
      ),
    );
  }
}