import 'package:flutter/material.dart';
import '../../../data/models/exam_model.dart';
import 'token_bottom_sheet.dart';

class ExamCard extends StatelessWidget {
  final Exam exam;
  const ExamCard({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    bool isCompleted = exam.status == ExamStatus.Completed;
    bool isOngoing = exam.status == ExamStatus.Ongoing || exam.status == ExamStatus.Pause;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIcon(exam.status),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(exam.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(exam.subject, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      if (isCompleted && exam.score != null) _buildScoreInfo(),
                    ],
                  ),
                ),
                _buildBadge(exam.status),
              ],
            ),
          ),
          const Divider(height: 1),
          _buildTimeInfo(),
          _buildActionButton(context, isCompleted, isOngoing),
        ],
      ),
    );
  }

  Widget _buildIcon(ExamStatus status) {
    Color color = status == ExamStatus.Completed ? Colors.green : (status == ExamStatus.Ongoing ? Colors.orange : Colors.blue);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: Icon(Icons.assignment_outlined, color: color),
    );
  }

  Widget _buildScoreInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          const Text("Skor: ", style: TextStyle(fontSize: 13)),
          Text("${exam.score}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          const SizedBox(width: 8),
          _resultBadge(),
        ],
      ),
    );
  }

  Widget _resultBadge() {
    bool isLulus = exam.resultStatus == "Lulus";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: isLulus ? Colors.green.shade50 : Colors.red.shade50, borderRadius: BorderRadius.circular(4), border: Border.all(color: isLulus ? Colors.green.shade200 : Colors.red.shade200)),
      child: Text(exam.resultStatus ?? "", style: TextStyle(color: isLulus ? Colors.green : Colors.red, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildBadge(ExamStatus status) {
    String label = status == ExamStatus.Completed ? "SELESAI" : (status == ExamStatus.Ongoing ? "BERLANGSUNG" : "TERSEDIA");
    Color color = status == ExamStatus.Completed ? Colors.green : (status == ExamStatus.Ongoing ? Colors.orange : Colors.blue);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTimeInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _infoItem(Icons.timer_outlined, exam.duration),
          _infoItem(Icons.login, exam.startAt),
          _infoItem(Icons.logout, exam.endAt),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String value) {
    return Row(children: [Icon(icon, size: 14, color: Colors.grey), const SizedBox(width: 4), Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600))]);
  }

  Widget _buildActionButton(BuildContext context, bool isCompleted, bool isOngoing) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SizedBox(
        width: double.infinity,
        height: 45,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isCompleted ? Colors.grey.shade300 : (isOngoing ? Colors.orange : Colors.green),
            foregroundColor: isCompleted ? Colors.grey : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          onPressed: isCompleted ? null : () {
            showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
                builder: (_) => TokenBottomSheet(examTitle: exam.title));
          },
          child: Text(isCompleted ? "UJIAN SELESAI" : (isOngoing ? "LANJUTKAN KERJAKAN" : "MULAI KERJAKAN"), style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}