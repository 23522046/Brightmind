import 'dart:convert';
import 'package:brightmind/models/video_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/videoplayer_page.dart';

class LearnVisionPage extends StatefulWidget {
  const LearnVisionPage({super.key});

  @override
  State<LearnVisionPage> createState() => _LearnVisionPageState();
}

class _LearnVisionPageState extends State<LearnVisionPage> {
  List<VideoGroup> _videoGroups = [];

  @override
  void initState() {
    super.initState();
    _loadVideosFromJson();
  }

  Future<void> _loadVideosFromJson() async {
    final String jsonString = await rootBundle.loadString(
      'assets/video_data.json',
    );
    final List<dynamic> jsonData = json.decode(jsonString);

    setState(() {
      _videoGroups = jsonData.map((item) => VideoGroup.fromJson(item)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _videoGroups.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            const Text(
              'Video Pembelajaran',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Pelajari berbagai materi SMP secara interaktif.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ..._buildGroupedTiles(),
          ],
        );
  }

  List<Widget> _buildGroupedTiles() {
    final Map<String, Map<String, List<VideoItem>>> grouped = {};

    for (var group in _videoGroups) {
      grouped[group.kelas] ??= {};
      grouped[group.kelas]![group.mapel] = group.videos;
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
                    mapelEntry.value.map((video) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => VideoPlayerPage(
                                      videoId: video.id,
                                      title: video.title,
                                    ),
                              ),
                            );
                          },

                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                                child: Image.network(
                                  video.thumbnailUrl,
                                  width: 120,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        video.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Durasi: ${video.duration}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
