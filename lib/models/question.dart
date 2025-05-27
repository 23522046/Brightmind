class Question {
  final String id;
  final String question;
  final String? answer;
  final DateTime askedAt;

  Question({
    required this.id,
    required this.question,
    this.answer,
    required this.askedAt,
  });
}

// Dummy data pertanyaan
final List<Question> dummyQuestions = [
  Question(
    id: 'q1',
    question: 'Bagaimana cara memahami materi Matematika dengan mudah?',
    answer:
        'Cobalah memecah soal menjadi bagian kecil dan latihan soal secara rutin.',
    askedAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
  Question(
    id: 'q2',
    question: 'Apa tips agar bisa lancar dalam pelajaran Bahasa Indonesia?',
    answer:
        'Rajin membaca buku dan berlatih menulis membantu meningkatkan kemampuan bahasa.',
    askedAt: DateTime.now().subtract(const Duration(days: 5)),
  ),
  Question(
    id: 'q3',
    question: 'Bagaimana cara mengatur waktu belajar yang efektif?',
    answer:
        'Buat jadwal belajar harian dengan waktu istirahat yang cukup dan fokus pada satu materi tiap sesi.',
    askedAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  Question(
    id: 'q4',
    question: 'Apa saja cara meningkatkan konsentrasi saat belajar?',
    answer: null,
    askedAt: DateTime.now().subtract(const Duration(hours: 12)),
  ),
];
