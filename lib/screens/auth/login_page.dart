import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart' as local_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  void _togglePassword() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  // Handle login
  void _onLogin() async {
    final auth = Provider.of<local_auth.AuthProvider>(context, listen: false);

    if (!_formKey.currentState!.validate()) return;

    try {
      // Perform login
      await auth.login(_emailCtrl.text.trim(), _passwordCtrl.text.trim());

      if (auth.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(auth.errorMessage!)));
        return;
      }

      // Firebase Auth login validation
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _emailCtrl.text.trim(),
            password: _passwordCtrl.text.trim(),
          );

      final user = userCredential.user;
      if (user != null) {
        // Fetch user category from Firestore
        final userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        if (userDoc.exists) {
          final category = userDoc['category'];

          // Navigate based on category
          if (mounted) {
            if (category == 'Siswa') {
              Navigator.pushReplacementNamed(context, '/student/home');
            } else if (category == 'Relawan') {
              Navigator.pushReplacementNamed(context, '/volunteer/home');
            }
          }
        } else {
          // Handle the case where the user document does not exist
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User tidak ditemukan')),
            );
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException
      String errorMessage = '';

      if (e.code == 'user-not-found') {
        errorMessage = 'Email yang anda masukkan tidak terdaftar.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Password yang anda masukkan salah.';
      } else {
        errorMessage = 'Terjadi kesalahan: ${e.message}';
      }

      // Show custom error message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      // Catch other errors
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login gagal: $e')));
      }
    }
  }

  // Google login (to be implemented)
  void _onGoogleLogin() {
    // TODO: implement Google login via AuthProvider
    Navigator.pushReplacementNamed(context, '/volunteer/home');
  }

  // Apple login (to be implemented)
  void _onAppleLogin() {
    // TODO: implement Apple login via AuthProvider
  }

  // Forgot password action
  void _onForgotPassword() {
    // TODO: navigate to forgot password page
  }

  // Navigate to register page
  void _onRegister() {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<local_auth.AuthProvider>(context);
    final primaryColor = const Color(0xFF0B60FF);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      'assets/logo.png',
                      width: 120,
                      height: 120,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Ayo Masuk!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D2236),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Masuk ke akun anda untuk mengakses BrightMind',
                      style: TextStyle(fontSize: 14, color: Color(0xFF5B5F7B)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Email field
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email wajib diisi';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Password field
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: _togglePassword,
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  // Remember Me Checkbox
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged:
                                (val) =>
                                    setState(() => _rememberMe = val ?? false),
                            activeColor: primaryColor,
                          ),
                          const Text(
                            'Ingat Saya',
                            style: TextStyle(color: Color(0xFF5B5F7B)),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: _onForgotPassword,
                        child: const Text(
                          'Lupa Password',
                          style: TextStyle(
                            color: Color(0xFF5B5F7B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      onPressed: auth.isLoading ? null : _onLogin,
                      child:
                          auth.isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Masuk',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // const Text(
                  //   'Atau Lanjutkan Dengan',
                  //   style: TextStyle(color: Color(0xFF5B5F7B)),
                  // ),
                  // const SizedBox(height: 20),
                  // // Google Login and Apple Login
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     GestureDetector(
                  //       onTap: _onGoogleLogin,
                  //       child: CircleAvatar(
                  //         radius: 24,
                  //         backgroundColor: Colors.white,
                  //         child: Image.asset(
                  //           'assets/google_logo.png',
                  //           width: 24,
                  //           height: 24,
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 40),
                  //     GestureDetector(
                  //       onTap: _onAppleLogin,
                  //       child: CircleAvatar(
                  //         radius: 24,
                  //         backgroundColor: Colors.white,
                  //         child: Image.asset(
                  //           'assets/apple_logo.png',
                  //           width: 24,
                  //           height: 24,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum memiliki Akun? ',
                        style: TextStyle(color: Color(0xFF5B5F7B)),
                      ),
                      GestureDetector(
                        onTap: _onRegister,
                        child: const Text(
                          'Daftar',
                          style: TextStyle(
                            color: Color(0xFF0B60FF),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
