import 'package:flutter/material.dart';
import 'package:ms_smart_test/data/common_enums.dart';
import 'package:ms_smart_test/providers/auth_provider.dart';
import 'package:ms_smart_test/ui/widgets/AlertBottomSheet.dart';
import 'package:ms_smart_test/ui/widgets/loading_dialog.dart';
import 'package:ms_smart_test/ui/widgets/loading_overlay.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();

    _userController.addListener(() {
      setState(() {});
    });

    _passController.addListener(() {
      setState(() {});
    });
  }

  void _handleLogin() async {
    FocusScope.of(context).unfocus();

    String username = _userController.text;
    String password = _passController.text;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    bool success = await authProvider.login(username, password);

    if (success) {
      // Navigator.pop(context);
      // await Future.delayed(const Duration(milliseconds: 200));

      if (!context.mounted) return;

      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
            (route) => false,
      );
    } else {
      AlertBottomSheet.show(
        context: context,
        type: AlertType.error,
        description: authProvider.error ?? "Terjadi kesalahan",
        buttonText: "Coba Lagi",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return LoadingOverlay(
      isLoading: authProvider.isLoading,
      text: "Menunggu proses...",
      child: Scaffold(
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
                    return const Icon(
                      Icons.school_rounded,
                      size: 100,
                      color: Colors.green,
                    );
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
                  isDisabled:
                      _userController.text.isEmpty ||
                      _passController.text.isEmpty,
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
      ),
    );
  }
}
