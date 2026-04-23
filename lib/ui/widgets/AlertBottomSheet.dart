import 'package:flutter/material.dart';
import 'package:ms_smart_test/data/common_enums.dart';

class AlertBottomSheet {
  static void show({
    required BuildContext context,
    required AlertType type,
    String? title,
    required String description,
    String? buttonText,
    VoidCallback? onPressed,
    bool buttonBack = false, // ⬅️ default false
  }) {
    IconData icon;
    Color color;
    String defaultTitle;

    switch (type) {
      case AlertType.success:
        icon = Icons.check_circle;
        color = Colors.green;
        defaultTitle = "Berhasil";
        break;
      case AlertType.error:
        icon = Icons.error;
        color = Colors.red;
        defaultTitle = "Terjadi Kesalahan";
        break;
      case AlertType.warning:
        icon = Icons.warning;
        color = Colors.orange;
        defaultTitle = "Peringatan";
        break;
    }

    showModalBottomSheet(
      context: context,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔥 Handle / garis atas
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                Icon(icon, size: 60, color: color),
                const SizedBox(height: 16),

                Text(
                  title ?? defaultTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),

                const SizedBox(height: 20),

                if (buttonText != null)
                  Row(
                    children: [
                      if (buttonBack) ...[
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Batal"),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],

                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color,
                            foregroundColor: Colors.white,
                          ),
                          onPressed:
                          onPressed ?? () => Navigator.pop(context),
                          child: Text(buttonText),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}