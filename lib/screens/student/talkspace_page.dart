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
  final TextEditingController _questionCtrl = TextEditingController();
  bool _isLoading = false;

  Future<void> _addQuestion() async {
    final text = _questionCtrl.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pertanyaan tidak boleh kosong')),
      );
      return;
    }

    final auth = Provider.of<local_auth.AuthProvider>(context, listen: false);
    if (auth.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda harus login terlebih dahulu')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Get user data for the question
    final userData = await auth.getUserData();
    final userName = userData?['name'] ?? 'Student';

    final questionId = await _talkspaceService.addQuestion(
      question: text,
      askedBy: userName,
      askedById: auth.user!.uid,
    );

    setState(() {
      _isLoading = false;
    });

    if (questionId != null) {
      _questionCtrl.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pertanyaan berhasil dikirim!')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengirim pertanyaan')),
        );
      }
    }
  }

  @override
  void dispose() {
    _questionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<local_auth.AuthProvider>(context);

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
                    onPressed: _isLoading ? null : _addQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B60FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
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
                            : const Text(
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
              child:
                  auth.user == null
                      ? const Center(
                        child: Text(
                          'Anda harus login untuk melihat pertanyaan',
                        ),
                      )
                      : StreamBuilder<List<Question>>(
                        stream: _talkspaceService.getQuestionsByStudent(
                          auth.user!.uid,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }

                          final questions = snapshot.data ?? [];

                          if (questions.isEmpty) {
                            return const Center(
                              child: Text(
                                'Belum ada pertanyaan.\nAyo ajukan pertanyaan pertamamu!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          return ListView.separated(
                            padding: const EdgeInsets.all(12),
                            itemCount: questions.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, index) {
                              final q = questions[index];
                              final bool isAnswered = q.answer != null;

                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Status + tanggal
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            isAnswered
                                                ? 'Sudah Dijawab'
                                                : 'Menunggu Jawaban',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  isAnswered
                                                      ? Colors.green
                                                      : Colors.orange,
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
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
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
