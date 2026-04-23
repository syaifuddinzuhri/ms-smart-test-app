import 'package:flutter/material.dart';

class ExamInfoBar extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;
  final String questionType;

  const ExamInfoBar({
    super.key,
    required this.currentIndex,
    required this.totalQuestions,
    required this.questionType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, 2), blurRadius: 5)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text("SOAL ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 14)),
              Text("${currentIndex + 1}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 18)),
              Text(" / $totalQuestions", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 14)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Text(
              questionType.toUpperCase(),
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}