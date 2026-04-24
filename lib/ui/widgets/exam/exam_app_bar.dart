import 'package:flutter/material.dart';
import 'package:ms_smart_test/providers/exam_provider.dart';
import 'package:provider/provider.dart';

class ExamAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String remainingTime;
  final bool isTimeCritical;

  const ExamAppBar({
    super.key,
    required this.title,
    required this.remainingTime,
    required this.isTimeCritical,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade800,
            Colors.green.shade600,
          ],
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // --- SISI KIRI: JUDUL & BADGE AMAN ---
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.verified_user_rounded,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        const Text(
                          "SECURED",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Di dalam Row AppBar
              if (context.watch<ExamProvider>().isSyncing)
                const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: SizedBox(
                    width: 15, height: 15,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white70),
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(Icons.cloud_done_rounded, size: 18, color: Colors.white70),
                ),

              // --- SISI KANAN: TIMER PILL ---
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isTimeCritical
                      ? Colors.red.withOpacity(0.9)
                      : Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isTimeCritical ? Colors.white : Colors.white24,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: isTimeCritical ? Colors.white : Colors.green.shade100,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      remainingTime,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace', // Biar angka tidak goyang saat berganti
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80); // Tinggi ditambah sedikit
}