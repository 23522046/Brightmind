import 'package:brightmind/screens/common/reset_password_page.dart';
import 'package:brightmind/screens/student/student_home.dart';
import 'package:brightmind/screens/volunteer/volunteer_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart' as local_auth;
import 'screens/auth/login_page.dart';
import 'screens/auth/register_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BrightMind',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Consumer<local_auth.AuthProvider>(
        builder: (context, local_auth.AuthProvider auth, _) {
          // Show loading while checking auth state
          if (auth.user == null &&
              auth.userCategory == null &&
              !auth.isLoading) {
            return const LoginPage(); // User is not logged in
          }

          // Show loading while fetching user category
          if (auth.user != null && auth.userCategory == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // User is logged in and category is loaded
          if (auth.user != null && auth.userCategory != null) {
            final user = auth.user!;
            final category = auth.userCategory!;

            // Navigate based on the user's category
            if (category == 'Siswa') {
              return StudentHomePage();
            } else if (category == 'Relawan') {
              return VolunteerHomePage();
            } else {
              return const Center(child: Text('Unknown category.'));
            }
          }

          // Default fallback
          return const LoginPage();
        },
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/reset-password': (context) => const ResetPasswordPage(),
        '/student/home': (context) => const StudentHomePage(),
        '/volunteer/home': (context) => const VolunteerHomePage(),
      },
    );
  }
}
