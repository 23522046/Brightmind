class Relawan {
  final String id;
  final String name;
  final String avatarUrl;
  final bool isOnline;

  Relawan({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.isOnline,
  });
}

final List<Relawan> dummyRelawan = [
  Relawan(
    id: 'r1',
    name: 'Andi Saputra',
    avatarUrl: 'https://i.pravatar.cc/150?img=1',
    isOnline: true,
  ),
  Relawan(
    id: 'r2',
    name: 'Yudi Prasetyo',
    avatarUrl: 'https://i.pravatar.cc/150?img=12',
    isOnline: false,
  ),
  Relawan(
    id: 'r3',
    name: 'Budi Santoso',
    avatarUrl: 'https://i.pravatar.cc/150?img=54',
    isOnline: true,
  ),
  Relawan(
    id: 'r4',
    name: 'Sari Dewi',
    avatarUrl: 'https://i.pravatar.cc/150?img=7',
    isOnline: true,
  ),
  Relawan(
    id: 'r5',
    name: 'Rizky Ahmad',
    avatarUrl: 'https://i.pravatar.cc/150?img=20',
    isOnline: false,
  ),
  Relawan(
    id: 'r6',
    name: 'Lina Marlina',
    avatarUrl: 'https://i.pravatar.cc/150?img=33',
    isOnline: true,
  ),
];
