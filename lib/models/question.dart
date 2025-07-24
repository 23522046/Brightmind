import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String id;
  final String question;
  final String? answer;
  final String? answeredBy; // Name of the relawan
  final String? answeredById; // UID of the relawan
  final String askedBy; // Name of the student
  final String askedById; // UID of the student
  final DateTime askedAt;
  final DateTime? answeredAt;

  Question({
    required this.id,
    required this.question,
    this.answer,
    this.answeredBy,
    this.answeredById,
    required this.askedBy,
    required this.askedById,
    required this.askedAt,
    this.answeredAt,
  });

  // Convert from Firestore document
  factory Question.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Question(
      id: doc.id,
      question: data['question'] ?? '',
      answer: data['answer'],
      answeredBy: data['answeredBy'],
      answeredById: data['answeredById'],
      askedBy: data['askedBy'] ?? '',
      askedById: data['askedById'] ?? '',
      askedAt: (data['askedAt'] as Timestamp).toDate(),
      answeredAt:
          data['answeredAt'] != null
              ? (data['answeredAt'] as Timestamp).toDate()
              : null,
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'question': question,
      'answer': answer,
      'answeredBy': answeredBy,
      'answeredById': answeredById,
      'askedBy': askedBy,
      'askedById': askedById,
      'askedAt': Timestamp.fromDate(askedAt),
      'answeredAt': answeredAt != null ? Timestamp.fromDate(answeredAt!) : null,
    };
  }

  // Create a copy with updated fields
  Question copyWith({
    String? id,
    String? question,
    String? answer,
    String? answeredBy,
    String? answeredById,
    String? askedBy,
    String? askedById,
    DateTime? askedAt,
    DateTime? answeredAt,
  }) {
    return Question(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      answeredBy: answeredBy ?? this.answeredBy,
      answeredById: answeredById ?? this.answeredById,
      askedBy: askedBy ?? this.askedBy,
      askedById: askedById ?? this.askedById,
      askedAt: askedAt ?? this.askedAt,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }
}

final List<Question> dummyQuestions = [
  Question(
    id: 'q1',
    question: 'Bagaimana cara memahami materi Matematika dengan mudah?',
    answer:
        'Cobalah memecah soal menjadi bagian kecil dan latihan soal secara rutin.',
    answeredBy: 'Andi Saputra',
    answeredById: 'volunteer1',
    askedBy: 'Brian Elwin',
    askedById: 'student1',
    askedAt: DateTime.now().subtract(const Duration(days: 3)),
    answeredAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  Question(
    id: 'q2',
    question: 'Apa tips agar bisa lancar dalam pelajaran Bahasa Indonesia?',
    answer: null,
    answeredBy: null,
    answeredById: null,
    askedBy: 'Sarah Putri',
    askedById: 'student2',
    askedAt: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
    answeredAt: null,
  ),
];
