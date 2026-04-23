import 'package:flutter/material.dart';
import 'package:ms_smart_test/data/common_enums.dart';
import 'package:ms_smart_test/providers/auth_provider.dart';
import 'package:ms_smart_test/ui/pages/login_page.dart';
import 'package:ms_smart_test/ui/widgets/AlertBottomSheet.dart';
import 'package:provider/provider.dart';
import 'exam_list_page.dart';
import '../widgets/home/profile_card.dart';
import '../widgets/home/rules_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _handleLogout(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    AlertBottomSheet.show(
      context: context,
      type: AlertType.warning,
      title: "Logout",
      description: "Apakah Anda yakin ingin keluar?",
      buttonText: "Ya, Logout",
      buttonBack: true,
      onPressed: () async {
        Navigator.pop(context);
        await authProvider.logout();

        if (!context.mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "MS SMART TEST",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await authProvider.getMe();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const HomeProfileSection(),
              const SizedBox(height: 16),
              const HomeRulesSection(),
              const SizedBox(height: 24),
              _buildActionButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExamListPage()),
          );
        },
        child: const Text(
          "LIHAT DAFTAR UJIAN AKTIF",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
