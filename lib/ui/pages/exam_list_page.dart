import 'package:flutter/material.dart';
import '../../../data/models/exam_model.dart';
import '../widgets/exam_list/exam_card.dart';

class ExamListPage extends StatelessWidget {
  const ExamListPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          title: const Text("DAFTAR UJIAN", style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.green,
            tabs: [
              Tab(text: "Tersedia"),
              Tab(text: "Berlangsung"),
              Tab(text: "Selesai"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(allExams, ExamStatus.Pending),
            _buildList(allExams, ExamStatus.Ongoing),
            _buildList(allExams, ExamStatus.Completed),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<Exam> list, ExamStatus filter) {
    final filteredList = list.where((e) => e.status == filter).toList();

    if (filteredList.isEmpty) {
      return const Center(child: Text("Tidak ada ujian dalam status ini", style: TextStyle(color: Colors.grey)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredList.length,
      itemBuilder: (context, index) => ExamCard(exam: filteredList[index]),
    );
  }
}