import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/tryout_item.dart';

class ReadyToTestPage extends StatefulWidget {
  const ReadyToTestPage({super.key});

  @override
  State<ReadyToTestPage> createState() => _ReadyToTestPageState();
}

class _ReadyToTestPageState extends State<ReadyToTestPage> {
  List<TryOutGroup> _tryOutData = [];

  @override
  void initState() {
    super.initState();
    _loadTryOutData();
  }

  Future<void> _loadTryOutData() async {
    final String jsonString = await rootBundle.loadString(
      'assets/tryout_data.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      _tryOutData = jsonData.map((e) => TryOutGroup.fromJson(e)).toList();
    });
  }

  void _launchTryOut(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuka tautan tryout')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _tryOutData.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            const Text(
              'Try Out',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Latihan soal dari berbagai mapel untuk persiapan ujian kamu.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ..._buildGroupedTryouts(),
          ],
        );
  }

  List<Widget> _buildGroupedTryouts() {
    final Map<String, Map<String, List<TryOutItem>>> grouped = {};

    for (var item in _tryOutData) {
      grouped[item.kelas] ??= {};
      grouped[item.kelas]![item.mapel] = item.tryouts;
    }

    return grouped.entries.map((kelasEntry) {
      return ExpansionTile(
        title: Text(
          kelasEntry.key,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children:
            kelasEntry.value.entries.map((mapelEntry) {
              return ExpansionTile(
                title: Text(mapelEntry.key),
                children:
                    mapelEntry.value.map((item) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(item.title),
                          subtitle: Text(item.description),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0B60FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () => _launchTryOut(item.url),
                            child: const Text(
                              'Kerjakan',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              );
            }).toList(),
      );
    }).toList();
  }
}
