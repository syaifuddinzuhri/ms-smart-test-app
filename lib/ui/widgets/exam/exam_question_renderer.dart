import 'package:flutter/material.dart';
import '../../../data/models/question_model.dart';
import '../option_tile.dart';

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
    switch (question.type) {
      case QuestionType.single:
      case QuestionType.trueFalse:
        return Column(
          children: question.options!.asMap().entries.map((entry) {
            return OptionTile(
              label: String.fromCharCode(65 + entry.key),
              text: entry.value,
              isSelected: question.selectedAnswer == entry.key,
              onTap: () => onUpdate(() => question.selectedAnswer = entry.key),
            );
          }).toList(),
        );

      case QuestionType.multiple:
        return Column(
          children: question.options!.asMap().entries.map((entry) {
            bool isSelected = question.selectedAnswers.contains(entry.key);
            return OptionTile(
              label: isSelected ? "✓" : String.fromCharCode(65 + entry.key),
              text: entry.value,
              isSelected: isSelected,
              onTap: () => onUpdate(() {
                isSelected ? question.selectedAnswers.remove(entry.key) : question.selectedAnswers.add(entry.key);
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
              maxLines: question.type == QuestionType.essay ? 12 : 1,
              decoration: InputDecoration(
                hintText: "Ketik jawaban Anda di sini...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  onUpdate(() => question.textAnswer = textController.text);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Jawaban disimpan"), duration: Duration(seconds: 1)));
                },
                icon: const Icon(Icons.save),
                label: const Text("SIMPAN JAWABAN"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              ),
            ),
          ],
        );
    }
  }
}