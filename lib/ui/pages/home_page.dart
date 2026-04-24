import 'package:flutter/material.dart';
import 'package:ms_smart_test/data/common_enums.dart';
import 'package:ms_smart_test/providers/auth_provider.dart';
import 'package:ms_smart_test/providers/exam_provider.dart';
import 'package:ms_smart_test/ui/pages/login_page.dart';
import 'package:ms_smart_test/ui/widgets/AlertBottomSheet.dart';
import 'package:provider/provider.dart';
import 'exam_list_page.dart';
import '../widgets/home/profile_card.dart';
import '../widgets/home/rules_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    _pauseOngoingSessions();
  }

  void _pauseOngoingSessions() {
    // Gunakan addPostFrameCallback agar dijalankan setelah frame pertama selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExamProvider>().pauseActiveSessions();
      context.read<ExamProvider>().fetchExams('active');
    });
  }

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
    final examProvider = context.read<ExamProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: Colors.grey.shade100, height: 1),
          ),
          title: Row(
            children: [
              // Logo Mini
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 24,
                  color: Colors.green.shade700,
                  colorBlendMode: BlendMode.srcIn,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.school_rounded, color: Colors.green, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              // Tipografi Judul
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                  children: [
                    TextSpan(
                      text: "MS ",
                      style: TextStyle(color: Colors.black87),
                    ),
                    TextSpan(
                      text: "SMART TEST",
                      style: TextStyle(color: Colors.green.shade500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            // Tombol Logout dengan Circle Background
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Material(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _handleLogout(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        Icons.logout_rounded,
                        color: Colors.red.shade600,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await authProvider.getMe();
          await examProvider.pauseActiveSessions();
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
          "LIHAT DAFTAR UJIAN",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
