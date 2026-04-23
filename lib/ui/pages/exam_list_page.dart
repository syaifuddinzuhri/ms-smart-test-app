import 'package:flutter/material.dart';
import '../../../data/models/exam_model.dart';
import '../widgets/exam_list/exam_card.dart';

class ExamListPage extends StatelessWidget {
  const ExamListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    final List<Exam> allExams = [
      Exam(title: "UTS Matematika", subject: "Matematika Dasar", duration: "90 Menit", startAt: "08:00", endAt: "09:30", status: ExamStatus.Pending),
      Exam(title: "Ujian Harian Inggris", subject: "Bahasa Inggris", duration: "45 Menit", startAt: "10:00", endAt: "10:45", status: ExamStatus.Ongoing),
      Exam(title: "Try Out Fisika", subject: "Fisika Modern", duration: "120 Menit", startAt: "13:00", endAt: "15:00", status: ExamStatus.Completed, score: 85.5, resultStatus: "Lulus"),
      Exam(title: "Kuis Kimia", subject: "Kimia", duration: "30 Menit", startAt: "09:00", endAt: "09:30", status: ExamStatus.Completed, score: 55.0, resultStatus: "Tidak Lulus"),
    ];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        // --- CUSTOM MODERN GRADIENT APPBAR ---
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(140), // Tinggi ditambah untuk TabBar
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green.shade800,
                  Colors.green.shade600,
                ],
              ),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Row Atas (Back Button & Title)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            "DAFTAR UJIAN",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48), // Penyeimbang IconButton
                      ],
                    ),
                  ),
                  // TabBar Modern (Pill Style)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelColor: Colors.green.shade800,
                      unselectedLabelColor: Colors.white,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      tabs: const [
                        Tab(text: "Tersedia"),
                        Tab(text: "Sedang"),
                        Tab(text: "Selesai"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                children: [
                  _buildList(context, allExams, ExamStatus.Pending),
                  _buildList(context, allExams, ExamStatus.Ongoing),
                  _buildList(context, allExams, ExamStatus.Completed),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<Exam> list, ExamStatus filter) {
    final filteredList = list.where((e) => e.status == filter).toList();

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: filteredList.isEmpty
          ? ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_turned_in_rounded, size: 80, color: Colors.grey.shade200),
                  const SizedBox(height: 16),
                  const Text(
                    "Tidak ada ujian",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
          : ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: filteredList.length,
        itemBuilder: (context, index) => ExamCard(exam: filteredList[index]),
      ),
    );
  }
}