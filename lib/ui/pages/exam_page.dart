import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ms_smart_test/core/main_navigator.dart';
import 'package:ms_smart_test/ui/pages/home_page.dart';
import 'package:ms_smart_test/ui/pages/violation_page.dart';
import 'package:ms_smart_test/ui/widgets/exam/exam_app_bar.dart';
import 'package:ms_smart_test/ui/widgets/exam/exam_bottom_navbar.dart';
import 'package:ms_smart_test/ui/widgets/exam/exam_info_bar.dart';
import 'package:ms_smart_test/ui/widgets/exam/exam_question_renderer.dart';
import 'package:ms_smart_test/ui/widgets/exam/exam_sheets.dart';
import '../../data/models/question_model.dart';
import '../../services/security_service.dart';
import '../widgets/option_tile.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({super.key});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> with WidgetsBindingObserver {
  int _currentIndex = 0;
  bool _isSecureActive = false;
  late Timer _timer;
  int _secondsRemaining = 3600; // Contoh: 60 menit (3600 detik)
  bool _isViolationDetected = false; // Flag untuk mencegah alert ganda

  final TextEditingController _textController = TextEditingController();

  final List<Question> _questions = [
    Question(
      id: 1,
      type: QuestionType.single,
      text: "Apa ibukota Indonesia?",
      options: ["Jakarta", "IKN", "Bandung", "Surabaya"],
    ),
    Question(
      id: 2,
      type: QuestionType.multiple,
      text: "Pilih warna bendera Indonesia (Pilih 2):",
      options: ["Merah", "Kuning", "Putih", "Biru"],
      selectedAnswers: [],
    ),
    Question(
      id: 3,
      type: QuestionType.trueFalse,
      text: "Matahari terbit dari sebelah barat.",
      options: ["Benar", "Salah"],
    ),
    Question(
      id: 4,
      type: QuestionType.shortAnswer,
      text: "Sebutkan nama presiden pertama Indonesia!",
    ),
    Question(
      id: 5,
      type: QuestionType.essay,
      text: "Jelaskan sejarah singkat kemerdekaan Indonesia!",
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _activateSecurity();
    _loadTextAnswer();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel(); // Hentikan timer saat keluar
    WidgetsBinding.instance.removeObserver(this);
    _textController.dispose();
    super.dispose();
  }

  void _loadTextAnswer() {
    _textController.text = _questions[_currentIndex].textAnswer;
  }

  Future<void> _activateSecurity() async {
    try {
      await SecurityService.startSecureMode();

      // KUNCI PERBAIKAN: Jika user keluar halaman sebelum proses selesai, stop di sini.
      if (!mounted) return;

      setState(() => _isSecureActive = true);
    } catch (e) {
      debugPrint("Security Error: $e");
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
        _autoSubmit();
      }
    });
  }

  // Fungsi format detik ke HH:mm:ss
  String _formatTime(int seconds) {
    int h = seconds ~/ 3600;
    int m = (seconds % 3600) ~/ 60;
    int s = seconds % 60;
    return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  void _autoSubmit() async {
    // 1. Matikan keamanan segera
    await SecurityService.stopSecureMode();

    if (!mounted) return;

    // 2. Tampilkan Bottom Sheet Waktu Habis
    ExamSheets.showTimeOutSheet(
      context: context,
      onFinish: () {
        // Redirect ke Dashboard (HomePage) dan hapus semua tumpukan halaman
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
        );
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted || !_isSecureActive || _isViolationDetected) return;

    // Deteksi jika aplikasi kehilangan fokus (minimize/notifikasi)
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      _handleViolation();
    }
  }

  void _handleViolation() async {
    setState(() => _isViolationDetected = true);

    // 1. Matikan Kiosk Mode segera
    await SecurityService.stopSecureMode();

    // 2. Arahkan ke halaman Pelanggaran (bukan dialog)
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ViolationPage()),
            (route) => false, // Hapus semua riwayat halaman agar tidak bisa back
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: ExamAppBar(
          title: "Ujian Matematika",
          remainingTime: _formatTime(_secondsRemaining),
          isTimeCritical: _secondsRemaining < 300,
        ),
        body: Column(
          children: [
            ExamInfoBar(
              currentIndex: _currentIndex,
              totalQuestions: _questions.length,
              questionType: question.type.name,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(question.text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 25),
                    ExamQuestionRenderer(
                      question: question,
                      textController: _textController,
                      onUpdate: (fn) => setState(fn),
                    ),
                  ],
                ),
              ),
            ),
            // GUNAKAN KOMPONEN BARU
            ExamBottomNavbar(
              isFlagged: question.isFlagged,
              currentIndex: _currentIndex,
              totalQuestions: _questions.length,
              onFlagChanged: (v) => setState(() => question.isFlagged = v!),
              onPrev: _currentIndex == 0 ? null : () {
                setState(() => _currentIndex--);
                _loadTextAnswer();
              },
              onNext: _currentIndex == _questions.length - 1 ? null : () {
                setState(() => _currentIndex++);
                _loadTextAnswer();
              },
              onNavTap: () => ExamSheets.showNavigation(
                context: context,
                questions: _questions,
                currentIndex: _currentIndex,
                onQuestionTap: (index) {
                  setState(() => _currentIndex = index);
                  _loadTextAnswer();
                },
              ),
              onSubmitTap: () => ExamSheets.showConfirmSubmit(
                context: context,
                questions: _questions,
                onConfirm: () async {
                  await SecurityService.stopSecureMode();
                  if (!mounted) return;

                    Navigator.pop(context); // Tutup Sheet
                    Navigator.pop(context); // Keluar Ujian

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
