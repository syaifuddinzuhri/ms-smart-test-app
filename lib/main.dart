import 'package:flutter/material.dart';
import 'package:ms_smart_test/core/main_navigator.dart';
import 'ui/pages/splash_page.dart'; // Import splash page baru

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'MS Smart Test',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      // UBAH DI SINI: ganti LoginPage ke SplashPage
      home: const SplashPage(),
    );
  }
}