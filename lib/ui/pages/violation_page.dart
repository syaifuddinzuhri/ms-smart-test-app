import 'package:flutter/material.dart';
import 'login_page.dart';

class ViolationPage extends StatelessWidget {
  const ViolationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade900, // Background Merah Gelap
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Peringatan Besar
            const Icon(Icons.security_update_warning_rounded,
                size: 120, color: Colors.white),
            const SizedBox(height: 30),

            const Text(
              "AKSES TERKUNCI",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2
              ),
            ),
            const SizedBox(height: 15),

            const Text(
              "Anda terdeteksi mencoba meninggalkan aplikasi atau membuka aplikasi lain selama ujian berlangsung.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
            ),

            const SizedBox(height: 40),

            // Box Informasi Detail
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Column(
                children: [
                  Text(
                    "Pelanggaran ini telah dicatat oleh sistem pusat. Sesi ujian Anda telah dihentikan secara otomatis.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),

            // Tombol Kembali ke Login
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red.shade900,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                onPressed: () {
                  // Logic redirect ke login
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false,
                  );
                },
                child: const Text(
                  "KEMBALI KE LOGIN",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}