import 'package:flutter/material.dart';
import 'package:ms_smart_test/core/common_helper.dart';
import 'package:ms_smart_test/data/models/profile_stats.dart';
import 'package:ms_smart_test/providers/auth_provider.dart';
import 'package:ms_smart_test/ui/widgets/skeletons/profile_skeleton.dart';
import 'package:provider/provider.dart';
import 'info_column.dart';
import 'stat_card.dart';

class HomeProfileSection extends StatelessWidget {
  const HomeProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final profile = authProvider.profileData;

    if (profile == null) {
      return const ProfileSkeleton();
    }

    final user = profile.user;
    final stats = profile.stats;

    final student = user.student;

    final className = CommonHelper.formatClassroom(
      student?.classroom.name,
      student?.classroom.major.name,
    );

    final gender = CommonHelper.formatGender(student?.gender);

    final birth = CommonHelper.formatBirth(student?.pob, student?.dob);

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
          _buildHeader(user.name, student?.nisn),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InfoColumn(label: "KELAS & JURUSAN", value: className),
              InfoColumn(label: "JENIS KELAMIN", value: gender),
              InfoColumn(label: "TEMPAT/TANGGAL LAHIR", value: birth),
            ],
          ),
          const SizedBox(height: 20),
          _buildStatGrid(stats),
        ],
      ),
    );
  }

  Widget _buildHeader(String name, String? nisn) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundColor: Color(0xFFE8F5E9),
          child: Icon(Icons.person, color: Colors.green, size: 35),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Text("NISN: ${nisn ?? '-'}",
                  style: const TextStyle(color: Colors.grey)),
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

  Widget _buildStatGrid(ProfileStats stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.5,
      children:  [
        StatCard(title: "BELUM DIKERJAKAN", value: "${stats.examsPending} Ujian", icon: Icons.assignment_late_outlined, bgColor: Color(0xFFFFFDE7), iconColor: Colors.orange),
        StatCard(title: "SELESAI DIKERJAKAN", value: "${stats.examsPending} Ujian", icon: Icons.assignment_turned_in_outlined, bgColor: Color(0xFFE3F2FD), iconColor: Colors.blue),
        StatCard(title: "SKOR TERTINGGI", value: "${stats.examsPending} Ujian", icon: Icons.emoji_events_outlined, bgColor: Color(0xFFE8F5E9), iconColor: Colors.teal),
        StatCard(title: "SKOR RATA-RATA", value: "${stats.examsPending} Ujian", icon: Icons.bar_chart_outlined, bgColor: Color(0xFFF3E5F5), iconColor: Colors.purple),
      ],
    );
  }
}