import 'package:flutter/material.dart';
import 'home_page.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  void _handleLogin() {
    String username = _userController.text;
    String password = _passController.text;

    // Dummy Logic Login
    if (username == "siswa" && password == "123") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username atau Password salah!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 80),
              // Logo atau Icon
              Image.asset(
                'assets/images/logo.png',
                height: 120, // Anda bisa menyesuaikan ukurannya
                width: 120,
                fit: BoxFit.contain,
                // Jika logo tidak muncul, pastikan sudah terdaftar di pubspec.yaml
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.school_rounded, size: 100, color: Colors.green);
                },
              ),
              const SizedBox(height: 20),
              const Text(
                "MS SMART TEST",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  letterSpacing: 1.5,
                ),
              ),
              const Text(
                "Computer Based Test System",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 60),

              // Form Login
              CustomTextField(
                controller: _userController,
                label: "Username",
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _passController,
                label: "Password",
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 40),

              // Button Login
              CustomButton(
                text: "MASUK",
                onPressed: _handleLogin,
              ),

              const SizedBox(height: 20),
              const Text(
                "v1.0.0",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}