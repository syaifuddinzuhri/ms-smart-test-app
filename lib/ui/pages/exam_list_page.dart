import 'package:flutter/material.dart';
import '../../../data/models/exam_model.dart';
import '../widgets/exam_list/exam_card.dart';

class ExamListPage extends StatelessWidget {
  const ExamListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data Tetap Sama
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              color: Colors.white,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded, // Icon back yang lebih modern
                  color: Colors.black87,
                  size: 20,
                ),
              ),
            ),
          ),
          title: const Text(
            "DAFTAR UJIAN",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w900,
              fontSize: 18,
              letterSpacing: 1,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade600,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                tabs: const [
                  Tab(text: "Tersedia"),
                  Tab(text: "Sedang"),
                  Tab(text: "Selesai"),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
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

    // JIKA DATA KOSONG
    if (filteredList.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        child: ListView( // Wajib pakai ListView agar bisa di-scroll untuk memicu refresh
          physics: const AlwaysScrollableScrollPhysics(), // Memaksa scroll walau data kosong
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.assignment_turned_in_rounded, size: 80, color: Colors.grey.shade200),
                    const SizedBox(height: 16),
                    Text("Tidak ada ujian", style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // JIKA DATA ADA
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        // Panggil fungsi ambil data API Anda di sini nanti
      },
      child: ListView.builder(
        // physics: AlwaysScrollableScrollPhysics() memastikan pull-to-refresh
        // tetap aktif meskipun jumlah item sedikit.
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: filteredList.length,
        itemBuilder: (context, index) => ExamCard(exam: filteredList[index]),
      ),
    );
  }
}