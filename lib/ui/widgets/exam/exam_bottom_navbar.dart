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
      padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 15,
          bottom: MediaQuery.of(context).padding.bottom + 15
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- BARIS 1: RAGU-RAGU & SUBMIT ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Custom Toggle Ragu-Ragu
              GestureDetector(
                onTap: () => onFlagChanged(!isFlagged),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isFlagged ? Colors.orange : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isFlagged ? Colors.orange : Colors.orange.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isFlagged ? Icons.flag_rounded : Icons.outlined_flag_rounded,
                        size: 18,
                        color: isFlagged ? Colors.white : Colors.orange.shade800,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Ragu-Ragu",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isFlagged ? Colors.white : Colors.orange.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Tombol Submit (Glow Effect)
              if (isLastQuestion)
                GestureDetector(
                  onTap: onSubmitTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade600, Colors.blue.shade800],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: const Row(
                      children: [
                        Text(
                          "SELESAI",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.send_rounded, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 15),

          // --- BARIS 2: NAVIGASI ---
          Row(
            children: [
              // Tombol Prev
              _buildNavButton(
                onTap: onPrev,
                icon: Icons.arrow_back_ios_new_rounded,
                label: "PREV",
                isDisabled: onPrev == null,
              ),

              const SizedBox(width: 12),

              // Tombol Navigasi Tengah (Pill Style)
              Expanded(
                child: GestureDetector(
                  onTap: onNavTap,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.green.shade100),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.grid_view_rounded,
                            size: 18, color: Colors.green.shade700),
                        const SizedBox(width: 10),
                        Text(
                          "NAVIGASI",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: Colors.green.shade700,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Tombol Next
              _buildNavButton(
                onTap: onNext,
                icon: Icons.arrow_forward_ios_rounded,
                label: "NEXT",
                isDisabled: onNext == null,
                isPrimary: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper Widget untuk Tombol Navigasi
  Widget _buildNavButton({
    required VoidCallback? onTap,
    required IconData icon,
    required String label,
    bool isDisabled = false,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isDisabled ? 0.4 : 1.0,
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Icon(icon, size: 18, color: Colors.black87),
        ),
      ),
    );
  }
}