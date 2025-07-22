import 'package:flutter/material.dart';
import '../../../models/question.dart';

class TalkspacePage extends StatefulWidget {
  const TalkspacePage({super.key});

  @override
  State<TalkspacePage> createState() => _TalkspacePageState();
}

class _TalkspacePageState extends State<TalkspacePage> {
  final List<Question> _questions = [...dummyQuestions];

  void _answerQuestionDialog(int index) {
    final TextEditingController _answerCtrl = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Jawab Pertanyaan'),
            content: SizedBox(
              width: double.maxFinite,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 100,
                  maxHeight: 250,
                  minWidth: 300,
                  maxWidth: 400,
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    child: TextField(
                      controller: _answerCtrl,
                      maxLines: null,
                      minLines: 6,
                      decoration: const InputDecoration(
                        hintText: 'Tulis jawaban di sini...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(12),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  final text = _answerCtrl.text.trim();
                  if (text.isEmpty) return;

                  setState(() {
                    _questions[index] = Question(
                      id: _questions[index].id,
                      question: _questions[index].question,
                      answer: text,
                      answeredBy: 'Nama Relawan', // ← You can replace this
                      askedAt: _questions[index].askedAt,
                    );
                  });

                  Navigator.pop(context);
                },
                child: const Text('Kirim'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TalkSpace - Relawan')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView.separated(
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
                  // Header: status + date
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
                          isAnswered ? 'Sudah Dijawab' : 'Menunggu Jawaban',
                          style: TextStyle(
                            fontSize: 12,
                            color: isAnswered ? Colors.green : Colors.orange,
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

                  // Question
                  Text(
                    q.question,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 6),

                  // Answer
                  if (isAnswered) ...[
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

                  // Jawab Button
                  if (!isAnswered) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0B60FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () => _answerQuestionDialog(index),
                        child: const Text(
                          'Jawab',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
