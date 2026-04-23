import 'package:flutter/material.dart';
import 'dart:async';
import '../../../data/models/question_model.dart';
import '../../../services/security_service.dart';

class ExamSheets {
  // --- BOTTOM SHEET NAVIGASI ---
  static void showNavigation({
    required BuildContext context,
    required List<Question> questions,
    required int currentIndex,
    required Function(int) onQuestionTap,
  }) {
    // Hitung progress untuk header
    int dijawab = questions.where((q) => _checkIsAnswered(q)).length;
    double progressPercent = (dijawab / questions.length) * 100;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          child: Column(
            children: [
              // --- HANDLE BAR ---
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // --- HEADER NAVIGASI ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Navigasi Soal",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                      Text(
                        "Progres Pengerjaan: ${progressPercent.toStringAsFixed(0)}%",
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "$dijawab/${questions.length} Selesai",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // --- GRID SOAL ---
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final q = questions[index];
                    bool isAnswered = _checkIsAnswered(q);
                    bool isCurrent = currentIndex == index;
                    bool isFlagged = q.isFlagged;

                    // Logika Warna Modern
                    Color boxColor = Colors.grey.shade100;
                    Color textColor = Colors.black87;
                    Color borderColor = Colors.transparent;

                    if (isFlagged) {
                      boxColor = Colors.orange;
                      textColor = Colors.white;
                    } else if (isAnswered) {
                      boxColor = Colors.green;
                      textColor = Colors.white;
                    }

                    if (isCurrent) {
                      borderColor = Colors.blue.shade700;
                    }

                    return InkWell(
                      onTap: () {
                        onQuestionTap(index);
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(15),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: boxColor,
                          borderRadius: BorderRadius.circular(15),
                          border: isCurrent
                              ? Border.all(color: borderColor, width: 3)
                              : Border.all(color: Colors.grey.shade200, width: 1),
                          boxShadow: isCurrent
                              ? [BoxShadow(color: Colors.blue.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))]
                              : (isAnswered || isFlagged)
                              ? [BoxShadow(color: boxColor.withOpacity(0.2), blurRadius: 5, offset: const Offset(0, 3))]
                              : [],
                        ),
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: textColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // --- LEGEND SECTION ---
              Container(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey.shade100)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildModernLegend(Colors.green, "Dijawab"),
                    _buildModernLegend(Colors.orange, "Ragu"),
                    _buildModernLegend(Colors.grey.shade200, "Belum", isTextDark: true),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  static Widget _buildModernLegend(Color color, String text, {bool isTextDark = false}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  // --- BOTTOM SHEET KONFIRMASI SUBMIT ---
  static void showConfirmSubmit({
    required BuildContext context,
    required List<Question> questions,
    required VoidCallback onConfirm,
  }) {
    int totalSoal = questions.length;
    int dijawab = questions.where((q) => _checkIsAnswered(q)).length;
    int tidakDijawab = totalSoal - dijawab;
    int jmlRagu = questions.where((q) => q.isFlagged).length;
    bool adaRaguRagu = jmlRagu > 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 25),
              CircleAvatar(
                radius: 40,
                backgroundColor: adaRaguRagu ? Colors.orange.shade50 : Colors.blue.shade50,
                child: Icon(adaRaguRagu ? Icons.priority_high_rounded : Icons.task_alt_rounded, size: 50, color: adaRaguRagu ? Colors.orange : Colors.blue),
              ),
              const SizedBox(height: 20),
              const Text("Konfirmasi Selesai", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("Apakah Anda yakin ingin mengakhiri ujian ini?", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem("Total", "$totalSoal", Colors.blue, Icons.list_alt),
                  _buildStatItem("Dijawab", "$dijawab", Colors.green, Icons.check_circle_outline),
                  _buildStatItem("Kosong", "$tidakDijawab", Colors.red, Icons.highlight_off),
                  _buildStatItem("Ragu", "$jmlRagu", Colors.orange, Icons.flag_outlined),
                ],
              ),
              const SizedBox(height: 25),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: adaRaguRagu ? Colors.orange.shade50 : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: adaRaguRagu ? Colors.orange.shade200 : Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(adaRaguRagu ? Icons.info_outline : Icons.help_outline, color: adaRaguRagu ? Colors.orange : Colors.blue),
                    const SizedBox(width: 15),
                    Expanded(child: Text(adaRaguRagu ? "Selesaikan soal ragu-ragu Anda sebelum mengirim." : "Setelah dikirim, jawaban tidak dapat diubah.", style: const TextStyle(fontSize: 13))),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text("KEMBALI"))),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: adaRaguRagu ? null : onConfirm,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, disabledBackgroundColor: Colors.grey.shade300),
                      child: const Text("KIRIM HASIL"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  static void showTimeOutSheet({
    required BuildContext context,
    required VoidCallback onFinish,
  }) {
    int secondsRemaining = 5; // Durasi redirect otomatis
    Timer? redirectTimer;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            // Jalankan timer hanya jika belum berjalan
            redirectTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
              if (secondsRemaining > 0) {
                setModalState(() {
                  secondsRemaining--;
                });
              } else {
                timer.cancel();
                if (Navigator.canPop(context)) {
                  Navigator.pop(context); // Tutup sheet
                }
                onFinish(); // Jalankan redirect
              }
            });

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: secondsRemaining / 5, // Progress bar mengecil
                          strokeWidth: 8,
                          color: Colors.blue.shade100,
                          backgroundColor: Colors.blue.shade500,
                        ),
                      ),
                      const Icon(Icons.timer_off_rounded, size: 40, color: Colors.blue),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "WAKTU HABIS",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Sesi ujian Anda telah berakhir. Jawaban Anda telah disimpan secara otomatis.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.grey, height: 1.5),
                  ),
                  const SizedBox(height: 20),

                  // --- INFO REDIRECT OTOMATIS ---
                  Text(
                    "Kembali otomatis dalam $secondsRemaining detik...",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        redirectTimer?.cancel(); // Matikan timer jika user klik manual
                        Navigator.pop(context);
                        onFinish();
                      },
                      child: const Text(
                        "KEMBALI SEKARANG",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((_) => redirectTimer?.cancel()); // Pastikan timer mati jika sheet tertutup
  }

  // --- PRIVATE HELPERS ---
  static bool _checkIsAnswered(Question q) {
    if (q.type == QuestionType.single || q.type == QuestionType.trueFalse) return q.selectedAnswer != null;
    if (q.type == QuestionType.multiple) return q.selectedAnswers.isNotEmpty;
    return q.textAnswer.trim().isNotEmpty;
  }

  static Widget _buildLegend(Color color, String text) {
    return Row(children: [
      Container(width: 15, height: 15, decoration: BoxDecoration(color: color, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(3))),
      const SizedBox(width: 5),
      Text(text, style: const TextStyle(fontSize: 12))
    ]);
  }

  static Widget _buildStatItem(String label, String value, Color color, IconData icon) {
    return Column(children: [
      Icon(icon, color: color, size: 24),
      Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    ]);
  }
}