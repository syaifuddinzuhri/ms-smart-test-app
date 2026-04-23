import 'package:flutter/material.dart';
import 'package:ms_smart_test/providers/exam_provider.dart';
import 'package:provider/provider.dart';
import '../../../data/models/exam_model.dart';
import '../widgets/exam_list/exam_card.dart';

class ExamListPage extends StatefulWidget {
  const ExamListPage({super.key});

  @override
  State<ExamListPage> createState() => _ExamListPageState();
}

class _ExamListPageState extends State<ExamListPage> {

  @override
  void initState() {
    super.initState();
   _loadData('pending');
  }

  void _loadData(String status) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExamProvider>().fetchExams(status);
    });
  }

  @override
  Widget build(BuildContext context) {
    final examProvider = context.watch<ExamProvider>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(140),
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
                      onTap: (index) {
                        // Load data tiap kali tab diklik
                        if (index == 0) _loadData('pending');
                        if (index == 1) _loadData('active');
                        if (index == 2) _loadData('completed');
                      },
                      tabs: const [
                        Tab(text: "Tersedia"),
                        Tab(text: "Sedang Berlangsung"),
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
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildList(context, 'pending'),
                  _buildList(context, 'active'),
                  _buildList(context, 'completed'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, String status) {
    final examProvider = context.watch<ExamProvider>();
    final list = examProvider.getExamsByStatus(status);

    // 1. KONDISI: SEDANG LOADING PERTAMA KALI (Data benar-benar belum ada)
    if (examProvider.isLoading && list.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.green),
      );
    }

    // 2. KONDISI: SELESAI LOADING TAPI DATA TETAP KOSONG (Empty State)
    if (!examProvider.isLoading && list.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => examProvider.fetchExams(status),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_turned_in_rounded,
                      size: 80, color: Colors.grey.shade200),
                  const SizedBox(height: 16),
                  const Text(
                    "Tidak ada ujian",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Tarik ke bawah untuk menyegarkan",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // 3. KONDISI: DATA ADA (Happy Path)
    // RefreshIndicator tetap membungkus ListView agar pull-to-refresh berfungsi
    return RefreshIndicator(
      onRefresh: () => examProvider.fetchExams(status),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (context, index) => ExamCard(exam: list[index], status: status),
      ),
    );
  }
}