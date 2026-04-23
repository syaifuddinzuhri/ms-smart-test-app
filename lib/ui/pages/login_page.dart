import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ms_smart_test/data/common_enums.dart';
import 'package:ms_smart_test/providers/auth_provider.dart';
import 'package:ms_smart_test/ui/widgets/AlertBottomSheet.dart';
import 'package:ms_smart_test/ui/widgets/loading_overlay.dart';
import 'home_page.dart';
import '../widgets/custom_button.dart';

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
    _userController.addListener(() => setState(() {}));
    _passController.addListener(() => setState(() {}));
  }

  void _handleLogin() async {
    FocusScope.of(context).unfocus();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    bool success = await authProvider.login(_userController.text, _passController.text);

    if (success) {
      Navigator.pop(context);

      if (!mounted) return;
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
    final size = MediaQuery.of(context).size;

    return LoadingOverlay(
      isLoading: authProvider.isLoading,
      text: "Menunggu proses...",
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // 1. Background Hijau Melengkung
                  CustomPaint(
                    size: Size(size.width, 380), // Tinggi header ditambah untuk teks
                    painter: HeaderPainter(),
                  ),

                  // 2. Konten Logo dan Judul
                  SafeArea(
                    child: SizedBox(
                      width: size.width,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          // Di dalam LoginPage, ubah bagian Image.asset menjadi:
                          Image.asset(
                            'assets/images/logo.png',
                            height: 100,
                            color: Colors.white, // MEMAKSA LOGO MENJADI PUTIH
                            colorBlendMode: BlendMode.srcIn, // Mengisi seluruh bentuk logo dengan warna di atas
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.school, size: 80, color: Colors.white),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "MS SMART TEST",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const Text(
                            "Solusi Ujian Online Terpadu",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 3. Card Login
                  Padding(
                    padding: EdgeInsets.only(
                      top: 240, // Mengatur posisi card agar menimpa kurva
                      left: 25,
                      right: 25,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Masuk sebagai peserta",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 30),

                          _buildModernTextField(
                            controller: _userController,
                            label: "Username",
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 20),
                          _buildModernTextField(
                            controller: _passController,
                            label: "Kata Sandi",
                            icon: Icons.lock_outline,
                            isPassword: true,
                          ),

                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: CustomButton(
                              text: "MASUK",
                              isDisabled: _userController.text.isEmpty || _passController.text.isEmpty,
                              onPressed: _handleLogin,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
              const Text("v1.0.0", style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: "Masukkan ${label.toLowerCase()}",
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: Icon(icon, color: Colors.green, size: 20),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
      ],
    );
  }
}

class HeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. MEMBUAT GRADIENT UNTUK BACKROUND UTAMA
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    Paint paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.green.shade800, // Hijau Tua
          Colors.green.shade500, // Hijau Terang
        ],
      ).createShader(rect);

    // 2. MEMBUAT PATH UNTUK LENGKUNGAN HEADER
    Path path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.close();

    // Gambar background utama
    canvas.drawPath(path, paint);

    // 3. MENGGAMBAR LINGKARAN DEKORATIF
    // Kita gunakan clipPath agar lingkaran tidak "bocor" ke area putih di bawah
    canvas.save();
    canvas.clipPath(path);

    Paint circlePaint = Paint()..color = Colors.white.withOpacity(0.1);

    // Lingkaran 1 (Atas Kiri)
    canvas.drawCircle(
        Offset(size.width * 0.1, size.height * 0.1),
        80,
        circlePaint
    );

    // Lingkaran 2 (Tengah Kanan)
    canvas.drawCircle(
        Offset(size.width * 0.9, size.height * 0.6),
        90,
        circlePaint..color = Colors.white.withOpacity(0.05)
    );

    // Lingkaran 3 (Dekat lengkungan bawah)
    canvas.drawCircle(
        Offset(size.width * 0.5, size.height * 0.8),
        60,
        circlePaint..color = Colors.white.withOpacity(0.08)
    );

    // Lingkaran 4 (Kecil di pojok kanan atas)
    canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.05),
        40,
        circlePaint..color = Colors.white.withOpacity(0.05)
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}