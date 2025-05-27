import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register user pakai email dan password
  Future<User?> registerWithEmailPassword(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Login pakai email dan password
  Future<User?> loginWithEmailPassword(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Logout user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Stream user login state
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
