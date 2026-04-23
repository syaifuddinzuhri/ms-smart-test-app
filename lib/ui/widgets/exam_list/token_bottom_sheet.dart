import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../pages/exam_page.dart';

class TokenBottomSheet extends StatefulWidget {
  final String examTitle;
  const TokenBottomSheet({super.key, required this.examTitle});

  @override
  State<TokenBottomSheet> createState() => _TokenBottomSheetState();
}

class _TokenBottomSheetState extends State<TokenBottomSheet> {
  final TextEditingController _tokenController = TextEditingController();
  int _currentLength = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      // --- TAMBAHKAN INI ---
      decoration: const BoxDecoration(
        color: Colors.white, // Warna background putih
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)), // Melengkung di atas
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
            // Handle garis kecil di atas
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
            Text(widget.examTitle,
                style: const TextStyle(
                    color: Colors.green, fontWeight: FontWeight.w600)),
            const SizedBox(height: 30),

            // Bagian Kotak OTP tetap sama
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
                    onChanged: (v) => setState(() => _currentLength = v.length),
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
            const SizedBox(height: 40),
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
                onPressed: _currentLength == 6
                    ? () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const ExamPage()));
                }
                    : null,
                child: const Text("MULAI UJIAN SEKARANG",
                    style: TextStyle(fontWeight: FontWeight.bold)),
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