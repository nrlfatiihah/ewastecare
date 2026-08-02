class QuizQuestionModel {
  String question;
  List<String> options;
  int correctAnswerIndex;

  QuizQuestionModel({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  }) : assert(options.length == 4);

  static QuizQuestionModel empty() => QuizQuestionModel(
    question: '',
    options: ['', '', '', ''],
    correctAnswerIndex: 0,
  );

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
    };
  }

  factory QuizQuestionModel.fromMap(Map<String, dynamic> map) {
    final options = (map['options'] as List<dynamic>? ?? const [])
        .map((option) => option.toString())
        .toList();

    final normalizedOptions = options.length >= 4
        ? options.sublist(0, 4)
        : [...options, ...List.filled(4 - options.length, '')];

    return QuizQuestionModel(
      question: map['question']?.toString() ?? '',
      options: normalizedOptions,
      correctAnswerIndex: map['correctAnswerIndex'] is int
          ? map['correctAnswerIndex'] as int
          : 0,
    );
  }
}
