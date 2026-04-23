import 'package:flutter/material.dart';
import '../../../data/models/exam_model.dart';
import 'token_bottom_sheet.dart';

class ExamCard extends StatelessWidget {
  final Exam exam;
  const ExamCard({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    bool isCompleted = exam.status == ExamStatus.Completed;
    bool isOngoing =
        exam.status == ExamStatus.Ongoing || exam.status == ExamStatus.Pause;

    // Warna tema berdasarkan status
    Color themeColor = isCompleted
        ? Colors.green
        : (isOngoing ? Colors.orange : Colors.blue);
    bool isLulus = exam.resultStatus == "Lulus";

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Aksen Dekoratif di pojok kanan bawah
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                Icons.assignment_outlined,
                size: 100,
                color: themeColor.withOpacity(0.03),
              ),
            ),

            // Konten Utama
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ikon dengan background soft
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: themeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          isCompleted
                              ? Icons.task_alt_rounded
                              : Icons.assignment_rounded,
                          color: themeColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Judul & Detail
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exam.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                color: Colors.black87,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              exam.subject,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (isCompleted && exam.score != null)
                              _buildModernScoreInfo(),
                          ],
                        ),
                      ),

                      if (exam.resultStatus?.isNotEmpty ?? false)
                        _resultBadge(isLulus),
                    ],
                  ),
                ),

                // Info Bar (Waktu & Durasi)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _infoItem(Icons.timer_rounded, exam.duration),
                      Container(
                        width: 1,
                        height: 15,
                        color: Colors.grey.shade300,
                      ),
                      _infoItem(
                        Icons.play_circle_outline_rounded,
                        exam.startAt,
                      ),
                      Container(
                        width: 1,
                        height: 15,
                        color: Colors.grey.shade300,
                      ),
                      _infoItem(Icons.stop_circle_outlined, exam.endAt),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                _buildActionButton(context, isCompleted, isOngoing, themeColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernScoreInfo() {
    bool isLulus = exam.resultStatus == "Lulus";
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Text(
                  "Skor: ",
                  style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                ),
                Text(
                  "${exam.score}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultBadge(bool isLulus) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isLulus ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: (isLulus ? Colors.green : Colors.red).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        exam.resultStatus?.toUpperCase() ?? "",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade500),
        const SizedBox(width: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    bool isCompleted,
    bool isOngoing,
    Color themeColor,
  ) {
    if (isCompleted) return const SizedBox(height: 10);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: themeColor.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: themeColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => TokenBottomSheet(examTitle: exam.title),
            );
          },
          child: Text(
            isOngoing ? "LANJUTKAN KERJAKAN" : "MULAI KERJAKAN SEKARANG",
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
