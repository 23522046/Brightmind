import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/question.dart';
import '../../services/talkspace_service.dart';
import '../../providers/auth_provider.dart' as local_auth;

class TalkspacePage extends StatefulWidget {
  const TalkspacePage({super.key});

  @override
  State<TalkspacePage> createState() => _TalkspacePageState();
}

class _TalkspacePageState extends State<TalkspacePage> {
  final TalkspaceService _talkspaceService = TalkspaceService();

  void _answerQuestionDialog(Question question) {
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
                onPressed: () async {
                  final text = _answerCtrl.text.trim();
                  if (text.isEmpty) return;

                  final auth = Provider.of<local_auth.AuthProvider>(
                    context,
                    listen: false,
                  );
                  if (auth.user == null) return;

                  // Get volunteer data
                  final userData = await auth.getUserData();
                  final volunteerName = userData?['name'] ?? 'Relawan';

                  final success = await _talkspaceService.answerQuestion(
                    questionId: question.id,
                    answer: text,
                    answeredBy: volunteerName,
                    answeredById: auth.user!.uid,
                  );

                  if (mounted) {
                    Navigator.pop(context);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Jawaban berhasil dikirim!'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Gagal mengirim jawaban')),
                      );
                    }
                  }
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
        child: StreamBuilder<List<Question>>(
          stream: _talkspaceService.getQuestions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final questions = snapshot.data ?? [];

            if (questions.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada pertanyaan dari siswa.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.separated(
              itemCount: questions.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final q = questions[index];
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
                            onPressed: () => _answerQuestionDialog(q),
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
            );
          },
        ),
      ),
    );
  }
}
