import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:ms_smart_test/providers/exam_provider.dart';
import 'package:provider/provider.dart';
import '../../../data/models/question_model.dart';

class ExamQuestionRenderer extends StatelessWidget {
  final QuestionModel question;
  final TextEditingController textController;
  final Function(VoidCallback) onUpdate;
  final double fontSizeMultiplier;

  const ExamQuestionRenderer({
    super.key,
    required this.question,
    required this.textController,
    required this.onUpdate,
    required this.fontSizeMultiplier,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- TEXT SOAL (SUPPORT HTML) ---
        // Container(
        //   width: double.infinity,
        //   child: HtmlWidget(
        //     question.text,
        //     renderMode: RenderMode.column,
        //     textStyle: TextStyle(
        //       fontSize: 16 * fontSizeMultiplier,
        //       height: 1.5,
        //       color: Colors.black87,
        //     ),
        //   ),
        // ),
        _buildHtmlContent(question.text, 16),
        const SizedBox(height: 25),

        // --- RENDER JAWABAN BERDASARKAN TIPE ---
        _buildAnswerSection(context),
      ],
    );
  }

  Widget _buildHtmlContent(String htmlData, double baseFontSize) {
    return HtmlWidget(
      htmlData,
      renderMode: RenderMode.column,
      textStyle: TextStyle(
        fontSize: baseFontSize * fontSizeMultiplier,
        height: 1.5,
        color: Colors.black87,
      ),
      customWidgetBuilder: (element) {
        if (element.classes.contains('math')) {
          String texCode = element.text.replaceAll(r'$$', '').trim();

          // --- SOLUSI OVERFLOW: Bungkus dengan ScrollView ---
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.03),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Memungkinkan geser kanan-kiri
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                child: Math.tex(
                  texCode,
                  textStyle: TextStyle(
                    fontSize: (baseFontSize + 2) * fontSizeMultiplier,
                  ),
                  onErrorFallback: (err) => Text(
                    element.text,
                    style: const TextStyle(color: Colors.red, fontSize: 10),
                  ),
                ),
              ),
            ),
          );
        }
        return null;
      },
    );
  }

  Widget _buildAnswerSection(BuildContext context) {
    switch (question.type) {
      case QuestionType.single_choice:
      case QuestionType.true_false:
        return Column(
          children: question.options!.asMap().entries.map((entry) {
            return _ModernOptionCard(
              fontSizeMultiplier: fontSizeMultiplier,
              label: String.fromCharCode(65 + entry.key),
              text: entry.value.text,
              isSelected: question.selectedAnswerIndex == entry.key,
              onTap: () =>
                  onUpdate(() => question.selectedAnswerIndex = entry.key),
              isMultiple: false,
              htmlRenderer: (data) => _buildHtmlContent(data, 14),
            );
          }).toList(),
        );

      case QuestionType.multiple_choice:
        return Column(
          children: question.options.asMap().entries.map((entry) {
            final option = entry.value; // Ini adalah OptionModel
            final index = entry.key;

            // Cek apakah index ini ada dalam daftar jawaban terpilih
            bool isSelected = question.selectedAnswerIndices.contains(index);

            return _ModernOptionCard(
              // Pakai label asli dari API (A, B, C, D) bukan generate manual
              fontSizeMultiplier: fontSizeMultiplier,
              label: option.label,
              text: option.text, // Ini mendukung HTML
              isSelected: isSelected,
              isMultiple: true,
              htmlRenderer: (data) => _buildHtmlContent(data, 14),
              onTap: () => onUpdate(() {
                if (isSelected) {
                  question.selectedAnswerIndices.remove(index);
                } else {
                  question.selectedAnswerIndices.add(index);
                }
              }),
            );
          }).toList(),
        );

      case QuestionType.short_answer:
      case QuestionType.essay:
        return Column(
          children: [
            TextField(
              controller: textController,
              enableInteractiveSelection: false,
              contextMenuBuilder: (context, _) => const SizedBox.shrink(),

              // Menutup keyboard saat klik di luar area input
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },

              // Konfigurasi tombol "Enter" di keyboard
              textInputAction: question.type == QuestionType.essay
                  ? TextInputAction.newline
                  : TextInputAction.done,

              onSubmitted: (value) {
                FocusScope.of(context).unfocus();
              },

              // Tinggi kotak input: Essay lebih besar (5 baris), Short Answer (2 baris)
              maxLines: question.type == QuestionType.essay ? 5 : 2,
              style: TextStyle(fontSize: 15 * fontSizeMultiplier),
              decoration: InputDecoration(
                hintText: "Tuliskan jawaban Anda di sini...",
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14 * fontSizeMultiplier,
                ),
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
            // Tombol simpan untuk memindahkan teks dari Controller ke Model
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
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          // Update state lokal
          onUpdate(() => question.textAnswer = textController.text);

          // Langsung tembak API (tanpa nunggu pindah soal)
          context.read<ExamProvider>().syncAnswer(question);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Jawaban disimpan ke server")),
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
  final double fontSizeMultiplier;
  final Widget Function(String) htmlRenderer;

  const _ModernOptionCard({
    required this.label,
    required this.text,
    required this.isSelected,
    required this.isMultiple,
    required this.onTap,
    required this.fontSizeMultiplier,
    required this.htmlRenderer,
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
              ? [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
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
                Expanded(child: htmlRenderer(text)),
                // Expanded(
                //   child: HtmlWidget(
                //     text,
                //     renderMode: RenderMode.column,
                //     textStyle: TextStyle(
                //       fontSize: 15 * fontSizeMultiplier,
                //       color: isSelected ? Colors.green.shade900 : Colors.black87,
                //       fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
