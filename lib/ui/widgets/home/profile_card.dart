import 'package:flutter/material.dart';
import 'info_column.dart';
import 'stat_card.dart';

class HomeProfileSection extends StatelessWidget {
  const HomeProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InfoColumn(label: "KELAS & JURUSAN", value: "XII - Teknik Informatika"),
              InfoColumn(label: "JENIS KELAMIN", value: "Laki-laki"),
              InfoColumn(label: "TEMPAT/TANGGAL LAHIR", value: "-"),
            ],
          ),
          const SizedBox(height: 20),
          _buildStatGrid(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundColor: Color(0xFFE8F5E9),
          child: Icon(Icons.person, color: Colors.green, size: 35),
        ),
        const SizedBox(width: 15),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Tester", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("NISN: 1234567898", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        _buildActiveBadge(),
      ],
    );
  }

  Widget _buildActiveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(20)),
      child: const Row(
        children: [
          CircleAvatar(radius: 4, backgroundColor: Colors.green),
          SizedBox(width: 5),
          Text("Aktif", style: TextStyle(color: Colors.green, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildStatGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.5,
      children: const [
        StatCard(title: "BELUM DIKERJAKAN", value: "0 Ujian", icon: Icons.assignment_late_outlined, bgColor: Color(0xFFFFFDE7), iconColor: Colors.orange),
        StatCard(title: "SELESAI DIKERJAKAN", value: "1 Ujian", icon: Icons.assignment_turned_in_outlined, bgColor: Color(0xFFE3F2FD), iconColor: Colors.blue),
        StatCard(title: "SKOR TERTINGGI", value: "0.0", icon: Icons.emoji_events_outlined, bgColor: Color(0xFFE8F5E9), iconColor: Colors.teal),
        StatCard(title: "SKOR RATA-RATA", value: "0.0", icon: Icons.bar_chart_outlined, bgColor: Color(0xFFF3E5F5), iconColor: Colors.purple),
      ],
    );
  }
}