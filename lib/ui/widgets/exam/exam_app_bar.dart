import 'package:flutter/material.dart';

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
    return AppBar(
      title: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
          Text(
            "Sisa Waktu: $remainingTime",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isTimeCritical ? Colors.yellow : Colors.white,
            ),
          ),
        ],
      ),
      automaticallyImplyLeading: false,
      toolbarHeight: 70,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}