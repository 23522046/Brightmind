import 'package:flutter/material.dart';

class VideoItem {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String duration;

  VideoItem({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.duration,
  });
}

final List<VideoItem> videos = [
  VideoItem(
    id: '1',
    title: 'Video Motivasi Pendidikan Siswa-Siswa SMP/Sederajat',
    thumbnailUrl: 'https://img.youtube.com/vi/VMSd7deMBn4/0.jpg',
    duration: '5:12',
  ),
  VideoItem(
    id: '2',
    title: 'Video karya siswa dalam Pembelajaran B.Indonesia Kelas VIII',
    thumbnailUrl: 'https://img.youtube.com/vi/6vXE871wp0w/0.jpg',
    duration: '3:45',
  ),
  VideoItem(
    id: '3',
    title: 'GURU INSPIRATIF TERBAIK 2022 | VIDEO PEMBELAJARAN',
    thumbnailUrl: 'https://img.youtube.com/vi/gZ4x73MBaPE/0.jpg',
    duration: '7:30',
  ),
];

class LearnVisionPage extends StatelessWidget {
  const LearnVisionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Video Pembelajaran',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          // Subtitle / description
          const Text(
            'Pelajari berbagai materi secara interaktif melalui video berikut.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          // Expanded list supaya memenuhi sisa ruang layar
          Expanded(
            child: ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      // TODO: navigasi ke detail video
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
                            width: 150,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  video.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Durasi: ${video.duration}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
