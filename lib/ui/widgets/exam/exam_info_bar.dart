import 'package:flutter/material.dart';

class ExamInfoBar extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;
  final String questionType;
  final VoidCallback onZoomIn;  // Tambahan
  final VoidCallback onZoomOut; // Tambahan

  const ExamInfoBar({
    super.key,
    required this.currentIndex,
    required this.totalQuestions,
    required this.questionType,
    required this.onZoomIn,
    required this.onZoomOut,
  });

  @override
  Widget build(BuildContext context) {
    // Menghitung progress pengerjaan (0.0 sampai 1.0)
    double progress = (currentIndex + 1) / totalQuestions;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              textBaseline: TextBaseline.alphabetic,
              children: [
                // --- SISI KIRI: INDIKATOR NOMOR ---
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.tag_rounded,
                          size: 16, color: Colors.green.shade700),
                    ),
                    const SizedBox(width: 10),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black87),
                        children: [
                          const TextSpan(
                            text: "SOAL ",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey
                            ),
                          ),
                          TextSpan(
                            text: "${currentIndex + 1}",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Colors.green.shade700
                            ),
                          ),
                          TextSpan(
                            text: " / $totalQuestions",
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    _zoomButton(Icons.remove, onZoomOut),
                    const SizedBox(width: 8),
                    const Icon(Icons.format_size_rounded, size: 18, color: Colors.grey),
                    const SizedBox(width: 8),
                    _zoomButton(Icons.add, onZoomIn),
                  ],
                ),

                // --- SISI KANAN: BADGE TIPE SOAL ---
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.blue.shade700],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Text(
                    _formatTypeName(questionType),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- PROGRESS BAR HALUS ---
          Stack(
            children: [
              Container(
                height: 4,
                width: double.infinity,
                color: Colors.grey.shade100,
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                height: 4,
                width: MediaQuery.of(context).size.width * progress,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade400, Colors.green.shade700],
                  ),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _zoomButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: Colors.black87),
      ),
    );
  }

  // Helper untuk merapikan teks tipe soal
  String _formatTypeName(String type) {
    switch (type.toLowerCase()) {
      case 'single_choice': return 'PILIHAN GANDA';
      case 'multiple_choice': return 'JAWABAN JAMAK';
      case 'true_false': return 'BENAR / SALAH';
      case 'short_answer': return 'ISIAN SINGKAT';
      case 'essay': return 'ESSAY / URAIAN';
      default: return type.toUpperCase();
    }
  }
}