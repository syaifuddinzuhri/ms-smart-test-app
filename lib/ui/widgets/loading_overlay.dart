import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final String text;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.text = "Loading...",
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,

        // Overlay
        if (isLoading)
          Positioned.fill(
            child: IgnorePointer(
              ignoring: false, // ⬅️ block semua klik
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isLoading ? 1 : 0,
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                  child: Center(
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 3),
                            ),
                            const SizedBox(width: 16),
                            Flexible( // ⬅️ penting
                              child: Text(
                                text,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}