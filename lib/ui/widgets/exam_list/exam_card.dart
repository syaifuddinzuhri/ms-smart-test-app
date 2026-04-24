import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ms_smart_test/core/common_helper.dart';
import 'package:ms_smart_test/data/models/exam_model.dart';
import 'token_bottom_sheet.dart';
import 'package:timezone/timezone.dart' as tz;

class ExamCard extends StatelessWidget {
  final ExamModel exam;
  final String status;
  const ExamCard({super.key, required this.exam, required this.status});

  @override
  Widget build(BuildContext context) {
    bool isCompleted = status == 'completed';
    bool isOngoing = status == 'active';

    Color themeColor = isCompleted
        ? Colors.green
        : (isOngoing ? Colors.orange : Colors.blue);

    final latestSession = exam.sessions.firstOrNull;
    double scoreValue = double.tryParse(latestSession?.totalScore ?? '0') ?? 0;
    double passingGrade = double.tryParse(exam.passingGrade.toString()) ?? 0;
    bool isLulus = scoreValue >= passingGrade;
    bool canShowResult = exam.showResultToStudent && isCompleted;

    final jakarta = tz.getLocation('Asia/Jakarta');

    // 1. Format Waktu Akses (Header Utama)
    String startTime = DateFormat(
      'd/MM/y HH:mm',
    ).format(tz.TZDateTime.from(exam.startTime, jakarta));
    String endTime = DateFormat(
      'd/MM/y HH:mm',
    ).format(tz.TZDateTime.from(exam.endTime, jakarta));

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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIconBadge(isCompleted, themeColor),
                  const SizedBox(width: 16),
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
                          ),
                        ),
                        Text(
                          exam.subject.name,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                        // if (canShowResult) _buildModernScoreInfo(scoreValue),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (canShowResult) _buildCombinedScoreAndBadge(scoreValue, isLulus),

            if (isCompleted && latestSession != null)
              _buildSessionGridInfo(latestSession, jakarta)
            else
              _buildDefaultInfoBar(startTime, endTime, themeColor),

            const SizedBox(height: 20),
            _buildActionButton(context, isCompleted, isOngoing, themeColor),
          ],
        ),
      ),
    );
  }

  Widget _buildCombinedScoreAndBadge(double totalScore, bool isLulus) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Row(
              children: [
                const Text(
                  "Skor: ",
                  style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                ),
                Text(
                  totalScore.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),
          Container(
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
            child: Row(
              children: [
                Icon(
                  isLulus ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  isLulus ? "LULUS" : "TIDAK LULUS",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET: GRID 2x2 RIWAYAT PENGERJAAN
  Widget _buildSessionGridInfo(dynamic session, tz.Location loc) {
    String start = session.startedAt != null
        ? DateFormat(
            'd/MM/y HH:mm',
          ).format(tz.TZDateTime.from(session.startedAt!, loc))
        : "-";
    String end = session.finishedAt != null
        ? DateFormat(
            'd/MM/y HH:mm',
          ).format(tz.TZDateTime.from(session.finishedAt!, loc))
        : "-";

    int duration = 0;
    if (session.startedAt != null && session.finishedAt != null) {
      duration = session.finishedAt!.difference(session.startedAt!).inMinutes;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _gridItem(
                Icons.timer_rounded,
                "$duration Menit",
                "DURASI",
                Colors.blue,
              ),
              _verticalDivider(),
              _gridItem(
                Icons.gavel_rounded,
                "${session.violationCount} Pelanggaran",
                "KEAMANAN",
                Colors.red,
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, thickness: 0.5),
          ),
          Row(
            children: [
              _gridItem(
                Icons.play_arrow_rounded,
                start,
                "WAKTU MULAI",
                Colors.green,
              ),
              _verticalDivider(),
              _gridItem(Icons.stop_rounded, end, "WAKTU SELESAI", Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  // HELPER UNTUK ITEM GRID
  Widget _gridItem(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() => Container(
    width: 1,
    height: 25,
    color: Colors.grey.shade300,
    margin: const EdgeInsets.symmetric(horizontal: 10),
  );

  // WIDGET: DEFAULT INFO BAR (Untuk Tab Selain Completed)
  Widget _buildDefaultInfoBar(String start, String end, Color themeColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoItem(Icons.timer_rounded, "${exam.duration} Menit"),
              _infoItem(Icons.play_circle_outline, start),
              _infoItem(Icons.stop_circle_outlined, end),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: themeColor.withOpacity(0.7),
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  "Informasi durasi dan rentang waktu di atas adalah patokan jadwal resmi ujian. Waktu pengerjaan sesungguhnya akan mulai dihitung mundur secara mandiri setelah Anda memulai mengerjakan.",
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- WIDGET PENDUKUNG LAINNYA ---

  Widget _buildIconBadge(bool isCompleted, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        isCompleted ? Icons.task_alt_rounded : Icons.assignment_rounded,
        color: color,
        size: 24,
      ),
    );
  }

  Widget _buildModernScoreInfo(double totalScore) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Skor: ",
              style: TextStyle(fontSize: 12, color: Colors.blueGrey),
            ),
            Text(
              totalScore.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 14,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultBadge(bool isLulus) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isLulus ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        isLulus ? "LULUS" : "TIDAK LULUS",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 4),
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
              builder: (_) => TokenBottomSheet(exam: exam),
            );
          },
          child: Text(
            isOngoing ? "LANJUTKAN KERJAKAN" : "MULAI KERJAKAN SEKARANG",
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
