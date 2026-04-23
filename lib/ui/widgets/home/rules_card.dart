import 'package:flutter/material.dart';

class HomeRulesSection extends StatelessWidget {
  const HomeRulesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER SECTION ---
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.gavel_rounded, color: Colors.green, size: 20),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ketentuan & Tata Tertib",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "Harap baca dengan teliti sebelum ujian",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 0.5),

          // --- RULES GRID ---
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildModernRuleItem(
                        "1", "Jadwal & Durasi",
                        "Akses sesuai jadwal. Masuklah tepat waktu.",
                        Icons.timer_outlined, Colors.blue
                    ),
                    const SizedBox(width: 16),
                    _buildModernRuleItem(
                        "2", "Device Lock",
                        "Keluar aplikasi akan mengunci sesi Anda.",
                        Icons.phonelink_lock_rounded, Colors.purple
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildModernRuleItem(
                        "3", "Auto-Submit",
                        "Waktu habis, jawaban otomatis terkirim.",
                        Icons.cloud_upload_outlined, Colors.orange, isWarning: true
                    ),
                    const SizedBox(width: 16),
                    _buildModernRuleItem(
                        "4", "Ragu-Ragu",
                        "Tanda ragu-ragu akan tetap dihitung.",
                        Icons.flag_outlined, Colors.red, isWarning: true
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildModernRuleItem(
                        "5", "Integritas",
                        "Dilarang minimize atau buka notifikasi.",
                        Icons.verified_user_outlined, Colors.teal
                    ),
                    const SizedBox(width: 16),
                    _buildModernRuleItem(
                        "6", "Daya & Koneksi",
                        "Baterai min. 20% dan internet stabil.",
                        Icons.battery_charging_full_rounded, Colors.green
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- FOOTER SECTION (LIVE MONITORING) ---
          _buildLiveMonitoringFooter(),
        ],
      ),
    );
  }

  Widget _buildModernRuleItem(String number, String title, String desc, IconData icon, Color color, {bool isWarning = false}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "$number.",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: isWarning ? Colors.red.shade400 : Colors.green.shade400
                ),
              ),
              const SizedBox(width: 6),
              Icon(icon, size: 16, color: color.withOpacity(0.8)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: TextStyle(
                fontSize: 10,
                color: isWarning ? Colors.red.shade700 : Colors.grey.shade600,
                height: 1.4,
                fontWeight: isWarning ? FontWeight.w500 : FontWeight.normal
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveMonitoringFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50.withOpacity(0.5),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          // Pulsing Effect (Simulasi dengan kontainer statis)
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "SISTEM PEMANTAUAN REAL-TIME AKTIF\nSEGALA BENTUK PELANGGARAN DICATAT OTOMATIS",
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: Colors.red,
                  letterSpacing: 0.5,
                  height: 1.3
              ),
            ),
          ),
        ],
      ),
    );
  }
}