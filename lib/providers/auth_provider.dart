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

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    if (user == null) return null;

    try {
      final userDoc = await _firestore.collection('users').doc(user!.uid).get();
      if (userDoc.exists) {
        return userDoc.data();
      }
    } catch (e) {
      print('Error getting user data: $e');
    }
    return null;
  }

  // Update user profile data
  Future<bool> updateUserProfile({
    required String name,
    required String phone,
    required String gender,
  }) async {
    if (user == null) return false;

    try {
      await _firestore.collection('users').doc(user!.uid).update({
        'name': name,
        'phone': phone,
        'gender': gender,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update the display name in Firebase Auth if needed
      if (user!.displayName != name) {
        await user!.updateDisplayName(name);
      }

      notifyListeners();
      return true;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
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

      // Send email verification
      if (user != null && !user!.emailVerified) {
        await user!.sendEmailVerification();
        print('Email verification sent to ${user!.email}');
      } else {
        print('Email already verified');
      }

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

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Terjadi kesalahan saat mengirim link reset.";
    } catch (e) {
      throw "Terjadi kesalahan: $e";
    }
  }
}
