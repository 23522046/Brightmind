import 'package:flutter/material.dart';

class ReadyToTestPage extends StatelessWidget {
  const ReadyToTestPage({super.key});

  // Dummy try out list data
  final List<Map<String, String>> tryOutList = const [
    {
      'title': 'Try Out Matematika Dasar',
      'description': 'Latihan soal untuk mengasah kemampuan matematika dasar.',
    },
    {
      'title': 'Try Out Bahasa Indonesia',
      'description': 'Soal latihan untuk persiapan ujian Bahasa Indonesia.',
    },
    {
      'title': 'Try Out IPA SMP',
      'description': 'Persiapkan dirimu dengan soal IPA SMP terbaru.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: tryOutList.length,
      itemBuilder: (context, index) {
        final tryOut = tryOutList[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              tryOut['title'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(tryOut['description'] ?? ''),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to try out detail or start try out
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Memulai: ${tryOut['title']}')),
              );
            },
          ),
        );
      },
    );
  }
}
