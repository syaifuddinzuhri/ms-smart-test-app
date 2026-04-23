import 'package:flutter/material.dart';
import 'package:ms_smart_test/core/common_helper.dart';
import 'package:ms_smart_test/data/models/profile_stats.dart';
import 'package:ms_smart_test/providers/auth_provider.dart';
import 'package:ms_smart_test/ui/widgets/skeletons/profile_skeleton.dart';
import 'package:provider/provider.dart';

class HomeProfileSection extends StatelessWidget {
  const HomeProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final profile = authProvider.profileData;

    if (profile == null) return const ProfileSkeleton();

    final user = profile.user;
    final stats = profile.stats;
    final student = user.student;

    return Column(
      children: [
        // 1. MAIN PROFILE CARD
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.green.shade700, Colors.green.shade500],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Stack(
            children: [
              // Aksesoris Dekorasi (Lingkaran transparan di background)
              Positioned(
                right: -20,
                top: -20,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white.withOpacity(0.1),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildTopHeader(user.name, student?.nisn, student?.gender ?? 'male'),
                    const SizedBox(height: 24),
                    _buildInfoGrid(student),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 2. STATS GRID SECTION
        _buildModernStatGrid(stats),
      ],
    );
  }

  Widget _buildTopHeader(String name, String? nisn, String gender) {
    String getStudentAvatar(String? gender) {
      if (gender == 'female') {
        return 'assets/images/female.png';
      }
      return 'assets/images/male.png';
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child:CircleAvatar(
            radius: 32,
            backgroundColor: Colors.grey.shade200,
            child: ClipOval(
              child: Image.asset(
                getStudentAvatar(gender),
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Selamat Datang,",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "NISN: ${nisn ?? '-'}",
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.verified_user, color: Colors.green, size: 20),
    );
  }

  Widget _buildInfoGrid(dynamic student) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _infoItem(Icons.class_outlined, "Kelas", CommonHelper.formatClassroom(student?.classroom?.name, student?.classroom?.major?.code)),
          _infoItem(Icons.transgender_rounded, "Gender", CommonHelper.formatGender(student?.gender)),
          _infoItem(Icons.location_on_outlined, "Tempat/Tanggal Lahir", CommonHelper.formatBirth(student?.pob, student?.dob)),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildModernStatGrid(ProfileStats stats) {
    return GridView.count(
      crossAxisCount: 2, // 2 kolom
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.3, // Membuat bentuk menjadi persegi panjang horizontal
      children: [
        _statCard("Ujian Tersedia", "${stats.examsPending}", Icons.pending_actions_rounded, Colors.orange),
        _statCard("Ujian Selesai", "${stats.examsDone}", Icons.task_alt_rounded, Colors.blue),
        _statCard("Skor Tertinggi", "${stats.highestScore}", Icons.auto_awesome_rounded, Colors.teal),
        _statCard("Skor Rata-rata", "${stats.averageScore}", Icons.insights_rounded, Colors.purple),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // Icon di sisi kiri dengan background transparan berwarna
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          // Text di sisi kanan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}