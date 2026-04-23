import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../data/models/question_model.dart';

class ExamQuestionRenderer extends StatelessWidget {
  final Question question;
  final TextEditingController textController;
  final Function(VoidCallback) onUpdate;

  const ExamQuestionRenderer({
    super.key,
    required this.question,
    required this.textController,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- TEXT SOAL (SUPPORT HTML) ---
        Container(
          width: double.infinity,
          child: HtmlWidget(
            question.text,
            textStyle: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 25),

        // --- RENDER JAWABAN BERDASARKAN TIPE ---
        _buildAnswerSection(context),
      ],
    );
  }

  Widget _buildAnswerSection(BuildContext context) {
    switch (question.type) {
      case QuestionType.single:
      case QuestionType.trueFalse:
        return Column(
          children: question.options!.asMap().entries.map((entry) {
            return _ModernOptionCard(
              label: String.fromCharCode(65 + entry.key),
              text: entry.value,
              isSelected: question.selectedAnswer == entry.key,
              isMultiple: false,
              onTap: () => onUpdate(() => question.selectedAnswer = entry.key),
            );
          }).toList(),
        );

      case QuestionType.multiple:
        return Column(
          children: question.options!.asMap().entries.map((entry) {
            bool isSelected = question.selectedAnswers.contains(entry.key);
            return _ModernOptionCard(
              label: String.fromCharCode(65 + entry.key),
              text: entry.value,
              isSelected: isSelected,
              isMultiple: true,
              onTap: () => onUpdate(() {
                if (isSelected) {
                  question.selectedAnswers.remove(entry.key);
                } else {
                  question.selectedAnswers.add(entry.key);
                }
              }),
            );
          }).toList(),
        );

      default: // ShortAnswer & Essay
        return Column(
          children: [
            TextField(
              controller: textController,
              enableInteractiveSelection: false,
              contextMenuBuilder: (context, _) => const SizedBox.shrink(),

              // --- TAMBAHKAN INI UNTUK MENUTUP KEYBOARD SAAT KLIK LUAR ---
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },

              // --- KONFIGURASI TOMBOL KEYBOARD ---
              textInputAction: question.type == QuestionType.essay
                  ? TextInputAction.newline // Enter untuk baris baru di Essay
                  : TextInputAction.done,    // Tombol "Centang/Selesai" untuk Isian Singkat

              onSubmitted: (value) {
                FocusScope.of(context).unfocus(); // Tutup keyboard saat tekan "Done"
              },
              // ----------------------------------------------------------

              maxLines: question.type == QuestionType.essay ? 5 : 2,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                hintText: "Tuliskan jawaban Anda di sini...",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(20),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSaveButton(context),
          ],
        );
    }
  }

  Widget _buildSaveButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [Colors.green.shade600, Colors.green.shade800],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          onUpdate(() => question.textAnswer = textController.text);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Jawaban berhasil disimpan!"),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green.shade800,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        label: const Text(
          "SIMPAN JAWABAN",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}

// --- WIDGET KOMPONEN PILIHAN GANDA MODERN ---
class _ModernOptionCard extends StatelessWidget {
  final String label;
  final String text;
  final bool isSelected;
  final bool isMultiple;
  final VoidCallback onTap;

  const _ModernOptionCard({
    required this.label,
    required this.text,
    required this.isSelected,
    required this.isMultiple,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.green.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))]
              : [],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Bulatan Label (A, B, C...)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.green : Colors.grey.shade300,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    isMultiple && isSelected ? "✓" : label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // Text Opsi (SUPPORT HTML)
                Expanded(
                  child: HtmlWidget(
                    text,
                    textStyle: TextStyle(
                      fontSize: 15,
                      color: isSelected ? Colors.green.shade900 : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}