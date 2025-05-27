import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data statis profil siswa
    final String name = "Brian Elwin Hanner";
    final String email = "brian.elwin@example.com";
    final String phone = "081234567890";
    final String gender = "Laki-laki";
    final String category = "Siswa";
    final String? avatarUrl = "https://i.pravatar.cc/150?img=4";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            CircleAvatar(radius: 60, backgroundImage: NetworkImage(avatarUrl!)),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B60FF),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              email,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            // Tombol Edit di bawah email
            const SizedBox(height: 8),
            TextButton.icon(
              icon: const Icon(Icons.edit, size: 20, color: Color(0xFF0B60FF)),
              label: const Text(
                'Edit Profil',
                style: TextStyle(
                  color: Color(0xFF0B60FF),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                // TODO: Navigasi ke halaman edit profil
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit Profil ditekan')),
                );
              },
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.phone, color: Color(0xFF0B60FF)),
                title: const Text('Nomor Handphone'),
                subtitle: Text(phone),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.male, color: Color(0xFF0B60FF)),
                title: const Text('Jenis Kelamin'),
                subtitle: Text(gender),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.group, color: Color(0xFF0B60FF)),
                title: const Text('Kategori'),
                subtitle: Text(category),
              ),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton.icon(
                icon: const Icon(Icons.logout, color: Color(0xFF0B60FF)),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B60FF),
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  side: const BorderSide(
                    color: Color(0xFF0B60FF),
                  ), // optional border
                ),
                onPressed: () {
                  // TODO: Implement logout logic here
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
