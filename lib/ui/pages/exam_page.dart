import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ms_smart_test/core/main_navigator.dart';
import 'package:ms_smart_test/data/models/exam_model.dart';
import 'package:ms_smart_test/providers/exam_provider.dart';
import 'package:ms_smart_test/ui/pages/home_page.dart';
import 'package:ms_smart_test/ui/pages/violation_page.dart';
import 'package:ms_smart_test/ui/widgets/exam/exam_app_bar.dart';
import 'package:ms_smart_test/ui/widgets/exam/exam_bottom_navbar.dart';
import 'package:ms_smart_test/ui/widgets/exam/exam_info_bar.dart';
import 'package:ms_smart_test/ui/widgets/exam/exam_loading_skeleton.dart';
import 'package:ms_smart_test/ui/widgets/exam/exam_question_renderer.dart';
import 'package:ms_smart_test/ui/widgets/exam/exam_sheets.dart';
import 'package:ms_smart_test/ui/widgets/loading_overlay.dart';
import 'package:provider/provider.dart';
import '../../data/models/question_model.dart';
import '../../services/security_service.dart';
import '../widgets/option_tile.dart';

class ExamPage extends StatefulWidget {
  final ExamModel exam;
  const ExamPage({super.key, required this.exam});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> with WidgetsBindingObserver {
  int _currentIndex = 0;
  bool _isSecureActive = false;

  bool _isViolationDetected = false;
  bool _isLoadingSession = true;
  double _fontSizeMultiplier = 1.3;

  Timer? _timer;
  int _secondsRemaining = 0;

  List<QuestionModel> _questions = [];

  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _activateSecurity();
    _loadInitialData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _textController.dispose();
    super.dispose();
  }

  void _increaseFontSize() {
    if (_fontSizeMultiplier < 2.0) {
      setState(() => _fontSizeMultiplier += 0.3);
    }
  }

  void _decreaseFontSize() {
    if (_fontSizeMultiplier > 1.0) {
      setState(() => _fontSizeMultiplier -= 0.3);
    }
  }

  void _loadTextAnswer() {
    if (_questions.isNotEmpty) {
      _textController.text = _questions[_currentIndex].textAnswer;
    }
  }

  Future<void> _activateSecurity() async {
    try {
      await SecurityService.startSecureMode();

      if (!mounted) return;

      setState(() => _isSecureActive = true);
    } catch (e) {
      debugPrint("Security Error: $e");
    }
  }

  Future<void> _loadInitialData({bool isRefresh = false}) async {
    try {
      final provider = context.read<ExamProvider>();

      final result = await provider.fetchExamQuestions(widget.exam.id);

      await provider.fetchAndSyncAnswers(widget.exam.id);

      if (!mounted) return;

      if (provider.questions.isEmpty) {
        throw "Soal tidak ditemukan atau kosong";
      }

      setState(() {
        _questions = provider.questions;
        _secondsRemaining = result['seconds'];
        _isLoadingSession = false;
      });

      if (!isRefresh) {
        _startTimer();
      }

      _loadTextAnswer();
    } catch (e) {
      debugPrint("Error load data: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
      Navigator.of(context).pop();
    }
  }

  Future<void> _handleRefresh() async {
    await _loadInitialData(isRefresh: true);
  }

  void _startTimer() {
    _timer?.cancel();
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

  String _formatTime(int seconds) {
    int h = seconds ~/ 3600;
    int m = (seconds % 3600) ~/ 60;
    int s = seconds % 60;
    return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  void _autoSubmit() async {
    await SecurityService.stopSecureMode();

    // Hit API Finalize dengan is_timeout = true
    await context.read<ExamProvider>().finalizeExam(
      widget.exam.id,
      isTimeout: true,
    );

    if (!mounted) return;

    ExamSheets.showTimeOutSheet(
      context: context,
      onFinish: () {
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
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _handleViolation();
    }
  }

  void _handleViolation() async {
    setState(() => _isViolationDetected = true);

    await SecurityService.stopSecureMode();

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ViolationPage(examId: widget.exam.id),
        ),
        (route) => false,
      );
    }
  }

  bool _shouldSync(QuestionModel q) {
    // Cek apakah ada jawaban berdasarkan tipe
    bool hasAnswer = false;
    switch (q.type) {
      case QuestionType.single_choice:
      case QuestionType.true_false:
        hasAnswer = q.selectedAnswerIndex != null;
        break;
      case QuestionType.multiple_choice:
        hasAnswer = q.selectedAnswerIndices.isNotEmpty;
        break;
      case QuestionType.short_answer:
      case QuestionType.essay:
        hasAnswer = q.textAnswer.trim().isNotEmpty;
        break;
      default:
        hasAnswer = false;
    }

    // Syarat Sync: Ada Jawaban ATAU Ditandai Ragu-ragu
    return hasAnswer || q.isFlagged;
  }

  Future<void> _navigateToStep(int newIndex) async {
    final provider = context.read<ExamProvider>();
    final questionToSave = _questions[_currentIndex];

    // 1. PINDAH HALAMAN DULU (Instant UX)
    setState(() {
      _currentIndex = newIndex;
      _loadTextAnswer();
    });
    FocusScope.of(context).unfocus();

    if (_shouldSync(questionToSave)) {
      // 2. JALANKAN SIMPAN DI BACKGROUND
      provider.syncAnswer(questionToSave).then((success) {
        if (!mounted) return;

        if (!success) {
          // ALERT GAGAL: Gunakan SnackBar Merah
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: const [
                  Icon(Icons.error_outline, color: Colors.white),
                  SizedBox(width: 10),
                  Text("Gagal sinkronisasi jawaban! Cek koneksi."),
                ],
              ),
              backgroundColor: Colors.red.shade700,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          // ALERT BERHASIL: SnackBar Hijau Kecil (Opsional)
          // Biasanya untuk "Next/Prev" sukses tidak perlu alert agar tidak berisik,
          // tapi ini kodenya jika Anda tetap ingin muncul:
          /*
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Jawaban tersimpan"),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 500),
            behavior: SnackBarBehavior.floating,
          ),
        );
        */
        }
      });
    }
  }

