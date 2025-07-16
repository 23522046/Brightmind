import 'package:flutter/material.dart';
import '../../../models/question.dart';

class TalkspacePage extends StatefulWidget {
  const TalkspacePage({super.key});

  @override
  State<TalkspacePage> createState() => _TalkspacePageState();
}

class _TalkspacePageState extends State<TalkspacePage> {
  final List<Question> _questions = [...dummyQuestions];
  final TextEditingController _questionCtrl = TextEditingController();

  void _addQuestion() {
    final text = _questionCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _questions.insert(
        0,
        Question(
          id: DateTime.now().toIso8601String(),
          question: text,
          answer: null,
          answeredBy: null,
          askedAt: DateTime.now(),
        ),
      );
      _questionCtrl.clear();
    });
  }

  @override
  void dispose() {
    _questionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TalkSpace - Tanya Jawab Bersama Relawan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _questionCtrl,
                      minLines: 1,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'Tulis pertanyaanmu di sini...',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B60FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Kirim',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),

            // List pertanyaan
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: _questions.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final q = _questions[index];
                  final bool isAnswered = q.answer != null;

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status + tanggal
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isAnswered
                                        ? Colors.green[100]
                                        : Colors.orange[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                isAnswered
                                    ? 'Sudah Dijawab'
                                    : 'Menunggu Jawaban',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      isAnswered ? Colors.green : Colors.orange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              '${q.askedAt.day}/${q.askedAt.month}/${q.askedAt.year}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Pertanyaan
                        Text(
                          q.question,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        // Jawaban (jika ada)
                        if (isAnswered) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                size: 16,
                                color: Colors.blueGrey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                q.answeredBy ?? 'Relawan',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(q.answer!),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
