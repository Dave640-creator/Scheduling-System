// lib/main.dart
import 'package:flutter/material.dart';
import 'theme.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const TCGCApp());
}

class TCGCApp extends StatelessWidget {
  const TCGCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TCGC Academic Scheduling System',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const LoginPage(),
    );
  }
}
