import 'package:flutter/material.dart';

class ExamBottomNavbar extends StatelessWidget {
  final bool isFlagged;
  final int currentIndex;
  final int totalQuestions;
  final ValueChanged<bool?> onFlagChanged;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final VoidCallback onNavTap;
  final VoidCallback onSubmitTap;

  const ExamBottomNavbar({
    super.key,
    required this.isFlagged,
    required this.currentIndex,
    required this.totalQuestions,
    required this.onFlagChanged,
    required this.onPrev,
    required this.onNext,
    required this.onNavTap,
    required this.onSubmitTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isLastQuestion = currentIndex == totalQuestions - 1;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isFlagged,
                    activeColor: Colors.orange,
                    onChanged: onFlagChanged,
                  ),
                  const Text("Ragu-Ragu",
                      style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                ],
              ),
              if (isLastQuestion)
                ElevatedButton(
                  onPressed: onSubmitTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("SIMPAN & SELESAI"),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: onPrev,
                child: const Icon(Icons.arrow_back_ios, size: 16),
              ),
              OutlinedButton.icon(
                onPressed: onNavTap,
                icon: const Icon(Icons.grid_view_rounded, size: 18),
                label: const Text("Navigasi"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue),
                ),
              ),
              ElevatedButton(
                onPressed: onNext,
                child: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}