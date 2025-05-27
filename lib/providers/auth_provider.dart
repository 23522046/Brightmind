import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null;

  AuthProvider() {
    // Listen perubahan auth state
    _authService.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> register(String email, String password) async {
    _setLoading(true);
    try {
      await _authService.registerWithEmailPassword(email, password);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _setLoading(false);
  }

  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      await _authService.loginWithEmailPassword(email, password);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _setLoading(false);
  }

  Future<void> logout() async {
    await _authService.signOut();
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
}
