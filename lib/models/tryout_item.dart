class TryOutItem {
  final String title;
  final String description;
  final String url;

  TryOutItem({
    required this.title,
    required this.description,
    required this.url,
  });

  factory TryOutItem.fromJson(Map<String, dynamic> json) => TryOutItem(
    title: json['title'],
    description: json['description'],
    url: json['url'],
  );
}

class TryOutGroup {
  final String kelas;
  final String mapel;
  final List<TryOutItem> tryouts;

  TryOutGroup({
    required this.kelas,
    required this.mapel,
    required this.tryouts,
  });

  factory TryOutGroup.fromJson(Map<String, dynamic> json) => TryOutGroup(
    kelas: json['kelas'],
    mapel: json['mapel'],
    tryouts:
        (json['tryouts'] as List).map((t) => TryOutItem.fromJson(t)).toList(),
  );
}
