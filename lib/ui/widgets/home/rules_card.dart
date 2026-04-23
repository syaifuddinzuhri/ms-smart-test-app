import 'package:flutter/material.dart';

class HomeRulesSection extends StatelessWidget {
  const HomeRulesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.green, size: 20),
                SizedBox(width: 10),
                Text("KETENTUAN & TATA TERTIB UJIAN", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
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
                    Expanded(child: _ruleItem("1", "Jadwal & Durasi", "Ujian hanya dapat diakses sesuai jadwal.")),
                    Expanded(child: _ruleItem("3", "Sistem Device Lock", "Pelanggaran akan mengunci sesi otomatis.")),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _ruleItem("2", "Integritas & Kejujuran", "Dilarang pindah tab/minimize aplikasi.")),
                    Expanded(child: _ruleItem("4", "Koneksi & Daya", "Pastikan internet stabil dan baterai cukup.")),
                  ],
                ),
              ],
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _ruleItem(String number, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: Colors.amber.shade100,
          child: Text(number, style: const TextStyle(fontSize: 12, color: Colors.amber, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              Text(desc, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12))),
      child: const Row(
        children: [
          CircleAvatar(radius: 4, backgroundColor: Colors.green),
          SizedBox(width: 10),
          Text("SISTEM PEMANTAUAN AKTIF SELAMA UJIAN BERLANGSUNG", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}