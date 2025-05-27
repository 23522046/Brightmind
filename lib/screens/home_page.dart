import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

// Dummy pages for demo
class VideoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Center(child: Text('Video Pembelajaran'));
}

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text('Chat'));
}

class QnAPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text('Q&A'));
}

class TryOutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text('Try Out'));
}

class ManageVideoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text('Kelola Video'));
}

class ManageQnAPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text('Kelola Q&A'));
}

class ManageTryOutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text('Kelola Try Out'));
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text('Profil'));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userRole =
        'student'; // Replace with authProvider.userRole or similar from your User model

    // Define pages & bottom nav items by role
    final studentPages = [
      VideoPage(),
      ChatPage(),
      QnAPage(),
      TryOutPage(),
      ProfilePage(),
    ];
    final volunteerPages = [
      ManageVideoPage(),
      ChatPage(),
      ManageQnAPage(),
      ManageTryOutPage(),
      ProfilePage(),
    ];

    final studentNavItems = [
      BottomNavigationBarItem(icon: Icon(Icons.video_library), label: 'Video'),
      BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
      BottomNavigationBarItem(icon: Icon(Icons.question_answer), label: 'Q&A'),
      BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Try Out'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
    ];

    final volunteerNavItems = [
      BottomNavigationBarItem(
        icon: Icon(Icons.video_call),
        label: 'Kelola Video',
      ),
      BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
      BottomNavigationBarItem(
        icon: Icon(Icons.question_answer),
        label: 'Kelola Q&A',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.assignment),
        label: 'Kelola Try Out',
      ),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
    ];

    final pages = userRole == 'student' ? studentPages : volunteerPages;
    final navItems =
        userRole == 'student' ? studentNavItems : volunteerNavItems;

    return Scaffold(
      appBar: AppBar(
        title: Text('BrightMind'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: navItems,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
