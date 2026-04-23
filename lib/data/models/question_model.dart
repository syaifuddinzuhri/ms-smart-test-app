enum QuestionType { single, multiple, trueFalse, shortAnswer, essay }

class Question {
  final int id;
  final String text;
  final QuestionType type;
  final List<String>? options; // Untuk pilihan ganda
  int? selectedAnswer;        // Untuk single & true/false
  List<int> selectedAnswers;  // Untuk multiple choice
  String textAnswer;          // Untuk short answer & essay
  bool isFlagged;

  Question({
    required this.id,
    required this.text,
    required this.type,
    this.options,
    this.selectedAnswer,
    this.selectedAnswers = const [],
    this.textAnswer = "",
    this.isFlagged = false,
  });
}