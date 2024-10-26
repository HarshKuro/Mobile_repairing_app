// In main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'splash_screen.dart';
import 'theme_manager.dart'; // Import your theme manager

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Repair Shop',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: Provider.of<ThemeManager>(context).themeMode,
      home: const SplashScreen(),
    );
  }
}