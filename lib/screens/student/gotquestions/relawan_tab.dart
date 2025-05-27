import 'package:flutter/material.dart';

import '../../../models/relawan.dart';

// Import model dan dummy data Relawan di file terpisah jika perlu

class RelawanTab extends StatefulWidget {
  const RelawanTab({super.key});

  @override
  State<RelawanTab> createState() => _RelawanTabState();
}

class _RelawanTabState extends State<RelawanTab> {
  String _searchQuery = '';

  void _startChat(BuildContext context, Relawan relawan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mulai chat dengan ${relawan.name}')),
    );
  }

  void _startVideoCall(BuildContext context, Relawan relawan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mulai video call dengan ${relawan.name}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredRelawan =
        dummyRelawan
            .where(
              (r) => r.name.toLowerCase().contains(_searchQuery.toLowerCase()),
            )
            .toList();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Cari relawan...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRelawan.length,
              itemBuilder: (context, index) {
                final relawan = filteredRelawan[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(relawan.avatarUrl),
                    ),
                    title: Text(relawan.name),
                    subtitle: Text(
                      relawan.isOnline ? 'Online' : 'Offline',
                      style: TextStyle(
                        color: relawan.isOnline ? Colors.green : Colors.grey,
                      ),
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Image.asset(
                              'assets/wa_logo.png',
                              width: 24,
                              height: 24,
                            ),
                            onPressed: () => _startChat(context, relawan),
                          ),
                          IconButton(
                            icon: Image.asset(
                              'assets/googlemeet_logo.png',
                              width: 36,
                              height: 36,
                            ),
                            onPressed:
                                relawan.isOnline
                                    ? () => _startVideoCall(context, relawan)
                                    : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
