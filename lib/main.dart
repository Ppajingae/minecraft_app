import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/navigation/main_navigation_page.dart';


Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PJG',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorSchemeSeed: Colors.blueGrey,
      ),

      themeMode: ThemeMode.system,

      home: const MainNavigationPage(), // ← 여기도
    );
  }
}
