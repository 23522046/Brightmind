import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  String? errorMessage;
  User? user;
  String? userCategory;
  bool rememberMe = false;

  bool get isLoggedIn => user != null;

  AuthProvider() {
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      this.user = user;
      if (user != null) {
        _loadUserCategory();
      } else {
        userCategory = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserCategory() async {
    if (user != null) {
      try {
        final userDoc =
            await _firestore.collection('users').doc(user!.uid).get();
        if (userDoc.exists) {
          userCategory = userDoc['category'];
          notifyListeners();
        }
      } catch (e) {
        print('Error loading user category: $e');
      }
    }
  }

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
    userCategory = null;
    notifyListeners();
  }

  // Login method - simplified since authStateChanges will handle user updates
  Future<void> login(
    String email,
    String password, {
    bool rememberMe = false,
  }) async {
    isLoading = true;
    errorMessage = null;
    this.rememberMe = rememberMe;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // No need to manually set user - authStateChanges listener will handle it
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
