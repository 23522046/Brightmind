import 'package:cloud_firestore/cloud_firestore.dart';

class InitTalkspaceData {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> addSampleQuestions() async {
    try {
      // Sample question 1 - Answered
      await _firestore.collection('talkspace').add({
        'question': 'Bagaimana cara memahami materi Matematika dengan mudah?',
        'answer': 'Cobalah memecah soal menjadi bagian kecil dan latihan soal secara rutin. Jangan lupa untuk memahami konsep dasar terlebih dahulu.',
        'answeredBy': 'Andi Saputra',
        'answeredById': 'volunteer1',
        'askedBy': 'Brian Elwin',
        'askedById': 'student1',
        'askedAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 3))),
        'answeredAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 2))),
      });

      // Sample question 2 - Unanswered
      await _firestore.collection('talkspace').add({
        'question': 'Apa tips agar bisa lancar dalam pelajaran Bahasa Indonesia?',
        'answer': null,
        'answeredBy': null,
        'answeredById': null,
        'askedBy': 'Sarah Putri',
        'askedById': 'student2',
        'askedAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1, hours: 5))),
        'answeredAt': null,
      });

      // Sample question 3 - Unanswered
      await _firestore.collection('talkspace').add({
        'question': 'Bagaimana cara mengerjakan soal fisika yang sulit?',
        'answer': null,
        'answeredBy': null,
        'answeredById': null,
        'askedBy': 'Dimas Pratama',
        'askedById': 'student3',
        'askedAt': Timestamp.fromDate(DateTime.now().subtract(const Duration(hours: 8))),
        'answeredAt': null,
      });

      print('Sample talkspace data added successfully!');
    } catch (e) {
      print('Error adding sample data: $e');
    }
  }

  // Call this method to clear all talkspace data (for testing purposes)
  static Future<void> clearAllQuestions() async {
    try {
      final snapshot = await _firestore.collection('talkspace').get();
      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
      print('All talkspace data cleared!');
    } catch (e) {
      print('Error clearing data: $e');
    }
  }
}
