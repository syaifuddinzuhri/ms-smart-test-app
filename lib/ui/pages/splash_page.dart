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

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Inisialisasi Animasi
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
    _init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    // Beri waktu animasi berjalan
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool isAuth = await authProvider.checkAuth();

    if (!mounted) return;

    if (isAuth) {
      _navigateTo(const HomePage());
    } else {
      _navigateTo(const LoginPage());
    }
  }

  void _navigateTo(Widget page) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Gradient Modern
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.green.shade800,
                  Colors.green.shade600,
                  Colors.green.shade900,
                ],
              ),
            ),
          ),

          // 2. Elemen Dekoratif (Lingkaran Abu-abu Transparan)
          Positioned(
            top: -100,
            right: -100,
            child: CircleAvatar(
              radius: 200,
              backgroundColor: Colors.white.withOpacity(0.05),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: Colors.black.withOpacity(0.05),
            ),
          ),

          // 3. Konten Utama
          SizedBox(
            width: double.infinity,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo dengan efek bayangan (glow)
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.shade600,
                            blurRadius: 20,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 140,
                        height: 140,
                        color: Colors.white, // Logo jadi putih agar elegan
                        colorBlendMode: BlendMode.srcIn,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.school, size: 100, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Nama Aplikasi
                    const Text(
                      "MS SMART TEST",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Solusi Ujian Online Terpadu",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. Loading & Version di Bottom
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "v1.0.0",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}