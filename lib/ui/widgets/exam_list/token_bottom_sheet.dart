import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ms_smart_test/data/models/exam_model.dart';
import 'package:ms_smart_test/providers/exam_provider.dart';
import 'package:provider/provider.dart';
import '../../pages/exam_page.dart';

class TokenBottomSheet extends StatefulWidget {
  final ExamModel exam;
  const TokenBottomSheet({super.key, required this.exam});

  @override
  State<TokenBottomSheet> createState() => _TokenBottomSheetState();
}

class _TokenBottomSheetState extends State<TokenBottomSheet> {
  final TextEditingController _tokenController = TextEditingController();
  int _currentLength = 0;
  bool _isSubmitting = false;
  String? _localError;

  void _handleStart() async {
    final examProvider = context.read<ExamProvider>();

    setState(() => _isSubmitting = true);

    final result = await examProvider.startSession(
        widget.exam.id,
        _tokenController.text
    );

    setState(() {
      _isSubmitting = true;
      _localError = null;
    });

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (result) {
      Navigator.pop(context, true);

      await Future.delayed(const Duration(milliseconds: 100));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ExamPage(exam: widget.exam),
        ),
      );
    } else {
      setState(() {
        _localError = examProvider.error ?? "Gagal memulai ujian";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      // ----------------------
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 25),
            const Text("Masukkan Token Ujian",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.exam.title,
                style: const TextStyle(
                    color: Colors.green, fontWeight: FontWeight.w600)),
            const SizedBox(height: 30),

            Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: 0,
                  child: TextField(
                    controller: _tokenController,
                    autofocus: true,
                    maxLength: 6,
                    inputFormatters: [UpperCaseTextFormatter()],
                    onChanged: (v) {
                      setState(() {
                        _currentLength = v.length;
                        _localError = null;
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    bool isFocused = index == _currentLength;
                    bool isFilled = index < _currentLength;
                    return Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: isFilled ? Colors.green.shade50 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isFocused
                              ? Colors.green
                              : (isFilled ? Colors.green : Colors.grey.shade300),
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        isFilled ? _tokenController.text[index] : "",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_localError != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _localError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _currentLength == 6 ? Colors.green : Colors.grey.shade400,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: (_currentLength == 6 && !_isSubmitting) ? _handleStart : null,
                child: _isSubmitting
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("MULAI UJIAN SEKARANG"),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) =>
      TextEditingValue(text: newValue.text.toUpperCase(), selection: newValue.selection);
}