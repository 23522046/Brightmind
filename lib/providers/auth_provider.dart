import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  String? errorMessage;
  User? user;

  bool get isLoggedIn => user != null;

  Future<void> register(
    String email,
    String password, {
    required String name,
    required String phone,
    required String gender,
    required String category,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      // Check if phone number already exists
      final phoneQuery =
          await _firestore
              .collection('users')
              .where('phone', isEqualTo: phone)
              .get();

      if (phoneQuery.docs.isNotEmpty) {
        errorMessage = 'Nomor Handphone sudah digunakan.';
        isLoading = false;
        notifyListeners();
        return;
      }

      // Check if email already exists
      final emailQuery =
          await _firestore
              .collection('users')
              .where('email', isEqualTo: email)
              .get();

      if (emailQuery.docs.isNotEmpty) {
        errorMessage = 'Email sudah digunakan.';
        isLoading = false;
        notifyListeners();
        return;
      }

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;

      // Save extra data to Firestore
      await _firestore.collection('users').doc(user!.uid).set({
        'uid': user!.uid,
        'name': name,
        'email': email,
        'phone': phone,
        'gender': gender,
        'category': category,
        'createdAt': FieldValue.serverTimestamp(),
      });

      errorMessage = null;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Terjadi kesalahan: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    user = null;
    notifyListeners();
  }

  // Login, logout, and other methods...
  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      errorMessage = null;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = 'Terjadi kesalahan: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
