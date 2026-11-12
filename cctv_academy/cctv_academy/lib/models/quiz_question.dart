class QuizQuestion {
  final int id;
  final int moduleId;
  final String question;
  final List<String> options;
  final int correctOption;
  final String explanation;

  QuizQuestion({
    required this.id,
    required this.moduleId,
    required this.question,
    required this.options,
    required this.correctOption,
    required this.explanation,
  });

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
      id: map['id'] as int,
      moduleId: map['module_id'] as int,
      question: map['question'] as String,
      options: [
        map['option_a'] as String,
        map['option_b'] as String,
        map['option_c'] as String,
        map['option_d'] as String,
      ],
      correctOption: map['correct_option'] as int,
      explanation: map['explanation'] as String,
    );
  }
}
