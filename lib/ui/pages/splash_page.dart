import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ms_smart_test/providers/auth_provider.dart';
import 'package:ms_smart_test/ui/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 2)); // biar splash tetap kelihatan

    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    bool isAuth = await authProvider.checkAuth();

    if (!mounted) return;

    if (isAuth) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih bersih
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // 1. Logo Aplikasi
            Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.school, size: 100, color: Colors.green),
            ),

            const SizedBox(height: 20),

            // 2. Nama Aplikasi
            const Text(
              "MS SMART TEST",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.green,
                letterSpacing: 2.0,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "Computer Based Test System",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const Spacer(),

            // 3. Loading Indicator atau Versi di bawah
            const CircularProgressIndicator(
              color: Colors.green,
              strokeWidth: 3,
            ),

            const SizedBox(height: 40),

            const Text(
              "v1.0.0",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}