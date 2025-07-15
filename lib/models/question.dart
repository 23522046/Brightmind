class Question {
  final String id;
  final String question;
  final String? answer;
  final String? answeredBy; // Name of the relawan
  final DateTime askedAt;

  Question({
    required this.id,
    required this.question,
    this.answer,
    this.answeredBy,
    required this.askedAt,
  });
}

final List<Question> dummyQuestions = [
  Question(
    id: 'q1',
    question: 'Bagaimana cara memahami materi Matematika dengan mudah?',
    answer:
        'Cobalah memecah soal menjadi bagian kecil dan latihan soal secara rutin.',
    answeredBy: 'Andi Saputra',
    askedAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
  Question(
    id: 'q2',
    question: 'Apa tips agar bisa lancar dalam pelajaran Bahasa Indonesia?',
    answer: null,
    answeredBy: null,
    askedAt: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
  ),
];
