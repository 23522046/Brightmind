import 'package:flutter/material.dart';

import '../../../models/question.dart';

// Import model dan dummy data Question dari file terpisah jika perlu

class PertanyaanTab extends StatelessWidget {
  const PertanyaanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListView.separated(
        itemCount: dummyQuestions.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final q = dummyQuestions[index];
          return ListTile(
            title: Text(q.question),
            subtitle:
                q.answer != null
                    ? Text('Jawaban: ${q.answer!}')
                    : const Text(
                      'Belum ada jawaban',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
            trailing: Text(
              '${q.askedAt.day}/${q.askedAt.month}/${q.askedAt.year}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            onTap: () {
              // TODO: buka detail pertanyaan
            },
          );
        },
      ),
    );
  }
}
