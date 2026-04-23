import 'package:flutter/material.dart';
import 'package:ms_smart_test/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class HomeRulesSection extends StatelessWidget {
  const HomeRulesSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan background hijau tipis agar lebih tegas
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.gavel_rounded, color: Colors.green, size: 22),
                const SizedBox(width: 10),
                Text(
                  "KETENTUAN & TATA TERTIB UJIAN",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _ruleItem("1", "Jadwal & Durasi", "Ujian hanya dapat diakses sesuai jadwal. Pastikan Anda masuk tepat waktu.")),
                    Expanded(child: _ruleItem("2", "Sistem Device Lock", "Jika terdeteksi keluar aplikasi, sesi akan otomatis TERKUNCI secara permanen.")),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Poin Tegas: Auto Submit
                    Expanded(child: _ruleItem("3", "Auto-Submit Sistem", "Jika waktu habis, seluruh jawaban akan TERKIRIM OTOMATIS ke server.", isWarning: true)),
                    // Poin Tegas: Ragu-Ragu
                    Expanded(child: _ruleItem("4", "Jawaban Ragu-Ragu", "Jawaban yang masih bertanda 'Ragu-Ragu' AKAN TETAP DIHITUNG oleh sistem.", isWarning: true)),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _ruleItem("5", "Integritas & Kejujuran", "Dilarang meminimalkan aplikasi atau membuka notifikasi selama ujian.")),
                    Expanded(child: _ruleItem("6", "Koneksi & Daya", "Pastikan internet stabil dan baterai perangkat mencukupi (Minimal 20%).")),
                  ],
                ),
              ],
            ),
          ),

          // Footer Pemantauan Aktif
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _ruleItem(String number, String title, String desc, {bool isWarning = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 11,
          backgroundColor: isWarning ? Colors.red.shade100 : Colors.green.shade100,
          child: Text(
            number,
            style: TextStyle(
                fontSize: 11,
                color: isWarning ? Colors.red.shade800 : Colors.green.shade800,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  title,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)
              ),
              const SizedBox(height: 3),
              Text(
                  desc,
                  style: TextStyle(
                    fontSize: 10,
                    color: isWarning ? Colors.red.shade700 : Colors.grey.shade600,
                    fontWeight: isWarning ? FontWeight.w500 : FontWeight.normal,
                    height: 1.3,
                  )
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Row(
        children: [
          const Icon(Icons.radar, size: 14, color: Colors.red),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "SISTEM PEMANTAUAN REAL-TIME AKTIF. SETIAP PELANGGARAN AKAN DICATAT OLEH SERVER.",
              style: TextStyle(
                  fontSize: 9,
                  color: Colors.red.shade900,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3
              ),
            ),
          ),
        ],
      ),
    );
  }
}