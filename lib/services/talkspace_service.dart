import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/question.dart';

class TalkspaceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'talkspace';

  // Get all questions ordered by creation date (newest first)
  Stream<List<Question>> getQuestions() {
    return _firestore
        .collection(_collection)
        .orderBy('askedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Question.fromFirestore(doc))
            .toList());
  }

  // Add a new question
  Future<String?> addQuestion({
    required String question,
    required String askedBy,
    required String askedById,
  }) async {
    try {
      final docRef = await _firestore.collection(_collection).add({
        'question': question,
        'answer': null,
        'answeredBy': null,
        'answeredById': null,
        'askedBy': askedBy,
        'askedById': askedById,
        'askedAt': FieldValue.serverTimestamp(),
        'answeredAt': null,
      });
      return docRef.id;
    } catch (e) {
      print('Error adding question: $e');
      return null;
    }
  }

  // Answer a question
  Future<bool> answerQuestion({
    required String questionId,
    required String answer,
    required String answeredBy,
    required String answeredById,
  }) async {
    try {
      await _firestore.collection(_collection).doc(questionId).update({
        'answer': answer,
        'answeredBy': answeredBy,
        'answeredById': answeredById,
        'answeredAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error answering question: $e');
      return false;
    }
  }

  // Get questions by student (for student view)
  Stream<List<Question>> getQuestionsByStudent(String studentId) {
    return _firestore
        .collection(_collection)
        .where('askedById', isEqualTo: studentId)
        .orderBy('askedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Question.fromFirestore(doc))
            .toList());
  }

  // Get unanswered questions (for volunteer view)
  Stream<List<Question>> getUnansweredQuestions() {
    return _firestore
        .collection(_collection)
        .where('answer', isNull: true)
        .orderBy('askedAt', descending: false) // Oldest first for volunteers
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Question.fromFirestore(doc))
            .toList());
  }

  // Get answered questions (for volunteer view)
  Stream<List<Question>> getAnsweredQuestions() {
    return _firestore
        .collection(_collection)
        .where('answer', isNull: false)
        .orderBy('answeredAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Question.fromFirestore(doc))
            .toList());
  }

  // Delete a question (if needed)
  Future<bool> deleteQuestion(String questionId) async {
    try {
      await _firestore.collection(_collection).doc(questionId).delete();
      return true;
    } catch (e) {
      print('Error deleting question: $e');
      return false;
    }
  }
}
