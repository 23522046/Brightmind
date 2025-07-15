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

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    return VideoItem(
      id: json['id'],
      title: json['title'],
      thumbnailUrl: json['thumbnailUrl'],
      duration: json['duration'],
    );
  }
}

class VideoGroup {
  final String kelas;
  final String mapel;
  final List<VideoItem> videos;

  VideoGroup({required this.kelas, required this.mapel, required this.videos});

  factory VideoGroup.fromJson(Map<String, dynamic> json) {
    return VideoGroup(
      kelas: json['kelas'],
      mapel: json['mapel'],
      videos:
          (json['videos'] as List)
              .map((item) => VideoItem.fromJson(item))
              .toList(),
    );
  }
}
