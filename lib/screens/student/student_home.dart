import 'package:brightmind/screens/student/home_content.dart';
import 'package:flutter/material.dart';

import 'learnvision_page.dart';
import '../common/profile_page.dart';
import 'readytotest_page.dart';
import 'talkspace_page.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  final primaryColor = const Color(0xFF0B60FF);

  int _selectedIndex = -1;

  // List halaman untuk tab bottom nav (tidak termasuk FAB)
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const LearnVisionPage(),
      const TalkspacePage(),
      const ReadyToTestPage(),
      const ProfilePage(),
    ];
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onFabPressed() {
    setState(() {
      _selectedIndex = -1;
    });
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final color = _selectedIndex == index ? primaryColor : Colors.grey;
    return GestureDetector(
      onTap: () => _onNavItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: (_selectedIndex == -1) ? HomeContent() : _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: _onFabPressed,
        child: const Icon(Icons.home, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.video_collection, 'LearnVision', 0),
              _buildNavItem(Icons.chat, 'TalkSpace', 1),

              const SizedBox(width: 56), // space untuk FAB
              _buildNavItem(Icons.assignment_outlined, 'ReadyToTest!', 2),
              _buildNavItem(Icons.person_3_outlined, 'Profil', 3),
            ],
          ),
        ),
      ),
    );
  }
}
