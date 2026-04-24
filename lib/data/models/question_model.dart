enum QuestionType { single_choice, multiple_choice, true_false, short_answer, essay }

class QuestionModel {
  final String id;
  final String text;
  final QuestionType type;
  final List<OptionModel> options;

  // State Jawaban (Lokal)
  int? selectedAnswerIndex;
  List<int> selectedAnswerIndices;
  String textAnswer;
  bool isFlagged;

  QuestionModel({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
    this.selectedAnswerIndex,
    this.selectedAnswerIndices = const [],
    this.textAnswer = "",
    this.isFlagged = false,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      text: json['question_text'],
      // Map string dari API ke Enum
      type: QuestionType.values.firstWhere(
            (e) => e.name == json['question_type'],
        orElse: () => QuestionType.single_choice,
      ),
      options: (json['options'] as List)
          .map((o) => OptionModel.fromJson(o))
          .toList(),
    );
  }
}

class OptionModel {
  final String id;
  final String label;
  final String text;

  OptionModel({required this.id, required this.label, required this.text});

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      id: json['id'],
      label: json['label'],
      text: json['text'],
    );
  }
}