  Future<void> _handleFinalizeExam() async {
    // Tutup BottomSheet konfirmasi dulu
    Navigator.pop(context);

    try {
      final provider = context.read<ExamProvider>();

      // API Call (Ini akan memicu isLoading = true di Provider)
      bool success = await provider.finalizeExam(widget.exam.id);

      if (success) {
        // Matikan keamanan
        await SecurityService.stopSecureMode();

        if (!mounted) return;

        // Kembali ke Dashboard
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Ujian berhasil diselesaikan!"),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 500),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 10),
                Text("Gagal mengirim hasil: $e")
              ],
            ),
            backgroundColor: Colors.red.shade700,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final examProvider = context.watch<ExamProvider>();

    if (_isLoadingSession || _questions.isEmpty) {
      return const Scaffold(body: ExamLoadingSkeleton());
    }

    final question = _questions[_currentIndex];

    return LoadingOverlay(
      isLoading: examProvider.isLoadingFinalized,
      text: "Sedang mengirim hasil ujian...",
      child: PopScope(
        canPop: false,
        child: Scaffold(
          appBar: _isLoadingSession
              ? null
              : ExamAppBar(
                  title: widget.exam.title,
                  remainingTime: _formatTime(_secondsRemaining),
                  isTimeCritical: _secondsRemaining < 300,
                ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isLoadingSession
                ? const ExamLoadingSkeleton()
                : GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Column(
                      children: [
                        // HEADER (TIDAK SCROLL)
                        ExamInfoBar(
                          currentIndex: _currentIndex,
                          totalQuestions: _questions.length,
                          questionType: question.type.name,
                          onZoomIn: _increaseFontSize, // Hubungkan fungsi zoom
                          onZoomOut: _decreaseFontSize, // Hubungkan fungsi zoom
                        ),

                        // SCROLL AREA + REFRESH
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: _handleRefresh,
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ExamQuestionRenderer(
                                    question: question,
                                    textController: _textController,
                                    onUpdate: (fn) => setState(fn),
                                    fontSizeMultiplier: _fontSizeMultiplier,
                                  ),

                                  const SizedBox(
                                    height: 100,
                                  ), // ruang biar ga ketutup navbar
                                ],
                              ),
                            ),
                          ),
                        ),

                        // NAVBAR (FIXED)
                        ExamBottomNavbar(
                          isFlagged: _questions[_currentIndex].isFlagged,
                          currentIndex: _currentIndex,
                          totalQuestions: _questions.length,
                          onFlagChanged: (val) {
                            setState(() {
                              _questions[_currentIndex].isFlagged = val!;
                            });

                            // HANYA hit API jika ada jawaban atau sedang dicentang Ragu-ragu
                            if (_shouldSync(_questions[_currentIndex])) {
                              context.read<ExamProvider>().syncAnswer(
                                _questions[_currentIndex],
                              );
                            }
                          },
                          onPrev: _currentIndex == 0
                              ? null
                              : () => _navigateToStep(_currentIndex - 1),
                          onNext: _currentIndex == _questions.length - 1
                              ? null
                              : () => _navigateToStep(_currentIndex + 1),
                          onNavTap: () => ExamSheets.showNavigation(
                            context: context,
                            questions: _questions,
                            currentIndex: _currentIndex,
                            onQuestionTap: (index) => _navigateToStep(index),
                          ),
                          onSubmitTap: () {
                            final currentQ = _questions[_currentIndex];

                            // Tetap sync jika memang ada isinya
                            if (_shouldSync(currentQ)) {
                              context.read<ExamProvider>().syncAnswer(currentQ);
                            }

                            // 2. Munculkan BottomSheet Rangkuman & Konfirmasi
                            ExamSheets.showConfirmSubmit(
                              context: context,
                              questions: _questions,
                              onConfirm: () async {
                                // Fungsi ini dipanggil saat siswa klik "KIRIM HASIL" di Bottom Sheet
                                await _handleFinalizeExam();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
