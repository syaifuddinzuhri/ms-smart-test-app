import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ExamLoadingSkeleton extends StatelessWidget {
  const ExamLoadingSkeleton({super.key});

  Widget _box({double height = 16, double width = double.infinity}) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _option() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      height: 50,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _box(height: 20, width: 200),
            _box(height: 16, width: 250),
            const SizedBox(height: 20),

            _box(height: 14),
            _box(height: 14),
            _box(height: 14, width: 180),

            const SizedBox(height: 25),

            _option(),
            _option(),
            _option(),
            _option(),
          ],
        ),
      ),
    );
  }
}