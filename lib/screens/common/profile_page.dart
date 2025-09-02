import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart' as local_auth;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  bool _isLoading = false;

  // Controllers for edit form
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedGender;

  // User data
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final auth = Provider.of<local_auth.AuthProvider>(context, listen: false);
    final userData = await auth.getUserData();

    if (userData != null) {
      setState(() {
        _userData = userData;
        _nameController.text = _userData?['name'] ?? '';
        _phoneController.text = _userData?['phone'] ?? '';
        _selectedGender = _userData?['gender'];
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading profile data')),
        );
      }
    }
  }

  Future<void> _updateProfile() async {
    final auth = Provider.of<local_auth.AuthProvider>(context, listen: false);

    // Validate form
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nama tidak boleh kosong')));
      return;
    }

    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nomor handphone tidak boleh kosong')),
      );
      return;
    }

    if (_selectedGender == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pilih jenis kelamin')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final success = await auth.updateUserProfile(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      gender: _selectedGender!,
    );

    if (success) {
      // Reload user data
      await _loadUserData();

      setState(() {
        _isEditing = false;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile berhasil diperbarui!')),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui profile')),
        );
      }
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Reset form when canceling
        _nameController.text = _userData?['name'] ?? '';
        _phoneController.text = _userData?['phone'] ?? '';
        _selectedGender = _userData?['gender'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<local_auth.AuthProvider>(context);

    if (_userData == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          children: [
            // Profile Avatar
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white,
              child: Image.asset('assets/logo.png', width: 120, height: 120),
            ),
            const SizedBox(height: 16),

            // Name
            Text(
              _userData?['name'] ?? 'Unknown',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B60FF),
              ),
            ),
            const SizedBox(height: 8),

            // Email
            Text(
              _userData?['email'] ?? 'Unknown',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 8),

            // Edit/Save Button
            if (!_isEditing)
              TextButton.icon(
                icon: const Icon(
                  Icons.edit,
                  size: 20,
                  color: Color(0xFF0B60FF),
                ),
                label: const Text(
                  'Edit Profil',
                  style: TextStyle(
                    color: Color(0xFF0B60FF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: _toggleEdit,
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                    label: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: _toggleEdit,
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    icon:
                        _isLoading
                            ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : const Icon(Icons.save, size: 20),
                    label: Text(_isLoading ? 'Saving...' : 'Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B60FF),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _isLoading ? null : _updateProfile,
                  ),
                ],
              ),

            const SizedBox(height: 20),

            // Profile Information Cards
            if (_isEditing) ..._buildEditForm() else ..._buildProfileCards(),

            const SizedBox(height: 36),

            // Logout Button
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
                  side: const BorderSide(color: Color(0xFF0B60FF)),
                ),
                onPressed: () async {
                  await auth.logout();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildProfileCards() {
    return [
      Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: const Icon(Icons.phone, color: Color(0xFF0B60FF)),
          title: const Text('Nomor Handphone'),
          subtitle: Text(_userData?['phone'] ?? 'Not set'),
        ),
      ),
      const SizedBox(height: 12),
      Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Icon(
            _userData?['gender'] == 'Laki-laki' ? Icons.male : Icons.female,
            color: const Color(0xFF0B60FF),
          ),
          title: const Text('Jenis Kelamin'),
          subtitle: Text(_userData?['gender'] ?? 'Not set'),
        ),
      ),
      const SizedBox(height: 12),
      Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: const Icon(Icons.group, color: Color(0xFF0B60FF)),
          title: const Text('Kategori'),
          subtitle: Text(_userData?['category'] ?? 'Not set'),
        ),
      ),
    ];
  }

  List<Widget> _buildEditForm() {
    return [
      // Name Field
      Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nama',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B60FF),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Masukkan nama lengkap',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 12),

      // Phone Field
      Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nomor Handphone',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B60FF),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: 'Masukkan nomor handphone',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 12),

      // Gender Field
      Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Jenis Kelamin',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B60FF),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                hint: const Text('Pilih jenis kelamin'),
                items:
                    ['Laki-laki', 'Perempuan'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 12),

      // Category Field (Read-only)
      Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Kategori',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B60FF),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey[100],
                ),
                child: Text(
                  _userData?['category'] ?? 'Not set',
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Kategori tidak dapat diubah',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }
}
